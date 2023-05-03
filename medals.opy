#!mainFile "ANA_PB.opy"

rule "sleep hit sys msg":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition not eventWasEnvironment

    attacker.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.MedalQueue)


rule "Jumps":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isJumping()

    eventPlayer.Jumps +=1
    if eventPlayer.Jumps == 250:
        eventPlayer.MedalQueue.append(Medal.JOLLY_JUMPER)


rule "perfect quickscopes":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.ElimsBeforeQS = eventPlayer.KillStreak
    wait(0.24) # Scope-in time
    waitUntil(eventPlayer.isFiringPrimaryFire(), 0.016) # 1 frame time window
    if eventPlayer.isFiringPrimaryFire():
        wait(0.16) # Scope-out time
        if not eventPlayer.isFiringSecondaryFire() and eventPlayer.KillStreak == eventPlayer.ElimsBeforeQS + 1:
            eventPlayer.MedalQueue.append(Medal.PERFECT_QS)
            eventPlayer.PerfectQuickscopes += 1


rule "quadfeed kills":
    @Event playerEarnedElimination
    @Hero ana

    attacker.QuadFeedTimes = [t for t in attacker.QuadFeedTimes if getTotalTimeElapsed() - t <= 7.5]
    attacker.QuadFeedTimes.append(getTotalTimeElapsed())
    getAllPlayers().exclude(attacker).QuadFeedTimes = []
    if len(attacker.QuadFeedTimes) >= 4:
        attacker.MedalQueue.append(Medal.QUADFEED)
        attacker.QuadFeedTimes = []


rule "Detect stolen kills":
    @Event playerEarnedElimination
    @Hero ana
    @Condition victim.SleepAuthor != null
    @Condition victim.SleepAuthor != attacker
   
    attacker.StolenFrom = victim.SleepAuthor
    attacker.StolenKills +=1
    attacker.MedalQueue.append(Medal.STOLEN_KILL)
    attacker.StolenFrom.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.StolenFrom.MedalQueue)    # For the assist
    attacker.StolenFrom.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.StolenFrom.MedalQueue)    # For the kill
    attacker.StolenFrom.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.StolenFrom.MedalQueue)    # For the message below
    smallMessage(attacker.StolenFrom, "    {0}  {1} stole your kill!".format(abilityIconString(Hero.ROADHOG, Button.ABILITY_1), attacker))
    wait(2, Wait.RESTART_WHEN_TRUE)
    attacker.StolenFrom = null

    
rule "Killstreak effects & announcements":
    @Event playerEarnedElimination
    @Hero ana
    @Condition not eventAbility == Button.ABILITY_1

    if attacker.KillStreak == ONFIRE_STREAK:
        attacker.MedalQueue.append(Medal.ON_FIRE)
            for i in range(getNumberOfPlayers(Team.ALL) - 1):
            getAllPlayers().exclude(attacker)[i].MedalQueue = [Medal.SYSTEM_MESSAGE].concat(getAllPlayers().exclude(attacker)[i].MedalQueue)
        attacker.setStatusEffect(null, Status.BURNING, 9999)
        attacker.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE, OutlineVisibility.DEFAULT)
        playEffect(getAllPlayers(), DynamicEffect.ASHE_DYNAMITE_EXPLOSION_SOUND, Color.TEAM_1, attacker, 70 if eventPlayer == localPlayer else 200)
        smallMessage(getAllPlayers().exclude(attacker), "    {0}  {1} is on fire!  {0}".format(abilityIconString(Hero.TORBJORN, Button.ULTIMATE), attacker))
    elif attacker.KillStreak == RAMPAGE_STREAK:
        attacker.MedalQueue.append(Medal.RAMPAGE)
        attacker.RampageSFX = true
        attacker.startForcingOutlineFor(getAllPlayers(), true, Color.YELLOW, OutlineVisibility.DEFAULT)
        bigMessage(getAllPlayers().exclude(attacker), "{0}  {1} is on a rampage!  {0}".format(abilityIconString(Hero.REAPER, Button.ULTIMATE), attacker))
        attacker.RampageVFX = true
        wait(1)
        attacker.RampageVFX = false
    
    
