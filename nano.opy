#!mainFile "ANA_PB.opy"

rule "While score < NANO_SCORE, allow all buttons":
    @Event eachPlayer
    @Hero ana
    @Condition (eventPlayer.getScore() < NANO_SCORE and eventPlayer.isAlive())
    
    wait(0.2)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.stopForcingButton(Button.ULTIMATE)


rule "When reaching NANO_SCORE, nanoboost self":
    @Event playerEarnedElimination
    @Hero ana
    @Condition eventPlayer.getScore() == NANO_SCORE

    if eventPlayer.isMeleeing():
        attacker.MedalQueue.append(Medal.NANOPUNCH)
    if eventPlayer.isFiringSecondaryFire():    # for people using toggle scope
        eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    eventPlayer.setUltCharge(100)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    wait()
    eventPlayer.forceButtonPress(Button.ULTIMATE)    # for people using "confirm nano target"


rule "When score = NANO_SCORE, disable all except sleep dart, warn other players, display  objective":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getScore() == NANO_SCORE

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.RELOAD)
    bigMessage(getAllPlayers().exclude(eventPlayer), "{0}  {1} wins in 1 kill!  {0}".format(iconString(Icon.WARNING), eventPlayer))
    bigMessage(eventPlayer, "{0}  use sleep dart to win!  {0}".format(abilityIconString(Hero.ANA, Button.ABILITY_1)))


rule "While score = NANO_SCORE, sleep CD is 1.5":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getScore() == NANO_SCORE
    @Condition eventPlayer.isUsingAbility1()

    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0, 1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1.5)


rule "If NANO_SCORE and died, nanoboost again":
    @Event playerDied
    @Hero ana
    @Condition eventPlayer.getScore() == NANO_SCORE
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.disallowButton(Button.ABILITY_1)
    wait(2.2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    wait()
    eventPlayer.forceButtonPress(Button.ULTIMATE)    # for people using "confirm nano target"