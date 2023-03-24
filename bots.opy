#!mainFile "ANA_PB.opy"

rule "PETRA create FLOORBREAKER":
    @Event global
    @Condition getCurrentMap() == Map.PETRA
    @Condition getNumberOfHeroes(Hero.ANA, Team.ALL) > 1

    createDummy(Hero.WIDOWMAKER, Team.ALL, 11, vect(500, 500, 0), Vector.UP)
    getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL).setGravity(0)
    getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL).setInvisibility(Invis.ALL)
    getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL).startScalingSize(0.2, false)
    getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL).setFacing(Vector.UP, Relativity.TO_WORLD)
    getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL).startForcingName("Floorbreaker")


rule "PETRA break floor over time":
    @Event global
    @Condition getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL)
    @Condition getCurrentMap() == Map.PETRA

    for PetraPunches in range(0, 50, 1):
        wait(3)
        getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL).teleport(random.choice([vect(-4, -11, 12), vect(9.5, -11, 11.3), vect(8.2, -11, 6.5), vect(-3.3, -11, 6.5)]))
        getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL).startForcingButton(Button.MELEE)
        wait()
        getPlayersOnHero(Hero.WIDOWMAKER, Team.ALL).teleport(vect(500, 500, 0))
    destroyAllDummies()


rule "HAMMOND spawn - CHATEAU":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.CHATEAU_GUILLARD or getCurrentMap() == Map.CHATEAU_GUILLARD_HALLOWEEN

    createDummy(Hero.HAMMOND, Team.ALL, 11, vect(200, 200, 80), Vector.FORWARD)
    OutOfBoundBot1 = getLastCreatedEntity()
    OutOfBoundBot1.startForcingName("giant cheese eater")
    OutOfBoundBot1.disableNameplatesFor(getAllPlayers())
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
    OutOfBoundBot1.startFacing(directionTowards(OutOfBoundBot1.getEyePosition(), getClosestPlayer(OutOfBoundBot1, Team.ALL)) if distance(getClosestPlayer(OutOfBoundBot1, Team.ALL), vect(206.4, 0, 92)) <= 25 and distance(getClosestPlayer(OutOfBoundBot1, Team.ALL), vect(206, 0, 73)) <= 13 and getClosestPlayer(OutOfBoundBot1, Team.ALL).getPosition().y < 3.5 else Vector.BACKWARD, 20, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)


rule "HAMMOND exploit - CHATEAU":
    @Condition getCurrentMap() == Map.CHATEAU_GUILLARD or getCurrentMap() == Map.CHATEAU_GUILLARD_HALLOWEEN

    wait(10)
    OutOfBoundBot1.setEnvironmentalKillCreditor(OutOfBoundBot1)
    OutOfBoundBot1.startForcingOutlineFor(getAllPlayers(), false, Color.RED, OutlineVisibility.DEFAULT)
        goto RULE_START


rule "HAMMOND spawn - HOLLYWOOD":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN

    createDummy(Hero.HAMMOND, Team.ALL, 11, vect(200, 200, 80), Vector.FORWARD)
    OutOfBoundBot1 = getLastCreatedEntity()
    OutOfBoundBot1.startForcingName("giant cheese eater")
    OutOfBoundBot1.disableNameplatesFor(getAllPlayers())
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


rule "HAMMOND exploit - HOLLYWOOD":
    @Condition getCurrentMap() == Map.HOLLYWOOD or getCurrentMap() == Map.HOLLYWOOD_HALLOWEEN

    wait(10)
    OutOfBoundBot1.setEnvironmentalKillCreditor(OutOfBoundBot1)
    OutOfBoundBot1.startForcingOutlineFor(getAllPlayers(), false, Color.RED, OutlineVisibility.DEFAULT)
        goto RULE_START


rule "SIGMA spawn - BLACK FOREST":
    @Condition isGameInProgress()
    @Condition getCurrentMap() == Map.BLACK_FOREST or getCurrentMap() == Map.BLACK_FOREST_WINTER

    createDummy(Hero.SIGMA, Team.ALL, 11, vect(1000, 1000, 1000), Vector.FORWARD)
    OutOfBoundBot1 = getLastCreatedEntity()
    OutOfBoundBot1.startForcingName("Bigma")
    OutOfBoundBot1.disableNameplatesFor(getAllPlayers())
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
    OutOfBoundBot1.startForcingOutlineFor(getAllPlayers(), false, Color.RED, OutlineVisibility.DEFAULT)


rule "SIGMA exploit - BLACK FOREST":
    @Condition getCurrentMap() == Map.BLACK_FOREST or getCurrentMap() == Map.BLACK_FOREST_WINTER

    wait(10)
    OutOfBoundBot1.setEnvironmentalKillCreditor(OutOfBoundBot1)
    OutOfBoundBot1.startForcingOutlineFor(getAllPlayers(), false, Color.RED, OutlineVisibility.DEFAULT)
        goto RULE_START