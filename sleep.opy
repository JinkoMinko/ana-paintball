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
    @Condition victim.SleepAuthor == attacker

    eventPlayer.SleepLock += 1


rule "If SleepLock = 2, execute attacker, wake victim, reset attacker SleepLock and KillStreak":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.hasStatusEffect(Status.ASLEEP)
    @Condition victim.SleepAuthor == attacker
    @Condition eventPlayer.SleepLock == 2
    @Condition not eventWasEnvironment

    kill(eventPlayer, eventPlayer)
    attacker.setScore(attacker.getScore() - 1)
    victim.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(victim.MedalQueue)
    smallMessage(victim, "    {0}  Executed {1} for sleep-locking".format(abilityIconString(Hero.GENJI, Button.ABILITY_2), eventPlayer))
    wait(1)
    attacker.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(attacker.MedalQueue)
    smallMessage(attacker, "    {0}  Executed for sleep-locking {1}".format(abilityIconString(Hero.GENJI, Button.ABILITY_2), victim))
    damage(victim, attacker, 1)


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
        wait(0.5)
        damage(victim, null, 1)
    if attacker.SleepUsedAndDied: # if the attacker is dead when sleep dart hits
        victim.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(victim.MedalQueue)
        smallMessage(victim, "    {0}  {1} died, awaking...".format(abilityIconString(Hero.MERCY, Button.ABILITY_2), attacker))
        wait(0.5)
        damage(victim, null, 1)


rule "Detect when two players sleep each-other":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Disabled
    
    victim.SleepAuthor = attacker
    wait()
    if attacker.SleepAuthor == victim:
        wait(0.3)
        if attacker.isAlive() and victim.isAlive():
            eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
            smallMessage([attacker, victim], random.choice(["    {0} mimimimi...".format(abilityIconString(Hero.ANA, Button.ABILITY_1)), "    {0}{1}{0}  This is fine!".format(iconString(Icon.FIRE), iconString(Icon.HAPPY)), "    That's awkward!", "    zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"]))
        else:
        waitUntil(not eventPlayer.hasStatusEffect(Status.ASLEEP), 5)
        [attacker, victim].SleepAuthor = null