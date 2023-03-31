#!mainFile "ANA_PB.opy"

rule "Respawns":
    @Event playerDied
    @Hero ana
    @Condition SpawnPointSettings != 0

    eventPlayer.disableNameplatesFor([getAllPlayers(), localPlayer])
    wait(0.7)
    eventPlayer.setInvisibility(Invis.ALL)
    waitUntil(eventPlayer.isAlive(), 9)

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
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[0], 25, 55) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[1], 25, 55) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[2], 25, 55) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[3], 25, 55) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[4], 25, 55) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[5], 25, 55) and
            distanceFromPointToPlayerBetween(s[0], eventPlayer.AlivePlayers[6], 25, 55)
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
    eventPlayer.setFacing(eventPlayer.ChosenSpawnPoint[1], Relativity.TO_WORLD)
    wait()
    eventPlayer.setFacing(eventPlayer.ChosenSpawnPoint[1], Relativity.TO_WORLD)
    wait()
    eventPlayer.setFacing(eventPlayer.ChosenSpawnPoint[1], Relativity.TO_WORLD)
    wait()
    eventPlayer.setFacing(eventPlayer.ChosenSpawnPoint[1], Relativity.TO_WORLD)
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.enableNameplatesFor(getAllPlayers())


rule "select spawn settings based on current map":
    @Event global
    if getCurrentMap() == Map.CHATEAU_GUILLARD or getCurrentMap() == Map.CHATEAU_GUILLARD_HALLOWEEN:
        SpawnPointSettings = [
            [vect(165.76, 5.00, 81.00), vect(1.00, 0.00, 0.00)],
            [vect(185.50, 1.00, 72.40), vect(0.83, 0.00, -0.56)],
            [vect(167.64, 5.00, 76.94), vect(0.88, 0.00, 0.48)],
            [vect(170.00, 7.00, 69.50), vect(0.84, 0.00, -0.55)],
            [vect(177.00, 0.00, 51.50), vect(1.00, 0.00, 0.07)],
            [vect(194.68, 1.00, 66.55), vect(-0.74, 0.00, 0.68)],
            [vect(202.00, 0.00, 84.20), vect(0.63, 0.00, -0.78)],
            [vect(210.50, 0.00, 84.20), vect(-0.68, 0.00, -0.73)],
            [vect(202.55, 0.00, 70.12), vect(0.55, 0.00, 0.83)],
            [vect(210.18, 0.00, 70.46), vect(-0.57, 0.00, 0.82)],
            [vect(224.40, 1.00, 80.70), vect(-1.00, 0.00, -0.01)],
            [vect(215.75, 2.00, 93.49), vect(0.71, 0.00, -0.71)],
            [vect(238.63, 2.00, 84.62), vect(-0.71, 0.00, 0.71)],
            [vect(233.80, 2.00, 100.20), vect(-0.90, 0.00, -0.43)],
            [vect(228.51, 2.00, 101.19), vect(0.52, 0.00, -0.85)],
            [vect(204.15, 9.00, 89.40), vect(0.55, 0.00, 0.83)],
            [vect(189.60, 9.00, 110.00), vect(1.00, 0.00, -0.00)],
            [vect(176.53, 9.00, 108.5), vect(0.5, 0.00, -0.86)],
            [vect(220.35, 12.00, 43.89), vect(-0.86, 0.00, 0.50)],
            [vect(209.20, 9.00, 83.40), vect(-0.57, 0.00, -0.82)],
            [vect(202.50, 8.00, 73.60), vect(1.00, 0.00, 0.00)],
            [vect(209.69, 8.00, 73.08), vect(-1.00, 0.00, 0.00)],
            [vect(220.06, 8.00, 69.50), vect(0.22, 0.00, 0.97)],
            [vect(218.91, 9.00, 61.07), vect(-1.00, 0.00, -0.08)],
            [vect(222.50, 8.00, 80.00), vect(-0.72, 0.00, 0.70)],
            [vect(225.30, 13.00, 62.00), vect(-1.00, 0.00, -0.01)],
            [vect(222.60, 6.00, 107.30), vect(-0.36, 0.00, -0.93)],
            [vect(236.50, 4.00, 113.40), vect(-0.24, 0.00, -0.97)],
            [vect(181.00, 1.66, 84.71), vect(0.93, 0.00, -0.36)],
            [vect(180.88, 1.67, 81.50), vect(0.72, 0.00, 0.69)],
            [vect(188.74, 1.00, 93.79), vect(-0.97, 0.00, -0.26)],
            [vect(172.90, 5.00, 92.30), vect(0.73, 0.00, -0.68)],
            [vect(183.50, 9.00, 108.50), vect(-0.17, 0.00, -0.99)],
            [vect(188.73, 8.00, 106.49), vect(0.52, 0.00, -0.85)],
            [vect(188.50, 9.00, 115.00), vect(0.90, 0.00, -0.43)],
            [vect(193.12, 9.00, 116.87), vect(0.02, 0.00, -1.00)],
            [vect(222.75, 2.00, 93.49), vect(-0.92, 0.00, -0.39)],
            [vect(177.30, 7.00, 59.74), vect(-0.97, 0.00, -0.25)],
            [vect(188.50, 6.00, 90.00), vect(-0.87, 0.00, -0.50)],
            [vect(222.00, 8.00, 98.00), vect(-1.00, 0.0, -0.01)],
            [vect(203.10, 9.00, 83.35), vect(0.58, 0.00, -0.81)],
            [vect(208.30, 9.00, 89.40), vect(-0.57, 0.00, 0.82)],
            [vect(225.71, 1.00, 78.32), vect(-0.92, 0.00, 0.40)],
            [vect(238.63, 2.00, 90.67), vect(-1.00, 0.00, -0.01)],
            [vect(210.38, 8.00, 110.58), vect(-1.00, 0.00, -0.03)],
            [vect(212.99, 8.00, 95.91), vect(-1.00, 0.00, -0.10)],
            [vect(217.31, 5.00, 109.50), vect(1.00, 0.00, 0.00)],
            [vect(217.31, 5.00, 114.61), vect(1.00, 0.00, 0.00)],
            [vect(177.25, 7.00, 63.99), vect(-0.40, 0.00, 0.91)],
            [vect(176.04, 7.00, 70.00), vect(-0.28, 0.00, -0.96)],
            [vect(168.87, 7.00, 67.51), vect(0.72, 0.00, -0.69)],
        ] # 51

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
            [vect(-7.21, 1.00, -19.24), vect(-0.21, 0.00, 0.98)],
            [vect(4.81, -4.99, -17.37), vect(-0.66, 0.00, 0.75)],
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
            [vect(-10.79, 1.05, -19.24), vect(0.50, 0.00, 0.87)],
            [vect(24.37, -10.19, 26.91), vect(-0.19, 0.00, 0.98)],
            [vect(11.14, -12.19, 57.62), vect(0.70, 0.00, -0.71)],
            [vect(-7.74, -10.11, 52.59), vect(0.88, 0.00, 0.47)],
            [vect(22.17, -10.87, 44.60), vect(0.26, 0.00, -0.97)],
            [vect(-40.94, -12.79, 22.58), vect(0.05, 0.00, -1.00)],
        ] # 44

    elif getCurrentMap() == Map.MALEVENTO:
        SpawnPointSettings = [
            [vect(49.14, 6.00, 18.50), vect(-1.00, 0.00, -0.00)],
            [vect(49.25, 4.00, 24.78), vect(-1.00, 0.00, -0.02)],
            [vect(38.32, 3.00, 17.00), vect(-0.54, 0.00, 0.84)],
            [vect(40.88, 6.00, 30.29), vect(-0.97, 0.00, 0.25)],
            [vect(8.70, 4.00, 30.84), vect(0.77, 0.00, 0.64)],
            [vect(6.28, 1.56, 33.49), vect(-0.83, 0.00, -0.56)],
            [vect(-4.21, 8.59, 39.42), vect(0.60, 0.00, -0.80)],
            [vect(-7.25, 2.00, 10.28), vect(0.98, 0.00, -0.22)],
            [vect(-7.25, 1.00, 1.75), vect(0.95, 0.00, 0.30)],
            [vect(7.25, 1.00, 1.75), vect(-0.95, 0.00, 0.30)],
            [vect(0.58, 2.00, 7.14), vect(-0.03, 0.00, 1.00)],
            [vect(-7.25, 5.50, 1.75), vect(0.84, -0.00, 0.54)],
            [vect(20.06, 6.00, -4.27), vect(0.65, 0.00, 0.76)],
            [vect(33.67, 5.50, -5.35), vect(-0.76, 0.00, -0.65)],
            [vect(33.55, 3.16, -14.22), vect(-0.93, 0.00, -0.36)],
            [vect(25.68, 2.00, -29.70), vect(-0.27, 0.00, 0.96)],
            [vect(32.39, 3.00, -20.42), vect(-0.95, 0.00, -0.30)],
            [vect(24.57, 1.00, -0.15), vect(-0.87, 0.00, -0.50)],
            [vect(6.80, 5.00, -29.91), vect(-0.80, 0.00, 0.60)],
            [vect(2.91, -3.50, -35.07), vect(-0.28, 0.00, 0.96)],
            [vect(6.99, -3.27, -31.79), vect(-0.85, 0.00, 0.52)],
            [vect(3.97, -3.50, -26.85), vect(-0.89, 0.00, -0.45)],
            [vect(-14.24, -2.32, -13.98), vect(-0.99, 0.00, 0.12)],
            [vect(-18.37, -3.00, -5.07), vect(-0.51, 0.00, -0.86)],
            [vect(-25.38, -2.00, 4.00), vect(-0.39, 0.00, 0.92)],
            [vect(-34.45, -1.00, 14.55), vect(0.92, 0.00, 0.40)],
            [vect(-28.88, 0.00, 37.31), vect(0.64, 0.00, -0.77)],
            [vect(-16.43, 3.01, 48.47), vect(0.76, 0.00, -0.65)],
            [vect(-1.36, 2.67, 47.36), vect(0.78, 0.00, -0.63)],
            [vect(1.36, 2.67, 47.36), vect(-0.79, 0.00, -0.61)],
            [vect(-0.24, 6.46, 27.72), vect(0.00, 0.00, 1.00)],
            [vect(9.62, 3.00, 12.55), vect(1.00, 0.00, -0.01)],
            [vect(-9.67, 0.00, 1.51), vect(-0.99, 0.00, 0.12)],
            [vect(-9.73, 4.00, 17.25), vect(-0.76, 0.00, -0.65)],
            [vect(-32.84, 4.00, 7.94), vect(1.00, 0.00, -0.00)],
            [vect(-24.15, 4.00, 5.10), vect(-0.41, 0.00, 0.91)],
            [vect(-23.40, 4.00, 11.43), vect(-0.40, 0.00, -0.92)],
            [vect(42.74, 3.00, 22.07), vect(-1.00, 0.00, -0.00)],
            [vect(39.25, 3.00, 26.68), vect(-0.69, 0.00, -0.73)],
            [vect(-7.25, 1.00, 1.75), vect(0.41, 0.00, 0.91)],
            [vect(7.25, 1.00, 1.75), vect(-0.39, 0.00, 0.92)],
            [vect(3.83, -2.00, -19.89), vect(-0.96, 0.00, -0.27)],
            [vect(-5.83, -2.00, -22.48), vect(0.96, 0.00, 0.28)],
            [vect(-17.27, 2.00, 40.48), vect(0.84, 0.00, 0.54)],
        ] #44

    elif getCurrentMap() == Map.DORADO:
        SpawnPointSettings = [
            [vect(100.81, 11.01, -26.22), vect(0.99, 0.00, -0.15)],
            [vect(113.87, 11.01, -32.43), vect(-0.76, 0.00, 0.65)],
            [vect(110.10, 11.01, -34.39), vect(-0.29, 0.00, 0.96)],
            [vect(107.48, 11.00, -20.13), vect(1.00, 0.00, -0.05)],
            [vect(111.05, 8.04, -18.21), vect(1.00, 0.00, -0.10)],
            [vect(130.48, 8.04, -7.10), vect(-0.90, 0.00, -0.44)],
            [vect(134.67, 11.00, -7.11), vect(-0.36, 0.00, -0.93)],
            [vect(144.24, 11.00, -20.05), vect(-0.64, 0.00, 0.77)],
            [vect(158.34, 10.01, -13.25), vect(-0.84, 0.00, 0.54)],
            [vect(152.32, 10.01, -3.06), vect(-0.85, 0.00, -0.53)],
            [vect(161.88, 10.01, -3.16), vect(-0.96, 0.00, -0.27)],
            [vect(134.11, 10.01, -4.46), vect(0.23, 0.00, 0.97)],
            [vect(152.47, 10.01, 0.62), vect(-0.26, 0.00, 0.96)],
            [vect(159.65, 11.05, 2.60), vect(-0.80, 0.00, 0.60)],
            [vect(113.76, 10.28, 5.89), vect(0.96, 0.00, -0.30)],
            [vect(94.34, 18.01, 9.82), vect(1.00, 0.00, 0.03)],
            [vect(100.03, 18.01, 20.70), vect(0.61, 0.00, -0.79)],
            [vect(95.03, 19.04, 20.81), vect(-0.78, 0.00, -0.62)],
            [vect(63.50, 17.01, 37.64), vect(0.98, 0.00, 0.20)],
            [vect(63.98, 14.01, 24.34), vect(0.94, 0.00, 0.33)],
            [vect(77.74, 13.01, 16.59), vect(0.05, 0.00, 1.00)],
            [vect(68.49, 14.01, 16.33), vect(0.79, 0.00, 0.62)],
            [vect(102.64, 12.03, 19.43), vect(0.15, 0.00, -0.99)],
            [vect(88.65, 7.03, -10.50), vect(0.78, 0.18, -0.59)],
            [vect(83.21, 6.81, -7.75), vect(0.37, -0.00, 0.93)],
            [vect(78.10, 8.00, 1.95), vect(0.56, 0.00, 0.83)],
            [vect(73.03, 8.00, 8.15), vect(1.00, 0.00, 0.10)],
            [vect(97.21, 13.96, 47.54), vect(-0.41, 0.00, -0.91)],
            [vect(107.12, 11.00, 48.48), vect(0.63, 0.00, -0.78)],
            [vect(121.37, 11.00, 52.18), vect(-0.42, 0.00, -0.91)],
            [vect(135.61, 11.01, 48.21), vect(-0.97, 0.00, -0.25)],
            [vect(138.86, 14.01, 43.75), vect(-0.90, 0.35, -0.26)],
            [vect(154.72, 14.01, 20.43), vect(-0.49, 0.00, -0.87)],
            [vect(75.80, 8.00, 10.95), vect(0.79, 0.00, -0.61)],
            [vect(138.02, 14.01, 55.50), vect(-0.53, 0.00, -0.85)],
            [vect(124.55, 11.00, 39.69), vect(-0.96, 0.00, -0.28)],
            [vect(117.83, 7.25, -26.51), vect(0.09, 0.00, 1.00)],
            [vect(133.61, 7.25, -14.25), vect(-0.99, 0.00, 0.14)],
            [vect(67.79, 15.25, 32.63), vect(0.63, -0.16, -0.76)],
            [vect(131.16, 9.02, -26.74), vect(-0.65, 0.00, 0.76)],
            [vect(98.46, 13.01, 21.62), vect(-0.99, 0.00, 0.15)],
        ] #41

    else:
        SpawnPointSettings = 0 