#!mainFile "ANA_PB.opy"

rule "Disable inspector & match ending and initiate text rainbow":
    @Event global
    
    enableInspector() if DEBUG_MODE else disableInspector()
    disableGamemodeCompletion()
    Rainbow = vect(0, 0, 0)
    chase(Rainbow, vect(rainbow(getTotalTimeElapsed() * 50)), rate=99999, ChaseReeval.DESTINATION_AND_RATE)


rule "Player damage & HP settings":
    @Event eachPlayer
    @Hero ana

    eventPlayer.setDamageReceived(0.0001)
    eventPlayer.setMaxHealth(34.5)


rule "Start match sooner & pause timer":
    @Condition not DEBUG_MODE
    @Condition isAssemblingHeroes()
    
    setMatchTime(13)
    wait(13.2)
    setMatchTime(261)
    wait()
    pauseMatchTime()


rule "Detect players": # Differentiate players from spectators & bots
    @Event playerJoined
    @Condition not eventPlayer.isDummy()
    
    eventPlayer.IsPlayer = true
    eventPlayer.setRespawnTime(CUSTOM_RESPAWN_TIME)


rule "Initial spawn message":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.getNumberOfDeaths() == 0

    wait(0.1) # required
    smallMessage(eventPlayer, random.choice([
                                                "    {0}  Discord link on top !  {0}".format(iconString(Icon.ARROW_UP)),
                                                "    {0}  Ana Paintball on TikTok: @Jinko_OW".format(heroIcon(Hero.ANA)),
                                                "    {0}  Scoped shots pierce through enemies!".format(abilityIconString(Hero.ZARYA, Button.ABILITY_2)),
                                                "    {0}{1}  You can punch sleeping players!".format(abilityIconString(Hero.ANA, Button.MELEE), abilityIconString(Hero.ANA, Button.ABILITY_1)),
                                                "    {0}  Guaranteed without bad teammates!".format(iconString(Icon.CHECKMARK)),
                                            ]))
    wait(0.2) # required
    smallMessage(eventPlayer, "    Mode by Jinko#2838")


rule "Restart game when lobby is empty": # For when I spectate randoms
    @Event playerLeft
    @Condition not MatchEnded
    
    if len(getPlayersOnHero(Hero.ANA, Team.ALL)) == 0:
        restartMatch()


rule "Pick spawn points & define playzone":
    @Event global

    if getCurrentMap() == Map.CHATEAU_GUILLARD or getCurrentMap() == Map.CHATEAU_GUILLARD_HALLOWEEN:
        RespawnsCHATEAU()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.PETRA:
        RespawnsPETRA()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.BLACK_FOREST or getCurrentMap() ==Map.BLACK_FOREST_WINTER:
        RespawnsBLACKFOREST()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.MALEVENTO:
        RespawnsMALEVENTO()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.DORADO:
        RespawnsDORADO()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN:
        RespawnsHOLLYWOOD()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.BLIZZ_WORLD or getCurrentMap() == Map.BLIZZ_WORLD_WINTER:
        RespawnsBLIZZWORLD()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.EICHENWALDE or getCurrentMap() == Map.EICHENWALDE_HALLOWEEN:
        RespawnsEICHENWALDE()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.ECOPOINT_ANTARCTICA or getCurrentMap() == Map.ECOPOINT_ANTARCTICA_WINTER:
        RespawnsECOPOINT()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.KANEZAKA:
        RespawnsKANEZAKA()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 25
        RespawnFailsafeDistance = 15
    elif getCurrentMap() == Map.LIJIANG_CONTROL_CENTER or getCurrentMap() == Map.LIJIANG_CONTROL_CENTER_LNY:
        RespawnsLIJANGCONTROL()
        RespawnHigherDistance = 999
        RespawnLowerDistance = 30
        RespawnFailsafeDistance = 15
        PlayzoneCenter = vect(0, 267.28, 282.52)
        PlayzoneRadius = 75
    else: # if the current map is not supported by the mode, use default spawn system
        SpawnPointSettings = 0
        PlayzoneCenter = 0
        PlayzoneRadius = 0


