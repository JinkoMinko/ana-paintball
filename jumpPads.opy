#!mainFile "ANA_PB.opy"

rule "CREATE all jump pads":
    @Event global

    switch getCurrentMap():
        case Map.EICHENWALDE:
        case Map.EICHENWALDE_HALLOWEEN:
            JumpPadPos = [
            vect(47.05, 2.91, -75.46),  # main
            vect(60.91, 8.90, -58.98),  # staircase
            vect(67.98, 11.05, -104.86) # overpass
            ]
        
            JumpPadPower = [
            23.5,
            15,
            17
            ]
        
            JumpPadSize = [
            3.9,
            3.1,
            1.8
            ]
            break
        case Map.PETRA:
            JumpPadPos = [
            vect(1.91, -16.70, 46.10),   # big boy
            vect(-2.54, -11.77, 16.85),  # mid
            vect(-15.33, -10.7, 30.07),  # staircase
            vect(-38.52, -15.72, 18.04), # sanctuary
            vect(2.051, -4.5, -19.133),  # broken floor
            vect(16.05, -11.4, 8.72)     # broken stairs mid
            ]
        
            JumpPadPower = [
            22.2,
            19,
            19,
            18.5,
            13,
            12
            ]
        
            JumpPadSize = [
            3.9,
            2.4,
            2,
            3.5,
            1.3,
            2.7
            ]
            break
        case Map.CHATEAU_GUILLARD:
        case Map.CHATEAU_GUILLARD_HALLOWEEN:
            JumpPadPos = [
            vect(229.49, 0.38, 83.1),   # idk
            vect(187.32, -0.6, 69.5),   # idk
            vect(218.55, 10.44, 47.06), # idk
            vect(172, -1.25, 53.8)      # water pad
            ]
        
            JumpPadPower = [
            17.5,
            17.5,
            17.5,
            17.5
            ]
        
            JumpPadSize = [
            2.3,
            2,
            2,
            1.8
            ]
            break
        case Map.ECOPOINT_ANTARCTICA_WINTER:
        case Map.ECOPOINT_ANTARCTICA:
            JumpPadPos = [
            vect(-6.1, 4.7, 17),  # positive side
            vect(-6.1, 4.7, -17), # negative side
            vect(10.35, 2.18, 0), # mid
            vect(-15, 4.85, 0)    # garage
            ]
        
            JumpPadPower = [
            16,
            16,
            15.5,
            15
            ]
        
            JumpPadSize = [
            2.6, 
            2.6,
            2.3,
            2.9
            ]
            break
        case Map.MALEVENTO:
            JumpPadPos = [
            vect(-29.65, -4.57, -8), # bridge
            vect(0, -2.62, -7.23),   # woman statue
            vect(11.72, 0, 9.65),    # big boy
            vect(0, -1.78, 34.06)    # big boy
            ]
            
            JumpPadPower = [
            17,
            20.9,
            15,
            26
            ]
            
            JumpPadSize = [
            2, 
            2,
            3.7,
            4.1
            ]
            break
        case Map.BLACK_FOREST_WINTER:
        case Map.BLACK_FOREST:
            JumpPadPos = [
            vect(4.6, 10, 5),         # mill
            vect(0, 10.82, 24.24),    # positive side panoramic view
            vect(0, 10.82, -14.87),   # negative side panoramic view
            vect(-20.55, 11.40, 22),  # positive side house
            vect(-20.55, 11.40, -11), # negative side house
            vect(21.4, 9.6, 19.16),   # positive side ramparts
            vect(21.4, 9.5, -8.7),    # negative side ramparts
            ]
            
            JumpPadPower = [
            15,
            15,
            15,
            15,
            15,
            15,
            15
            ]
            
            JumpPadSize = [
            2.8, 
            2,
            2,
            2,
            2,
            2,
            2
            ]
            break
        case Map.BLIZZ_WORLD_WINTER:
        case Map.BLIZZ_WORLD:
            JumpPadPos = [
            vect(-75.5, -1.45, 75),   # indoor stairs
            vect(-41.3, -3.3, 84.3),  # restaurant
            vect(-20, -1.16, 92.15),  # turret
            vect(-63.5, -4.1, 92.14), # mid bridges
            vect(-41, -4.8, 145.45),  # Spawn room
            vect(-70, -1.9, 116.5)    # Spawn room
            ]
            
            JumpPadPower = [
            16.5,
            16,
            15,
            17,
            14,
            16.5
            ]
            
            JumpPadSize = [
            2, 
            3.3,
            3.4,
            4,
            3,
            3
            ]
            break

        case Map.DORADO:
            JumpPadPos = [
            vect(129.71, 7.77, 16.9), # CORNER
            vect(92.5, 9.67, 31.88),  # TREES
            vect(102.9, 7.7, 8.9),    # CHURCH
            vect(110.9, 7.66, 17.8),  # CHURCH WINDOWS
            vect(149.14, 6.7, 12.35)  # BANK STAIRCASE
            ]
            
            JumpPadPower = [
            17.5,
            18.5,
            17.5,
            16.3,
            17.5
            ]
            
            JumpPadSize = [
            3.5, 
            3.5,
            3.5,
            3.6,
            3.5
            ]
            break
        case Map.HOLLYWOOD_HALLOWEEN:
        case Map.HOLLYWOOD:
            JumpPadPos = [
                vect(9.66, -1.7, -74.8),  # PAYLOAD
                vect(-3, -1.7, -17),      # STORE
                vect(-2.2, -1.7, -40.4),  # MID
                vect(18.76, -1.7, -50.5), # BANK
                vect(39.5, -1.7, -71.4)   # JAIL
            ]
            
            JumpPadPower = [
                21,
                15,
                20,
                15,
                16
            ]
            
            JumpPadSize = [
                3.5, 
                3.5,
                3.5,
                3.5,
                3.5
            ]
            break
        case Map.LIJIANG_CONTROL_CENTER_LNY:
        case Map.LIJIANG_CONTROL_CENTER:
            JumpPadPos = [
                vect(-25.15, 263.75, 291.55), # ROVER SIDE A
                vect(25.15, 263.75, 291.55),   # ROVER SIDE B
                vect(0, 263.85, 285.88),      # MID BIG PAD
                vect(5.63, 267.79, 313.71),   # INTERIOR SIDE A
                vect(-5.63, 267.79, 313.71),  # INTERIOR SIDE B
            ]
            
            JumpPadPower = [
                13,
                13,
                20.5,
                18.5,
                18.5,
            ]
            
            JumpPadSize = [
                3.4, 
                3.4, 
                4,
                2.5,
                2.5,
            ]
            break  
    for JumpPadFx in range(len(JumpPadPos)):
        createJumpPad(JUMP_PAD_COLOR, JumpPadPos[JumpPadFx], JumpPadSize[JumpPadFx])


rule "TRIGGER any jump pad":
    @Event eachPlayer
    @Hero ana
    @Condition any([distance(eventPlayer, pos) <= JumpPadSize[i] for pos, i in JumpPadPos])

    eventPlayer.ClosestPadIndex = JumpPadPos.index(sorted(JumpPadPos, lambda pos: distance(eventPlayer, pos)))
    eventPlayer.applyImpulse(Vector.UP, JumpPadPower[eventPlayer.ClosestPadIndex], Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 30)


    #playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 30)
    #playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, JumpPadPos[eventPlayer.ClosestPadIndex], 35)
    