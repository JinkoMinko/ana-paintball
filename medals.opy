#!mainFile "ANA_PB.opy"

rule "Send honor medal":
    @SuppressWarnings w_ow2_rule_condition_chase
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.HonorTarget != null
    @Condition eventPlayer.HonorBar != 0

    eventPlayer.HonorTarget.HonorQueue.append(eventPlayer)
    eventPlayer.HonorTarget.MedalQueue.append(Medal.HONOR)
    eventPlayer.HonorBar = 0

    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, "    {0}  honor sent to {1}!".format(iconString(Icon.HAPPY), eventPlayer.HonorTarget))
    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 200)


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
    if eventPlayer.Jumps == 200:
        eventPlayer.MedalQueue.append(Medal.JOLLY_JUMPER)


rule "perfect quickscopes":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.ElimsBeforeQS = eventPlayer.KillStreak
    wait(0.24, Wait.ABORT_WHEN_FALSE) # Scope-in time
    waitUntil(eventPlayer.isFiringPrimaryFire(), 0.016) # 1 frame time window
    if eventPlayer.isFiringPrimaryFire():
        wait(0.16) # Scope-out time
        if not eventPlayer.isFiringSecondaryFire() and eventPlayer.KillStreak >= eventPlayer.ElimsBeforeQS + 1:
            eventPlayer.MedalQueue.append(Medal.PERFECT_QS)
            eventPlayer.PerfectQuickscopes += 1
            eventPlayer.PerfectQSVFX = true
            playEffect(eventPlayer, DynamicEffect.WRECKING_BALL_MINEFIELD_EXPLOSION_SOUND, Color.TEAM_1, eventPlayer.getPosition()+eventPlayer.getThrottle()*eventPlayer.getSpeed(), 200)
            if eventPlayer.PerfectQuickscopes == 5:
                eventPlayer.MedalQueue.append(Medal.PERFECTIONIST)
                bigMessage(eventPlayer, "{0}  Perfectionist!  {0}".format(abilityIconString(Hero.KIRIKO, Button.ULTIMATE)))
            wait(0.5)
            eventPlayer.PerfectQSVFX = null


rule "Quadfeed":
    @Event playerEarnedElimination
    @Hero ana

    attacker.QuadFeedTimes = [t for t in attacker.QuadFeedTimes if getTotalTimeElapsed() - t <= 7.5]
    attacker.QuadFeedTimes.append(getTotalTimeElapsed())
    getAllPlayers().exclude(attacker).QuadFeedTimes = []
    if len(attacker.QuadFeedTimes) == 4:
        attacker.MedalQueue.append(Medal.QUADFEED)
        attacker.QuadFeedTimes = []
        bigMessage(attacker, "{0}  Quadfeed!  {0}".format(abilityIconString(Hero.PHARAH, Button.ULTIMATE)))
        playEffect(attacker, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION_SOUND, Color.TEAM_1, attacker.getPosition() + attacker.getThrottle() * attacker.getSpeed(), 200)

rule "Multikills":
        @Event playerEarnedElimination
        @Hero ana

        attacker.MultiKillCount +=1
        if attacker.MultiKillCount == 5:
            attacker.MedalQueue.append(Medal.PENTAKILL)
            playEffect(attacker, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION_SOUND, Color.TEAM_1, attacker.getPosition() + attacker.getThrottle() * attacker.getSpeed(), 200)
            for i in range(getNumberOfPlayers(Team.ALL) - 1): # For loop required for SYSMSG that target multiple players
                getAllPlayers().exclude(attacker)[i].MedalQueue = [Medal.SYSTEM_MESSAGE].concat(getAllPlayers().exclude(attacker)[i].MedalQueue)
            smallMessage(getAllPlayers().exclude(attacker), "    {0} got a pentakill!".format(abilityIconString(Hero.KIRIKO, Button.ABILITY_2)))
        elif attacker.MultiKillCount == 6:
            attacker.MedalQueue.append(Medal.ULTRAKILL)
            playEffect(attacker, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION_SOUND, Color.TEAM_1, attacker.getPosition() + attacker.getThrottle() * attacker.getSpeed(), 200)
            for i in range(getNumberOfPlayers(Team.ALL) - 1): # For loop required for SYSMSG that target multiple players
                getAllPlayers().exclude(attacker)[i].MedalQueue = [Medal.SYSTEM_MESSAGE].concat(getAllPlayers().exclude(attacker)[i].MedalQueue)
            smallMessage(getAllPlayers().exclude(attacker), "    {0} got an ultrakill!".format(abilityIconString(Hero.ZENYATTA, Button.PRIMARY_FIRE)))
        elif attacker.MultiKillCount >= 7:
            attacker.MedalQueue.append(Medal.KILLIONAIRE)
            playEffect(attacker, DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION_SOUND, Color.TEAM_1, attacker.getPosition() + attacker.getThrottle() * attacker.getSpeed(), 200)
            for i in range(getNumberOfPlayers(Team.ALL) - 1): # For loop required for SYSMSG that target multiple players
                getAllPlayers().exclude(attacker)[i].MedalQueue = [Medal.SYSTEM_MESSAGE].concat(getAllPlayers().exclude(attacker)[i].MedalQueue)
            smallMessage(getAllPlayers().exclude(attacker), "    {0} got a pentakill!".format(abilityIconString(Hero.ZENYATTA, Button.ULTIMATE)))
    wait(3, Wait.RESTART_WHEN_TRUE)
    attacker.MultiKillCount = 0


