$system_name = $args[0]

$asteroid_count = $args[1]

$asteroid_type = @("C","S","M") 

$asteroid_shape = @("Rectangular Prism", "Cube", "Spherical", "Cone", "Cyclinder","Potato","Banana","Pear", "Ellipsoid")

$asteroids = @{}

foreach ($i in 1..$asteroid_count) {
    
    $pi = 3.1415926535
    $asteroid_id = Get-Random -Minimum 1000000 -Maximum 9999999
    $asteroid = @{}
    $asteroid.Name = $system_name+'-'+(Get-Random -InputObject $asteroid_type)+'-'+($asteroid_id)
    $asteroid.Composition = "Yes"
    $asteroid.Size = [math]::Round((Get-Random -Minimum 0.5 -Maximum 550),2)
    $asteroid.Volume = [math]::ROUND((4/3) * [math]::PI * [math]::Pow(($asteroid.Size/2), 3),2)
    $asteroid.Mass = [math]::ROUND(2*($asteroid.Volume*1000),2)
    $asteroid.Shape = Get-Random -InputObject $asteroid_shape
    $asteroid.Rotation_rate = Get-Random -Minimum 1 -Maximum 10
    $asteroids.add($asteroid)
}

#$asteroids = ConvertTo-Json $asteroids

return $asteroids