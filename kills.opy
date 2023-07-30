#!mainFile "ANA_PB.opy"

rule "Kill logic": 
    @Event playerDealtDamage #cant use final blow because it breaks eventability conditions
    @Hero ana
    @Condition eventAbility == Button.PRIMARY_FIRE or (eventAbility == Button.MELEE and victim.hasStatusEffect(Status.ASLEEP))
    @Condition not MatchEnded

    kill(victim, attacker)
    attacker.EarnedCollateral = 0

    victim.HonorTarget = attacker
    victim.HonorBar = 100
    chase(victim.HonorBar, 0, duration=CUSTOM_RESPAWN_TIME + 0.9, ChaseReeval.DESTINATION_AND_DURATION)

    if attacker.ComebackCount >= 3:
        attacker.MedalQueue.append(Medal.COMEBACK)
        attacker.ComebackCount = 0
        async(SayVoiceline, AsyncBehavior.NOOP)

    if not FirstBlood:
        attacker.MedalQueue.append(Medal.FIRST_BLOOD)
        FirstBlood = not FirstBlood
        async(SayVoiceline, AsyncBehavior.NOOP)
                
    if attacker.isFiringPrimaryFire() and attacker.isFiringSecondaryFire():    # SCOPED KILLS
        attacker.ScopedHits +=1
        attacker.RaycastLastHitPlayer = attacker
        attacker.RaycastLastHitPos = attacker.getEyePosition()
        while attacker.RaycastLastHitPlayer != null:    #COLLATERALS
            #if DEBUG_MODE: createBeam(getAllPlayers(), Beam.GRAPPLE, attacker.RaycastLastHitPos, raycast(attacker.RaycastLastHitPos, attacker.RaycastLastHitPos + eventPlayer.getFacingDirection() * 250, getAllPlayers(), [victim, attacker.RaycastLastHitPlayer], true).getHitPosition(), Color.GRAY, EffectReeval.VISIBILITY)
            attacker.Temp = raycast(attacker.RaycastLastHitPos,  attacker.RaycastLastHitPos + eventPlayer.getFacingDirection() * 250, getLivingPlayers(Team.ALL), [victim, attacker.RaycastLastHitPlayer], true).getHitPosition()
            attacker.RaycastLastHitPlayer = raycast(attacker.RaycastLastHitPos,  attacker.RaycastLastHitPos + eventPlayer.getFacingDirection() * 250, getLivingPlayers(Team.ALL), [victim, attacker.RaycastLastHitPlayer], true).getPlayerHit()
            attacker.RaycastLastHitPos = attacker.Temp

            kill(attacker.RaycastLastHitPlayer, attacker)
            attacker.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.MedalQueue)
            attacker.KillStreak += 1
            attacker.EarnedCollateral += 1

        attacker.ScopedAccuracy = round((attacker.ScopedHits / attacker.ScopedShots)*100)
        BestScopedAccuracyPlayer = sorted([scoper for scoper in getAllPlayers() if scoper.ScopedShots >= 15], lambda p: p.ScopedAccuracy).last()
        BestScopedAccuracyValue = BestScopedAccuracyPlayer.ScopedAccuracy
        
        if attacker.EarnedCollateral > 1:
            attacker.MedalQueue.append(Medal.COLLATERAL_KILLS)
            bigMessage(getAllPlayers().exclude(attacker), "{0}  {1} got {2} collateral kills!  {0}".format(abilityIconString(Hero.ZARYA, Button.ABILITY_2), attacker, attacker.EarnedCollateral))
            bigMessage(attacker, "{0}  {1} collateral kills!  {0}".format(abilityIconString(Hero.ZARYA, Button.ABILITY_2), attacker.EarnedCollateral))

    elif eventAbility == Button.PRIMARY_FIRE:    # NOSCOPE KILLS
        attacker.KillStreak += 1
        attacker.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.MedalQueue)
    
    else:    # MELEE KILLS
        attacker.KillStreak += 1
        if victim.isInAir() and attacker.isInAir():
            attacker.MedalQueue.append(Medal.DREAMCATCHER)  

        attacker.Executes += 1
        attacker.PunchDrunk += 1
        attacker.setAmmo(0, 15)
        attacker.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.MedalQueue)
        playEffect(getAllPlayers() if victim.getScore() > attacker.getScore() else getAllPlayers().exclude(victim), DynamicEffect.SIGMA_ACCRETION_IMPACT_SOUND, Color.WHITE, victim.getPosition(), 55)
        if victim.getScore() >= attacker.getScore():    # DEMOTIONS
            attacker.DemotionVictim = victim
            attacker.MedalQueue.append(Medal.DEMOTION)
            async(SaySorry, AsyncBehavior.NOOP)
            smallMessage(getAllPlayers().exclude([victim, attacker]), "    {0}  {1} demoted {2}!".format(abilityIconString(Hero.HAMMOND, Button.CROUCH), attacker, victim))
            victim.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(victim.MedalQueue)
            smallMessage(victim, "    {0}  {1} demoted you".format(abilityIconString(Hero.HAMMOND, Button.CROUCH), attacker))
            victim.setScore(victim.getScore()-1)
            attacker.DemotedPlayers += 1
            playEffect(attacker, DynamicEffect.ANA_BIOTIC_GRENADE_EXPLOSION_SOUND, Color.WHITE, victim, 200)
            victim.DemotedEffect = true

            if victim.getScore() == NANO_SCORE -1:
                attacker.MedalQueue.append(Medal.SHOWSTOPPER)
        
        elif attacker.getScore() < NANO_SCORE:
            attacker.MedalQueue.append(Medal.EXECUTED)
            attacker.setAmmo(0, 15)
        
        if attacker.PunchDrunk == 3:
            attacker.MedalQueue.append(Medal.PUNCH_DRUNK)  
            attacker.PunchDrunk = 0
    
    if victim.KillStreak == ONFIRE_STREAK-1 or victim.KillStreak == RAMPAGE_STREAK-1:
        attacker.MedalQueue.append(Medal.BUZZKILL)
        async(SaySorry(), AsyncBehavior.NOOP)

    if victim.KillStreak == NUCLEAR_STREAK -1:
        attacker.MedalQueue.append(Medal.COUNTERMEASURE)
        async(SaySorry(), AsyncBehavior.NOOP)
    
    if victim.IsNuclear:
        attacker.MedalQueue.append(Medal.CATASTROPHE)

    if victim.KillStreak == 0:
        victim.ComebackCount +=1

    if attacker.KillStreak > BestKillstreakValue and attacker.KillStreak >= ONFIRE_STREAK:
        BestKillstreakPlayer = attacker
        BestKillstreakValue = attacker.KillStreak

    if attacker.getScore() > NANO_SCORE:
        attacker.setScore(NANO_SCORE)

    if attacker.getAmmo(0) == 0:
        attacker.MedalQueue.append(Medal.LAST_BULLET)

    if victim.LastSleptBy != null and victim.LastSleptBy != attacker:    # STOLEN KILLS
        attacker.StolenFrom = victim.LastSleptBy
        attacker.StolenKills +=1
        attacker.MedalQueue.append(Medal.STOLEN_KILL)
        attacker.StolenFrom.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.StolenFrom.MedalQueue)    # For the assist
        attacker.StolenFrom.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.StolenFrom.MedalQueue)    # For the kill
        attacker.StolenFrom.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.StolenFrom.MedalQueue)    # For the message below
        smallMessage(attacker.StolenFrom, "    {0}  {1} stole your kill".format(abilityIconString(Hero.ROADHOG, Button.ABILITY_1), attacker))
        async(SayThanks, AsyncBehavior.NOOP)
    
    if attacker.isDead():
        async(FromTheGrave, AsyncBehavior.NOOP)

    attacker.setUltCharge((attacker.getScore()/NANO_SCORE)*100)
    
    if attacker.getScore() == NANO_SCORE - 2:
        async(SayUltStatus, AsyncBehavior.NOOP)
    
    attacker.ComebackCount = 0


