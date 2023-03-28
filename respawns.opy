#!mainFile "ANA_PB.opy"

# rule "initial spawn + initial spawn message":
#     @Event global
#     @Condition isAssemblingHeroes() == false
#     @Disabled

#     InitialSpawns = SpawnPointSettings
#     for i in range(len(getAllPlayers())):
#         PlayerSpawnPoint = random.choice(InitialSpawns)
#         getAllPlayers()[i].teleport(PlayerSpawnPoint[0])
#         getAllPlayers()[i].setFacing(PlayerSpawnPoint[1])
#         InitialSpawns = [point for point in InitialSpawns if distanceBetween(point, PlayerSpawnPoint[0]) >= some_distance]


rule "Respawns":
    @Event playerDied
    @Hero ana
    @Condition SpawnPointSettings != 0

    eventPlayer.disableNameplatesFor(getAllPlayers())
    waitUntil(eventPlayer.isAlive(), 9)
    eventPlayer.setInvisibility(Invis.ALL)

    eventPlayer.AlivePlayers = [
        p for p in getAllPlayers() if 
            p != eventPlayer and
            p.isAlive() and 
            p.hasSpawned() and
            p.getCurrentHero() == Hero.ANA 
            # p.isDummy
    ]

    eventPlayer.SpawnPointsNotInLOS = [
        s for s in SpawnPointSettings if
            playerCantSeeSpawnPoint(s[0], eventPlayer.AlivePlayers[0]) and 
            playerCantSeeSpawnPoint(s[0], eventPlayer.AlivePlayers[1]) and 
            playerCantSeeSpawnPoint(s[0], eventPlayer.AlivePlayers[2]) and 
            playerCantSeeSpawnPoint(s[0], eventPlayer.AlivePlayers[3]) and 
            playerCantSeeSpawnPoint(s[0], eventPlayer.AlivePlayers[4]) and 
            playerCantSeeSpawnPoint(s[0], eventPlayer.AlivePlayers[5]) and 
            playerCantSeeSpawnPoint(s[0], eventPlayer.AlivePlayers[6])
    ]
    if len(eventPlayer.SpawnPointsNotInLOS) == 0:
        # failsafe
        eventPlayer.SpawnPointsNotInLOS = SpawnPointSettings
    
    eventPlayer.SpawnPointsFarEnoughFromPlayers = [
        s for s in eventPlayer.SpawnPointsNotInLOS if
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[0], 25, 40) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[1], 25, 40) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[2], 25, 40) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[3], 25, 40) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[4], 25, 40) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[5], 25, 40) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[6], 25, 40)
    ]

    if len(eventPlayer.SpawnPointsFarEnoughFromPlayers) == 0:
        # failsafe
        eventPlayer.SpawnPointsFarEnoughFromPlayers = [
        s for s in eventPlayer.SpawnPointsNotInLOS if
            distanceFromPointToPlayer(s[0], eventPlayer.AlivePlayers[0]) >= 15 and 
            distanceFromPointToPlayer(s[0], eventPlayer.AlivePlayers[1]) >= 15 and 
            distanceFromPointToPlayer(s[0], eventPlayer.AlivePlayers[2]) >= 15 and 
            distanceFromPointToPlayer(s[0], eventPlayer.AlivePlayers[3]) >= 15 and 
            distanceFromPointToPlayer(s[0], eventPlayer.AlivePlayers[4]) >= 15 and 
            distanceFromPointToPlayer(s[0], eventPlayer.AlivePlayers[5]) >= 15 and 
            distanceFromPointToPlayer(s[0], eventPlayer.AlivePlayers[6]) >= 15
        ]
    if len(eventPlayer.SpawnPointsFarEnoughFromPlayers) == 0:
        # failsafe
        eventPlayer.SpawnPointsFarEnoughFromPlayers = eventPlayer.SpawnPointsNotInLOS

    eventPlayer.ChosenSpawnPoint = random.choice(eventPlayer.SpawnPointsFarEnoughFromPlayers)
    eventPlayer.teleport(eventPlayer.ChosenSpawnPoint[0])
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.enableNameplatesFor(getAllPlayers())
    eventPlayer.setFacing(eventPlayer.ChosenSpawnPoint[1], Relativity.TO_WORLD)
    wait()
    eventPlayer.setFacing(eventPlayer.ChosenSpawnPoint[1], Relativity.TO_WORLD)
    wait()
    eventPlayer.setFacing(eventPlayer.ChosenSpawnPoint[1], Relativity.TO_WORLD)
    wait()
    eventPlayer.setFacing(eventPlayer.ChosenSpawnPoint[1], Relativity.TO_WORLD)


