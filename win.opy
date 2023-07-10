#!mainFile "ANA_PB.opy"

rule "Nuclear victory":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.IsNuclear
    @Condition not MatchEnded
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) or eventPlayer.isDead()

    MatchEnded = true
    Winner = eventPlayer

    NukeCamHorizontalDist = horizontalAngleOfDirection(directionTowards(NukeImpactPos, NukeCamPos))
    Camdist = magnitude((NukeCamPos - NukeImpactPos) * vect(1, 0, 1))
    NukePos = NukeImpactPos + angleToDirection(NukeCamHorizontalDist + 90, 0) * (Camdist + 0) + vect(0, NukeCamPos.y - 10, 0)

    destroyAllInWorldTexts()
    destroyAllHudTexts()
    createInWorldText(Winner, "{0} Nano-nuke requested! {0}".format(iconString(Icon.CHECKMARK)), updateEveryTick(localPlayer.getEyePosition() + (100 * (0 * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION) + ((0.69 - 0.2) * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)), SpecVisibility.DEFAULT)
    getAllPlayers().disableGamemodeHud()
    getAllPlayers().disableHeroHUD()
    NuclearBot.teleport(Winner)
    wait(0.5)
    NuclearBot.forceButtonPress(Button.ULTIMATE)
    wait()
    NuclearBot.cancelPrimaryAction()
    wait()
    destroyDummy(Team.ALL, 10)
    wait()

    # Create bot for 2nd siren
    createDummy(Hero.BASTION, Team.ALL, 10, vect(0, 999, 0), Vector.UP)
    NuclearBot = getLastCreatedEntity()
    NuclearBot.startForcingName("NUCLEAR BOMB")
    NuclearBot.setInvisibility(Invis.ALL)
    NuclearBot.setStatusEffect(null, Status.PHASED_OUT, 9999)
    NuclearBot.setGravity(0)
    NuclearBot.startModifyingVoicelinePitch(0.5, false)
    NuclearBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    wait(2)

    # Winner cam
    destroyAllInWorldTexts()
    getAllPlayers().startCamera(raycast(updateEveryTick(Winner.getEyePosition()), 1 * (updateEveryTick(Winner.getFacingDirection())) + updateEveryTick(Winner.getEyePosition()), null, null, true).getHitPosition(), updateEveryTick(Winner.getEyePosition()), 0)
    getAllPlayers().setStatusEffect(null, Status.ROOTED, 999)
    getAllPlayers().setAimSpeed(10)
    getAllPlayers().setMoveSpeed(10)
    RandomEmote()
    wait(2)
    destroyAllInWorldTexts()

    # Swap to nuke cam
    eventPlayer.startFacing(eventPlayer.getFacingDirection(), 1000, Relativity.TO_PLAYER, FacingReeval.NONE)
    getAllPlayers().startCamera(worldVector(vect(0, 2, 2), Winner, Transform.ROTATION_AND_TRANSLATION), Winner.getPosition(), 0)
    getAllPlayers().startCamera(NukeCamPos, NukeImpactPos, 1)

    # 2nd siren
    NuclearBot.teleport(worldVector(vect(0, 30, 0), Winner, Transform.ROTATION_AND_TRANSLATION))
    wait(0.5)
    destroyAllInWorldTexts()
    NuclearBot.forceButtonPress(Button.ULTIMATE)
    wait()
    destroyDummy(Team.ALL, 10)
    wait(2)

    # Create nuke effect
    createProjectileEffect(getAllPlayers(), Projectile.BAPTISTE_BIOTIC_LAUNCHER, null, NukePos, directionTowards(NukePos, NukeImpactPos), 0.4, ProjectileEffectReeval.VISIBILITY_POSITION_DIRECTION_AND_SIZE)
    Winner.NukeEffects[0] = getLastCreatedEntity()
    wait(2)
    chase(NukePos, NukeImpactPos, duration=5, ChaseReeval.DESTINATION_AND_DURATION)
    wait(4.8)
    declarePlayerVictory(Winner)
    destroyEffect(Winner.NukeEffects[0])
    kill(getAllPlayers().exclude([OutOfBoundBot, NuclearBot]), Winner)
    Winner.addToScore(1) # to compensate for bomb self kill
    getAllPlayers().disableRespawn()

    # Explosion effects at NukeImpactPos
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.TEAM_1, NukeImpactPos, 200)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, NukeImpactPos, 200)

    # Explosion frames in front of NukeCamPos
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.WHITE, NukeCamPos + directionTowards(NukeCamPos, NukeImpactPos) * 1, 50)
    playEffect(getAllPlayers(), DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION, Color.WHITE, NukeCamPos + directionTowards(NukeCamPos, NukeImpactPos) * 1, 200)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, NukeCamPos + directionTowards(NukeCamPos, NukeImpactPos) * 1, 200)
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION_SOUND, Color.WHITE, NukeCamPos + directionTowards(NukeCamPos, NukeImpactPos) * 1, 200)

    #Explosion radius effect + smoke
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, NukeImpactPos, NukeExplodeFxPos, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.CLOUD, Color.RED, NukeImpactPos, NukeExplodeFxPos, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.ORANGE, NukeImpactPos, NukeExplodeFxPos - 5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, NukeImpactPos, NukeExplodeFxPos - 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.CLOUD, Color.ORANGE, NukeImpactPos, NukeExplodeFxPos, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    chase(NukeExplodeFxPos, 220, rate=20, ChaseReeval.DESTINATION_AND_RATE)

    createInWorldText(getAllPlayers(),"Nuclear victory!", WinCamTextPosition(NukeCamPos, NukeImpactPos, 0, 0.8), 10, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)), SpecVisibility.NEVER)
    createInWorldText(getAllPlayers(),"www.jinko.dev/discord", WinCamTextPosition(NukeCamPos, NukeImpactPos, 0, -1), 10, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)), SpecVisibility.NEVER)

    # camera shake
    wait(0.3)
    for i in range(50):
        NukeCamShakeX = random.uniform(-10, 10)
        NukeCamShakeY = random.uniform(-5, 5)
        NukeCamShakeZ = random.uniform(-5, 5)
        getAllPlayers().startCamera(vect(NukeCamShakeX + NukeCamPos.x, NukeCamShakeY + NukeCamPos.y, NukeCamShakeZ + NukeCamPos.z), vect(NukeCamShakeX + NukeImpactPos.x, NukeCamShakeY + NukeImpactPos.y, NukeCamShakeZ + NukeImpactPos.z), 10)
        wait(0.05)

    for i in range(50):
        NukeCamShakeX = random.uniform(-10, 10)
        NukeCamShakeY = random.uniform(-5, 5)
        NukeCamShakeZ = random.uniform(-5, 5)
        getAllPlayers().startCamera(vect(NukeCamShakeX + NukeCamPos.x, NukeCamShakeY + NukeCamPos.y, NukeCamShakeZ + NukeCamPos.z), vect(NukeCamShakeX + NukeImpactPos.x, NukeCamShakeY + NukeImpactPos.y, NukeCamShakeZ + NukeImpactPos.z), 10)
        wait(0.05)

