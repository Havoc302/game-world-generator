# This generator creates military outposts

$amount = $args[0]
$location = $args[1]
$scale = $args[2]

$homePath = 'G:\Colonial_Alliance_Game'

$bases = @{}

foreach ($c in 1..$amount) {
    
    $base = @{}

    if ($scale -eq $null) {$scale = Get-Random "Small","Small","Small","Small","Small","Small","Small","Small","Medium","Medium","Medium","Medium","Large"}

    do {
        $name = (& "G:\Colonial_Alliance_Game\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
    } until ($name -notmatch "\?")
    $name = (Get-Culture).TextInfo.ToTitleCase($name)

    switch ($Scale) 
    {
        Small {$x = 5,100;
            $baseType = Get-Random -InputObject ("Reconnaisance Outpost","Aid Station","Observation Outpost","Marine Support Outpost","Fleet Support Outpost")
            if (($location -imatch "planet*") -or ($location -imatch "moon*")) {
                $baseOrb = " Orbital"
            }
            $baseName = $name + $baseOrb + " " + $baseType
        }
        Medium {$x= 101,1001;
            $baseType = Get-Random -InputObject ("Forward Airbase","Marine Training Barracks","Fleet Ground Firing Range")
            if (($location -imatch "planet*") -or ($location -imatch "moon*")) {
                $baseOrb = " Orbital"
            }
            $baseName = $name + $baseOrb + " " + $baseType
        }
        Large {$x= 1001,10000;
            $baseType = Get-Random -InputObject ("Airbase","Marine Base","Fleet Yard")
            if (($location -imatch "planet*") -or ($location -imatch "moon*")) {
                $baseOrb = " Orbital"
            }
            $baseName = $name + $baseOrb + " " + $baseType
        }
    }

    $base.Name = $baseName
    $population = Get-Random -Minimum $($x[0]) -Maximum $($x[1])
    $base.Population = $population
    $base.Location = $location
    
    $bases.Add($base.Name,$base)
}

$bases