rule "Killstreak effects & announcements":
    @Event playerEarnedElimination
    @Hero ana
    @Condition not eventAbility == Button.ABILITY_1

    if attacker.KillStreak >= ONFIRE_STREAK and attacker.isAlive() and not attacker.IsOnFire:
        attacker.IsOnFire = true
        attacker.setStatusEffect(null, Status.BURNING, 9999)
        playEffect(getAllPlayers(), DynamicEffect.ASHE_DYNAMITE_EXPLOSION_SOUND, Color.TEAM_1, attacker, 70 if eventPlayer == localPlayer else 200)
        attacker.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE, OutlineVisibility.DEFAULT)
        attacker.MedalQueue.append(Medal.ON_FIRE)
        for i in range(getNumberOfPlayers(Team.ALL) - 1): # For loop required for SYSMSG that target multiple players
            getAllPlayers().exclude(attacker)[i].MedalQueue = [Medal.SYSTEM_MESSAGE].concat(getAllPlayers().exclude(attacker)[i].MedalQueue)
        smallMessage(getAllPlayers().exclude(attacker), "    {0}  {1} is on fire!  {0}".format(abilityIconString(Hero.TORBJORN, Button.ULTIMATE), attacker))
    elif attacker.KillStreak >= RAMPAGE_STREAK and attacker.isAlive() and not attacker.IsOnRampage:
        attacker.IsOnRampage = true
        attacker.MedalQueue.append(Medal.RAMPAGE)
        attacker.RampageSFX = true
        attacker.startForcingOutlineFor(getAllPlayers(), true, Color.YELLOW, OutlineVisibility.DEFAULT)
        bigMessage(getAllPlayers().exclude(attacker), "{0}  {1} is on a rampage!  {0}".format(abilityIconString(Hero.REAPER, Button.ULTIMATE), attacker))
        attacker.RampageVFX = true
        wait(1)
        attacker.RampageVFX = false
    elif attacker.KillStreak >= NUCLEAR_STREAK and not attacker.IsNuclear:
        attacker.IsNuclear = true
        attacker.MedalQueue.append(Medal.NUCLEAR)
        playEffect(getAllPlayers(), DynamicEffect.ANA_BIOTIC_GRENAGE_NO_HEALING_SOUND, Color.WHITE, attacker, 200)
        createInWorldText(attacker, "    {0} Nuclear killstreak! {0}\nPress [{1}] to request Nano-nuke".format(iconString(Icon.RADIOACTIVE), buttonString(Button.ULTIMATE)), updateEveryTick(localPlayer.getEyePosition() + (100 * (0 * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION) + ((0.69 - 0.2) * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 9, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)), SpecVisibility.DEFAULT)
        bigMessage(getAllPlayers().exclude(attacker), "{0}  {1} is Nuclear!  {0}".format(iconString(Icon.RADIOACTIVE), attacker))


rule "Killstreak shutdown announcements":
    @Event playerDealtFinalBlow
    @Hero ana
    @Condition not eventWasEnvironment
    @Condition victim.SleepLock < 1 # ?
    @Condition victim.KillStreak >= ONFIRE_STREAK

    attacker.ShutdownVictim = victim
    attacker.communicate(Comms.GOODBYE)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_DISAPPEAR_SOUND, Color.WHITE, victim.getPosition(), 200)
    for i in range(getNumberOfPlayers(Team.ALL) - 2): # For loop required for SYSMSG that target multiple players
        getAllPlayers().exclude([victim, attacker])[i].MedalQueue = [Medal.SYSTEM_MESSAGE].concat(getAllPlayers().exclude([victim, attacker])[i].MedalQueue)

    if victim.KillStreak < RAMPAGE_STREAK:
        attacker.MedalQueue.append(Medal.ON_FIRE_SHUTDOWN)
        smallMessage(getAllPlayers().exclude([victim, attacker]), "    {0}  {1}'s {2} killstreak ended".format(abilityIconString(Hero.TRACER, Button.ABILITY_2), victim, victim.KillStreak))
    
    elif victim.KillStreak < NUCLEAR_STREAK:
        attacker.MedalQueue.append(Medal.RAMPAGE_SHUTDOWN)
        smallMessage(getAllPlayers().exclude([victim, attacker]), "    {0}  {1}'s {2} kills rampage ended".format(abilityIconString(Hero.TRACER, Button.ABILITY_2), victim, victim.KillStreak))
    wait(2) # why


