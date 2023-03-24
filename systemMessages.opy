#!mainFile "ANA_PB.opy"

rule "Initial spawn messages":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.getNumberOfDeaths() == 0

    wait(0.2)
    smallMessage(eventPlayer, random.choice(["    {0}  discord link above the scoreboard!".format(iconString(Icon.ARROW_UP)), "    {0}  Good luck have fun!".format(iconString(Icon.HAPPY)),"    {0}  Nanoboost reduces sleep dart's cooldown!".format(abilityIconString(Hero.ANA, Button.ULTIMATE)),"    {0}  Scoped shots pierce through enemies!".format(abilityIconString(Hero.ZARYA, Button.ABILITY_2)), "    {0}{1}  You can punch sleeping players!  ".format(abilityIconString(Hero.ANA, Button.MELEE), abilityIconString(Hero.ANA, Button.ABILITY_1)), "    {0}  say GG at the end!".format(iconString(Icon.HEART)), "    {0}  'ana' spelled backwards is 'ana'!".format(iconString(Icon.CHECKMARK)), "    {0}  Reject other modes, embrace Ana Paintball!".format(abilityIconString(Hero.KIRIKO, Button.ULTIMATE)), "    {0}  POV: you are about to play ana paintball".format(abilityIconString(Hero.LUCIO, Button.JUMP)), "    {0}  The scoreboard has cute icons!  {1}".format(abilityIconString(Hero.KIRIKO, Button.ULTIMATE), abilityIconString(Hero.DVA, Button.ULTIMATE)), "    {0}  I spent 100+ hours making this mode!".format(abilityIconString(Hero.TORBJORN, Button.ABILITY_2)), "    {0}  You look cute today!".format(abilityIconString(Hero.ASHE, Button.ULTIMATE)), "    {0} : People who favorite this mode are so hot".format(heroIcon(Hero.WIDOWMAKER))]))
    wait(0.1)
    smallMessage(eventPlayer, "    Mode by Jinko")


rule "Hardscope messages":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isFiringPrimaryFire()
    
    wait(4, Wait.ABORT_WHEN_FALSE)
    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer,random.choice(["    Take your time...", "    That's a long hardscope", "    No quickscopes?"]))
        return


rule "If melee awake player":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.MELEE
    @Condition not victim.hasStatusEffect(Status.ASLEEP)

    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, "    {0}{1}  Melee kills sleeping players only  {0}{1}".format(abilityIconString(Hero.ANA, Button.MELEE), abilityIconString(Hero.ANA, Button.ABILITY_1)))
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 120)
    wait(0.5)


rule "If nanoboosted player uses disabled buttons":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getScore() == NANO_SCORE
    @Condition any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]])
    
    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, "    {0}  You can only use sleep dart!  {0}".format(iconString(Icon.EXCLAMATION_MARK)))
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 120)
    wait(1)