rule "Killstreak shutdown announcements":
    @Event playerDealtFinalBlow
    @Hero ana
    @Condition not eventWasEnvironment
    @Condition victim.SleepLock < 1
    @Condition victim.KillStreak >= ONFIRE_STREAK

    attacker.ShutdownVictim = victim

    if victim.KillStreak < RAMPAGE_STREAK:
        attacker.MedalQueue.append(Medal.ON_FIRE_SHUTDOWN)

        smallMessage(getAllPlayers().exclude([victim, attacker]), "    {0}  {1}'s {2} killstreak ended!".format(abilityIconString(Hero.TRACER, Button.ABILITY_2), victim, victim.KillStreak))
    else:
        attacker.MedalQueue.append(Medal.RAMPAGE_SHUTDOWN)
        smallMessage(getAllPlayers().exclude([victim, attacker]), "    {0}  {1}'s {2} kills rampage ended!".format(abilityIconString(Hero.TRACER, Button.ABILITY_2), victim, victim.KillStreak))
        
    for i in range(getNumberOfPlayers(Team.ALL) - 1):
        getAllPlayers().exclude(attacker)[i].MedalQueue = [Medal.SYSTEM_MESSAGE].concat(getAllPlayers().exclude(attacker)[i].MedalQueue)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_DISAPPEAR_SOUND, Color.WHITE, victim.getPosition(), 200)
    wait(2)


rule "environment kills":
    @Event playerDied
    @Hero ana
    @Condition eventWasEnvironment
    @Condition eventAbility == Button.ABILITY_1

    attacker.MedalQueue.append(Medal.ENV_KILL)


rule "Environement death":
    @Event playerDied
    @Hero ana
    @Condition eventWasEnvironment

    wait(1)
    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, random.choice([
        "    {}  no wings?".format(heroIcon(Hero.ECHO)),
        "    {}  no wings?".format(heroIcon(Hero.MERCY)),
        "    {}  no jetpacks?".format(heroIcon(Hero.PHARAH)),
        "    {}  no translocators?".format(heroIcon(Hero.SOMBRA)),
        "    {}  no grapples?".format(heroIcon(Hero.HAMMOND)),
        "    {}  no grapples?".format(heroIcon(Hero.WIDOWMAKER)),
        "    {}  lmfao".format(heroIcon(Hero.WIDOWMAKER)),
        "    {}  no swift steps?".format(heroIcon(Hero.KIRIKO)),
        "    {}  no recalls?".format(heroIcon(Hero.TRACER)),
        "    {}  no wallrides?".format(heroIcon(Hero.LUCIO)),
        "    {}  no slams?".format(heroIcon(Hero.DOOMFIST)),
        "    {}  no jumps?".format(heroIcon(Hero.WINSTON)),
        "    {}  no mekas?".format(heroIcon(Hero.DVA)),
        "    {}  no jumps?".format(heroIcon(Hero.GENJI)),
        "    {}  no wallclimbs?".format(heroIcon(Hero.HANZO))
        ]))


rule "Longshot":
    @Event playerDealtDamage
    @Hero ana
    @Condition attacker.isAlive()
    @Condition distance(attacker, victim) >= LONGSHOT_DISTANCE
    @Condition not eventWasEnvironment
    @Condition attacker.getScore() != NANO_SCORE

    wait()
    attacker.MedalQueue.append(Medal.LONGSHOT)
    attacker.OofDistance = distance(attacker, victim)
    createInWorldText(getAllPlayers(), random.choice(["oof", "ouch", "damn", "owie", "bonk"]), victim, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 150)), SpecVisibility.NEVER)
    attacker.OofText = getLastCreatedText()
    if attacker.OofDistance > attacker.LongestLongshot:
        attacker.LongestLongshot = distance(attacker, victim)
    wait()
    if attacker.LongestLongshot > LongestLongshotValue:
        LongestLongshotPlayer = attacker
        LongestLongshotValue = attacker.LongestLongshot
    wait(0.5)
    destroyInWorldText(attacker.OofText)


