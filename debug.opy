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

    hudSubtext(eventPlayer, "{}".format(eventPlayer.MultiKillCount), HudPosition.TOP, 100, Color.ORANGE, HudReeval.STRING)
    #hudSubtext(eventPlayer, updateEveryTick("{}".format(eventPlayer.getPosition())), HudPosition.TOP, 100, Color.WHITE, HudReeval.STRING)
    #hudSubtext(eventPlayer, "looking at: {}".format(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection()*100, getAllPlayers(), eventPlayer, true).getHitPosition()), HudPosition.TOP, 100, Color.WHITE, HudReeval.STRING)

    #hudSubtext(eventPlayer, "Cam pos: {}".format(updateEveryTick(NukeImpactPos + normalize(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z)) * 55 + vect(0, NukeImpactPos.y, 0) + vect(0, 80, 0)), NukeImpactPos, 0), HudPosition.TOP, 100, Color.ORANGE, HudReeval.STRING)
    #hudSubtext(eventPlayer, "NukeImpactPos: {}".format(NukeImpactPos), HudPosition.TOP, 100, Color.ORANGE, HudReeval.STRING)

    
rule "INTERACT: spawn bots":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    createDummy(Hero.ANA, Team.ALL, -1, eventPlayer.getPosition(), eventPlayer.getPosition())
    getLastCreatedEntity().startForcingName("Ana {0}".format(BotName))
    BotName += 1
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    

rule "ULT + INTERACT":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    eventPlayer.disableEnvironmentCollision(false)
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 5)
    eventPlayer.enableEnvironmentCollision()


rule "PRIMARY FIRE: make bots attack":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.PRIMARY_FIRE)

rule "GRENADE: make bots punch":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.MELEE)


rule "CROUCH: teleport to closest bot":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")
    @Condition getNumberOfHeroes(Hero.ANA, Team.ALL) > 1

    eventPlayer.teleport(getClosestPlayer(eventPlayer, Team.ALL))


rule "RELOAD: make bots use sleep dart":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    getAllPlayers().exclude(eventPlayer).forceButtonPress(Button.ABILITY_1)

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
    BotName = 1


rule "Reset score": 
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition strContains("{0}".format(eventPlayer), "Jinko")

    kill(eventPlayer, null)
    eventPlayer.setScore(0)


    #    #    #    #    # SPAWN POINTS TOOL

rule "show spawn points":
    @Condition DEBUG_MODE
    @Event global
    @Disabled

    wait(1)
    for Spawn in range(len(SpawnPointSettings)):
        #createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.GREEN, SpawnPointSettings[evalOnce(Spawn)], 0.3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createInWorldText(getAllPlayers(), "{0}".format(SpawnPointSettings[evalOnce(Spawn)]), SpawnPointSettings[evalOnce(Spawn)]+vect(0,0.5,0), 1, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.GREEN, SpecVisibility.NEVER)
        #createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, SpawnPointSettings[evalOnce(Spawn)]+vect(0,2,0), 0.1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    
rule "log spawn point and facing direction":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition strContains("{0}".format(eventPlayer), "Jinko")
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Disabled

    printLog("[vect{0}, vect{1}],".format(eventPlayer.getPosition(), normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1))))
    smallMessage(eventPlayer, "    {0} printed log".format(iconString(Icon.CHECKMARK)))
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.PURPLE, eventPlayer.getPosition(), 0.3, EffectReeval.NONE)


rule "cycle through to spawn points":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition strContains("{0}".format(eventPlayer), "Jinko")
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Disabled

    eventPlayer.teleport(SpawnPointSettings[IndexValue][0])
    eventPlayer.setFacing(SpawnPointSettings[IndexValue][1], Relativity.TO_WORLD)
    IndexValue +=1
    #wait(0.5)
    #goto RULE_START



    #    #    #    #    # NUKE TOOL

rule "Debug HUDs":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Hero ana
    @Condition strContains("{0}".format(eventPlayer), "Jinko")
    @Disabled

    hudSubtext(eventPlayer, "Cam pos: {}".format(updateEveryTick(NukeImpactPos + normalize(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z)) * 55 + vect(0, NukeImpactPos.y, 0) + vect(0, 80, 0)), NukeImpactPos, 0), HudPosition.TOP, 100, Color.ORANGE, HudReeval.STRING)
    hudSubtext(eventPlayer, "NukeImpactPos: {}".format(NukeImpactPos), HudPosition.TOP, 100, Color.ORANGE, HudReeval.STRING)


rule "Define NukeImpactPos":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Disabled

    destroyAllEffects()
    NukeImpactPos = raycast(eventPlayer.getEyePosition(),  eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 500, null, eventPlayer, false).getHitPosition()
    createEffect(getAllPlayers(), Effect.SPHERE, Color.GREEN, NukeImpactPos, 0.5, EffectReeval.NONE)


rule "Show nuke cam":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Disabled

    #!define dist 55
    #!define heightOffset vect(0, 80, 0)
    eventPlayer().startCamera(updateEveryTick(NukeImpactPos + normalize(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z)) * dist + vect(0, NukeImpactPos.y, 0) + heightOffset), NukeImpactPos, 0)
    waitUntil(eventPlayer.isMeleeing(), 99)
    eventPlayer.stopCamera()


rule "Print vectors":
    @Condition DEBUG_MODE
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Disabled

    printLog("NukeImpactPos = vect{}".format(NukeImpactPos))
    printLog("NukeCamPos = vect{}".format(updateEveryTick(NukeImpactPos + normalize(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z)) * dist + vect(0, NukeImpactPos.y, 0) + heightOffset), NukeImpactPos, 0))
    smallMessage(eventPlayer, "    {} printed log".format(iconString(Icon.CHECKMARK)))



