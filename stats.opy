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
    @Condition not attacker.isFiringSecondaryFire()
    @Condition not attacker.isMeleeing()

    attacker.NoscopeHits += 1
    attacker.NoscopeAccuracy = round((attacker.NoscopeHits / attacker.NoscopeShots)*100)
    BestNoscopeAccuracyValue = sorted([noscoper for noscoper in getAllPlayers() if noscoper.NoscopeShots >= 15], lambda p: p.NoscopeAccuracy).last().NoscopeAccuracy
    BestNoscopeAccuracyPlayer = eventPlayer
    if attacker.NoscopeHits == 10:
        attacker.MedalQueue.append(Medal.NO_SCOPE_NEEDED)


rule "Sleep Dart shots":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isAlive()
    
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    eventPlayer.SleepShots += 1
    eventPlayer.SleepAccuracy = round((eventPlayer.SleepHits / eventPlayer.SleepShots)*100)
    BestSleepAccuracyValue = sorted([sleeper for sleeper in getAllPlayers() if sleeper.SleepShots >= 10], lambda p: p.SleepAccuracy).last().SleepAccuracy

def SleepDarts():
    if not FirstSleep:
        attacker.MedalQueue.append(Medal.FIRST_SLEEP)
        FirstSleep = true
    victim.SleepAuthor = attacker
    for i in range(len(getAllPlayers())):
        victim.startForcingOutlineFor(getAllPlayers()[i], true, customGreen if victim.getScore() > getAllPlayers()[i].getScore() else Color.SKY_BLUE, OutlineVisibility.DEFAULT)
    attacker.SleepHits += 1
    attacker.SleepAccuracy = round((attacker.SleepHits / attacker.SleepShots)*100)
    BestSleepAccuracyValue = sorted([sleeper for sleeper in getAllPlayers() if sleeper.SleepShots >= 10], lambda p: p.SleepAccuracy).last().SleepAccuracy
    BestSleepAccuracyPlayer = attacker
    wait(0.5)
    victim.SleepsOnground = true
    waitUntil(not victim.hasStatusEffect(Status.ASLEEP), 4)
    victim.SleepsOnground = false
    victim.stopForcingOutlineFor(getAllPlayers())
    if victim.isAlive():
        victim.SleepAuthor = null
        if victim.KillStreak >= RAMPAGE_STREAK:
            victim.startForcingOutlineFor(getAllPlayers(), true, Color.YELLOW, OutlineVisibility.DEFAULT)
        elif  victim.KillStreak >= ONFIRE_STREAK:
            victim.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE, OutlineVisibility.DEFAULT)
        else:
            victim.stopForcingOutlineFor(getAllPlayers())

rule "Sleep Dart hits":
    @Event playerTookDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition not eventWasEnvironment

    async(SleepDarts,AsyncBehavior.RESTART)

rule "detect movement bug":
    @Event playerDealtDamage
    @Hero ana
    @Condition victim.hasStatusEffect(Status.ASLEEP)
    @Condition eventAbility == Button.ABILITY_1
    @Condition not eventWasEnvironment

    victim.FixMovementBug = true