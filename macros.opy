#!mainFile "ANA_PB.opy"

#!define emptySpace "                                                                                                                                                                "
#!define hsv(h,s,v) (updateEveryTick(rgb(((((s) * (v)) if abs((h)-180)>=120 else ((s) * (v) * (1 - abs(((h)/60) % 2 - 1))) if abs((h)-180)>=60 else 0)+(v)-((s)*(v)))*255,((((s) * (v) * (1 - abs(((h)/60) % 2 - 1))) if (h)%180 < 60 else ((s) * (v)) if (h) < 180 else 0)+(v)-((s)*(v)))*255,(((s * v * (1 - abs(((h)/60) % 2 - 1))) if (h)%180 >= 120 else 0 if (h) < 180 else ((s) * (v)))+(v)-((s)*(v)))*255)))
#!define cancelMomentum(player) player.applyImpulse(player.getVelocity() * -1, player.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
#!define OofString(dist)  ("{0}".format((dist) + 0.001)).substring(0, strLen("{0}".format((dist) + 0.001)) - 1)
#!define createJumpPad(JUMP_PAD_COLOR, JumpPadPos, JumpPadSize,) (createEffect(getAllPlayers(), Effect.SPHERE, JUMP_PAD_COLOR, JumpPadPos, JumpPadSize, EffectReeval.VISIBILITY_AND_COLOR))
#!define WinCamTextPosition(EYE_POS, LOOK_POS, X_POS, Y_POS) (updateEveryTick(EYE_POS + (100 * (X_POS * (crossProduct(directionTowards(EYE_POS, LOOK_POS), angleToDirection(horizontalAngleOfDirection(directionTowards(EYE_POS, LOOK_POS)), verticalAngleOfDirection(directionTowards(EYE_POS, LOOK_POS)) - 90))) + ((Y_POS - 0.2) * (angleToDirection(horizontalAngleOfDirection(directionTowards(EYE_POS, LOOK_POS)), verticalAngleOfDirection(directionTowards(EYE_POS, LOOK_POS)) - 90))) + 3 * directionTowards(EYE_POS, LOOK_POS)))))
#!define ScoreboardWallpaperAbility(hero, button) ("                                                         {0}    {0}       {0}    {0}".format(abilityIconString((hero), (button))))
#!define ScoreboardWallpaperIcon(icon) ("                                                         {0}    {0}       {0}    {0}".format(iconString(Icon.WARNING)))
#!define KD(player) ((localPlayer.ScopedHits+localPlayer.NoscopeHits+localPlayer.SleepPunches) / localPlayer.Deaths)

#!define createStreakEffect(streak, effect, radius) createEffect(localPlayer if eventPlayer.KillStreak >= streak else [], effect, Color.TEAM_1, eventPlayer, radius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

#!define isPlayerEligible(p) (p.isAlive() and p.hasSpawned() and not p.isDummy())
#!define isSpawnpointEligible(s, p) (not isPlayerEligible(p) or not isInLoS(s, s, BarrierLos.PASS_THROUGH_BARRIERS))
#!define distanceCheck(s, p) (distance(s, p) if isPlayerEligible(p) else 99999)