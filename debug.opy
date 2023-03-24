#!mainFile "ANA_PB.opy"

rule "Debug HUDs":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    hudSubtext(eventPlayer, "{}".format(getClosestPlayer(eventPlayer, Team.ALL).IsPlayer), HudPosition.TOP, 100, Color.WHITE, HudReeval.STRING)
    
    #hudSubtext(eventPlayer, "looking at: {}".format(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection()*100, getAllPlayers(), eventPlayer, true).getHitPosition()), HudPosition.TOP, 100, Color.WHITE, HudReeval.STRING)


rule "show spawn points":
    @Condition DEBUG_MODE
    @Event global
    for Spawn in range(len(getSpawnPoints(Team.ALL))):
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.GREEN, getSpawnPoints(Team.ALL)[evalOnce(Spawn)].getPosition(), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, getSpawnPoints(Team.ALL)[evalOnce(Spawn)].getPosition(), 0.05, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createInWorldText(getAllPlayers(), "{0}".format(getSpawnPoints(Team.ALL)[evalOnce(Spawn)].getPosition()), getSpawnPoints(Team.ALL)[evalOnce(Spawn)].getPosition(), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.GREEN, SpecVisibility.NEVER)


rule "Create bots with INTERACT":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    createDummy(Hero.ANA, Team.ALL, -1, eventPlayer.getPosition(), eventPlayer.getPosition())
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    

rule "Make bots shoot by shooting":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    #getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.MELEE)
    #getAllPlayers().exclude(eventPlayer).startForcingButton(Button.SECONDARY_FIRE)
    #wait(0.5)
    getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.PRIMARY_FIRE)


rule "TP to closest bot by crouching":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")
    @Condition getNumberOfHeroes(Hero.ANA, Team.ALL) > 1

    eventPlayer.teleport(getClosestPlayer(eventPlayer, Team.ALL))


rule "Make bots use sleep by using sleep":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.ABILITY_1)
    #getAllPlayers().exclude(eventPlayer).startThrottleInDirection(directionTowards(localPlayer.getEyePosition(), Vector.FORWARD), 1, Relativity.TO_PLAYER, Throttle.ADD_TO_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)


rule "Make bots say nice shot":
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


rule "Show where bots are":
    @Condition DEBUG_MODE
    @Event eachPlayer

    createIcon(getAllPlayers(), eventPlayer, Icon.ARROW_DOWN, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN, true)


rule "Start match immediately":
    @Condition DEBUG_MODE
    @Condition isAssemblingHeroes()

    setMatchTime(1)
    wait(1.2)
    setMatchTime(261)
    wait()
    pauseMatchTime()