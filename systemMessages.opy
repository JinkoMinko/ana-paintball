#!mainFile "ANA_PB.opy"

rule "Initial spawn message":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.getNumberOfDeaths() == 0

    wait(0.1) #keep
    smallMessage(eventPlayer, random.choice([
                                                "    {0}  Discord server link above the scoreboard!".format(heroIcon(Hero.ANA)),
                                               #"    {0}  Got feedback? Join the discord!".format(iconString(Icon.ARROW_UP)),
                                                "    {0}  Ana Paintball TikTok: @Jinko_OW".format(heroIcon(Hero.ANA)),

                                               #"    {0}  I spent 200+ hours working on it!".format(abilityIconString(Hero.TORBJORN, Button.ABILITY_2)),
                                               #"    {0}  Created in 2019!".format(abilityIconString(Hero.BASTION, Button.ABILITY_1)),

                                               #"    {0}  Good luck have fun!".format(iconString(Icon.HAPPY)),
                                               #"    {0}  say GG at the end of the game!".format(iconString(Icon.HEART)),
                                               #"    {0}  I bet you're gonna win this one!".format(iconString(Icon.SPADE)),

                                               #"    {0}  Press [{1}] after dying to honor your killer!".format(iconString(Icon.HEART), buttonString(Button.INTERACT)),
                                               #"    {0}  You can see your stats in the top left corner!".format(abilityIconString(Hero.ANA, Button.ULTIMATE)),
                                               #"    {0}  Nanoboost reduces sleep dart's cooldown!".format(abilityIconString(Hero.ANA, Button.ULTIMATE)),
                                               "    {0}  Scoped shots pierce through enemies!".format(abilityIconString(Hero.ZARYA, Button.ABILITY_2)),
                                               #"    {0}{1}  You can punch sleeping players to execute them!".format(abilityIconString(Hero.ANA, Button.MELEE), abilityIconString(Hero.ANA, Button.ABILITY_1)),
                                               #"    {0}{1}  Execute players with a better score to demote them!".format(abilityIconString(Hero.ANA, Button.MELEE), abilityIconString(Hero.HAMMOND, Button.CROUCH)),
                                                
                                               #"    {0}  'ana' spelled backwards is 'ana'!".format(iconString(Icon.CHECKMARK)),
                                               #"    {0}  Honoring others makes you 69% more likely to win!".format(iconString(Icon.CHECKMARK)),
                                               #"    {0}  Reject ranked, play Ana Paintball!".format(abilityIconString(Hero.LUCIO, Button.JUMP)),
                                               "    {0}  Guaranteed with 0% bad teammates!".format(iconString(Icon.CHECKMARK)),
                                               #"    {0}  ur cute if you read this".format(abilityIconString(Hero.ASHE, Button.ULTIMATE)),
                                               #"    {0}  An hour of Ana PB a day keeps bad teammates away!".format(abilityIconString(Hero.ROADHOG, Button.ABILITY_2)),
                                            ]))
    #wait(0.2) #keep that
    #smallMessage(eventPlayer, "    Mode by Jinko")


rule "Hardscope messages":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isFiringPrimaryFire()
    
    wait(4, Wait.ABORT_WHEN_FALSE)
    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer,random.choice(["    Take your time...", "    That's a long hardscope", "    No quickscopes?"]))
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
    smallMessage(eventPlayer, "    {0}  Use sleep dart to win!  {0}".format(iconString(Icon.EXCLAMATION_MARK)))
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer, 120)
    wait(1)