import random

asteroidType = ["C","S","M"]

asteroidShape = ["Rectangular Prism", "Cube", "Spherical", "Cone", "Cyclinder","Potato","Banana","Pear", "Ellipsoid"]

mineralList = ["Aluminium,Antimony,Arsenic,Bismuth,Cadmium,Chromium,Cobalt,Indium,Iron,Manganese,Molybdenum,Nickel,Rhenium,Selenium,Tantalum,Tellurium,Tin,Titanium,Tungsten,Vanadium,Zinc,Gold,Copper,Lead,Aluminum,Mercury,Silver,Platinum,Iridium,Osmium,Palladium,Rhodium,Ruthenium,Brass,Bronze,Pewter,German Silver,Osmiridium,Electrum,White Gold,Silver-Mercury,Gold-Mercury Amalgam"]

def getAsteroidID():
    asteroidIDList = []
    while rnd in asteroidIDList:
        rnd = random.randint(1,9999999999)
    rndStr = str(rnd).zfill(10)
    asteroidIDList += rnd
    rndFull = rnd
    print(rnd)
    print(rndFull)
    return rndFull

getAsteroidID
