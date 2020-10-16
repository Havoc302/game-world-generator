$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

$solar_system_count = 1000000

$binary_percent = 5

Function Make-Star {
    param($total_stars, $current_star_number_id, $star_system_number_id, $class, $luminosity_min, $luminosity_max, $radius_min, $radius_max, $mass_min, $mass_max, $temperature_min, $temperature_max, $chromaticity)
    #Make a star
    $star = @{}
    if ($total_stars -eq 2) {
        $star.BinaryStar = $current_star_number_id
    }
    $star.ID = $star_system_number_id
    $star.Class = $class
    $star.Luminosity = [math]::Round((Get-Random -Minimum $luminosity_min -Maximum $luminosity_max),2)
    $star.Radius = [math]::Round((Get-Random -Minimum $radius_min -Maximum $radius_max),2)
    $star.Mass = [math]::Round((Get-Random -Minimum $mass_min -Maximum $mass_max),2)
    $star.Gravity = [math]::Round(($star.mass*247)/9.807)
    $star.Temperature = [math]::Round((Get-Random -Minimum $temperature_min -Maximum $temperature_max),2)
    $star.Chromaticity = $chromaticity

    #Put star into Star Object
    $star_object = @{}
    $star_object."Star_$current_star_number_id" = $star

    return $star_object
}

Function Create-StarSystem {
    param($Count,$Binary_Chance)

    $star_system_number_id = 0

    [System.Collections.ArrayList]$system = @()

    foreach ($number in 1..$Count) {

        $binary_rndm = Get-Random -Minimum 1 -Maximum 100

        $total_stars = 1

        if ($binary_rndm -le $Binary_Chance) {
            $total_stars = 2
        }

        foreach ($current_star_number_id in 1..$total_stars) {
            $star_rndm = Get-Random -Minimum 1 -Maximum 10000
            if ($star_rndm -le 7645) {
                $star_object = Make-Star -total_stars $total_stars -current_star_number_id $current_star_number_id -star_system_number_id $star_system_number_id `
                -class "M" `
                -luminosity_min 0.01 -luminosity_max 0.08 `
                -radius_min 0.1 -radius_max 0.7 `
                -mass_min 0.08 -mass_max 0.45 `
                -temperature_min 2400 -temperature_max 3700 `
                -chromaticity "Light Orange Red"
            } elseif ($star_rndm -in 7646..8855) {
                $star_object = Make-Star -total_stars $total_stars -current_star_number_id $current_star_number_id -star_system_number_id $star_system_number_id `
                -class "K" `
                -luminosity_min 0.08 -luminosity_max 0.6 `
                -radius_min 0.7 -radius_max 0.96 `
                -mass_min 0.45 -mass_max 0.8 `
                -temperature_min 3700 -temperature_max 5200 `
                -chromaticity "Pale Yellow Orange"
            } elseif ($star_rndm -in 8856..9615) {
                $star_object = Make-Star -total_stars $total_stars -current_star_number_id $current_star_number_id -star_system_number_id $star_system_number_id `
                -class "G" `
                -luminosity_min 0.6 -luminosity_max 1.5 `
                -radius_min 0.96 -radius_max 1.15 `
                -mass_min 0.8 -mass_max 1.04 `
                -temperature_min 5200 -temperature_max 6000 `
                -chromaticity "Yellowish White"
            } elseif ($star_rndm -in 9616..9915) {
                $star_object = Make-Star -total_stars $total_stars -current_star_number_id $current_star_number_id -star_system_number_id $star_system_number_id `
                -class "F" `
                -luminosity_min 1.5 -luminosity_max 5 `
                -radius_min 1.15 -radius_max 1.4 `
                -mass_min 1.04 -mass_max 1.4 `
                -temperature_min 6000 -temperature_max 7500 `
                -chromaticity "White"
            } elseif ($star_rndm -in 9916..9975) {
                $star_object = Make-Star -total_stars $total_stars -current_star_number_id $current_star_number_id -star_system_number_id $star_system_number_id `
                -class "A" `
                -luminosity_min 5 -luminosity_max 25 `
                -radius_min 1.4 -radius_max 1.8 `
                -mass_min 1.4 -mass_max 2.1 `
                -temperature_min 7500 -temperature_max 10000 `
                -chromaticity "Blue White"
            } elseif ($star_rndm -in 9976..9987) {
                $star_object = Make-Star -total_stars $total_stars -current_star_number_id $current_star_number_id -star_system_number_id $star_system_number_id `
                -class "B" `
                -luminosity_min 25 -luminosity_max 30000 `
                -radius_min 1.8 -radius_max 6.6 `
                -mass_min 2.1 -mass_max 16 `
                -temperature_min 10000 -temperature_max 30000 `
                -chromaticity "Deep Blue White"
            } elseif ($star_rndm -in 9988..10000) {
                $star_object = Make-Star -total_stars $total_stars -current_star_number_id $current_star_number_id -star_system_number_id $star_system_number_id `
                -class "O" `
                -luminosity_min 30000 -luminosity_max 500000 `
                -radius_min 6.6 -radius_max 12 `
                -mass_min 16 -mass_max 90 `
                -temperature_min 30000 -temperature_max 60000 `
                -chromaticity "Blue" 
            }
            $system.Add($star_object)
        }
    }
    return $system
}

Function Get-PlanetType {
    param($RandomNumber)

}

$system_output = Create-StarSystem -Count $solar_system_count -Binary_Chance $binary_percent

#ConvertTo-Json $system_output -Compress | Out-File -FilePath C:\Temp\Stars.json

$stopwatch