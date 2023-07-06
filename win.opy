#!mainFile "ANA_PB.opy"


rule "Nuclear victory":
    @Event playerEarnedElimination
    @Hero ana
    @Condition attacker.KillStreak >= NUCLEAR_STREAK
    @Condition not MatchEnded
    #@Disabled

    MatchEnded = true
    Winner = attacker

    #NuclearBot.teleport(Winner)
    #wait(0.5)
    #NuclearBot.forceButtonPress(Button.ULTIMATE)
    #wait()
    #NuclearBot.cancelPrimaryAction()
    #wait()    
    #destroyDummy(Team.ALL, 10)
#
    #createInWorldText(localPlayer, "{0} 15 kills streak! {1} is nuclear! {0}".format(iconString(Icon.RADIOACTIVE), attacker), updateEveryTick(localPlayer.getEyePosition() + (100 * (0 * worldVector(Vector.RIGHT, localPlayer, Transform.ROTATION) + ((0.69 - 0.2) * (angleToDirection(horizontalAngleOfDirection(localPlayer.getFacingDirection()), verticalAngleOfDirection(localPlayer.getFacingDirection()) - 90))) + 3 * localPlayer.getFacingDirection()))), 9, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)), SpecVisibility.DEFAULT)
#
    #wait(6)
    #getAllPlayers().disableRespawn()
    #getAllPlayers().disableNameplatesFor(getAllPlayers())
#
    #createDummy(Hero.BASTION, Team.ALL, 10, vect(0, 999, 0), Vector.UP)
    #NuclearBot = getLastCreatedEntity()
    #NuclearBot.startForcingName("Nuclear Bomb")
    #NuclearBot.setGravity(0)
    #NuclearBot.setInvisibility(Invis.ALL)
#
    #kill(getAllPlayers().exclude([attacker, OutOfBoundBot1, NuclearBot]), NuclearBot)
    #declarePlayerVictory(attacker)
    #async(RandomEmote, AsyncBehavior.NOOP)
#
    #wait(1)
    #destroyAllInWorldTexts()
    #getAllPlayers().startCamera(raycast(updateEveryTick(attacker.getEyePosition()), 1 * (updateEveryTick(attacker.getFacingDirection())) + updateEveryTick(attacker.getEyePosition()), null, null, true).getHitPosition(), updateEveryTick(attacker.getEyePosition()), 0)
    #getAllPlayers().setStatusEffect(null, Status.INVINCIBLE, 999)
    #getAllPlayers().setStatusEffect(null, Status.ROOTED, 999)
    #getAllPlayers().setAimSpeed(10)
    #createInWorldText(getAllPlayers(), "{0} Nuclear victory! {0}".format(iconString(Icon.RADIOACTIVE)), Winner, 10, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)), SpecVisibility.NEVER)
#
    #wait(0.45)
    #playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.TEAM_1, attacker, 999)
    #playEffect(getAllPlayers(), DynamicEffect.SOMBRA_EMP_EXPLOSION_EFFECT, Color.TEAM_1, attacker, 999)
    #playEffect(getAllPlayers(), DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION, Color.TEAM_1, attacker, 999)
    #playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Color.TEAM_1, attacker, 999)
#
    #wait(18.5)
    #restartMatch()


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