#!mainFile "ANA_PB.opy"

# CONSTANTS
globalvar ONFIRE_STREAK = (5 if DEBUG_MODE else 5)
globalvar RAMPAGE_STREAK = (10 if DEBUG_MODE else 10)
globalvar NUCLEAR_STREAK = (15 if DEBUG_MODE else 15)
globalvar NANO_SCORE = (1 if DEBUG_MODE else 29)

globalvar LONGSHOT_DISTANCE = (40 if DEBUG_MODE else 40)
globalvar CUSTOM_RESPAWN_TIME = 1.6
globalvar NIGHT_MAPS = [Map.EICHENWALDE_HALLOWEEN, Map.CHATEAU_GUILLARD_HALLOWEEN, Map.BLIZZ_WORLD_WINTER, Map.ECOPOINT_ANTARCTICA_WINTER, Map.HOLLYWOOD_HALLOWEEN]
globalvar JUMP_PAD_COLOR = Color.BLUE if getCurrentMap() in NIGHT_MAPS else Color.PURPLE
globalvar DEATH_PLANE_BOT_MAPS = [Map.BLACK_FOREST, Map.BLACK_FOREST_WINTER, Map.HOLLYWOOD, Map.HOLLYWOOD_HALLOWEEN, Map.CHATEAU_GUILLARD, Map.CHATEAU_GUILLARD_HALLOWEEN]


# JUMP PADS
globalvar CreateJumpPad    # Macro call
globalvar JumpPadPos
globalvar JumpPadPower
globalvar JumpPadSize
globalvar JumpPadFx
playervar ClosestPadIndex    # Closest Jump Pad relative to the player


# STATS
playervar LongshotCount
playervar LongestLongshot = 0
globalvar LongestShotPlayer
globalvar LongestShotValue

globalvar BestKillstreakPlayer
globalvar BestKillstreakValue

playervar SleepShots
playervar SleepHits
playervar SleepAccuracy
globalvar BestSleepAccuracyPlayer
globalvar BestSleepAccuracyValue

globalvar BestNoscopeAccuracyPlayer
globalvar BestNoscopeAccuracyValue

globalvar BestScopedAccuracyValue
globalvar BestScopedAccuracyPlayer

playervar NoscopeShots
playervar NoscopeHits
playervar NoscopeAccuracy

playervar ScopedShots
playervar ScopedHits
playervar ScopedAccuracy

playervar Jumps
subroutine SleepDarts
playervar PerfectQuickscopes
playervar ComebackCount # Player consecutive deaths without a kill

playervar Executes
playervar StolenKills
playervar DemotedPlayers
playervar Deaths
playervar ElimsBeforeQS

playervar KillStreak = 0
playervar KillStreakBeforeDeath


# END GAME
globalvar MatchEnded = false
globalvar Winner
globalvar FinalVictim
globalvar LongshotWin

# KILLSTREAKS
playervar DemotedEffect
playervar RampageVFX
playervar RampageSFX
playervar IsOnFire = false
playervar IsOnRampage = false
playervar IsNuclear = false


# COMMS
subroutine SayVoiceline
subroutine SayUltStatus
subroutine SayThanks
subroutine SaySorry
subroutine RandomEmote


# MEDALS
globalvar i    # used to loop medals sent globally
playervar DisplayMedal
playervar SystemMessages = []
playervar MedalQueue = []
playervar QuadFeedTimes = []
playervar EarnedCollateral
playervar Sandman
playervar PunchDrunk
globalvar FirstBlood
globalvar FirstSleep
subroutine FromTheGrave

enum Medal:
    SYSTEM_MESSAGE,
    HONOR,
    EXECUTED,
    PERFECT_QS,
    DEMOTION,
    STOLEN_KILL,
    FIRST_BLOOD,
    FIRST_SLEEP,
    COMEBACK,
    LONGSHOT,
    NANOPUNCH,
    ENV_KILL,
    ON_FIRE,
    ON_FIRE_SHUTDOWN,
    RAMPAGE,
    RAMPAGE_SHUTDOWN,
    BUZZKILL,
    NUCLEAR,
    NUCLEAR_SHUTDOWN,
    CATASTROPHE,
    COUNTERMEASURE,
    SHOWSTOPPER,
    QUADFEED,
    JOLLY_JUMPER,
    COLLATERAL_KILLS,
    MUTUAL_SLEEP,
    LAST_BULLET,
    DREAMCATCHER,
    NO_SCOPE_NEEDED,
    DEADEYE,
    SLEEP_SNIPER,
    SANDMAN,
    PUNCH_DRUNK,
    FROM_THE_GRAVE,


# RESPAWN SYSTEM
subroutine RespawnSystem

playervar AlivePlayers
playervar SpawnPointsNotInLOS
playervar SpawnPointsFarEnoughFromPlayers
playervar ChosenSpawnPoint

globalvar RespawnHigherDistance
globalvar RespawnLowerDistance
globalvar RespawnFailsafeDistance
globalvar SpawnPointSettings

subroutine RespawnsCHATEAU
subroutine RespawnsPETRA
subroutine RespawnsMALEVENTO
subroutine RespawnsDORADO
subroutine RespawnsHOLLYWOOD
subroutine RespawnsBLIZZWORLD
subroutine RespawnsEICHENWALDE
subroutine RespawnsECOPOINT
subroutine RespawnsBLACKFOREST
subroutine RespawnsNEPALSHRINE
subroutine RespawnsKANEZAKA


# PLAYZONES
globalvar PlayzoneCenter
globalvar PlayzoneRadius

subroutine RespawnsLIJANGCONTROL
subroutine PlayZoneLIJANGCONTROL


# BOTS
globalvar OutOfBoundBot
globalvar NanoNukeBot
globalvar PetraPunches    # Petra's Floorbreaker bot hits count


# HONOR SYSTEM
playervar HonorQueue = []
playervar HonorBar = 0
playervar HonorTarget


# COLLATERALS
playervar RaycastLastHitPlayer
playervar RaycastLastHitPos


# NUCLEAR BOMB
playervar NukeEffects
globalvar NukeExplodeFxPos = 1

globalvar NukeCamHorizontalDist
globalvar Camdist
globalvar NukePos
globalvar NukeImpactPos
globalvar NukeCamPos
globalvar NukeCamShakeX
globalvar NukeCamShakeY
globalvar NukeCamShakeZ

# HUD
globalvar Rainbow


# DEBUG
globalvar BotName = 1
playervar MedalCount
playervar SysMsgCount
globalvar Spawn      # shows spawn points
globalvar IndexValue # cycle through spawn points
playervar FixMovementBug # delete this system when blizz fixes the bug


# TRACKERS
playervar IsPlayer
playervar IsAIBot
playervar LastSleptBy
playervar SleepUsedAndDied = true    # detect when a sleeping player should be awoken due to their LastSleptBy dying
playervar SleepLock     # needs reworked
playervar SleepsOnground = false    # Whether a player that was hit with a sleep dart has finished the "falling on the ground" animation - needs reworked
playervar DemotionVictim
playervar ShutdownVictim
playervar StolenFrom
playervar NanoDelay = 1    # Used to know when a player can cast Nanoboost, used to know when nanoboost SFX can take over - can probably be removed and rework the shit


# OTHER
playervar DisplayStats = true
playervar OofDistance    # Distance between attacker and victim. >= Longshot Distance
playervar OofText
playervar Temp

globalvar SlowMo = 100
globalvar TempAIBotBeingRemoved
globalvar TempAIBotBeingRemovedName
