#!mainFile "ANA_PB.opy"

rule "Set up SleepUsedAndDied":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.SleepUsedAndDied = false


rule "Sleeping an already sleeping player adds 1 to your SleepLock":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.hasStatusEffect(Status.ASLEEP)
    @Condition victim.LastSleptBy == attacker

    eventPlayer.SleepLock += 1


rule "If SleepLock = 2, execute attacker, wake victim, reset attacker SleepLock and KillStreak":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.hasStatusEffect(Status.ASLEEP)
    @Condition victim.LastSleptBy == attacker
    @Condition eventPlayer.SleepLock == 2
    @Condition not eventWasEnvironment

    kill(eventPlayer, eventPlayer)
    attacker.setScore(attacker.getScore() - 1)
    victim.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(victim.MedalQueue)
    smallMessage(victim, "    {0}  Executed {1} for sleep-locking".format(abilityIconString(Hero.GENJI, Button.ABILITY_2), eventPlayer))
    attacker.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.MedalQueue)
    smallMessage(attacker, "    {0}  Executed for sleep-locking {1}".format(abilityIconString(Hero.GENJI, Button.ABILITY_2), victim))


rule "Sleep-lock resets after 5s without sleeping anyone":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.SleepLock > 0
    @Condition not eventWasEnvironment

    wait(5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.SleepLock = 0


rule "Wake slept player if attacker dies after using sleep dart":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition attacker.getScore() != NANO_SCORE

    if not attacker.SleepUsedAndDied: # if the attacker is alive when sleep dart hits
        waitUntil(victim.isDead() or attacker.isDead(), 3.5)
        if victim.isDead() and attacker.isAlive():
            attacker.SleepUsedAndDied = true
            return
        wait(0.5, Wait.ABORT_WHEN_FALSE)
        damage(victim, null, 1)
        victim.communicate(Comms.THANKS)
    else: # if the attacker is dead when sleep dart hits
        victim.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(victim.MedalQueue)
        smallMessage(victim, "    {0}  {1} died, awaking...".format(abilityIconString(Hero.MERCY, Button.ABILITY_2), attacker))
        wait(0.5, Wait.ABORT_WHEN_FALSE)
        damage(victim, null, 1)
        wait(0.5)
        victim.communicate(Comms.GOODBYE)


rule "Detect mutual sleeps":
    @Event playerDealtDamage
    @Condition attacker.hasStatusEffect(Status.ASLEEP)
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim == attacker.LastSleptBy
    @Hero ana

    [eventPlayer, victim].MedalQueue.append(Medal.MUTUAL_SLEEP)
    wait(1.5, Wait.ABORT_WHEN_FALSE)
    if attacker.isAlive() and victim.isAlive() == true:
        damage([eventPlayer, victim], null, 1)