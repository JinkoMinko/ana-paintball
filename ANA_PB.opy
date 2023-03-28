settings "settings.opy.json"

#!extension buffStatusEffects
#!extension buffAndDebuffSounds
#!extension energyExplosionEffects
#!extension explosionSounds
#!extension debuffStatusEffects

#!include "macros.opy"
#!define DEBUG_MODE false

#!include "variables.opy"

#!include "debug.opy"

# Pre-match
#!include "setup.opy"

# Context messages
#!include "systemMessages.opy"

# Trackers
#!include "stats.opy"

#!include "medals.opy"

#!include "fairPlay.opy"

# Kills & deaths
#!include "kills.opy"
#!include "respawns.opy"

# Sleep mechanics
#!include "sleep.opy"

# End-game nanoboost
#!include "nano.opy"

# When a player wins
#!include "win.opy"

#!include "jumpPads.opy"

# Launchers, teleporters, etc
#!include "mapObjects.opy"

#!include "bots.opy"