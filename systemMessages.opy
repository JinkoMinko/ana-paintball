#!mainFile "ANA_PB.opy"


rule "Hardscope messages":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isFiringPrimaryFire()
    
    wait(4, Wait.ABORT_WHEN_FALSE)
    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    if not strContains("{0}".format(eventPlayer), "ml7"):
        smallMessage(eventPlayer, random.choice(["    Take your time...", "    That's a long hardscope", "    No quickscopes?"]))
    else:
        smallMessage(eventPlayer, random.choice(["    ML7 HARDSCOPING LMFAO", "    POV ml7 is hardscoping", "    Even Demmos doesn't hardscope ml7LMAO"]))
    return


rule "If melee an awake player":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.MELEE
    @Condition not victim.hasStatusEffect(Status.ASLEEP)

    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, "    {0}{1}  Melee only kills sleeping players  {0}{1}".format(abilityIconString(Hero.ANA, Button.MELEE), abilityIconString(Hero.ANA, Button.ABILITY_1)))
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 120)
    wait(0.5)


rule "If nanoboosted player uses disabled buttons":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getScore() == NANO_SCORE
    @Condition any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]])
    
    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, "    {0}  Use sleep dart to win  {0}".format(iconString(Icon.EXCLAMATION_MARK)))
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 120)
    wait(1)