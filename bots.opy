#!mainFile "ANA_PB.opy"

rule "Hammond says hello back":
    @Event eachPlayer
    @Condition eventPlayer.isCommunicating(Comms.HELLO)
    @Condition distance(eventPlayer, OutOfBoundBot.getEyePosition()) < 15
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), OutOfBoundBot.getEyePosition())) <= 6.5
    @Condition isInLoS(eventPlayer.getEyePosition(), OutOfBoundBot.getEyePosition(), BarrierLos.PASS_THROUGH_BARRIERS)

    wait(0.5)
    OutOfBoundBot.communicate(Comms.HELLO)
    wait(3)

rule "GLOBAL create Nano-Nuke Bastion":
    @Event global
    @Condition isGameInProgress()    
    
    createDummy(Hero.BASTION, Team.ALL, 10, vect(0, 999, 0), Vector.UP)
    NanoNukeBot = getLastCreatedEntity()
    NanoNukeBot.startForcingName("join www.jinko.dev/discord")
    NanoNukeBot.setScore(-69)
    NanoNukeBot.setInvisibility(Invis.ALL)
    NanoNukeBot.setStatusEffect(null, Status.PHASED_OUT, 9999)
    NanoNukeBot.setGravity(0)
    NanoNukeBot.startModifyingVoicelinePitch(0.5, false)
    NanoNukeBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    NanoNukeBot.startScalingSize(0.2, false) # for petra floor breaking


rule "PETRA break floor over time":
    @Event global
    @Condition NanoNukeBot
    @Condition getCurrentMap() == Map.PETRA

    for PetraPunches in range(0, 50, 1):
        wait(3)
        NanoNukeBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT) # for spectators joining during the match
        NanoNukeBot.teleport(random.choice([vect(-4, -11, 12), vect(9.5, -11, 11.3), vect(8.2, -11, 6.5), vect(-3.3, -11, 6.5)]))
        NanoNukeBot.startForcingButton(Button.MELEE)
        wait()
        NanoNukeBot.teleport(vect(0, 999, 0))

################################### DEATH PLANE BOTS
    
rule "Death plane exploit loop":
    @Condition getCurrentMap() in DEATH_PLANE_BOT_MAPS

    wait(10)
    OutOfBoundBot.setEnvironmentalKillCreditor(OutOfBoundBot)
    OutOfBoundBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
        goto RULE_START

rule "Death plane HAMMOND CHATEAU":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.CHATEAU_GUILLARD or getCurrentMap() == Map.CHATEAU_GUILLARD_HALLOWEEN

    createDummy(Hero.HAMMOND, Team.ALL, 11, vect(200, 200, 80), Vector.FORWARD)
    OutOfBoundBot = getLastCreatedEntity()
    OutOfBoundBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot.setScore(-69)
    OutOfBoundBot.startForcingName("giant cheese eater")
    #OutOfBoundBot.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot.disableEnvironmentCollision(true)
    OutOfBoundBot.setMaxHealth(100000000)
    OutOfBoundBot.setDamageDealt(0.00001)
    OutOfBoundBot.startScalingSize(100, false)
    OutOfBoundBot.setGravity(0)
    wait(2)
    OutOfBoundBot.setStatusEffect(null, Status.INVINCIBLE, 9999)
    OutOfBoundBot.setStatusEffect(null, Status.PHASED_OUT, 9999)
    OutOfBoundBot.setEnvironmentalKillCreditor(OutOfBoundBot)

    OutOfBoundBot.teleport(vect(206.4, -34.5, 92))
    OutOfBoundBot.setFacing(Vector.BACKWARD, Relativity.TO_PLAYER)
    wait()
    OutOfBoundBot.startFacing(directionTowards(OutOfBoundBot.getEyePosition(), getClosestPlayer(OutOfBoundBot, Team.ALL)) if distance(getClosestPlayer(OutOfBoundBot, Team.ALL), vect(206.4, 0, 92)) <= 25 and distance(getClosestPlayer(OutOfBoundBot, Team.ALL), vect(206, 0, 73)) <= 13 and getClosestPlayer(OutOfBoundBot, Team.ALL).getPosition().y < 3.5 and getClosestPlayer(OutOfBoundBot, Team.ALL).hasSpawned() else Vector.BACKWARD, 20, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)