rule "select spawn settings based on current map":
    @Event global
    if getCurrentMap() == Map.CHATEAU_GUILLARD or getCurrentMap() == Map.CHATEAU_GUILLARD_HALLOWEEN:
        SpawnPointSettings = [
            [vect(165.76, 5.00, 81.00), vect(1.00, 0.00, 0.00)],
            [vect(185.50, 1.00, 72.40), vect(0.47, 0.00, -0.88)],
            [vect(167.64, 5.00, 76.94), vect(0.88, 0.00, 0.48)],
            [vect(170.00, 7.00, 69.50), vect(0.84, 0.00, -0.55)],
            [vect(177.00, 0.00, 51.50), vect(1.00, 0.00, 0.07)],
            [vect(194.68, 1.00, 66.55), vect(-0.74, 0.00, 0.68)],
            [vect(202.00, 0.00, 84.20), vect(0.63, 0.00, -0.78)],
            [vect(210.50, 0.00, 84.20), vect(-0.68, 0.00, -0.73)],
            [vect(202.55, 0.00, 70.12), vect(0.55, 0.00, 0.83)],
            [vect(210.18, 0.00, 70.46), vect(-0.57, 0.00, 0.82)],
            [vect(224.60, 1.00, 75.30), vect(-0.77, 0.00, 0.63)],
            [vect(224.40, 1.00, 80.70), vect(-1.00, 0.00, -0.01)],
            [vect(215.75, 2.00, 93.49), vect(0.71, 0.00, -0.71)],
            [vect(238.63, 2.00, 84.62), vect(-0.71, 0.00, 0.71)],
            [vect(233.80, 2.00, 100.20), vect(-0.90, 0.00, -0.43)],
            [vect(228.51, 2.00, 101.19), vect(0.52, 0.00, -0.85)],
            [vect(216.75, 6.00, 106.51), vect(0.71, 0.00, -0.70)],
            #[vect(212.90, 9.00, 92.30), vect(-0.90, 0.00, 0.43)],
            #[vect(208.30, 9.00, 89.40), vect(-0.57, 0.00, 0.82)],
            [vect(204.15, 9.00, 89.40), vect(0.55, 0.00, 0.83)],
            [vect(189.60, 9.00, 110.00), vect(1.00, 0.00, -0.00)],
            #[vect(189.00, 8.00, 97.50), vect(0.89, 0.00, 0.46)],
            [vect(176.53, 9.00, 108.5), vect(0.5, 0.00, -0.86)],
            [vect(212.40, 8.00, 47.10), vect(-0.54, 0.00, 0.84)],
            [vect(220.35, 12.00, 43.89), vect(-0.74, 0.00, 0.67)],
            #[vect(222.60, 8.00, 85.50), vect(-0.69, 0.00, 0.73)],
            [vect(209.20, 9.00, 83.40), vect(-0.57, 0.00, -0.82)],
            #[vect(203.10, 9.00, 83.35), vect(0.58, 0.00, -0.81)],
            [vect(202.50, 8.00, 73.60), vect(0.59, 0.00, 0.80)],
            [vect(209.69, 8.00, 73.08), vect(-0.55, 0.00, 0.83)],
            [vect(220.06, 8.00, 69.50), vect(0.22, 0.00, 0.97)],
            [vect(218.03, 9.00, 61.03), vect(-1.00, 0.00, -0.08)],
            [vect(222.50, 8.00, 80.00), vect(-0.72, 0.00, 0.70)],
            [vect(194.00, 8.00, 58.00), vect(-0.61, 0.00, 0.79)],
            [vect(225.30, 13.00, 62.00), vect(-1.00, 0.00, -0.01)],
            [vect(218.00, 5.00, 110.00), vect(0.81, 0.00, 0.58)],
            [vect(218.00, 5.00, 114.60), vect(0.77, 0.00, -0.64)],
            [vect(222.60, 6.00, 107.30), vect(-0.36, 0.00, -0.93)],
            [vect(236.50, 4.00, 113.40), vect(-0.71, 0.00, -0.70)],
            [vect(181.00, 1.66, 84.71), vect(0.99, 0.00, -0.10)],
            [vect(180.88, 1.67, 81.50), vect(0.81, 0.00, 0.59)],
            [vect(187.88, 1.00, 93.50), vect(-0.66, 0.00, -0.75)],
            [vect(172.90, 5.00, 92.30), vect(0.73, 0.00, -0.68)],
            [vect(183.50, 9.00, 108.50), vect(-0.17, 0.0, -0.99)],
            [vect(188.73, 8.00, 106.49), vect(0.52, 0.0, -0.85)],
            [vect(188.50, 9.00, 115.00), vect(0.90, 0.00, -0.43)],
            [vect(193.12, 9.00, 116.87), vect(0.02, 0.00, -1.00)],
            [vect(192.10, 8.00, 90.50), vect(0.71, 0.0, 0.70)],
            [vect(188.85, 6.00, 74.58), vect(-1, 0.0, 0.03)],
            [vect(171.78, 7.66, 94.46), vect(0.78, 0.00, -0.63)],
            #[vect(222.00, 8.00, 98.00), vect(-1.00, 0.0, -0.01)],
            [vect(222.40, 2.00, 93.20), vect(-0.41, 0.00, -0.91)],
            [vect(201.75, 0.71, 78.00), vect(1.00, 0.00, -0.00)],
            [vect(210.75, 0.71, 78.00), vect(-1.00, 0.00, -0.00)],
            [vect(198.00, 1.00, 78.05), vect(-0.95, 0.00, -0.32)],
            [vect(177.30, 7.00, 59.74), vect(-0.97, 0.00, -0.25)],
            [vect(170.00, 7.00, 59.43), vect(1.00, 0.00, 0.06)],
            [vect(170.00, 7.00, 63.00), vect(0.95, 0.00, 0.31)],
            [vect(177.36, 7.00, 65.90), vect(-1.00, 0.00, 0.00)],
            #[vect(188.50, 6.00, 90.00), vect(-0.87, 0.00, -0.50)],
            [vect(183.20, 6.00, 82.50), vect(0.93, 0.00, 0.36)],
        ]
    elif getCurrentMap() == Map.PETRA:
        SpawnPointSettings = [
        [vect(10.99, -5.72, -14.02), vect(0.73, 0.00, 0.68)],
        [vect(-38.36, -10.65, -15.66), vect(0.05, 0.00, 1.00)],
        [vect(-31.14, -11.67, 22.25), vect(0.51, 0.00, -0.86)],
        [vect(-27.86, -11.88, 22.24), vect(-0.68, 0.00, -0.74)],
        [vect(-24.83, -11.63, 19.22), vect(-0.57, 0.00, -0.82)],
        [vect(-45.20, -13.05, 16.69), vect(0.99, 0.00, 0.15)],
        [vect(-30.79, -5.00, 23.25), vect(0.47, 0.00, -0.88)],
        [vect(-15.25, -8.18, 17.22), vect(-0.76, 0.00, 0.65)],
        [vect(-3.24, -11.00, 30.79), vect(0.85, 0.00, -0.52)],
        [vect(7.24, -11.00, 30.79), vect(-0.77, 0.00, -0.63)],
        [vect(6.50, -12.79, 32.80), vect(-0.56, 0.00, 0.83)],
        [vect(-2.50, -11.90, 32.80), vect(0.55, 0.00, 0.83)],
        [vect(-6.50, -12.68, 40.57), vect(0.85, 0.00, 0.53)],
        [vect(5.20, -11.58, 60.53), vect(-0.93, 0.00, -0.34)],
        [vect(34.91, -9.43, 21.37), vect(-0.63, 0.00, 0.78)],
        [vect(28.25, -5.80, 11.79), vect(-0.83, 0.00, -0.56)],
        [vect(27.82, -5.71, 5.78), vect(-0.76, 0.00, 0.65)],
        [vect(19.75, -5.81, 6.23), vect(0.41, 0.00, 0.91)],
        [vect(19.83, -5.69, 11.87), vect(0.37, 0.00, -0.93)],
        [vect(-13.25, -9.33, -1.25), vect(0.66, 0.00, 0.75)],
        [vect(-9.34, -5.00, 39.25), vect(-0.61, 0.00, -0.79)],
        [vect(-12.79, -4.98, -5.75), vect(0.61, 0.00, -0.79)],
        [vect(-6.75, -5.61, -14.79), vect(-0.70, 0.00, 0.71)],
        [vect(-18.51, -6.03, -6.75), vect(-0.75, 0.00, -0.66)],
        [vect(3.65, -1.00, -13.36), vect(-0.91, 0.00, -0.42)],
        [vect(0.36, -1.00, -13.34), vect(0.91, 0.00, -0.42)],
        [vect(-7.21, 1.00, -19.24), vect(-0.21, -0.00, 0.98)],
        [vect(4.81, -4.99, -17.37), vect(-0.66, -0.00, 0.75)],
        [vect(-0.81, -5.40, -17.37), vect(0.66, 0.00, 0.75)],
        [vect(8.85, -6.00, -11.19), vect(-0.52, 0.00, 0.85)],
        [vect(16.24, -5.69, -6.72), vect(-0.81, 0.00, -0.58)],
        [vect(27.79, -4.00, -14.24), vect(-0.62, 0.00, 0.78)],
        [vect(28.04, -4.00, -5.54), vect(-0.90, -0.00, 0.43)],
        [vect(-36.27, -12.18, 12.22), vect(0.06, 0.00, -1.00)],
        [vect(-13.81, -9.00, 35.25), vect(-0.66, 0.00, -0.75)],
        [vect(-22.09, -6.02, 53.22), vect(0.97, 0.00, -0.22)],
        [vect(-9.87, -9.95, 14.38), vect(-0.24, 0.00, 0.97)],
        [vect(7.63, -5.93, -5.15), vect(-1, 0.00, -0.10)],
        [vect(-10.79, 1.05, -19.24), vect(0.50, -0.00, 0.87)],
    ]
    else:
        SpawnPointSettings = 0 