# This generator creates cities and towns on planetary bodies
$planet = $args[0]

$scale = $args[1]

Function Get-CityName {
    $rnd_cityid = Get-Random -Minimum 1 -Maximum 24152
    $city = Invoke-RestMethod -uri "http://geodb-free-service.wirefreethought.com/v1/geo/cities?limit=1&offset=$rnd_cityid&hateoasMode=off"
    return $city.data.city
}

Function Generate-City {
    param ($Scale,$Planet)

    switch ($Scale)
    {
        Small {$x = 1000,10000;
            $city_name = Get-CityName    
        }
        Medium {$x= 10001,100000
            $city_name = Get-CityName
        }
        Large {$x= 100001,1000000;
            $city_name = Get-CityName
        }
        Sub-Capital {$x= 1000001,10000000;
            $city_name = Get-CityName
        }
        Capital {$x= 10000001,50000000;
            $city_name = Get-CityName
        }
    }

    $min = $x[0]
    $max = $x[1]
    $population = Get-Random -Minimum $min -Maximum $max
    return $city_name,$planet,$population
}


$created_city = Generate-City -Scale $scale -Planet $planet

return $created_city