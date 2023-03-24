#!mainFile "ANA_PB.opy"

rule "Disable inspector and match ending":
    @Event global
    
    enableInspector() if DEBUG_MODE else disableInspector()
    disableGamemodeCompletion()


rule "Start match sooner":
    @Condition not DEBUG_MODE
    @Condition isAssemblingHeroes()
    
    setMatchTime(13)
    wait(13.2)
    setMatchTime(261)
    wait()
    pauseMatchTime()


rule "Detect players":
    @Event playerJoined
    @Condition not eventPlayer.isDummy()
    
    eventPlayer.IsPlayer = true


rule "If lobby is empty, restart the game":
    @Event playerLeft
    @Condition not MatchEnded
    
    if len(getPlayersOnHero(Hero.ANA, Team.ALL)) == 0:
        restartMatch()


rule "PLAYER HUDs":
    @Event global
    
    hudSubtext(localPlayer.IsPlayer, "                                                                                                                ana pb by jinko ▶  1DMTZ                  www.jinko.dev/discord"emptySpace, HudPosition.LEFT, 0, hsv((getTotalTimeElapsed())%12/12*360,0.5,0.9), HudReeval.VISIBILITY_AND_COLOR, SpecVisibility.NEVER)    
    hudSubheader(localPlayer.IsPlayer, "always import the code to play on the latest version, thanks!", HudPosition.TOP, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer.IsPlayer, " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n                                                                                                                               ", HudPosition.TOP, 5, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.NEVER) # Makes the scoreboard larger and pushes the "nice shot" prompt down
    hudSubheader(localPlayer.IsPlayer, "\n "emptySpace, HudPosition.RIGHT, 0, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER) # Aligns the ScoreBoard Wallpapers horizontally
    hudSubtext(localPlayer.IsPlayer, "{}".format(ScoreboardWallpaperIcon(Icon.WARNING) if any([eventPlayer.getScore() == NANO_SCORE for eventPlayer in getAllPlayers()]) else ScoreboardWallpaperAbility(Hero.KIRIKO, Button.ULTIMATE)), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext([localPlayer.IsPlayer and getNumberOfPlayers(Team.ALL) > 1], "\n{}".format(ScoreboardWallpaperIcon(Icon.WARNING) if len([nanoplayer for nanoplayer in getAllPlayers() if nanoplayer.getScore() == NANO_SCORE]) >= 2 and localPlayer.getScore() == NANO_SCORE else ScoreboardWallpaperAbility(Hero.DVA, Button.ULTIMATE)), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
    hudSubtext(localPlayer.IsPlayer, "▼ use [{0}] to toggle stats" emptySpace.format(buttonString(Button.INTERACT)) if localPlayer.DisplayStats else "▶ use [{0}] to toggle stats" emptySpace.format(buttonString(Button.INTERACT)), HudPosition.LEFT, 8, rgb(63, 191, 116) if localPlayer.DisplayStats else rgba(63, 191, 116, 50), HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.NEVER)
    hudSubheader(localPlayer.DisplayStats, "Rainbow = best overall" emptySpace, HudPosition.LEFT, 9, rgb(63, 191, 116), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudText(localPlayer.DisplayStats, "{}".format(abilityIconString(Hero.SOJOURN, Button.SECONDARY_FIRE)), "Scoped Accuracy          " emptySpace, "{0}%".format(localPlayer.ScopedAccuracy), HudPosition.LEFT, 10, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if localPlayer.ScopedAccuracy == BestScopedAccuracyValue and localPlayer.ScopedShots >= 15 and localPlayer.ScopedAccuracy > 0 else rgb(63, 191, 116), Color.WHITE, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if localPlayer.ScopedAccuracy == BestScopedAccuracyValue and localPlayer.ScopedShots >= 15 and localPlayer.ScopedAccuracy > 0 else rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.NEVER)
    hudText(localPlayer.DisplayStats, "{}".format(abilityIconString(Hero.ANA, Button.ULTIMATE)), "Noscope Accuracy          " emptySpace, "{0}%".format(localPlayer.NoscopeAccuracy), HudPosition.LEFT, 11, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if localPlayer.NoscopeAccuracy == BestNoscopeAccuracyValue and localPlayer.NoscopeShots >= 15 and localPlayer.NoscopeAccuracy > 0 else rgb(63, 191, 116), Color.WHITE, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if localPlayer.NoscopeAccuracy == BestNoscopeAccuracyValue and localPlayer.NoscopeShots >= 15 and localPlayer.NoscopeAccuracy > 0 else rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.NEVER)
    hudText(localPlayer.DisplayStats, "{}".format(abilityIconString(Hero.ANA, Button.ABILITY_1)), "Sleep Dart Accuracy          " emptySpace, "{0}%".format(localPlayer.SleepAccuracy), HudPosition.LEFT, 12, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if localPlayer.SleepAccuracy == BestSleepAccuracyValue and localPlayer.SleepShots >= 10 and localPlayer.SleepAccuracy > 0 else rgb(63, 191, 116), Color.WHITE, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if localPlayer.SleepAccuracy == BestSleepAccuracyValue and localPlayer.SleepShots >= 10 and localPlayer.SleepAccuracy > 0 else rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.NEVER)
    hudText([localPlayer.DisplayStats and LongestLongshotValue >= 40], "{}".format(abilityIconString(Hero.MCCREE, Button.ULTIMATE)), "Longest longshot          " emptySpace, "{0}: {1}m".format(LongestLongshotPlayer, LongestLongshotValue), HudPosition.LEFT, 13, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if localPlayer.LongestLongshot == LongestLongshotValue else rgb(63, 191, 116), Color.WHITE, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if localPlayer.LongestLongshot == LongestLongshotValue else rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.NEVER)
    hudText([localPlayer.DisplayStats and MostKillStreakValue >= ONFIRE_STREAK], "{}".format(abilityIconString(Hero.REAPER, Button.ULTIMATE)), "Longest killstreak          " emptySpace, "{0} - {1}k".format(MostKillStreakPlayer, MostKillStreakValue), HudPosition.LEFT, 14, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if MostKillStreakPlayer == localPlayer else rgb(63, 191, 116), Color.WHITE, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if MostKillStreakPlayer == localPlayer else rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.NEVER)
    hudSubheader([localPlayer.DisplayStats and localPlayer.PerfectQuickscopes > 0], "Perfect Quickscopes: {0}{1}          ".format(localPlayer.PerfectQuickscopes, emptySpace), HudPosition.LEFT, 21, rgb(63, 191, 116), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader([localPlayer.DisplayStats and localPlayer.StolenKills > 0], "Stolen kills: {0}{1}          ".format(localPlayer.StolenKills, emptySpace), HudPosition.LEFT, 22, rgb(63, 191, 116), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader([localPlayer.DisplayStats and (localPlayer.ScopedShots + localPlayer.NoscopeShots) > 100], "Rifle shots: {0}{1}          ".format((localPlayer.ScopedShots + localPlayer.NoscopeShots), emptySpace), HudPosition.LEFT, 23, rgb(63, 191, 116), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader([localPlayer.DisplayStats and localPlayer.DemotedPlayers > 0], "Demoted: {0}{1}          ".format(localPlayer.DemotedPlayers, emptySpace), HudPosition.LEFT, 24, rgb(63, 191, 116), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader([localPlayer.DisplayStats and localPlayer.Jumps > 200], "Jumps: {0}{1}          ".format(localPlayer.Jumps, emptySpace), HudPosition.LEFT, 25, rgb(63, 191, 116), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader([localPlayer.DisplayStats and localPlayer.Deaths > 0 and localPlayer.getScore() > 0], "K/D ratio: {0}{1}          ".format(KD(localPlayer), emptySpace), HudPosition.LEFT, 26, rgb(63, 191, 116), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    progressBarHud([localPlayer.IsPlayer and localPlayer.FairplayBar > 0 and localPlayer.FairplayBar < 100], localPlayer.FairplayBar, "press [{0}] to say 'nice shot' to {1}".format(buttonString(Button.ABILITY_2), localPlayer.Killer), HudPosition.TOP, 10, hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if distance(localPlayer, localPlayer.Killer) >= LONGSHOT_DISTANCE else rgb(44,133,81), hsv((getTotalTimeElapsed())%3/3*360,0.5,0.9) if distance(localPlayer, localPlayer.Killer) >= LONGSHOT_DISTANCE else rgb(44,133,81), ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.NEVER)


rule "SPECTATOR HUDs":
    @Event global

    hudText([not localPlayer.IsPlayer and BestScopedAccuracyValue > 0], "{}".format(abilityIconString(Hero.SOJOURN, Button.SECONDARY_FIRE)), "Best Scoped Accuracy          " emptySpace, "{0}: {1}%".format(BestScopedAccuracyPlayer, BestScopedAccuracyValue), HudPosition.LEFT, 10, rgb(63, 191, 116), Color.WHITE, rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.NEVER)
    hudText([not localPlayer.IsPlayer and BestNoscopeAccuracyValue > 0], "{}".format(abilityIconString(Hero.ANA, Button.ULTIMATE)), "Best Noscope Accuracy          " emptySpace, "{0}: {1}%".format(BestNoscopeAccuracyPlayer, BestNoscopeAccuracyValue), HudPosition.LEFT, 11, rgb(63, 191, 116), Color.WHITE, rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.NEVER)
    hudText([not localPlayer.IsPlayer and BestSleepAccuracyValue > 0], "{}".format(abilityIconString(Hero.ANA, Button.ABILITY_1)), "Best Sleep Dart Accuracy          " emptySpace, "{0}: {1}%".format(BestSleepAccuracyPlayer, BestSleepAccuracyValue), HudPosition.LEFT, 12, rgb(63, 191, 116), Color.WHITE, rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.NEVER)
    hudText([not localPlayer.IsPlayer and MostKillStreakValue > 0], "{}".format(abilityIconString(Hero.REAPER, Button.ULTIMATE)), "Longest killstreak          " emptySpace, "{0} - {1}k".format(MostKillStreakPlayer, MostKillStreakValue), HudPosition.LEFT, 13, rgb(63, 191, 116), Color.WHITE, rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.NEVER)
    hudText([not localPlayer.IsPlayer and LongestLongshotValue >= 40], "{}".format(abilityIconString(Hero.MCCREE, Button.ULTIMATE)), "Longest longshot          " emptySpace, "{0}: {1}m".format(LongestLongshotPlayer, LongestLongshotValue), HudPosition.LEFT, 14, rgb(63, 191, 116), Color.WHITE, rgb(63, 191, 116), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.NEVER)
    hudSubtext([not localPlayer.IsPlayer], "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nana paintball by jinko - code 1DMTZ\n             www.jinko.dev/discord", HudPosition.TOP, 100, hsv((getTotalTimeElapsed())%12/12*360,0.5,0.9), HudReeval.VISIBILITY_AND_COLOR, SpecVisibility.NEVER)    


rule "toggle stats HUD":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.DisplayStats = not eventPlayer.DisplayStats


rule "PLAYER SETTINGS & KILLSTREAK EFFECTS":
    @Event eachPlayer
    @Hero ana

    eventPlayer.setDamageReceived(0.0001)
    eventPlayer.setMaxHealth(34.5)

    createInWorldText(localPlayer if
                        not localPlayer.hasStatusEffect(Status.ASLEEP)
                        and eventPlayer.hasStatusEffect(Status.ASLEEP)
                        and distance(localPlayer, eventPlayer) <= eventPlayer.SleepPunchRange
                        and eventPlayer.isAlive() and eventPlayer.SleepsOnground
                        and angleBetweenVectors(localPlayer.getFacingDirection(), directionTowards(localPlayer.getEyePosition(), eventPlayer)) < 5
                        and not MatchEnded
                        else [],
                        "{0} punch to {1}".format(
                            abilityIconString(Hero.ANA, Button.MELEE), "demote" if eventPlayer.getScore() > localPlayer.getScore() else "kill"
                        ) if localPlayer.SleepPunches < 3
                        else "",
                        eventPlayer+vect(0, +0.4, 0), 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
                        rgb(63, 191, 116) if eventPlayer.getScore() > localPlayer.getScore() else Color.SKY_BLUE,
                        SpecVisibility.NEVER)

    createStreakEffect(ONFIRE_STREAK, Effect.SOLDIER_SPRINTING, 10)
    createStreakEffect(RAMPAGE_STREAK, Effect.ECHO_CLONING, 1)
    createStreakEffect(RAMPAGE_STREAK, Effect.MERCY_DAMAGE_BOOSTED_SOUND, 0 if eventPlayer.isUsingUltimate() else 10 if eventPlayer == localPlayer else 80)
    createStreakEffect(GODLIKE_STREAK, Effect.WINSTON_PRIMAL_RAGE, 1)
    
    createEffect(localPlayer if eventPlayer.getScore() == NANO_SCORE and eventPlayer.isAlive() and eventPlayer.RespawnDelay == 1 else [], Effect.ANA_NANO_BOOSTED, Color.TEAM_1, eventPlayer, 0 if eventPlayer.isUsingUltimate() else 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(localPlayer if eventPlayer.getScore() == NANO_SCORE and eventPlayer.isAlive() and eventPlayer.RespawnDelay == 1 else [], Effect.ANA_NANO_BOOSTED_SOUND, Color.TEAM_1, eventPlayer, (0 if eventPlayer.isUsingUltimate() else 25) if eventPlayer == localPlayer else 150, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)    