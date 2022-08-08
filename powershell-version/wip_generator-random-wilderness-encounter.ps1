# Random event generator

$list = "Ship engine failure
Ship sensors failure
Ship warp drive failure
Ship airlock failure
Ship window failure
Ship panel failure
Ship sublight drive failure
Ship faulty failure sensor
Ship invalid sensor signature
Ship incorrect navigation calculation
Ship gravity sensor failure
Ship diagnostic system failure
Ship decoy system failure
Ship ECM system failure
Ship weapons system failure
Ship shields system failure
Ship communications failure
Ship engine failure
Ship sensors failure
Ship warp drive failure
Ship airlock failure
Ship window failure
Ship panel failure
Ship sublight drive failure
Ship faulty failure sensor
Ship invalid sensor signature
Ship incorrect navigation calculation
Ship gravity sensor failure
Ship diagnostic system failure
Ship decoy system failure
Ship ECM system failure
Ship weapons system failure
Ship shields system failure
Ship communications failure
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
Civilian large freigher passing close
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
Real distress call (disabled pirate ship)"

$list = $list -split "`n"

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
Has 4 slaves aboard"

$twist = $twist -split "`n"

$chanceOfTwist = 5

$returnedEvent = Get-Random -InputObject $list

$twistCheck = Get-Random -Minimum 1 -Maximum 100

if ($twistCheck -le $chanceOfTwist -and $returnedEvent -cmatch "pirate") {
    $returnedTwist = Get-Random -InputObject $twist
    $returnedTwist = " - $returnedTwist"
}

$returnedEvent + $returnedTwist

$returnedEvent = $null
$returnedTwist = $null