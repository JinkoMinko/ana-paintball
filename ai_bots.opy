#!mainFile "ANA_PB.opy"

rule "Remove AI bots to leave space for human players":
    @Event eachPlayer
    @Condition getNumberOfPlayers(Team.ALL) - getNumberOfDummyBots(Team.ALL) == getNumberOfSlots(Team.ALL)
    @Condition eventPlayer == nextAIBot

    wait(0, Wait.ABORT_WHEN_FALSE) # let the setup playerJoined rule run first, so IsAIBot is set

    TempAIBotBeingRemoved = nextAIBot

    if not TempAIBotBeingRemoved:
        return

    waitUntil(hostPlayer.hasSpawned(), 99999)
    smallMessage(hostPlayer, "    {0} Removing {1} to leave space for more human players".format(iconString(Icon.BOLT), TempAIBotBeingRemoved))

    removeFromGame(TempAIBotBeingRemoved)
    waitUntil(not entityExists(TempAIBotBeingRemoved), 2)

    # There may be AI Bots in the lobby waiting to join in. Let's remove those too.
    if RULE_CONDITION:
        goto RULE_START
