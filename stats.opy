#!mainFile "ANA_PB.opy"

rule "Scoped shots":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isFiringSecondaryFire()
    

    eventPlayer.ScopedShots += 1
    eventPlayer.ScopedAccuracy = round((eventPlayer.ScopedHits / eventPlayer.ScopedShots)*100)
    BestScopedAccuracyValue = sorted([scoper for scoper in getAllPlayers() if scoper.ScopedShots >= 15], lambda p: p.ScopedAccuracy).last().ScopedAccuracy


rule "Noscope shots":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isFiringSecondaryFire()

    eventPlayer.NoscopeShots += 1
    eventPlayer.NoscopeAccuracy = round((eventPlayer.NoscopeHits / eventPlayer.NoscopeShots)*100)
    BestNoscopeAccuracyValue = sorted([noscoper for noscoper in getAllPlayers() if noscoper.NoscopeShots >= 15], lambda p: p.NoscopeAccuracy).last().NoscopeAccuracy


rule "Noscope hits":
    @Event playerDealtFinalBlow
    @Hero ana
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isMeleeing()

    eventPlayer.NoscopeHits += 1
    eventPlayer.NoscopeAccuracy = round((eventPlayer.NoscopeHits / eventPlayer.NoscopeShots)*100)
    BestNoscopeAccuracyValue = sorted([noscoper for noscoper in getAllPlayers() if noscoper.NoscopeShots >= 15], lambda p: p.NoscopeAccuracy).last().NoscopeAccuracy
    BestNoscopeAccuracyPlayer = eventPlayer


rule "Sleep Dart shots":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isAlive()
    
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    eventPlayer.SleepShots += 1
    eventPlayer.SleepAccuracy = round((eventPlayer.SleepHits / eventPlayer.SleepShots)*100)
    BestSleepAccuracyValue = sorted([sleeper for sleeper in getAllPlayers() if sleeper.SleepShots >= 10], lambda p: p.SleepAccuracy).last().SleepAccuracy


rule "Sleep Dart hits":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition not eventWasEnvironment

    victim.SleepAuthor = attacker
    victim.startForcingOutlineFor(getAllPlayers(), true, rgb(63, 191, 116) if victim.getScore() > attacker.getScore() else Color.SKY_BLUE, OutlineVisibility.DEFAULT)
    eventPlayer.SleepHits += 1
    eventPlayer.SleepAccuracy = round((eventPlayer.SleepHits / eventPlayer.SleepShots)*100)
    BestSleepAccuracyValue = sorted([sleeper for sleeper in getAllPlayers() if sleeper.SleepShots >= 10], lambda p: p.SleepAccuracy).last().SleepAccuracy
    BestSleepAccuracyPlayer = eventPlayer
    chase(victim.ExecuteRange, 10, duration=3.7, ChaseReeval.DESTINATION_AND_DURATION)
    wait(0.5)
    victim.SleepsOnground = true
    waitUntil(not victim.hasStatusEffect(Status.ASLEEP), 4)
    stopChasingVariable(victim.ExecuteRange)
    victim.SleepsOnground = false
    victim.ExecuteRange = 30
    victim.stopForcingOutlineFor(getAllPlayers())
    if victim.isAlive():
        victim.SleepAuthor = null
        if victim.KillStreak >= RAMPAGE_STREAK:
            victim.startForcingOutlineFor(getAllPlayers(), true, Color.YELLOW, OutlineVisibility.DEFAULT)
        elif  victim.KillStreak >= ONFIRE_STREAK:
            victim.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE, OutlineVisibility.DEFAULT)
        else:
            victim.stopForcingOutlineFor(getAllPlayers())



rule "detect movement bug":
    @Event playerDealtDamage
    @Hero ana
    @Condition victim.hasStatusEffect(Status.ASLEEP)
    @Condition eventAbility == Button.ABILITY_1
    @Condition not eventWasEnvironment

    victim.FixMovementBug = true