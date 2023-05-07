#!mainFile "ANA_PB.opy"

rule "NUKE_STREAK":
    @Event playerEarnedElimination
    @Hero ana
    @Condition attacker.KillStreak >= NUKE_STREAK
    @Condition not MatchEnded
    @Disabled
    
    getAllPlayers().disableKillFeed()
    getAllPlayers().disableScoreboard()
    getAllPlayers().disableGamemodeHud()
    getAllPlayers().disableHeroHUD()

    MatchEnded = true
    FinalVictim = victim
    Winner = attacker
    declarePlayerVictory(eventPlayer)
    attacker.setScore(25)
    createEffect(getAllPlayers(), Effect.SOLDIER_SPRINTING, Color.WHITE, victim, 1, EffectReeval.POSITION_AND_RADIUS)
    getAllPlayers().setStatusEffect(null, Status.INVINCIBLE, 999)
    getAllPlayers().setStatusEffect(null, Status.ROOTED, 999)
    getAllPlayers().setAimSpeed(10)
    getAllPlayers().setMoveSpeed(10)
    setSlowMotion(5)


rule "NANO_SCORE":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition attacker.getScore() == NANO_SCORE
    @Condition not MatchEnded

    #getAllPlayers().disableKillFeed()
    getAllPlayers().disableGamemodeHud()
    getAllPlayers().disableHeroHUD()

    MatchEnded = true
    FinalVictim = victim
    Winner = attacker
    declarePlayerVictory(eventPlayer)
    attacker.setScore(25)
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
    createInWorldText(getAllPlayers(),"longshot victory! {0}m hit!".format(OofString(victim.OofDistance)) if victim.OofDistance >= LONGSHOT_DISTANCE else "{0}m sleep dart hit!".format(OofString(victim.OofDistance)), WinCamTextPosition(raycast(victim.getEyePosition(), victim.getEyePosition() + directionTowards(attacker, victim) * -2 + Vector.UP * 0.5, null, null, true).getHitPosition(), victim.getEyePosition() + vect(0, -1, 0), 0, 0.8), 10, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)) if victim.OofDistance >= LONGSHOT_DISTANCE else rgb(63, 191, 116), SpecVisibility.NEVER)
    createInWorldText(getAllPlayers(),"www.jinko.dev/discord\nwww.jinko.dev/discord\nwww.jinko.dev/discord", WinCamTextPosition(raycast(victim.getEyePosition(), victim.getEyePosition() + directionTowards(attacker, victim) * -2 + Vector.UP * 0.5, null, null, true).getHitPosition(), victim.getEyePosition() + vect(0, -1, 0), 0, -1), 10, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, rgb(rainbow(getTotalTimeElapsed() * 500)), SpecVisibility.NEVER)
    wait(0.95)
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.ROSE, victim.getPosition(), 999)
    wait(18.5)
    restartMatch()

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