#!mainFile "ANA_PB.opy"


rule "Create playzone FX":
    @Event global
    @Condition PlayzoneCenter != 0

    createEffect([localPlayer if
                (distance(localPlayer, PlayzoneCenter) >= PlayzoneRadius - 8) else []], Effect.SPHERE, Color.ORANGE, PlayzoneCenter, PlayzoneRadius, EffectReeval.VISIBILITY)


rule "Trigger playzone":
    @Event eachPlayer
    @Condition distance(eventPlayer.getEyePosition(), PlayzoneCenter) >= PlayzoneRadius - 2 
    @Condition PlayzoneCenter != 0

    cancelMomentum(eventPlayer)
    eventPlayer.applyImpulse(vect(directionTowards(eventPlayer.getPosition(), PlayzoneCenter).x, 0, directionTowards(eventPlayer.getPosition(), PlayzoneCenter).z), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, 2, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    playEffect(eventPlayer, DynamicEffect.BAPTISTE_BIOTIC_LAUNCHER_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 20)
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.5)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START