rule "Respawn logic":
    @Event playerDied
    @Hero ana
    @Condition SpawnPointSettings != 0

    eventPlayer.disableNameplatesFor([getAllPlayers(), not localPlayer.IsPlayer])
    wait(0.7)
    eventPlayer.setInvisibility(Invis.ALL)
    waitUntil(eventPlayer.isAlive(), 9)
    RespawnSystem()
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.enableNameplatesFor(getAllPlayers())
    

rule "Reset players upon death":
    @Event playerDied
    @Hero ana

    eventPlayer.stopForcingOutlineFor(getAllPlayers())
    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue) # for the death system message
    eventPlayer.KillStreakBeforeDeath = eventPlayer.KillStreak
    eventPlayer.Deaths +=1
    eventPlayer.SleepUsedAndDied = true
    eventPlayer.SleepsOnground = false
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.IsOnFire = false
    eventPlayer.IsOnRampage = false
    eventPlayer.RampageSFX = false
    eventPlayer.NanoDelay = not eventPlayer.NanoDelay
    eventPlayer.Sandman = 0
    eventPlayer.PunchDrunk = 0

    waitUntil(eventPlayer.isAlive(), 69)

    eventPlayer.SleepLock = 0
    eventPlayer.KillStreak = 0
    eventPlayer.LastSleptBy = null
    if eventPlayer.getScore() < NANO_SCORE:
        eventPlayer.setUltCharge((eventPlayer.getScore()/NANO_SCORE)*100)
    wait(2.1 - CUSTOM_RESPAWN_TIME)
    eventPlayer.NanoDelay = 1
    wait(0.5)
    eventPlayer.DemotedEffect = null


rule "fix movement bug": #get rid of this system when Blizzard fixes the bug
    @Event playerDied
    @Hero ana
    @Condition eventPlayer.FixMovementBug == true

    waitUntil(eventPlayer.isAlive(), 69)
    eventPlayer.startForcingHero(Hero.ASHE)
    eventPlayer.startForcingHero(Hero.ANA)
    eventPlayer.FixMovementBug = false