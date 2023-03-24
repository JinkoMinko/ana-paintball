rule "":
    @Event playerDied
    @Hero ana

    wait(1)

    AlivePlayers = [p for p in getAllPlayers() if p.isAlive() and p.getCurrentHero() == Hero.ANA]

    A = sorted([s for s in SpawnPoints if
    isSpawnpointEligible(s, AlivePlayers[0])
    and isSpawnpointEligible(s, AlivePlayers[1])
    and isSpawnpointEligible(s, AlivePlayers[2])
    and isSpawnpointEligible(s, AlivePlayers[3])
    and isSpawnpointEligible(s, AlivePlayers[4])
    and isSpawnpointEligible(s, AlivePlayers[5])
    and isSpawnpointEligible(s, AlivePlayers[6])
    and isSpawnpointEligible(s, AlivePlayers[7])
        ][0], lambda s: 
            min(
                min(
                    min(
                        min(
                            min(
                                min(
                                    min(
                                        min(distanceCheck(s, AlivePlayers[0]),
                                            distanceCheck(s, AlivePlayers[1])),
                                            distanceCheck(s, AlivePlayers[2])),
                                            distanceCheck(s, AlivePlayers[3])),
                                            distanceCheck(s, AlivePlayers[4])),
                                            distanceCheck(s, AlivePlayers[5])),
                                            distanceCheck(s, AlivePlayers[6])),
                                            distanceCheck(s, AlivePlayers[7])),
        ) or random.choice(SpawnPoints))

    victim.teleport(A)
    victim.setFacing(SpawnFacings[SpawnPoints.index(A)], Relativity.TO_PLAYER)