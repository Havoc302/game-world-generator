# This generator creates cities and towns on planetary bodies
$planet = $args[0]

$scale = $args[1]

Function Get-CityName {
    $name = Invoke-RestMethod -Uri api.namefake.com/random | Select-Object -ExpandProperty maiden_name
    return $name
}

Function Generate-City {
    param ($Scale,$Planet)

    switch ($Scale) 
    {
        Small {$x = 10,100;
            $base_name = Get-CityName   
            $base_type = Get-Random -InputObject ("Reconnaisance Outpost","Aid Station","Observation Outpost","Marine Support Outpost","Fleet Support Outpost")
        }
        Medium {$x= 101,1001;
            $base_name = Get-CityName
            $base_type = Get-Random -InputObject ("Forward Airbase","Marine Training Base","Fleet Ground Firing Range","")
        }
        Large {$x= 100001,1000000;
            $base_name = Get-CityName
        }
    }

    $min = $x[0]
    $max = $x[1]
    $population = Get-Random -Minimum $min -Maximum $max
    return $city_name,$planet,$population
}

$created_city = Generate-City -Scale $scale -Planet $planet

return $created_city