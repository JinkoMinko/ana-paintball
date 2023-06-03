#!mainFile "ANA_PB.opy"

rule "When player dies, display honor HUD": 
    @Event playerDied
    @Hero ana
    @Condition not eventWasEnvironment
    
    victim.HonorTarget = attacker
    victim.HonorBar = 100
    chase(victim.HonorBar, 0, duration=CUSTOM_RESPAWN_TIME + 0.8, ChaseReeval.DESTINATION_AND_DURATION)

rule "Send honor message if GRENADE is pressed":
    @SuppressWarnings w_ow2_rule_condition_chase
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.HonorTarget != null
    @Condition eventPlayer.HonorBar != 0

    eventPlayer.HonorTarget.HonorQueue.append(eventPlayer)
    eventPlayer.HonorTarget.MedalQueue.append(Medal.NICE_SHOT)
    eventPlayer.HonorBar = 0

    eventPlayer.MedalQueue = [Medal.SYSTEM_MESSAGE].concat(eventPlayer.MedalQueue)
    smallMessage(eventPlayer, "    {0}  honor sent to {1}!".format(iconString(Icon.HAPPY), eventPlayer.HonorTarget))
    playEffect(eventPlayer, DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR_SOUND, Color.WHITE, eventPlayer, 200)