rule "Sleep Dart victory":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition attacker.getScore() == NANO_SCORE
    @Condition not MatchEnded

    MatchEnded = true
    FinalVictim = victim
    Winner = attacker

    getAllPlayers().disableGamemodeHud()
    getAllPlayers().disableHeroHUD()

    declarePlayerVictory(eventPlayer)
    Winner.setScore(NANO_SCORE+1)
    victim.OofDistance = distance(attacker, victim)
    if victim.OofDistance >= LONGSHOT_DISTANCE:
        LongshotWin = not LongshotWin
    getAllPlayers().exclude([Winner, FinalVictim]).startForcingOutlineFor(getAllPlayers(), false, rgb(rainbow(getTotalTimeElapsed() * 150)), OutlineVisibility.ALWAYS)
    createEffect(getAllPlayers(), Effect.SOLDIER_SPRINTING, Color.WHITE, victim, 1, EffectReeval.POSITION_AND_RADIUS)
    getAllPlayers().setStatusEffect(null, Status.INVINCIBLE, 999)
    getAllPlayers().setStatusEffect(null, Status.ROOTED, 999)
    getAllPlayers().setAimSpeed(10)
    getAllPlayers().setMoveSpeed(10)
    setSlowMotion(5)
    getAllPlayers().startCamera(raycast(attacker.getPosition(), attacker.getPosition() + directionTowards(victim, attacker.getPosition()) * 3 + Vector.UP * 1.5, null, null, true).getHitPosition(), victim.getPosition(), 0)
    wait(0.35)
    getAllPlayers().startCamera(raycast(victim.getEyePosition(), victim.getEyePosition() + directionTowards(attacker, victim()) * -2 + Vector.UP * 0.5, null, null, true).getHitPosition(), victim.getEyePosition() + vect(0, -1, 0), 25)
    wait(0.5)
    #Amazing in-world text code by josbird https://workshop.codes/wiki/articles/rendering-an-inworld-text-at-a-specific-onscreen-position
    createInWorldText(getAllPlayers(),"longshot victory! {0}m hit!".format(OofString(victim.OofDistance)) if victim.OofDistance >= LONGSHOT_DISTANCE else "{0}m sleep dart hit!".format(OofString(victim.OofDistance)), WinCamTextPosition(raycast(victim.getEyePosition(), victim.getEyePosition() + directionTowards(attacker, victim) * -2 + Vector.UP * 0.5, null, null, true).getHitPosition(), victim.getEyePosition() + vect(0, -1, 0), 0, 0.8), 10, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)) if victim.OofDistance >= LONGSHOT_DISTANCE else customGreen, SpecVisibility.NEVER)
    createInWorldText(getAllPlayers(),"www.jinko.dev/discord\nwww.jinko.dev/discord\nwww.jinko.dev/discord", WinCamTextPosition(raycast(victim.getEyePosition(), victim.getEyePosition() + directionTowards(attacker, victim) * -2 + Vector.UP * 0.5, null, null, true).getHitPosition(), victim.getEyePosition() + vect(0, -1, 0), 0, -1), 10, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)), SpecVisibility.NEVER)
    wait(0.95)
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.ROSE, victim.getPosition(), 999)
    wait(18.5)
    restartMatch()


rule "Fix camera if last victim leaves the game":
    @Event playerLeft
    @Condition MatchEnded

    if FinalVictim == eventPlayer:
        destroyAllInWorldTexts()
        getAllPlayers().startCamera(raycast(Winner.getPosition(), (Winner.getPosition() * 3 + Vector.UP * 1.5), null, null, true).getHitPosition(), Winner.getEyePosition(), 0)


rule "rainbow outline if last dart was a longshot":
    @Event eachPlayer
    @Hero ana
    @Condition MatchEnded
    @Condition Winner

    Winner.startForcingOutlineFor(getAllPlayers(), true, rgb(rainbow(getTotalTimeElapsed() * 500)), OutlineVisibility.ALWAYS)
    if FinalVictim.OofDistance >= LONGSHOT_DISTANCE:
        FinalVictim.startForcingOutlineFor(getAllPlayers(), true, rgb(rainbow(getTotalTimeElapsed() * 500)), OutlineVisibility.ALWAYS)
    else:
        FinalVictim.startForcingOutlineFor(getAllPlayers(), false, Color.RED, OutlineVisibility.ALWAYS)
    wait()
    goto RULE_START