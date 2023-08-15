#!mainFile "ANA_PB.opy"



#!define emptySpace "                                                                                                                                                                "

#!define cancelMomentum(player) player.applyImpulse(player.getVelocity() * -1, player.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

#!define OofString(dist)  ("{0}".format((dist) + 0.001)).substring(0, strLen("{0}".format((dist) + 0.001)) - 1)

#!define createJumpPad(JUMP_PAD_COLOR, JumpPadPos, JumpPadSize,) (createEffect(getAllPlayers(), Effect.SPHERE, JUMP_PAD_COLOR, JumpPadPos, JumpPadSize, EffectReeval.VISIBILITY_AND_COLOR))

#!define WinCamTextPosition(EYE_POS, LOOK_POS, X_POS, Y_POS) (updateEveryTick(EYE_POS + (100 * (X_POS * (crossProduct(directionTowards(EYE_POS, LOOK_POS), angleToDirection(horizontalAngleOfDirection(directionTowards(EYE_POS, LOOK_POS)), verticalAngleOfDirection(directionTowards(EYE_POS, LOOK_POS)) - 90))) + ((Y_POS - 0.2) * (angleToDirection(horizontalAngleOfDirection(directionTowards(EYE_POS, LOOK_POS)), verticalAngleOfDirection(directionTowards(EYE_POS, LOOK_POS)) - 90))) + 3 * directionTowards(EYE_POS, LOOK_POS)))))

#!define ScoreboardWallpaperAbility(hero, button) ("                                                         {0}    {0}       {0}    {0}".format(abilityIconString((hero), (button))))
#!define ScoreboardWallpaperIcon(icon) ("                                                         {0}    {0}       {0}    {0}".format(iconString(Icon.WARNING)))

#!define KD(player) ((localPlayer.ScopedHits+localPlayer.NoscopeHits+localPlayer.Executes) / localPlayer.Deaths)

#!define createStreakEffect(condition, effect, radius) createEffect(condition, effect, Color.TEAM_1, eventPlayer, radius, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

#!define playerCantSeeSpawnPoint(s, p) (not isInLoS(p, s + vect(0, 1.8, 0), BarrierLos.PASS_THROUGH_BARRIERS) if p != null else true)
#!define distanceFromPointToPlayer(s, p) (distance(s, p) if p != null else 999999)
#!define distanceFromPointToPlayerBetween(s, p, lower, upper) (abs(distance(s, p) - (upper + lower) / 2) <= (upper - lower) / 2 if p != null else true)

#!define getNumberOfDummyBots(team) len([player for player in getPlayers(team) if player.isDummy()])
#!define getNumberOfAIBots(team) len([player for player in getPlayers(team) if player.IsAIBot])

#!define nextAIBot [player for player in getAllPlayers() if player.IsAIBot][0]
#!define nextAIBotName "​ [ -C°▥°]-C Ana Bot #{}".format(getNumberOfAIBots(Team.ALL))

#!define customGreen (rgb(63, 191, 116))
#!define rSaturation 0.55
#!define rValue 1.0
#!define rMin (255 * (1-rSaturation) * (rValue))
#!define rMax (255 * (rValue))
#!define rMod ((rMax - rMin) * 6)
#!define rOffset (rMax - 2*rMin)

#!define rainbow(t) min(max(abs((((t) + (0*rMod)/3) % rMod) - rMod/2) - rOffset, rMin), rMax),\
                    min(max(abs((((t) + (1*rMod)/3) % rMod) - rMod/2) - rOffset, rMin), rMax),\
                    min(max(abs((((t) + (2*rMod)/3) % rMod) - rMod/2) - rOffset, rMin), rMax)
