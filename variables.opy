#!mainFile "ANA_PB.opy"

# Constants
globalvar ONFIRE_STREAK = (5 if DEBUG_MODE else 5)
globalvar RAMPAGE_STREAK = (10 if DEBUG_MODE else 10)
globalvar NUKE_STREAK = (15 if DEBUG_MODE else 15)
globalvar NANO_SCORE = (29 if DEBUG_MODE else 29)
globalvar LONGSHOT_DISTANCE = (40 if DEBUG_MODE else 40)
globalvar NIGHT_MAPS = [Map.EICHENWALDE_HALLOWEEN, Map.CHATEAU_GUILLARD_HALLOWEEN, Map.BLIZZ_WORLD_WINTER, Map.ECOPOINT_ANTARCTICA_WINTER, Map.HOLLYWOOD_HALLOWEEN]
globalvar JUMP_PAD_COLOR = Color.BLUE if getCurrentMap() in NIGHT_MAPS else Color.PURPLE
globalvar CUSTOM_RESPAWN_TIME = 1.1

# Jump pads
globalvar CreateJumpPad    # Macro call
globalvar JumpPadPos
globalvar JumpPadPower
globalvar JumpPadSize
globalvar JumpPadFx

# Stats
playervar LongshotCount
globalvar LongestLongshotPlayer
globalvar LongestLongshotValue

globalvar MostKillStreakPlayer
globalvar MostKillStreakValue

globalvar BestSleepAccuracyPlayer
globalvar BestSleepAccuracyValue

globalvar BestNoscopeAccuracyPlayer
globalvar BestNoscopeAccuracyValue

globalvar BestScopedAccuracyValue
globalvar BestScopedAccuracyPlayer

# General
globalvar MatchEnded = false
globalvar Winner
globalvar FirstBlood
globalvar FirstSleep
globalvar FinalVictim
globalvar LongshotWin
globalvar Spawn    #used in debug to show spawn points

# Other
globalvar OutOfBoundBot1
globalvar PetraPunches    # Petra's Floorbreaker bot hits count
globalvar i    # used to loop medals sent globally



playervar HonorBar = 0
playervar DisplayStats = true
playervar OofDistance    # Distance between attacker and victim. >= Longshot Distance
playervar OofText
playervar NanoDelay = 1    # Used to know when a player can cast Nanoboost
playervar ClosestPadIndex    # Closest Jump Pad relative to the player
playervar IsPlayer 
playervar LongestLongshot = 0
playervar KillStreak = 0
playervar KillStreakBeforeDeath
playervar SleepShots
playervar SleepHits
playervar SleepAccuracy
playervar NoscopeShots
playervar NoscopeHits
playervar NoscopeAccuracy
playervar ScopedShots
playervar ScopedHits
playervar ScopedAccuracy
playervar Jumps
playervar Execute
playervar StolenKills
playervar DemotedPlayers
playervar Deaths
playervar ElimsBeforeQS
playervar PerfectQuickscopes
playervar ComebackCount # Numbers of deaths without a kill
playervar Killer
playervar SleepAuthor
playervar SleepUsedAndDied = true    # Used to detect when a sleeping player should be awoken due to their SleepAuthor dying
playervar SleepLock     # should be reworked
playervar SleepsOnground = false    # Whether a player that was hit with a sleep dart has finished the "falling on the ground" animation
playervar ExecuteRange = 30    # Proximity-based visibility condition for "punch to execute" prompts - the chase is so you don't get prompted to execute if too far
playervar Temp
playervar EarnedCollateral
playervar Sandman
playervar PunchDrunk
playervar AlmostNano = true

playervar QuadFeedTimes = []
playervar HonorQueue = []
playervar SystemMessages = []
playervar MedalQueue = []

playervar ShutdownVictim
playervar StolenFrom
playervar DisplayMedal
playervar MedalCount #debug
playervar SysMsgCount #debug
playervar HonorTarget

playervar RaycastLastHitPlayer
playervar RaycastLastHitPos

playervar FixMovementBug

globalvar Rainbow
globalvar IndexValue

enum Medal:
    SYSTEM_MESSAGE,
    NICE_SHOT,
    EXECUTE,
    PERFECT_QS,
    DEMOTION,
    STOLEN_KILL,
    FIRST_BLOOD,
    FIRST_SLEEP,
    COMEBACK,
    LONGSHOT,
    NANOPUNCH,
    ENV_KILL,
    ON_FIRE_SHUTDOWN,
    RAMPAGE_SHUTDOWN,
    BUZZKILL,
    SHOWSTOPPER,
    QUADFEED,
    ON_FIRE,
    RAMPAGE,
    JOLLY_JUMPER,
    COLLATERAL_KILLS,
    MUTUAL_SLEEP,
    DECISIVE_SHOT,
    DREAMCATCHER,
    NO_SCOPE_NEEDED,
    DEADEYE,
    SLEEP_SNIPER,
    SANDMAN,
    PUNCH_DRUNK,
    FROM_THE_GRAVE,


playervar AlivePlayers
playervar SpawnPointsNotInLOS
playervar SpawnPointsFarEnoughFromPlayers
playervar ChosenSpawnPoint

globalvar SpawnPointSettings

playervar DemotedEffect
playervar RampageVFX
playervar RampageSFX

subroutine RespawnSystem
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
subroutine RespawnsLIJANGCONTROL
subroutine PlayZoneLIJANGCONTROL

globalvar PlayzoneCenter
globalvar PlayzoneRadius

globalvar RespawnHigherDistance
globalvar RespawnLowerDistance
globalvar RespawnFailsafeDistance
