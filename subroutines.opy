#!mainFile "ANA_PB.opy"

def FromTheGrave():
    waitUntil(attacker.isAlive(), 69)
    attacker.MedalQueue.append(Medal.FROM_THE_GRAVE)

def SayVoiceline():
    wait(0.4)
    if attacker.isAlive():
        switch random.randint(1,4):
            case 1:
                eventPlayer.communicate(Comms.VOICE_LINE_UP)
            case 2:
                eventPlayer.communicate(Comms.VOICE_LINE_RIGHT)
            case 3:
                eventPlayer.communicate(Comms.VOICE_LINE_DOWN)
            case 4:
                eventPlayer.communicate(Comms.VOICE_LINE_LEFT)

def SayUltStatus():
    wait(0.4)
    attacker.communicate(Comms.ULTIMATE_STATUS)

def SayThanks():
    wait(0.4)
    attacker.communicate(Comms.THANKS)

def SaySorry():
    wait(0.4)
    attacker.communicate(Comms.SORRY)