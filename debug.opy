#!mainFile "ANA_PB.opy"


rule "Start match immediately":
    @Condition DEBUG_MODE
    @Condition isAssemblingHeroes()

    setMatchTime(2)
    wait(2.2)
    setMatchTime(261)
    wait()
    pauseMatchTime()


rule "Show where bots are":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition eventPlayer.isDummy()

    createIcon(getAllPlayers(), eventPlayer, Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN, true)

rule "Debug HUDs":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    #hudSubtext(eventPlayer, "PunchDrunk {}".format(eventPlayer.PunchDrunk), HudPosition.TOP, 100, Color.GREEN, HudReeval.STRING)
    #hudSubtext(eventPlayer, "{}".format(eventPlayer.getFacingDirection()), HudPosition.TOP, 100, Color.ORANGE, HudReeval.STRING)
    
    #hudSubtext(eventPlayer, "looking at: {}".format(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection()*100, getAllPlayers(), eventPlayer, true).getHitPosition()), HudPosition.TOP, 100, Color.WHITE, HudReeval.STRING)

    
rule "INTERACT: create bots":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    createDummy(Hero.ANA, Team.ALL, -1, eventPlayer.getPosition(), eventPlayer.getPosition())
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    

rule "PRIMARY FIRE: make bots attack":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    #getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.MELEE)
    #getAllPlayers().exclude(eventPlayer).startForcingButton(Button.SECONDARY_FIRE)
    #wait(0.5)
    getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.PRIMARY_FIRE)
    #kill(eventPlayer, eventPlayer)


rule "GRENADE: make bots punch":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.MELEE)
    eventPlayer.setAmmo(0, 2)


rule "CROUCH: teleport to closest bot":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")
    @Condition getNumberOfHeroes(Hero.ANA, Team.ALL) > 1

    eventPlayer.teleport(getClosestPlayer(eventPlayer, Team.ALL))


rule "SLEEP DART: make bots use sleep dart":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.ABILITY_1)
    #getAllPlayers().exclude(eventPlayer).startThrottleInDirection(directionTowards(localPlayer.getEyePosition(), Vector.FORWARD), 1, Relativity.TO_PLAYER, Throttle.ADD_TO_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)


rule "bots honor players'":
    @Condition DEBUG_MODE
    @Event playerDied
    @Hero ana
    @Condition not strContains("{0}".format(eventPlayer), "Jinko")
    @Disabled
    wait(1)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait()
    eventPlayer.stopForcingButton(Button.ABILITY_2)


rule "Kill all bots": 
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    destroyAllDummies()


rule "show spawn points":
    @Condition DEBUG_MODE
    @Event global
    @Disabled

    wait(1)
    for Spawn in range(len(SpawnPointSettings)):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.GREEN, SpawnPointSettings[evalOnce(Spawn)], 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, SpawnPointSettings[evalOnce(Spawn)]+vect(0,2,0), 0.1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createInWorldText(getAllPlayers(), "{0}".format(SpawnPointSettings[evalOnce(Spawn)]), SpawnPointSettings[evalOnce(Spawn)]+vect(0,0.5,0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.GREEN, SpecVisibility.NEVER)

    
rule "cycle through to spawn points":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition strContains("{0}".format(eventPlayer), "Jinko")
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Disabled

    eventPlayer.teleport(SpawnPointSettings[IndexValue][0])
    eventPlayer.setFacing(SpawnPointSettings[IndexValue][1], Relativity.TO_WORLD)
    IndexValue +=1

rule "log spawn point and facing direction":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition strContains("{0}".format(eventPlayer), "Jinko")
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Disabled

    printLog(eventPlayer.getPosition())
    printLog(eventPlayer.getFacingDirection())
    smallMessage(eventPlayer, "    printed log")
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.PURPLE, eventPlayer.getPosition(), 0.3, EffectReeval.NONE)