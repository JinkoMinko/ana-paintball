#!mainFile "ANA_PB.opy"

rule "Count human kills of AI bots":
    @Event playerDied
    @Condition not attacker.IsAIBot
    @Condition victim.IsAIBot

    attacker.AIBotKillsPerSlot[victim.getSlot()] += 1

rule "Store slot of AI bot that just joined":
    @Event eachPlayer
    @Condition eventPlayer.IsAIBot

    AIBotSlots.append(eventPlayer.getSlot())

rule "Remove scores from players who killed the AI bot that just left":
    @Event playerLeft
    @Condition RevertKillsToAIBotsEnabled

    TempLeavingAIBotSlot = -1
    for i in range(getNumberOfSlots(Team.ALL)):
        if i in AIBotSlots and (not entityExists(getPlayersInSlot(i, Team.ALL)) or not getPlayersInSlot(i, Team.ALL).IsAIBot):
            TempLeavingAIBotSlot = i
            break

    if TempLeavingAIBotSlot >= 0:
        AIBotSlots.remove(TempLeavingAIBotSlot)

        for i in range(getNumberOfSlots(Team.ALL)):
            if not getPlayersInSlot(i, Team.ALL).IsAIBot and not getPlayersInSlot(i, Team.ALL).isDummy():
                getPlayersInSlot(i, Team.ALL).setScore(
                    getPlayersInSlot(i, Team.ALL).getScore() - getPlayersInSlot(i, Team.ALL).AIBotKillsPerSlot[TempLeavingAIBotSlot]
                )
                getPlayersInSlot(i, Team.ALL).AIBotKillsPerSlot[TempLeavingAIBotSlot] = 0

rule "Remove AI bots to leave space for human players":
    @Event eachPlayer
    @Condition getNumberOfPlayers(Team.ALL) - getNumberOfDummyBots(Team.ALL) == getNumberOfSlots(Team.ALL)
    @Condition eventPlayer == nextAIBot

    wait(0, Wait.ABORT_WHEN_FALSE) # let the setup playerJoined rule run first, so IsAIBot is set

    TempAIBotBeingRemoved = nextAIBot
    TempAIBotBeingRemovedName = "{0}".format(TempAIBotBeingRemoved)

    if not TempAIBotBeingRemoved:
        return

    waitUntil(hostPlayer.hasSpawned(), 99999)
    smallMessage(hostPlayer, "    {0} Removing {1} to leave space for more human players".format(iconString(Icon.BOLT), TempAIBotBeingRemovedName))

    removeFromGame(TempAIBotBeingRemoved)
    waitUntil(not entityExists(TempAIBotBeingRemoved), 2)

    # There may be AI Bots in the lobby waiting to join in. Let's remove those too.
    if RULE_CONDITION:
        goto RULE_START