rule "Death plane HAMMOND HOLLYWOOD":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN

    createDummy(Hero.HAMMOND, Team.ALL, 11, vect(200, 200, 80), Vector.FORWARD)
    OutOfBoundBot = getLastCreatedEntity()
    OutOfBoundBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot.setScore(-69)
    OutOfBoundBot.startForcingName("giant cheese eater")
    #OutOfBoundBot.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot.disableEnvironmentCollision(true)
    OutOfBoundBot.setMaxHealth(100000000)
    OutOfBoundBot.setDamageDealt(0.00001)
    OutOfBoundBot.startScalingSize(100, false)
    OutOfBoundBot.setGravity(0)
    wait(2)
    OutOfBoundBot.setStatusEffect(null, Status.INVINCIBLE, 9999)
    OutOfBoundBot.setStatusEffect(null, Status.PHASED_OUT, 9999)
    OutOfBoundBot.setEnvironmentalKillCreditor(OutOfBoundBot)

    OutOfBoundBot.teleport(vect(-16.7, -32.75, -14.25))
    OutOfBoundBot.setFacing(directionTowards(OutOfBoundBot.getEyePosition(), vect(-4, 3, -12)), Relativity.TO_WORLD)
    wait()
    OutOfBoundBot.startFacing(directionTowards(OutOfBoundBot.getEyePosition(), getClosestPlayer(OutOfBoundBot, Team.ALL)) if distance(getClosestPlayer(OutOfBoundBot, Team.ALL), vect(-7, 0.8, -7)) <= 12.2 else directionTowards(OutOfBoundBot.getEyePosition(), vect(-4, 3, -12)), 20, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)


rule "Death plane SIGMA BLACK FOREST":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.BLACK_FOREST or getCurrentMap() == Map.BLACK_FOREST_WINTER

    createDummy(Hero.SIGMA, Team.ALL, 11, vect(1000, 1000, 1000), Vector.FORWARD)
    OutOfBoundBot = getLastCreatedEntity()
    OutOfBoundBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot.setScore(-69)
    OutOfBoundBot.startForcingName("Bigma")
    #OutOfBoundBot.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot.disableEnvironmentCollision(true)
    OutOfBoundBot.setMaxHealth(100000000)
    OutOfBoundBot.setDamageDealt(0.00001)
    OutOfBoundBot.startScalingSize(100, false)
    OutOfBoundBot.setGravity(0)
    wait(2)
    OutOfBoundBot.setStatusEffect(null, Status.INVINCIBLE, 9999)
    OutOfBoundBot.setStatusEffect(null, Status.INVINCIBLE, 9999)
    OutOfBoundBot.setStatusEffect(null, Status.PHASED_OUT, 9999)
    OutOfBoundBot.setEnvironmentalKillCreditor(OutOfBoundBot)

    OutOfBoundBot.teleport(vect(-44, -25, -2))
    OutOfBoundBot.setFacing(directionTowards(OutOfBoundBot.getEyePosition(), vect(-16.4, 15, -6)), Relativity.TO_WORLD)


rule "Mei ECOPOINT":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.ECOPOINT_ANTARCTICA or getCurrentMap() == Map.ECOPOINT_ANTARCTICA_WINTER
    @Disabled

    createDummy(Hero.MEI, Team.ALL, 11, vect(26, 9.5, 0), Vector.RIGHT)
    OutOfBoundBot = getLastCreatedEntity()
    OutOfBoundBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot.setScore(-69)
    OutOfBoundBot.startForcingName("Ice Cube")
    OutOfBoundBot.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot.disableEnvironmentCollision(false)
    OutOfBoundBot.startScalingSize(0.2, false)
    OutOfBoundBot.setGravity(0)
    OutOfBoundBot.setStatusEffect(null, Status.INVINCIBLE, 9999)
    wait(2)
    OutOfBoundBot.setStatusEffect(null, Status.ASLEEP, 9999)


rule "Kiriko Kanezaka":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.KANEZAKA

    createDummy(Hero.KIRIKO, Team.ALL, 11, vect(-11.5, 10.80, 16.9), Vector.RIGHT)
    OutOfBoundBot = getLastCreatedEntity()
    OutOfBoundBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot.setScore(-69)
    OutOfBoundBot.startForcingName("Kiricat")
    OutOfBoundBot.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot.disableEnvironmentCollision(true)
    OutOfBoundBot.startScalingSize(0.15, false)
    OutOfBoundBot.setGravity(0)
    wait(2)
    OutOfBoundBot.setStatusEffect(null, Status.KNOCKED_DOWN, 9999)
    createEffect(localPlayer, Effect.ANA_SLEEPING, Color.TEAM_1, OutOfBoundBot.getEyePosition() + vect(0, -0.1, 0), 1, EffectReeval.VISIBILITY)
    OutOfBoundBot.setStatusEffect(null, Status.PHASED_OUT, 9999)


rule "Junkrat Petra":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.PETRA

    createDummy(Hero.JUNKRAT, Team.ALL, 11, vect(-17.94, 0.24, 17.11), Vector.LEFT)
    OutOfBoundBot = getLastCreatedEntity()
    OutOfBoundBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot.setScore(-69)
    OutOfBoundBot.startForcingName("Gold Hoarder")
    OutOfBoundBot.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot.setGravity(0)
    wait(2)
    OutOfBoundBot.setStatusEffect(null, Status.KNOCKED_DOWN, 9999)
    createEffect(localPlayer, Effect.ANA_SLEEPING, Color.TEAM_1, vect(-18.8, 0.85, 17.11), 1, EffectReeval.VISIBILITY)
    OutOfBoundBot.setStatusEffect(null, Status.PHASED_OUT, 9999)

    