$config_path = $pscommandpath | Split-Path -Parent
$solar_system_count = Get-Content -Path $config_path\master-config.cfg

$binary_percent = 5

$solar_systems = @()

Function Get-StarType {
    param($Count,$Binary_Chance)

    $id_count = 0

    $system = @{}

    foreach ($number in 1..$Count) {

        $id_count++

        $binary_rndm = Get-Random -Minimum 1 -Maximum 100

        $star_count = 1

        if ($binary_rndm -le $Binary_Chance) {
            $star_count = 2
        }

        foreach ($binary_count in 1..$star_count) {
            $star_object = @{}
            $star_rndm = Get-Random -Minimum 1 -Maximum 10000
            if ($star_rndm -le 7645) {
                $star_object."Star_$binary_count" = @{}
                if ($star_count -eq 2) {
                    $star_object."Star_$binary_count".BinaryStar = $binary_count
                }
                $star_object."Star_$binary_count".ID = $id_count
                $star_object."Star_$binary_count".Class = "M"
                $star_object."Star_$binary_count".Luminosity = [math]::Round((Get-Random -Minimum 0.01 -Maximum 0.08),2)
                $star_object."Star_$binary_count".Radius = [math]::Round((Get-Random -Minimum 0.1 -Maximum 0.7),2)
                $star_object."Star_$binary_count".Mass = [math]::Round((Get-Random -Minimum 0.08 -Maximum 0.45),2)
                $star_object."Star_$binary_count".Temperature = [math]::Round((Get-Random -Minimum 2400 -Maximum 3700),2)
                $star_object."Star_$binary_count".Chromaticity = "Light Orange Red"
            } elseif ($star_rndm -in 7646..8855) {
                $star_object."Star_$binary_count" = @{}
                if ($star_count -eq 2) {
                    $star_object."Star_$binary_count".BinaryStar = $binary_count
                }
                $star_object."Star_$binary_count".ID = $id_count
                $star_object."Star_$binary_count".Class = "K"
                $star_object."Star_$binary_count".Luminosity = [math]::Round((Get-Random -Minimum 0.08 -Maximum 0.6),2)
                $star_object."Star_$binary_count".Radius = [math]::Round((Get-Random -Minimum 0.7 -Maximum 096),2)
                $star_object."Star_$binary_count".Mass = [math]::Round((Get-Random -Minimum 0.45 -Maximum 0.8),2)
                $star_object."Star_$binary_count".Temperature = [math]::Round((Get-Random -Minimum 3700 -Maximum 5200),2)
                $star_object."Star_$binary_count".Chromaticity = "Pale Yellow Orange"
            } elseif ($star_rndm -in 8856..9615) {
                $star_object."Star_$binary_count" = @{}
                if ($star_count -eq 2) {
                    $star_object."Star_$binary_count".BinaryStar = $binary_count
                }
                $star_object."Star_$binary_count".ID = $id_count
                $star_object."Star_$binary_count".Class = "G"
                $star_object."Star_$binary_count".Luminosity = [math]::Round((Get-Random -Minimum 0.6 -Maximum 1.5),2)
                $star_object."Star_$binary_count".Radius = [math]::Round((Get-Random -Minimum 0.96 -Maximum 1.15),2)
                $star_object."Star_$binary_count".Mass = [math]::Round((Get-Random -Minimum 0.8 -Maximum 1.04),2)
                $star_object."Star_$binary_count".Temperature = [math]::Round((Get-Random -Minimum 5200 -Maximum 6000),2)
                $star_object."Star_$binary_count".Chromaticity = "Yellowish White"
            } elseif ($star_rndm -in 9616..9915) {
                $star_object."Star_$binary_count" = @{}
                if ($star_count -eq 2) {
                    $star_object."Star_$binary_count".BinaryStar = $binary_count
                }
                $star_object."Star_$binary_count".ID = $id_count
                $star_object."Star_$binary_count".Class = "F"
                $star_object."Star_$binary_count".Luminosity = [math]::Round((Get-Random -Minimum 1.5 -Maximum 5),2)
                $star_object."Star_$binary_count".Radius = [math]::Round((Get-Random -Minimum 1.15 -Maximum 1.4),2)
                $star_object."Star_$binary_count".Mass = [math]::Round((Get-Random -Minimum 1.04 -Maximum 1.4),2)
                $star_object."Star_$binary_count".Temperature = [math]::Round((Get-Random -Minimum 6000 -Maximum 7500),2)
                $star_object."Star_$binary_count".Chromaticity = "White"
            } elseif ($star_rndm -in 9916..9975) {
                $star_object."Star_$binary_count" = @{}
                if ($star_count -eq 2) {
                    $star_object."Star_$binary_count".BinaryStar = $binary_count
                }
                $star_object."Star_$binary_count".ID = $id_count
                $star_object."Star_$binary_count".Class = "A"
                $star_object."Star_$binary_count".Luminosity = [math]::Round((Get-Random -Minimum 5 -Maximum 25),2)
                $star_object."Star_$binary_count".Radius = [math]::Round((Get-Random -Minimum 1.4 -Maximum 1.8),2)
                $star_object."Star_$binary_count".Mass = [math]::Round((Get-Random -Minimum 1.4 -Maximum 2.1),2)
                $star_object."Star_$binary_count".Temperature = [math]::Round((Get-Random -Minimum 7500 -Maximum 10000),2)
                $star_object."Star_$binary_count".Chromaticity = "Blue White"
            } elseif ($star_rndm -in 9976..9998) {
                $star_object."Star_$binary_count" = @{}
                if ($star_count -eq 2) {
                    $star_object."Star_$binary_count".BinaryStar = $binary_count
                }
                $star_object."Star_$binary_count".ID = $id_count
                $star_object."Star_$binary_count".Class = "B"
                $star_object."Star_$binary_count".Luminosity = [math]::Round((Get-Random -Minimum 25 -Maximum 30000),2)
                $star_object."Star_$binary_count".Radius = [math]::Round((Get-Random -Minimum 1.8 -Maximum 6.6),2)
                $star_object."Star_$binary_count".Mass = [math]::Round((Get-Random -Minimum 2.1 -Maximum 16),2)
                $star_object."Star_$binary_count".Temperature = [math]::Round((Get-Random -Minimum 10000 -Maximum 30000),2)
                $star_object."Star_$binary_count".Chromaticity = "Deep Blue White"
            } elseif ($star_rndm -in 9999..10000) {
                $star_object."Star_$binary_count" = @{}
                if ($star_count -eq 2) {
                    $star_object."Star_$binary_count".BinaryStar = $binary_count
                }
                $star_object."Star_$binary_count".ID = $id_count
                $star_object."Star_$binary_count".Class = "O"
                $star_object."Star_$binary_count".Luminosity = [math]::Round((Get-Random -Minimum 30000 -Maximum 500000),2)
                $star_object."Star_$binary_count".Radius = [math]::Round((Get-Random -Minimum 6.6 -Maximum 12),2)
                $star_object."Star_$binary_count".Mass = [math]::Round((Get-Random -Minimum 16 -Maximum 90),2)
                $star_object."Star_$binary_count".Temperature = [math]::Round((Get-Random -Minimum 30000 -Maximum 60000),2)
                $star_object."Star_$binary_count".Chromaticity = "Blue"
            }
            $system."System_$id_count" += $star_object
        }
    }
return $system
}


Function Get-PlanetType {
    param($RandomNumber)
}

$system_output = Get-StarType -Count $solar_system_count -Binary_Chance $binary_percent

#ConvertTo-Json $solar_systems | Out-File -FilePath C:\Temp\Stars.json

$system_output

