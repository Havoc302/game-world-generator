# This generator creates criminal outposts

$amount = $args[0]
$location = $args[1]
$scale = $args[2]

$homePath = 'G:\Colonial_Alliance_Game'

$bases = @{}

foreach ($b in 1..$amount) {
    
    $base = @{}

    if ($scale -eq $null) {$scale = Get-Random "Small","Small","Small","Small","Small","Small","Small","Small","Medium","Medium","Medium","Medium","Large"}

    switch ($Scale) 
    {
        Small {$x = 5,30;
            $crimOrg = & 'G:\Colonial_Alliance_Game\game-world-generator\powershell-version\generator-random-criminal-organisation.ps1' 1 "Small"
            $base.Owner = $crimOrg.Values.Name
            $base.Activities = $crimOrg.Values.Activities
            $base.Population = $crimOrg.Values.MemberCount
            $base.Location = $location
        }
        Medium {$x= 15,100;
            $crimOrg = & 'G:\Colonial_Alliance_Game\game-world-generator\powershell-version\generator-random-criminal-organisation.ps1' 1 "Medium"
            $base.Owner = $crimOrg.Values.Name
            $base.Activities = $crimOrg.Values.Activities
            $base.Population = $crimOrg.Values.MemberCount
            $base.Location = $location
        }
        Large {$x= 300,800;
            $crimOrg = & 'G:\Colonial_Alliance_Game\game-world-generator\powershell-version\generator-random-criminal-organisation.ps1' 1 "Large"
            $base.Owner = $crimOrg.Values.Name
            $base.Activities = $crimOrg.Values.Activities
            $base.Population = $crimOrg.Values.MemberCount
            $base.Location = $location
        }
        Conglomerate {$x= 801,2500;
            $crimOrg = & 'G:\Colonial_Alliance_Game\game-world-generator\powershell-version\generator-random-criminal-organisation.ps1' 1 "Conglomerate"
            $base.Owner = $crimOrg.Values.Name
            $base.Activities = $crimOrg.Values.Activities
            $base.Population = $crimOrg.Values.MemberCount
            $base.Location = $location
        }
    }

    $population = Get-Random -Minimum $($x[0]) -Maximum $($x[1])
    
    $bases.Add($base.Owner,$base)
}

$bases