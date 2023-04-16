#!mainFile "ANA_PB.opy"

rule "Reset player's variables & effects upon death":
    @Event playerDied
    @Hero ana

    eventPlayer.stopForcingOutlineFor(getAllPlayers())
    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    eventPlayer.KillStreakBeforeDeath = eventPlayer.KillStreak
    eventPlayer.Deaths +=1
    eventPlayer.SleepUsedAndDied = true
    eventPlayer.SleepsOnground = false
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.NanoDelay = not eventPlayer.NanoDelay

    waitUntil(eventPlayer.isAlive(), 69)

    eventPlayer.SleepLock = 0
    eventPlayer.KillStreak = 0
    eventPlayer.SleepAuthor = null
    if eventPlayer.getScore() < NANO_SCORE:
        eventPlayer.setUltCharge((eventPlayer.getScore()/NANO_SCORE)*100)
    wait(2.1 - CUSTOM_RESPAWN_TIME)
    eventPlayer.NanoDelay = 1
    eventPlayer.DemotedEffect = null


rule "fix movement bug after death":
    @Event playerDied
    @Hero ana
    @Condition eventPlayer.FixMovementBug == true

    waitUntil(eventPlayer.isAlive(), 69)
    eventPlayer.startForcingHero(Hero.ASHE)
    eventPlayer.startForcingHero(Hero.ANA)
    eventPlayer.FixMovementBug = false


rule "RIFLE & MELEE KILLS mechanics":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.PRIMARY_FIRE or (eventAbility == Button.MELEE and victim.hasStatusEffect(Status.ASLEEP))
    
    attacker.EarnedCollateral = 0
    kill(victim, attacker)

    if not FirstBlood:
        attacker.MedalQueue.append(Medal.FIRST_BLOOD)
        FirstBlood = not FirstBlood

    if attacker.isFiringPrimaryFire() and attacker.isFiringSecondaryFire():    # SCOPED
        attacker.ScopedHits +=1
        attacker.RaycastLastHitPlayer = attacker
        attacker.RaycastLastHitPos = attacker.getEyePosition()
        while attacker.RaycastLastHitPlayer != null:    #COLLATERALS
            if DEBUG_MODE: createBeam(getAllPlayers(), Beam.GRAPPLE, attacker.RaycastLastHitPos, raycast(attacker.RaycastLastHitPos, attacker.RaycastLastHitPos + eventPlayer.getFacingDirection() * 250, getAllPlayers(), [victim, attacker.RaycastLastHitPlayer], true).getHitPosition(), Color.GRAY, EffectReeval.VISIBILITY)
            attacker.Temp = raycast(attacker.RaycastLastHitPos,  attacker.RaycastLastHitPos + eventPlayer.getFacingDirection() * 250, getAllPlayers(), [victim, attacker.RaycastLastHitPlayer], true).getHitPosition()
            attacker.RaycastLastHitPlayer = raycast(attacker.RaycastLastHitPos,  attacker.RaycastLastHitPos + eventPlayer.getFacingDirection() * 250, getAllPlayers(), [victim, attacker.RaycastLastHitPlayer], true).getPlayerHit()
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

    elif eventAbility == Button.PRIMARY_FIRE:    # NOSCOPE
        attacker.KillStreak += 1
        attacker.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.MedalQueue)
    
    else:    # MELEE
        attacker.KillStreak += 1
        attacker.Execute += 1
        attacker.setAmmo(0, 15)
        attacker.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.MedalQueue)
        playEffect(getAllPlayers() if victim.getScore() > attacker.getScore() else getAllPlayers().exclude(victim), DynamicEffect.SIGMA_ACCRETION_IMPACT_SOUND, Color.WHITE, victim.getPosition(), 55)
        if victim.getScore() >= attacker.getScore():
            attacker.MedalQueue.append(Medal.DEMOTED)
            smallMessage(getAllPlayers().exclude([victim, attacker]), "    {0}  {1} demoted {2}!".format(abilityIconString(Hero.HAMMOND, Button.CROUCH), attacker, victim))
            victim.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(victim.MedalQueue)
            smallMessage(victim, "    {0}  {1} demoted you!".format(abilityIconString(Hero.HAMMOND, Button.CROUCH), attacker))
            eventPlayer.DemotedVictim = victim
            victim.setScore(victim.getScore()-1)
            attacker.DemotedPlayers += 1
            playEffect(attacker, DynamicEffect.ANA_BIOTIC_GRENADE_EXPLOSION_SOUND, Color.WHITE, victim, 200)
            victim.DemotedEffect = true
            
            if victim.getScore() == NANO_SCORE -1:
                attacker.MedalQueue.append(Medal.SHOWSTOPPER)
        
        if attacker.getScore() < NANO_SCORE:
            attacker.MedalQueue.append(Medal.EXECUTE)
            attacker.setAmmo(0, 15)
    
    if victim.KillStreak == ONFIRE_STREAK-1 or victim.KillStreak == RAMPAGE_STREAK-1:
        attacker.MedalQueue.append(Medal.BUZZKILL)
    
    if attacker.ComebackCount >= 3:
        attacker.MedalQueue.append(Medal.COMEBACK)
        attacker.ComebackCount = 0

    if victim.KillStreak == 0:
        victim.ComebackCount +=1

    attacker.ComebackCount = 0

    if attacker.KillStreak > MostKillStreakValue and attacker.KillStreak >= ONFIRE_STREAK:
        MostKillStreakPlayer = attacker
        MostKillStreakValue = attacker.KillStreak

    if attacker.getScore() > NANO_SCORE:
        attacker.setScore(NANO_SCORE)
        
    attacker.setUltCharge((attacker.getScore()/NANO_SCORE)*100)


rule "Respawns":
    @Event playerDied
    @Hero ana
    @Condition SpawnPointSettings != 0

    eventPlayer.disableNameplatesFor([getAllPlayers(), localPlayer])
    wait(0.7)
    eventPlayer.setInvisibility(Invis.ALL)
    waitUntil(eventPlayer.isAlive(), 9)
    RespawnSystem()
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.enableNameplatesFor(getAllPlayers())