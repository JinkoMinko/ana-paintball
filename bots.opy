#!mainFile "ANA_PB.opy"

rule "GLOBAL create Nuclear Bomb Bastion":
    @Event global

    createDummy(Hero.BASTION, Team.ALL, 10, vect(0, 999, 0), Vector.UP)
    NuclearBot = getLastCreatedEntity()
    NuclearBot.startForcingName("Join jinko.dev/discord !")
    NuclearBot.setScore(-69)
    NuclearBot.setStatusEffect(null, Status.PHASED_OUT, 999)
    NuclearBot.setGravity(0)
    NuclearBot.setInvisibility(Invis.ALL)
    NuclearBot.disableEnvironmentCollision(true)
    NuclearBot.disablePlayerCollision()
    NuclearBot.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)

rule "PETRA create FLOORBREAKER":
    @Event global
    @Condition getCurrentMap() == Map.PETRA
    @Condition getNumberOfHeroes(Hero.ANA, Team.ALL) > 1

    createDummy(Hero.WIDOWMAKER, Team.ALL, 11, vect(500, 500, 0), Vector.UP)
    OutOfBoundBot1 = getLastCreatedEntity()
    OutOfBoundBot1.setScore(-69)
    OutOfBoundBot1.setGravity(0)
    OutOfBoundBot1.setInvisibility(Invis.ALL)
    OutOfBoundBot1.startScalingSize(0.2, false)
    OutOfBoundBot1.setFacing(Vector.UP, Relativity.TO_WORLD)
    OutOfBoundBot1.startForcingName("Floorbreaker")
    OutOfBoundBot1.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)


rule "PETRA break floor over time":
    @Event global
    @Condition OutOfBoundBot1
    @Condition getCurrentMap() == Map.PETRA

    for PetraPunches in range(0, 50, 1):
        wait(3)
        OutOfBoundBot1.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
        OutOfBoundBot1.teleport(random.choice([vect(-4, -11, 12), vect(9.5, -11, 11.3), vect(8.2, -11, 6.5), vect(-3.3, -11, 6.5)]))
        OutOfBoundBot1.startForcingButton(Button.MELEE)
        wait()
        OutOfBoundBot1.teleport(vect(500, 500, 0))
    destroyAllDummies()


################################### DEATH PLANE BOTS
    
rule "Death plane exploit loop":
    @Condition getCurrentMap() in DEATH_PLANE_BOT_MAPS

    wait(10)
    OutOfBoundBot1.setEnvironmentalKillCreditor(OutOfBoundBot1)
    OutOfBoundBot1.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
        goto RULE_START

rule "Death plane HAMMOND CHATEAU":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.CHATEAU_GUILLARD or getCurrentMap() == Map.CHATEAU_GUILLARD_HALLOWEEN

    createDummy(Hero.HAMMOND, Team.ALL, 11, vect(200, 200, 80), Vector.FORWARD)
    OutOfBoundBot1 = getLastCreatedEntity()
    OutOfBoundBot1.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot1.setScore(-69)
    OutOfBoundBot1.startForcingName("giant cheese eater")
    #OutOfBoundBot1.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot1.disableEnvironmentCollision(true)
    OutOfBoundBot1.setMaxHealth(100000000)
    OutOfBoundBot1.setDamageDealt(0.00001)
    OutOfBoundBot1.startScalingSize(100, false)
    OutOfBoundBot1.setGravity(0)
    wait(2)
    OutOfBoundBot1.setStatusEffect(null, Status.INVINCIBLE, 9999)
    OutOfBoundBot1.setStatusEffect(null, Status.PHASED_OUT, 9999)
    OutOfBoundBot1.setEnvironmentalKillCreditor(OutOfBoundBot1)

    OutOfBoundBot1.teleport(vect(206.4, -34.5, 92))
    OutOfBoundBot1.setFacing(Vector.BACKWARD, Relativity.TO_PLAYER)
    wait()
    OutOfBoundBot1.startFacing(directionTowards(OutOfBoundBot1.getEyePosition(), getClosestPlayer(OutOfBoundBot1, Team.ALL)) if distance(getClosestPlayer(OutOfBoundBot1, Team.ALL), vect(206.4, 0, 92)) <= 25 and distance(getClosestPlayer(OutOfBoundBot1, Team.ALL), vect(206, 0, 73)) <= 13 and getClosestPlayer(OutOfBoundBot1, Team.ALL).getPosition().y < 3.5 and getClosestPlayer(OutOfBoundBot1, Team.ALL).hasSpawned() else Vector.BACKWARD, 20, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)


