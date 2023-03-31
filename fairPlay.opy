#!mainFile "ANA_PB.opy"

rule "When player dies, display fair-play HUD": 
    @Event playerDied
    @Hero ana

    victim.Killer = attacker
    victim.FairplayBar = 100
    chase(victim.FairplayBar, 0, duration=2.5, ChaseReeval.DESTINATION_AND_DURATION)
    wait(2.6, Wait.RESTART_WHEN_TRUE)
    victim.Killer = null


rule "Send message if GRENADE is pressed":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.Killer != null
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.Killer.NiceShotQueue.append(eventPlayer)
    eventPlayer.Killer.MedalQueue.append(Medal.NICE_SHOT)
    eventPlayer.FairplayBar = 0

    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, "    {0}  message sent to {1}!".format(iconString(Icon.HAPPY), eventPlayer.Killer))
    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 200)
    wait()
    eventPlayer.Killer = null