rule "environmental kills":
    @Event playerDied
    @Hero ana
    @Condition eventWasEnvironment
    @Condition eventAbility == Button.ABILITY_1

    attacker.MedalQueue.append(Medal.ENVRNMTL_KILL)
    bigMessage(attacker, "{0}  Environmental Kill!  {0}".format(abilityIconString(Hero.SIGMA, Button.ULTIMATE)))
    for i in range(getNumberOfPlayers(Team.ALL) - 2): # For loop required for SYSMSG that target multiple players
        getAllPlayers().exclude([victim, attacker])[i].MedalQueue = [Medal.SYSTEM_MESSAGE].concat(getAllPlayers().exclude([victim, attacker])[i].MedalQueue)
    smallMessage(getAllPlayers().exclude([victim, attacker]),"    {0} made {1} fall off the map...".format(victim, attacker))



rule "Environement death":
    @Event playerDied
    @Hero ana
    @Condition eventWasEnvironment

    if not strContains("{0}".format(eventPlayer), "ml7"):
        eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
        smallMessage(eventPlayer, random.choice([
            "    {}  no wings?".format(heroIcon(random.choice([Hero.ECHO, Hero.MERCY]))),
            "    {}  no jetpacks?".format(heroIcon(random.choice([Hero.PHARAH, Hero.WINSTON]))),
            "    {}  no translocators?".format(heroIcon(Hero.SOMBRA)),
            "    {}  no grapples?".format(heroIcon(random.choice([Hero.HAMMOND, Hero.WIDOWMAKER]))),
            "    {}  no teleports?".format(heroIcon(Hero.KIRIKO)),
            "    {}  no recalls?".format(heroIcon(Hero.TRACER)),
            "    {}  no wallrides?".format(heroIcon(Hero.LUCIO)),
            "    {}  no slams?".format(heroIcon(Hero.DOOMFIST)),
            "    {}  no mekas?".format(heroIcon(Hero.DVA)),
            "    {}  no double jumps?".format(heroIcon(Hero.GENJI)),
            "    {}  no wallclimbs?".format(heroIcon(random.choice([Hero.GENJI, Hero.HANZO, Hero.KIRIKO]))),
            "    {}  no life grips?".format(heroIcon(Hero.LIFEWEAVER)),
            "    {}  no rocket legs?".format(heroIcon(Hero.SOJOURN)),
            ]))
    else: # for ml7
        eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
        smallMessage(eventPlayer, random.choice([
            "    {} would have survived this".format(random.choice(["Olaf", "Denn", "Umarrii"])),
            "    {} would never die like that".format(random.choice(["Demmos", "Sp33dyal", "Zeldig"])),
            "    Demmos would have never done this",
            "    Who put that wall there???",
            "    Are y'all really subbed to this guy?",
            "    COOM?!?",
            ]))



