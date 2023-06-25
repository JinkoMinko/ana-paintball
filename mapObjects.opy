#!mainFile "ANA_PB.opy"

rule "ECOPOINT create TPs":
    @Event global
    @Condition getCurrentMap() == Map.ECOPOINT_ANTARCTICA or getCurrentMap() == Map.ECOPOINT_ANTARCTICA_WINTER

    createIcon([localPlayer.IsPlayer and isInLoS(localPlayer.getEyePosition(), vect(-5, 9, -54), BarrierLos.BLOCKED_BY_ALL_BARRIERS)], vect(-5.20, 8, -54.64), Icon.SPIRAL, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.SKY_BLUE, false)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.ROSE, vect(-5.35, 8, -54.66), 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.PURPLE, vect(-5.35, 8, -54.66), 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.BEACON_SOUND, Color.BLUE, vect(-5.35, 8, -54.66), 100, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createIcon([localPlayer.IsPlayer and isInLoS(localPlayer.getEyePosition(), vect(-13, 9, 44), BarrierLos.BLOCKED_BY_ALL_BARRIERS)], vect(-13.6, 8, 43.6), Icon.SPIRAL, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.SKY_BLUE, false)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.ROSE, vect(-13.8, 8, 43.57), 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.PURPLE, vect(-13.8, 8, 43.57), 1.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.BEACON_SOUND, Color.BLUE, vect(-13.8, 8, 43.57), 100, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.ROSE, vect(-25, 31.5, -10.89), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.ROSE, vect(-25, 31.5, 10.89), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

rule "ECOPOINT trigger right side TP":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.ECOPOINT_ANTARCTICA or getCurrentMap() == Map.ECOPOINT_ANTARCTICA_WINTER
    @Condition distance(eventPlayer, vect(-7.78, 8, -57.05)) <= 4.8

    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, vect(-5.3, 8, -54.7), 80)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_DISAPPEAR, Color.WHITE, vect(-5.3, 8, -54.7), 20)
    eventPlayer.L = 1.5
    chase(eventPlayer.L, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.A = eventPlayer.getFacingDirection().y
    eventPlayer.teleport(vect(-25, 31.5, -10.89))
    eventPlayer.setFacing(normalize(vect(5, eventPlayer.getPosition().y, -23) - eventPlayer.getPosition()) + vect(0, eventPlayer.A, 0), Relativity.TO_WORLD)
    eventPlayer.startAcceleration(Vector.UP, 20, 20, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    eventPlayer.applyImpulse(vect(0, 0, 0), 2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.DOWN, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_REAPPEAR, Color.WHITE, eventPlayer.getPosition(), 20)
    wait(0.5)
    eventPlayer.stopAcceleration()

rule "ECOPOINT trigger left side TP":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.ECOPOINT_ANTARCTICA or getCurrentMap() == Map.ECOPOINT_ANTARCTICA_WINTER
    @Condition distance(eventPlayer, vect(-16.3, 8, 41)) <= 4.9

    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, vect(-13.7, 8, 43.5), 80)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_DISAPPEAR, Color.WHITE, vect(-13.7, 8, 43.5), 20)
    eventPlayer.L = 1.5
    chase(eventPlayer.L, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.A = eventPlayer.getFacingDirection().y
    eventPlayer.teleport(vect(-25, 31.5, 10.89))
    eventPlayer.setFacing(normalize(vect(0, eventPlayer.getPosition().y, 28) - eventPlayer.getPosition()) + vect(0, eventPlayer.A, 0), Relativity.TO_WORLD)
    eventPlayer.startAcceleration(Vector.UP, 20, 20, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    eventPlayer.applyImpulse(vect(0, 0, 0), 2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.DOWN, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_REAPPEAR, Color.WHITE, eventPlayer.getPosition(), 20)
    wait(0.5)
    eventPlayer.stopAcceleration()


rule "FOREST create TP":
    @Event global
    @Condition getCurrentMap() == Map.BLACK_FOREST_WINTER or getCurrentMap() == Map.BLACK_FOREST
    
    createInWorldText([localPlayer.IsPlayer and isInLoS(localPlayer.getEyePosition(), vect(-32, 13, 8), BarrierLos.BLOCKED_BY_ALL_BARRIERS) and angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), vect(-32, 13, 8))) < 15 and distance(vect(-32, 14.5, 8), localPlayer) <= 25], "teleporter", vect(-32, 17, 8), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_COLOR, Color.ROSE, SpecVisibility.NEVER)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.ROSE, vect(-32, 13, 8), 3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPARKLES, Color.PURPLE, vect(-32, 13, 8), 3, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.BEACON_SOUND, Color.BLUE, vect(-32, 13, 8), 100, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

