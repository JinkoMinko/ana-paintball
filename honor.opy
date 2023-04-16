#!mainFile "ANA_PB.opy"

rule "When player dies, display honor HUD": 
    @Event playerDied
    @Hero ana
    @Condition not eventWasEnvironment
    
    victim.Killer = attacker
    victim.HonorBar = 100
    chase(victim.HonorBar, 0, duration=2.5, ChaseReeval.DESTINATION_AND_DURATION)
    wait(2.6, Wait.RESTART_WHEN_TRUE)
    victim.Killer = null


rule "Sned honor message if GRENADE is pressed":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.Killer != null
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.Killer.NiceShotQueue.append(eventPlayer)
    eventPlayer.Killer.MedalQueue.append(Medal.NICE_SHOT)
    eventPlayer.HonorBar = 0

    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, "    {0}  honor sent to {1}!".format(iconString(Icon.HAPPY), eventPlayer.Killer))
    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 200)
    wait()
    eventPlayer.Killer = null