rule "Longshot":
    @Event playerTookDamage
    @Hero ana
    @Condition distance(attacker, victim) >= LONGSHOT_DISTANCE
    @Condition not eventWasEnvironment
    @Condition attacker.getScore() != NANO_SCORE

    wait() # try removing
    attacker.MedalQueue.append(Medal.LONGSHOT)
    attacker.LongshotCount += 1
    attacker.OofDistance = distance(attacker, victim)
    createInWorldText(getAllPlayers(), random.choice(["oof", "ouch", "damn", "owie", "bonk"]), victim, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 150)), SpecVisibility.NEVER)
    victim.OofText = getLastCreatedText()
    if attacker.OofDistance > attacker.LongestLongshot:
        attacker.LongestLongshot = distance(attacker, victim)
    wait() # try removing
    if attacker.LongestLongshot > LongestShotValue:
        LongestShotPlayer = attacker
        LongestShotValue = attacker.LongestLongshot
    if attacker.LongshotCount >= 10:
        attacker.MedalQueue.append(Medal.DEADEYE)
        bigMessage(attacker, "{0}  Deadeye!  {0}".format(abilityIconString(Hero.MCCREE, Button.ULTIMATE)))

    if eventAbility == Button.ABILITY_1:
        attacker.MedalQueue.append(Medal.SLEEP_SNIPER)
        bigMessage(attacker, "{0}  Sleep Sniper!  {0}".format(abilityIconString(Hero.ORISA, Button.SECONDARY_FIRE)))
    wait(0.5)
    destroyInWorldText(victim.OofText)


rule "Sandman":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition not eventWasEnvironment
    @Condition attacker.isAlive()
    @Condition not victim.hasStatusEffect(Status.ASLEEP)

    attacker.Sandman += 1
    if attacker.Sandman == 3:
        attacker.MedalQueue.append(Medal.SANDMAN)
        attacker.Sandman = 0


