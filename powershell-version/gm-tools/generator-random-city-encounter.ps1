# Random event generator

# Thing that's happening, amount of people assisting/initiating, amount of people in trouble
$list = "Building on fire - nobody helping - people in building,0,0-5
Building on fire - civilians helping - people in building,1-5,0-5
Building on fire - emergency crews on site - people in building,5-20,0-5
Hover car accident - nobody helping - people trapped,0,1-5
Hover car accident - a few civilians helping - people trapped,1-5,1-5
Hover car accident - emergency crews on site - people trapped,2-10,1-5
Thugs breaking into a house - unarmed,1-5,1-5
Thugs breaking into a house - armed melee,1-5,1-5
Thugs breaking into a house - armed firearm,1-5,1-5
Person being mugged by thugs - unarmed,1,1-5
Person being mugged by thugs - armed melee,1,1-5
Person being mugged by thug - armed firearm,1,1-5
Group of unarmed thugs confront players,1-5,0
Group of armed (melee) thugs confront players,1-5,0
Group of armed (firearm) thugs confront players,1-5,0
Players hear a woman screaming for help from a dark alley, back yard or apartment window (sexual assault),1-5,0
Grifter offer players a great deal on a holiday to a tropical moon,1,0
Drunk with a firearm on his porch,1,0
Construction drones malfunctions,1-10,0
Delivery drone malfunction,1-10,0
Replicator fault - keeps replicating something over and over,1-2,0
Town fair,0,0
Hover bike race - official,2-5,0
Hover bike race - unofficial,2-5,0
Woman screaming about a lost child,0-2,1
Woman screaming about a lost pet,0-2,1
Disease outbreak - minor rash / cold,0,0
Disease outbreak - moderate cold / blood condition,0,0
Disease outbreak - severe cold / blood condition,0,0
Elections,0,0
Elections - one side corrupt,0,0
A coup d'etat in progress,0,0
Town is secretly under rebel control,0,0
Terrorist attack - small,5-10,5-10
Terrorist attack - medium,10-50,10-50
Terrorist attack - large,50-100,50-100
Organised crime takeover - small,5-10,1-5
Organised crime takeover - medium,10-50,5-10
Organised crime takeover - large,50-100,10-50"

$list = $list -split "`n"

$returnedEvent = Get-Random -InputObject $list

$returnedEvent = $returnedEvent -split ","

$returnedEvent[0]
if (($returnedEvent[1]) -match "-") {$a = Get-Random -Minimum $(($returnedEvent[1] -split"-")[0]) -Maximum $(($returnedEvent[1] -split"-")[1])} else {$a = ($returnedEvent[1])}
if (($returnedEvent[2]) -match "-") {$b = Get-Random -Minimum $(($returnedEvent[2] -split"-")[0]) -Maximum $(($returnedEvent[2] -split"-")[1])} else {$b = ($returnedEvent[2])}
"Assisting/initiating $a"
"In trouble $b"

#$returnedEvent = $null