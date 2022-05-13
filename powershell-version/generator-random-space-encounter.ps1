# Random event generator

$list = "Ship Deuterium Leak -2
Ship Deuterium Leak -4
Ship Deuterium Fire -2
Ship engine failure -2
Ship engine failure -4
Ship engine fire -2
Ship sensors module failure -2
Ship sensors module failure -4
Ship sensors module fire -2
Ship warp drive failure - 2
Ship warp drive failure - 4
Ship warp drive fire - 2
Ship airlock failure - 2
Ship airlock failure - 4
Ship airlock fire - 2
Ship window failure -2
Ship window failure -4
Ship window fire -2
Ship panel failure -2
Ship panel failure -4
Ship panel fire -2
Ship sublight drive failure -2
Ship sublight drive failure -4
Ship sublight drive fire -2
Ship invalid sensor signature -2
Ship invalid sensor signature -4
Ship incorrect navigation calculation -2
Ship incorrect navigation calculation -4
Ship gravity sensor failure -2
Ship gravity sensor failure -4
Ship diagnostic system failure -2
Ship diagnostic system failure -4
Ship decoy system failure -2
Ship decoy system failure -4
Ship decoy system failure -2
Ship ECM system failure -2
Ship ECM system failure -4
Ship ECM system fire -2
Ship weapons system failure -2
Ship weapons system failure -4
Ship weapons system fire -2
Ship shields system failure -2
Ship shields system failure -4
Ship shields system fire -2
Ship communications failure -2
Ship communications failure -4
Ship communications fire -2
Ship Deuterium Leak -2
Ship Deuterium Leak -4
Ship Deuterium Fire -2
Ship engine failure -2
Ship engine failure -4
Ship engine fire -2
Ship sensors module failure -2
Ship sensors module failure -4
Ship sensors module fire -2
Ship warp drive failure - 2
Ship warp drive failure - 4
Ship warp drive fire - 2
Ship airlock failure - 2
Ship airlock failure - 4
Ship airlock fire - 2
Ship window failure -2
Ship window failure -4
Ship window fire -2
Ship panel failure -2
Ship panel failure -4
Ship panel fire -2
Ship sublight drive failure -2
Ship sublight drive failure -4
Ship sublight drive fire -2
Ship invalid sensor signature -2
Ship invalid sensor signature -4
Ship incorrect navigation calculation -2
Ship incorrect navigation calculation -4
Ship gravity sensor failure -2
Ship gravity sensor failure -4
Ship diagnostic system failure -2
Ship diagnostic system failure -4
Ship decoy system failure -2
Ship decoy system failure -4
Ship decoy system failure -2
Ship ECM system failure -2
Ship ECM system failure -4
Ship ECM system fire -2
Ship weapons system failure -2
Ship weapons system failure -4
Ship weapons system fire -2
Ship shields system failure -2
Ship shields system failure -4
Ship shields system fire -2
Ship communications failure -2
Ship communications failure -4
Ship communications fire -2
Small pirate attack (1 weak ship)
Small pirate attack (1 weak ship)
Small pirate attack (1 weak ship)
Small pirate attack (1 moderate ship)
Small pirate attack (1 moderate ship)
Small pirate attack (1 tough ship)
Medium pirate attack (2 weak ships)
Medium pirate attack (2 weak ships)
Medium pirate attack (2 weak ships)
Medium pirate attack (2 moderate ships)
Medium pirate attack (2 moderate ships)
Medium pirate attack (2 tough ships)
Hard pirate attack (3 weak ships)
Hard pirate attack (3 weak ships)
Hard pirate attack (3 moderate ships)
Hard pirate attack (3 tough ships)
Very hard pirate attack (1 large tough ship + 4 fighters)
Rogue comet crossing path
Meteorite shower
Navy random check
Federal Police random check
Civilian light transport passing close
Civilian medium transport passing close
Civilian light gunship passing close
Civilian medium gunship passing close
Civilian light freighter passing close
Civilian medium freighter passing close
Civilian large freighter passing close
Civilian medium mining ship passing close
Civilian large mining ship passing close
Pirate ship acting as a civilian light transport passing close
Pirate ship acting as a civilian medium transport passing close
Pirate ship acting as a civilian light gunship passing close
Pirate ship acting as a civilian medium gunship passing close
Rogue planet crossing path
Pirate warp disruption trap (medium pirate attack moderate)
Fake distress call (very hard pirate attack)
Real distress call (small pirate attack weak)
Real distress call (moderate pirate attack tough)
Real distress call (escape pod beacon)
Real distress call (disabled transport ship)
Real distress call (disabled navy patrol craft)
Real distress call (disabled civilian transport)
Real distress call (disabled pirate ship)
Crew member has disease
Parasite on crew member" -split "`n"

$twist = "Undercover Alliance Operative
Pirate with moral doubts
Only interested in money
Only interested in slaves
In desperate need of medical aid
In desperate need of drugs
Has 1 hostage aboard from a recent raid
Has 2 hostages aboard from a recent raid
Has 3 hostages aboard from a recent raid
Has 1 slave aboard
Has 2 slaves aboard
Has 3 slaves aboard
Has 4 slaves aboard" -split "`n"

$chanceOfTwist = 5

$returnedEvent = Get-Random -InputObject $list

$twistCheck = Get-Random -Minimum 1 -Maximum 100

if ($twistCheck -le $chanceOfTwist -and $returnedEvent -cmatch "pirate") {
    $returnedTwist = Get-Random -InputObject $twist
    $returnedTwist = " - $returnedTwist"
}

return "$returnedEvent $returnedTwist"

$returnedEvent = $null
$returnedTwist = $null