rule "Death plane HAMMOND HOLLYWOOD":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN

    createDummy(Hero.HAMMOND, Team.ALL, 11, vect(200, 200, 80), Vector.FORWARD)
    OutOfBoundBot1 = getLastCreatedEntity()
    OutOfBoundBot1.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot1.setScore(-69)
    OutOfBoundBot1.startForcingName("giant cheese eater")
    #OutOfBoundBot1.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot1.disableEnvironmentCollision(true)
    OutOfBoundBot1.setMaxHealth(100000000)
    OutOfBoundBot1.setDamageDealt(0.00001)
    OutOfBoundBot1.startScalingSize(100, false)
    OutOfBoundBot1.setGravity(0)
    wait(2)
    OutOfBoundBot1.setStatusEffect(null, Status.INVINCIBLE, 9999)
    OutOfBoundBot1.setStatusEffect(null, Status.PHASED_OUT, 9999)
    OutOfBoundBot1.setEnvironmentalKillCreditor(OutOfBoundBot1)

    OutOfBoundBot1.teleport(vect(-16.7, -32.75, -14.25))
    OutOfBoundBot1.setFacing(directionTowards(OutOfBoundBot1.getEyePosition(), vect(-4, 3, -12)), Relativity.TO_WORLD)
    wait()
    OutOfBoundBot1.startFacing(directionTowards(OutOfBoundBot1.getEyePosition(), getClosestPlayer(OutOfBoundBot1, Team.ALL)) if distance(getClosestPlayer(OutOfBoundBot1, Team.ALL), vect(-7, 0.8, -7)) <= 12.2 else directionTowards(OutOfBoundBot1.getEyePosition(), vect(-4, 3, -12)), 20, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)


rule "Death plane SIGMA BLACK FOREST":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.BLACK_FOREST or getCurrentMap() == Map.BLACK_FOREST_WINTER

    createDummy(Hero.SIGMA, Team.ALL, 11, vect(1000, 1000, 1000), Vector.FORWARD)
    OutOfBoundBot1 = getLastCreatedEntity()
    OutOfBoundBot1.startForcingOutlineFor([getAllPlayers(), not localPlayer.IsPlayer], false, Color.RED, OutlineVisibility.DEFAULT)
    OutOfBoundBot1.setScore(-69)
    OutOfBoundBot1.startForcingName("Bigma")
    #OutOfBoundBot1.disableNameplatesFor(getAllPlayers())
    OutOfBoundBot1.disableEnvironmentCollision(true)
    OutOfBoundBot1.setMaxHealth(100000000)
    OutOfBoundBot1.setDamageDealt(0.00001)
    OutOfBoundBot1.startScalingSize(100, false)
    OutOfBoundBot1.setGravity(0)
    wait(2)
    OutOfBoundBot1.setStatusEffect(null, Status.INVINCIBLE, 9999)
    OutOfBoundBot1.setStatusEffect(null, Status.INVINCIBLE, 9999)
    OutOfBoundBot1.setStatusEffect(null, Status.PHASED_OUT, 9999)
    OutOfBoundBot1.setEnvironmentalKillCreditor(OutOfBoundBot1)

    OutOfBoundBot1.teleport(vect(-44, -25, -2))
    OutOfBoundBot1.setFacing(directionTowards(OutOfBoundBot1.getEyePosition(), vect(-16.4, 15, -6)), Relativity.TO_WORLD)