rule "MEDALS":
    @Event eachPlayer
    @Hero ana
    @Condition len(eventPlayer.MedalQueue) > 0
    @Condition not MatchEnded

    wait()
    eventPlayer.DisplayMedal = eventPlayer.MedalQueue[0]
    if eventPlayer.DisplayMedal != Medal.SYSTEM_MESSAGE:
        smallMessage(eventPlayer, {
            Medal.HONOR:              "    {0}  {1} said: '{2}'".format(heroIcon(Hero.ANA), eventPlayer.HonorQueue[0], random.choice(["Nice one!", "Sheeeesh", "Damn!", "Wow", "Oof", "Clean", "{0}{0}{0}".format(iconString(Icon.FIRE))])),
            Medal.EXECUTED:           "    {0}{1}  Execution! Max ammo".format(abilityIconString(Hero.ANA, Button.MELEE), iconString(Icon.RECYCLE)),
            Medal.DEMOTION:           "    {0}  Demotion! {1} lost a point".format(abilityIconString(Hero.HAMMOND, Button.CROUCH), eventPlayer.DemotionVictim),
            Medal.TERMINATOR:         "    {0}  Terminator".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_2)),
            Medal.PERFECT_QS:         "    {0}  Perfect quickscope".format(abilityIconString(Hero.KIRIKO, Button.JUMP)),
            Medal.PERFECTIONIST:      "    {0}  Perfectionist".format(abilityIconString(Hero.KIRIKO, Button.ULTIMATE)),
            Medal.STOLEN_KILL:        "    {0}  Stole {1}'s kill".format(abilityIconString(Hero.ROADHOG, Button.ABILITY_1), eventPlayer.StolenFrom),
            Medal.SLEEP_THIEF:        "    {0}  Sleep thief".format(abilityIconString(Hero.MOIRA, Button.SECONDARY_FIRE)),
            Medal.COMEBACK:           "    {0}  Comeback".format(abilityIconString(Hero.MERCY, Button.ULTIMATE)),
            Medal.IRON_WILL:          "    {0}  Iron will".format(abilityIconString(Hero.PHARAH, Button.JUMP)),
            Medal.FIRST_BLOOD:        "    {0}  First blood".format(abilityIconString(Hero.BRIGITTE, Button.ULTIMATE)),
            Medal.FIRST_SLEEP:        "    {0}  First sleep".format(abilityIconString(Hero.BRIGITTE, Button.ULTIMATE)),
            Medal.LONGSHOT:           "    {0}  Longshot! {1}m".format(heroIcon(Hero.WIDOWMAKER), OofString(eventPlayer.OofDistance)),
            Medal.NANOPUNCH:          "    {0}  Nanopunch".format(abilityIconString(Hero.RAMATTRA, Button.ABILITY_1)),
            Medal.ENVRNMTL_KILL:      "    {0}  Environmental kill".format(abilityIconString(Hero.SIGMA, Button.ULTIMATE)),
            Medal.ON_FIRE:            "    {0}  On fire".format(abilityIconString(Hero.TORBJORN, Button.ULTIMATE)),
            Medal.ON_FIRE_SHUTDOWN:   "    {0}  Ended {1}'s {2} Kills streak".format(abilityIconString(Hero.TRACER, Button.ABILITY_2), eventPlayer.ShutdownVictim, eventPlayer.ShutdownVictim.KillStreakBeforeDeath),
            Medal.RAMPAGE:            "    {0}  {1}".format(abilityIconString(Hero.REAPER, Button.ULTIMATE), random.choice(["You are on a rampage!", "Rampage!"])),
            Medal.RAMPAGE_SHUTDOWN:   "    {0}  Ended {1}'s {2} kills rampage".format(abilityIconString(Hero.TRACER, Button.ABILITY_2), eventPlayer.ShutdownVictim, eventPlayer.ShutdownVictim.KillStreakBeforeDeath),
            Medal.NUCLEAR:            "    {0}  Nuclear".format(iconString(Icon.RADIOACTIVE)),
            Medal.COUNTERMEASURE:     "    {0}{1}  Countermeasure".format(iconString(Icon.NO), iconString(Icon.RADIOACTIVE)),
            Medal.CATASTROPHE:        "    {0}  Catastrophe".format(abilityIconString(Hero.BASTION, Button.ULTIMATE)),
            Medal.STREAK_SQUASHER:    "    {0}  Streak Squasher".format(abilityIconString(Hero.DOOMFIST, Button.ABILITY_1)),
            Medal.SHOWSTOPPER:        "    {0}  Showstopper".format(iconString(Icon.STOP)),
            Medal.QUADFEED:           "    {0}  Quadfeed".format(abilityIconString(Hero.PHARAH, Button.ULTIMATE)),
            Medal.PENTAKILL:          "    {0}  Pentakill".format(abilityIconString(Hero.KIRIKO, Button.ABILITY_2)),
            Medal.ULTRAKILL:          "    {0}  Ultrakill".format(abilityIconString(Hero.ZENYATTA, Button.PRIMARY_FIRE)),
            Medal.KILLIONAIRE:        "    {0}  Killionaire".format(abilityIconString(Hero.ZENYATTA, Button.ULTIMATE)),
            Medal.JOLLY_JUMPER:       "    {0}  Jolly jumper".format(abilityIconString(Hero.BAPTISTE, Button.CROUCH)),
            Medal.COLLATERAL_KILLS:   "    {0}  Collateral kills".format(abilityIconString(Hero.ZARYA, Button.ABILITY_2)),
            Medal.MUTUAL_SLEEP:       "    {0}  Mutual sleep, awaking...".format(abilityIconString(Hero.MERCY, Button.ABILITY_2)),
            Medal.LAST_BULLET:        "    {0}  Last bullet kill".format(iconString(Icon.CLUB)),
            Medal.DREAMCATCHER:       "    {0}  Dreamcatcher".format(abilityIconString(Hero.RAMATTRA, Button.ABILITY_2)),
            Medal.NO_SCOPE_NEEDED:    "    {0}  No scope needed".format(abilityIconString(Hero.SOJOURN, Button.ULTIMATE)),
            Medal.DEADEYE:            "    {0}  Deadeye".format(abilityIconString(Hero.MCCREE, Button.ULTIMATE)),
            Medal.SLEEP_SNIPER:       "    {0}  Sleep sniper".format(abilityIconString(Hero.ORISA, Button.SECONDARY_FIRE)),
            Medal.SANDMAN:            "    {0}{1}  Sandman".format(abilityIconString(Hero.ANA, Button.ABILITY_1), abilityIconString(Hero.ECHO, Button.ULTIMATE)),
            Medal.PUNCH_DRUNK:        "    {0}{1}  Punch drunk".format(abilityIconString(Hero.ANA, Button.MELEE), iconString(Icon.DIZZY)),
            Medal.FROM_THE_GRAVE:     "    {0}  From the grave".format(abilityIconString(Hero.REAPER, Button.ULTIMATE)),
            }[eventPlayer.DisplayMedal])
        if DEBUG_MODE:
            eventPlayer.MedalCount += 1
        playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 200)
    elif DEBUG_MODE:
        eventPlayer.SysMsgCount += 1
    del eventPlayer.MedalQueue[0]
    wait(0.5)
    if eventPlayer.DisplayMedal == Medal.HONOR:
        del eventPlayer.HonorQueue[0]
    if RULE_CONDITION:
        goto RULE_START