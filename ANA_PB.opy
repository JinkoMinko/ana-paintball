settings "settings.opy.json"


#!extension buffStatusEffects
#!extension buffAndDebuffSounds
#!extension energyExplosionEffects
#!extension explosionSounds
#!extension debuffStatusEffects
#!extension projectiles

#!include "macros.opy"

# Toggle debug mode
#!define DEBUG_MODE true
# # # # # # # # # # # # # # # # # # # # # # 

# Pre-match
#!include "variables.opy"
#!include "debug.opy"
#!include "setup.opy"
#!include "huds.opy"
#!include "respawns.opy"
#!include "playzones.opy"

# Context messages
#!include "systemMessages.opy"

# Trackers
#!include "stats.opy"
#!include "medals.opy"
#!include "honor.opy"

# Kills & deaths
#!include "kills.opy"

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

# Subroutines
#!include "subroutines.opy"