rule "PLAYER EFFECTS":
    @Event eachPlayer
    @Hero ana

    createInWorldText(localPlayer if     # PUNCH TO EXECUTE / DEMOTE PROMPTS
                        not localPlayer.hasStatusEffect(Status.ASLEEP)
                        and eventPlayer.hasStatusEffect(Status.ASLEEP)
                        and distance(localPlayer, eventPlayer) <= 20
                        and eventPlayer.isAlive() and eventPlayer.SleepsOnground
                        and angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), eventPlayer)) < 5
                        and not MatchEnded
                        else [],
                        "{0} punch to {1}".format(
                            abilityIconString(Hero.ANA, Button.MELEE), "demote" if eventPlayer.getScore() > localPlayer.getScore() else "execute"
                        ) if localPlayer.Executes < 3
                        else "",
                        eventPlayer+vect(0, +0.4, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
                        customGreen if eventPlayer.getScore() > localPlayer.getScore() else Color.SKY_BLUE,
                        SpecVisibility.NEVER)

    createStreakEffect(localPlayer if eventPlayer.KillStreak >= ONFIRE_STREAK else [], Effect.SOLDIER_SPRINTING, 10)
    createStreakEffect(localPlayer if eventPlayer.KillStreak >= RAMPAGE_STREAK else [], Effect.ECHO_CLONING, 1)
    createStreakEffect(localPlayer if eventPlayer.KillStreak >= RAMPAGE_STREAK and eventPlayer.RampageSFX == true else [], Effect.WINSTON_PRIMAL_RAGE_SOUND, 80 if eventPlayer == localPlayer else 200)
    
    createEffect(localPlayer if eventPlayer.getScore() == NANO_SCORE and eventPlayer.isAlive() and eventPlayer.NanoDelay else [], Effect.ANA_NANO_BOOSTED, Color.TEAM_1, eventPlayer, 0 if eventPlayer.isUsingUltimate() else 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(localPlayer if eventPlayer.getScore() == NANO_SCORE and eventPlayer.isAlive() and eventPlayer.NanoDelay else [], Effect.ANA_NANO_BOOSTED_SOUND, Color.TEAM_1, eventPlayer, (0 if eventPlayer.isUsingUltimate() else 25) if eventPlayer == localPlayer else 150, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    createEffect(localPlayer if eventPlayer.DemotedEffect == true else [], Effect.SOMBRA_HACKED_SOUND, Color.TEAM_1, eventPlayer, 100 if eventPlayer == localPlayer else 0, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(localPlayer.exclude(eventPlayer) if eventPlayer.RampageVFX == true else [], Effect.WINSTON_PRIMAL_RAGE, Color.TEAM_1, eventPlayer, 70 if eventPlayer == localPlayer else 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(localPlayer if eventPlayer.RampageVFX == true else [], Effect.WRECKING_BALL_ADAPTIVE_SHIELD_TARGET, Color.TEAM_1, eventPlayer, 70 if eventPlayer == localPlayer else 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(localPlayer if MatchEnded else [], Effect.ZENYATTA_ORB_OF_DISCORD_TARGET, Color.TEAM_1, eventPlayer.exclude(Winner), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "AFK detection":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isStanding()
    @Condition not any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]])
    @Condition getNumberOfHeroes(Hero.ANA, Team.ALL) > 2
    @Disabled

    waitUntil(any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding(), 5)
    if any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding():
        return
    smallMessage(eventPlayer, "    Inactivity detected, timeout in 30 seconds")
    waitUntil(any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding(), 5 if DEBUG_MODE else 20)
    if any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding():
        smallMessage(eventPlayer, "    No longer inactive")
        return
    smallMessage(eventPlayer, "    Inactivity detected, timeout in 10 seconds")
    waitUntil(any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding(), 5)
    if any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding():
        smallMessage(eventPlayer, "    No longer inactive")
        return
    smallMessage(eventPlayer, "    Inactivity timeout in 5 seconds")
    waitUntil(any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding(), 1)
    if any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding():
        smallMessage(eventPlayer, "    No longer inactive")
        return
    smallMessage(eventPlayer, "    Inactivity timeout in 4 seconds")
    waitUntil(any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding(), 1)
    if any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding():
        smallMessage(eventPlayer, "    No longer inactive")
        return
    smallMessage(eventPlayer, "    Inactivity timeout in 3 seconds")
    waitUntil(any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding(), 1)
    if any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding():
        smallMessage(eventPlayer, "    No longer inactive")
        return
    smallMessage(eventPlayer, "    Inactivity timeout in 2 seconds")
    waitUntil(any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding(), 1)
    if any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding():
        smallMessage(eventPlayer, "    No longer inactive")
        return
    smallMessage(eventPlayer, "    Inactivity timeout in 1 second")
    waitUntil(any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding(), 1)
    if any([eventPlayer.isHoldingButton(b) for b in [Button.MELEE, Button.RELOAD, Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]]) or not eventPlayer.isStanding():
        smallMessage(eventPlayer, "    No longer inactive")
        return
    wait(3, Wait.ABORT_WHEN_FALSE)
    moveToTeam(eventPlayer, [], -1)