rule "MEDALS":
    @Event eachPlayer
    @Hero ana
    @Condition len(eventPlayer.MedalQueue) > 0

    wait()
    eventPlayer.DisplayMedal = eventPlayer.MedalQueue[0]
    if eventPlayer.DisplayMedal != Medal.SYSTEM_MESSAGE:
        smallMessage(eventPlayer, {
            Medal.NICE_SHOT:        "    {0}  {1} said: '{2}'".format(heroIcon(Hero.ANA), eventPlayer.HonorQueue[0], random.choice(["Nice one", "Sheeeesh", "Damn!", "wow!", "oof"])),
            Medal.EXECUTE:      "    {0}{1}  Execution - max ammo!".format(abilityIconString(Hero.ANA, Button.MELEE), iconString(Icon.RECYCLE)),
            Medal.PERFECT_QS:       "    {0}  Perfect quickscope!".format(abilityIconString(Hero.KIRIKO, Button.JUMP)),
            Medal.DEMOTED:          "    {0}  demoted {1}!".format(abilityIconString(Hero.HAMMOND, Button.CROUCH), eventPlayer.DemotedVictim),
            Medal.STOLEN_KILL:      "    {0}  stole {1}'s kill!".format(abilityIconString(Hero.ROADHOG, Button.ABILITY_1), eventPlayer.StolenFrom),
            Medal.COMEBACK:         "    {0}  Comeback!".format(abilityIconString(Hero.MERCY, Button.ULTIMATE)),
            Medal.FIRST_BLOOD:      "    {0}  First blood!".format(abilityIconString(Hero.BRIGITTE, Button.ULTIMATE)),
            Medal.LONGSHOT:         "    {0}  {1}m longshot!".format(heroIcon(Hero.WIDOWMAKER), OofString(eventPlayer.OofDistance)),
            Medal.NANOPUNCH:        "    {0}  Nanopunch!".format(abilityIconString(Hero.RAMATTRA, Button.ABILITY_1)),
            Medal.ENV_KILL:         "    {0}  Environment kill!".format(abilityIconString(Hero.SIGMA, Button.ULTIMATE)),
            Medal.ON_FIRE_SHUTDOWN: "    {0}  Ended {1}'s {2} Killstreak!".format(abilityIconString(Hero.TRACER, Button.ABILITY_2), eventPlayer.ShutdownVictim, eventPlayer.ShutdownVictim.KillStreakBeforeDeath),
            Medal.RAMPAGE_SHUTDOWN: "    {0}  Ended {1}'s {2} kills rampage!".format(abilityIconString(Hero.TRACER, Button.ABILITY_2), eventPlayer.ShutdownVictim, eventPlayer.ShutdownVictim.KillStreakBeforeDeath),
            Medal.BUZZKILL:         "    {0}  Buzzkill!".format(abilityIconString(Hero.DOOMFIST, Button.ABILITY_1)),
            Medal.SHOWSTOPPER:          "    {0}  SHOWSTOPPER!".format(iconString(Icon.SAD)),
            Medal.QUADFEED:         "    {0}  Quadfeed!".format(abilityIconString(Hero.JUNKER_QUEEN, Button.ULTIMATE)),
            Medal.ON_FIRE:          "    {0}  On fire!".format(abilityIconString(Hero.TORBJORN, Button.ULTIMATE)),
            Medal.RAMPAGE:          "    {0}  {1}".format(abilityIconString(Hero.REAPER, Button.ULTIMATE), random.choice(["You are on a rampage!", "Rampage!"])),
            Medal.JOLLY_JUMPER:     "    {0}  Jolly jumper!".format(abilityIconString(Hero.BAPTISTE, Button.CROUCH)),
            Medal.COLLATERAL_KILLS:  "    {0}  Collateral kills!".format(abilityIconString(Hero.ZARYA, Button.ABILITY_2)),
            Medal.MUTUAL_SLEEP:     "    {0}  Mutual sleep! Awaking...".format(abilityIconString(Hero.MERCY, Button.ABILITY_2)),
        }[eventPlayer.DisplayMedal])
        if DEBUG_MODE:
            eventPlayer.MedalCount += 1
        playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 200)
    elif DEBUG_MODE:
        eventPlayer.SysMsgCount += 1
    del eventPlayer.MedalQueue[0]
    wait(0.5)
    if eventPlayer.DisplayMedal == Medal.NICE_SHOT:
        del eventPlayer.HonorQueue[0]
    if RULE_CONDITION:
        goto RULE_START