rule "FOREST trigger TP":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.BLACK_FOREST_WINTER or getCurrentMap() == Map.BLACK_FOREST
    @Condition distance(eventPlayer, vect(-32, 13, 8)) <= 3
    
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, vect(-32, 13, 8), 120)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_DISAPPEAR, Color.WHITE, vect(-32, 13, 8), 20)
    eventPlayer.L = 1.5
    chase(eventPlayer.L, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.A = eventPlayer.getFacingDirection().y
    eventPlayer.teleport(vect(29, 11, 5))
    eventPlayer.setFacing(normalize(vect(0, eventPlayer.getPosition().y, 0) - eventPlayer.getPosition()) + vect(0, eventPlayer.A, 0), Relativity.TO_WORLD)
    wait()
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATOR_REAPPEAR, Color.WHITE, eventPlayer.getPosition(), 20)
    wait(0.75)
    eventPlayer.stopAcceleration()


rule "HOLLYWOOD Locked zone 1":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN
    @Condition eventPlayer.isOnGround()
    @Condition (distance(eventPlayer, vect(2.88, 7.75, -15.9))) <= 2

    eventPlayer.applyImpulse(vectorTowards(vect(2.88, 7.75, -15.9), eventPlayer), 1, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.2)
    wait(0.1)
    if RULE_CONDITION:
        goto RULE_START

rule "HOLLYWOOD Locked zone 2":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN
    @Condition (distance(eventPlayer, vect(37, 8.74, -66.5))) <= 6.3
    @Condition eventPlayer.isOnGround()
    @Condition abs(eventPlayer.getPosition().y - 8.9) < 0.2

    eventPlayer.applyImpulse(vectorTowards(vect(138, -100, 300), eventPlayer), 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0.2)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "CREATE Dorado launcher":
    @Event global
    @Condition getCurrentMap() == Map.DORADO

    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, vect(123.4, 10, -17.5), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

rule "TRIGGER Dorado launcher":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.DORADO
    @Condition (distance(eventPlayer, vect(123.4, 10, -17.5))) <= 1.2

    cancelMomentum(eventPlayer)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 1)
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, vect(123.4, 10, -17.5), 30)
    playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, vect(123.4, 10, -17.5), 40)
    eventPlayer.applyImpulse(vectorTowards(vect(123.4, 10, -17.5), vect(102.3, 30, 9.9)), 44, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.disableEnvironmentCollision(false)
    wait(0.4)
    eventPlayer.enableEnvironmentCollision()


rule "CREATE Lijang Control launcher":
    @Event global
    @Condition getCurrentMap() == Map.LIJIANG_CONTROL_CENTER or getCurrentMap() == Map.LIJIANG_CONTROL_CENTER_LNY
    @Disabled

    createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, vect(0, 271, 268), 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

rule "TRIGGER Lijang Control launcher":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.LIJIANG_CONTROL_CENTER or getCurrentMap() == Map.LIJIANG_CONTROL_CENTER_LNY
    @Condition (distance(eventPlayer, vect(0, 271, 268))) <= 1.2
    @Disabled

    cancelMomentum(eventPlayer)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 1)
    playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, vect(0, 271, 268), 30)
    playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.BUFF_IMPACT_SOUND, Color.WHITE, vect(0, 271, 268), 40)
    eventPlayer.applyImpulse(vectorTowards(vect(0, 271, 268), vect(0, 287, 290)), 38, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.disableEnvironmentCollision(false)
    wait(1.2)
    eventPlayer.enableEnvironmentCollision()


rule "HOLLYWOOD platform boost PAYLOAD SIDE":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN
    @Condition distance(eventPlayer, vect(13.2, 10.55, -32.1)) <= 2.3
    @Condition eventPlayer.isOnGround()
    @Condition updateEveryTick(eventPlayer.getPosition().y >= 9 and eventPlayer.getPosition().y < 10.4)

    wait()
    if not eventPlayer.isJumping():
        if RULE_CONDITION:
            goto RULE_START
        waitUntil(eventPlayer.isJumping(), 0.016)
        if not eventPlayer.isJumping():
            return
    eventPlayer.applyImpulse(Vector.UP, 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 20)

rule "HOLLYWOOD platform boost WALL SIDE":
    @Event eachPlayer
    @Hero ana
    @Condition getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN
    @Condition distance(eventPlayer, vect(-6.21, 10.13, -58.94)) <= 2.3
    @Condition eventPlayer.isOnGround()
    @Condition updateEveryTick(eventPlayer.getPosition().y >= 8.3 and eventPlayer.getPosition().y < 9.88)

    wait()
    if RULE_CONDITION:
        goto RULE_START
    if eventPlayer.isJumping():
        eventPlayer.applyImpulse(Vector.UP, 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 20)