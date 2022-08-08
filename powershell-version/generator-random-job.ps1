$homePath = 'G:\Colonial_Alliance_Game'

$count = 20

$jobList = "Cargo Transport Small - Dangerous - Volatile Material - Air Risk - 1 - 5 - 0.3 - 500,
Cargo Transport Medium - Dangerous - Volatile Material - Air Risk - 6 - 20 - 0.3 - 500,
Cargo Transport Large - Dangerous - Volatile Material - Air Risk - 21 - 100 - 0.3 - 500,
Cargo Transport Very Large - Dangerous - Volatile Material - Air Risk - 101 - 1000 - 0.3 - 500,

Cargo Transport Small - Dangerous - Volatile Material - Water Risk - 1 - 5 - 1.87 - 250,
Cargo Transport Medium - Dangerous - Volatile Material - Water Risk - 6 - 20 - 1.87 - 250,
Cargo Transport Large - Dangerous - Volatile Material - Water Risk - 21 - 100 - 1.87 - 250,
Cargo Transport Very Large - Dangerous - Volatile Material - Water Risk - 101 - 1000 - 1.87 - 250,

Cargo Transport Small - Dangerous - Volatile Material - Biological Risk - 1 - 5 - 1 - 400,
Cargo Transport Medium - Dangerous - Volatile Material - Biological Risk - 6 - 20 - 1 - 400,
Cargo Transport Large - Dangerous - Volatile Material - Biological Risk - 21 - 100 - 1 - 400,
Cargo Transport Very Large - Dangerous - Volatile Material - Biological Risk - 101 - 1000 - 1 - 400,

Cargo Transport Small - Dangerous - Volatile Material - Creature Risk - 0.3 - 0.5 - 0.5 - 200,
Cargo Transport Medium - Dangerous - Volatile Material - Creature Risk - 1.6 - 5 - 0.5 - 200,
Cargo Transport Large - Dangerous - Volatile Material - Creature Risk - 21 - 100 - 0.5 - 200,
Cargo Transport Very Large - Dangerous - Volatile Material - Creature Risk - 101 - 1000 - 0.5 - 200,

Cargo Transport Small - Dangerous - Volatile Material - Movement Risk - 1 - 5 - 1.75 - 1000,
Cargo Transport Medium - Dangerous - Volatile Material - Movement Risk - 6 - 20 - 1.75 - 1000,
Cargo Transport Large - Dangerous - Volatile Material - Movement Risk - 21 - 100 - 1.75 - 1000,
Cargo Transport Very Large - Dangerous - Volatile Material - Movement Risk - 101 - 1000 - 1.75 - 1000,

Cargo Transport Small - Fragile - Medical Samples - Contamination Risk - 1 - 5 - 1.2 - 150,
Cargo Transport Medium - Fragile - Medical Samples - Contamination Risk - 6 - 20 - 1.2 - 150,
Cargo Transport Large - Fragile - Medical Samples - Contamination Risk - 21 - 100 - 1.2 - 150,
Cargo Transport Very Large - Fragile - Medical Samples - Contamination Risk - 101 - 1000 - 1.2 - 150,

Cargo Transport Small - Fragile - Components - Movement Risk - 1 - 2.5 - 7 - 300,
Cargo Transport Medium - Fragile - Components - Movement Risk - 6 - 20 - 7 - 300,
Cargo Transport Large - Fragile - Components - Movement Risk - 21 - 100 - 7 - 300,
Cargo Transport Very Large - Fragile - Components - Movement Risk - 101 - 1000 - 7 - 300,

Cargo Transport Small - Risky - Weapons - Legal Risk - 1 - 5 - 1.9 - 500,
Cargo Transport Medium - Risky - Weapons - Legal Risk - 6 - 20 - 1.9 - 500,
Cargo Transport Large - Risky - Weapons - Legal Risk - 21 - 100 - 1.9 - 500,
Cargo Transport Very Large - Risky - Weapons - Legal Risk - 101 - 1000 - 1.9 - 500,

Cargo Transport Small - Risky - Drugs - Legal Risk - 1 - 5 - 2.8 - 3000,
Cargo Transport Medium - Risky - Drugs - Legal Risk - 6 - 20 - 2.8 - 3000,
Cargo Transport Large - Risky - Drugs - Legal Risk - 21 - 100 - 2.8 - 3000,
Cargo Transport Very Large - Risky - Drugs - Legal Risk - 101 - 1000 - 2.8 - 3000,

Cargo Transport Small - Risky - Personnel - Legal Immigration Risk - 1 - 5 - 1 - 1000,
Cargo Transport Medium - Risky - Personnel - Legal Immigration Risk - 6 - 20 - 1 - 1000,
Cargo Transport Large - Risky - Personnel - Legal Immigration Risk - 21 - 100 - 1 - 1000,
Cargo Transport Very Large - Risky - Personnel - Legal Immigration Risk - 101 - 1000 - 1 - 1000,

Cargo Transport Small - Risky - Personnel In Stasis - Legal Immigration Risk - 1 - 5 - 1.5 - 1000,
Cargo Transport Medium - Risky - Personnel In Stasis - Legal Immigration Risk - 6 - 20 - 1.5 - 1000,
Cargo Transport Large - Risky - Personnel In Stasis - Legal Immigration Risk - 21 - 100 - 1.5 - 1000,
Cargo Transport Very Large - Risky - Personnel In Stasis - Legal Immigration Risk - 101 - 1000 - 1.5 - 1000,

Cargo Transport Small - Safe - Materials - No Risk - 1 - 5 - 10 - 100,
Cargo Transport Medium - Safe - Materials - No Risk - 6 - 20 - 10 - 100,
Cargo Transport Large - Safe - Materials - No Risk - 21 - 100 - 10 - 100,
Cargo Transport Very Large - Safe - Materials - No Risk - 101 - 1000 - 10 - 100,

Cargo Transport Small - Safe - Medical Materials - No Risk - 1 - 5 - 3 - 150,
Cargo Transport Medium - Safe - Medical Materials - No Risk - 6 - 20 - 3 - 150,
Cargo Transport Large - Safe - Medical Materials - No Risk - 21 - 100 - 3 - 150,
Cargo Transport Very Large - Safe - Medical Materials - No Risk - 101 - 1000 - 3 - 150,

Cargo Transport Small - Safe - Animal Transport - No Risk - 0.3 - 1.5 - 0.5 - 100,
Cargo Transport Medium - Safe - Animal Transport - No Risk - 1.6 - 5 - 0.5 - 100,
Cargo Transport Large - Safe - Animal Transport - No Risk - 21 - 100 - 0.5 - 100,
Cargo Transport Very Large - Safe - Animal Transport - No Risk - 101 - 1000 - 0.5 - 100,

Cargo Transport Small - Safe - Medical Samples - No Risk - 1 - 5 - 1.8 - 200,
Cargo Transport Medium - Safe - Medical Samples - No Risk - 6 - 20 - 1.8 - 200,
Cargo Transport Large - Safe - Medical Samples - No Risk - 21 - 100 - 1.8 - 200,
Cargo Transport Very Large - Safe - Medical Samples - No Risk - 101 - 1000 - 1.8 - 200,

Cargo Transport Small - Safe - Components - No Risk - 1 - 4 - 6 - 250,
Cargo Transport Medium - Safe - Components - No Risk - 6 - 20 - 6 - 250,
Cargo Transport Large - Safe - Components - No Risk - 21 - 100 - 6 - 250,
Cargo Transport Very Large - Safe - Components - No Risk - 101 - 1000 - 6 - 250,

Cargo Transport Small - Safe - Weapons - No Risk - 1 - 5 - 1.9 - 200,
Cargo Transport Medium - Safe - Weapons - No Risk - 6 - 20 - 1.9 - 200,
Cargo Transport Large - Safe - Weapons - No Risk - 21 - 100 - 1.9 - 200,
Cargo Transport Very Large - Safe - Weapons - No Risk - 101 - 1000 - 1.9 - 200,

Cargo Transport Small - Safe - Medical Pharmaceuticals - No Risk - 1 - 5 - 2.8 - 200,
Cargo Transport Medium - Safe - Medical Pharmaceuticals - No Risk - 6 - 20 - 2.8 - 200,
Cargo Transport Large - Safe - Medical Pharmaceuticals - No Risk - 21 - 100 - 2.8 - 200,
Cargo Transport Very Large - Safe - Medical Pharmaceuticals - No Risk - 101 - 1000 - 2.8 - 200,

Cargo Transport Small - Safe - Personnel - No Risk - 1 - 5 - 1 - 300,
Cargo Transport Medium - Safe - Personnel - No Risk - 6 - 20 - 1 - 300,
Cargo Transport Large - Safe - Personnel - No Risk - 21 - 100 - 1 - 300,
Cargo Transport Very Large - Safe - Personnel - No Risk - 101 - 1000 - 1 - 300,

Cargo Transport Small - Safe - Personnel In Stasis - No Risk - 1 - 5 - 1.5 - 400,
Cargo Transport Medium - Safe - Personnel In Stasis - No Risk - 6 - 20 - 1.5 - 400,
Cargo Transport Large - Safe - Personnel In Stasis - No Risk - 21 - 100 - 1.5 - 400,
Cargo Transport Very Large - Safe - Personnel In Stasis - No Risk - 101 - 1000 - 1.5 - 400,

Bounty Contract Easy - Risky - Assault Charge - Low Risk - 3 - 3.1 - 1 - 300,
Bounty Contract Easy - Risky - Arson Charges - Low Risk - 3 - 3.1 - 1 - 750,
Bounty Contract Easy - Risky - Drug Trafficking Charges - Low Risk - 3 - 3.1 - 1 - 1500,
Bounty Contract Easy - Risky - Theft Charges - Low Risk - 3 - 3.1 - 1 - 300,
Bounty Contract Easy - Risky - Embezzlement Charges - Low Risk - 3 - 3.1 - 1 - 3000,
Bounty Contract Medium - Risky - Armed Assault Charges - Medium Risk - 3 - 3.1 - 1 - 600,
Bounty Contract Medium - Risky - Arson Charges - Medium Risk - 3 - 3.1 - 1 - 1500,
Bounty Contract Medium - Drug Trafficking Risky - Charges - Medium Risk - 3 - 3.1 - 1 - 3000,
Bounty Contract Medium - Risky - Drug Manufacturing Charges - Medium Risk - 3 - 3.1 - 1 - 8000,
Bounty Contract Medium - Risky - Theft Charges - Medium Risk - 3 - 3.1 - 1 - 600,
Bounty Contract Medium - Risky - Embezzlement Charges - Medium Risk - 3 - 3.1 - 1 - 6000,
Bounty Contract Medium - Risky - People Smuggling Charges - Medium Risk - 3 - 3.1 - 1 - 4000,
Bounty Contract Medium - Risky - Sex Trafficking Charges - Medium Risk - 3 - 3.1 - 1 - 10000,
Bounty Contract Medium - Risky - Prostitution Charges - Medium Risk - 3 - 3.1 - 1 - 6000,
Bounty Contract Medium - Risky - Sexual Assault Charges - Medium Risk - 3 - 3.1 - 1 - 5000,
Bounty Contract Hard - Risky - Armed Assault Charges - High Risk - 3 - 3.1 - 1 - 1200,
Bounty Contract Hard - Risky - Arson Charges - High Risk - 3 - 3.1 - 1 - 3000,
Bounty Contract Hard - Risky - Drug Trafficking Charges - High Risk - 3 - 3.1 - 1 - 6000,
Bounty Contract Hard - Risky - Drug Manufacturing Charges - High Risk - 3 - 3.1 - 1 - 16000,
Bounty Contract Hard - Risky - Theft Charges - High Risk - 3 - 3.1 - 1 - 1200,
Bounty Contract Hard - Risky - Embezzlement Charges - High Risk - 3 - 3.1 - 1 - 12000,
Bounty Contract Hard - Risky - People Smuggling Charges - High Risk - 3 - 3.1 - 1 - 8000,
Bounty Contract Hard - Risky - Sex Trafficking Charges - High Risk - 3 - 3.1 - 1 - 20000,
Bounty Contract Hard - Risky - Prostitution Charges - High Risk - 3 - 3.1 - 1 - 12000,
Bounty Contract Hard - Risky - Underage Prostitution Charges - High Risk - 3 - 3.1 - 1 - 35000,
Bounty Contract Hard - Risky - Sexual Assault Charges - High Risk - 3 - 3.1 - 1 - 10000,

Ship Escort Low Risk - Risky - Escorting a Personnel Transport - Low Risk - 1 - 1.1 - 1 - 500,
Ship Escort Medium Risk - Risky - Escorting a Personnel Transport - Medium Risk - 1 - 1.1 - 1 - 1000,
Ship Escort Low Risk - Risky - Escorting a Cargo Transport - Low Risk - 1 - 1.1 - 1 - 400,
Ship Escort Medium Risk - Risky - Escorting a Cargo Transport - Medium Risk - 1 - 1.1 - 1 - 800,
Ship Escort High Risk - Dangerous - Escorting a Cargo Transport - High Risk - 1 - 1.1 - 1 - 1600,

Anti Piracy Patrol - Risky - Trade Lane Patrol - Low Risk - 1 - 1.1 - 1 - 500,
Anti Piracy Patrol - Risky - Solar System Patrol - Medium Risk - 1 - 1.1 - 1 - 1000,
Anti Piracy Patrol - Dangerous - Moons Asteroids and System Edge Patrol - High Risk - 1 - 1.1 - 1 - 2000
" -split ","


Function Get-Job {
    $job = Get-Random -InputObject $jobList

    $jobArray = $job -split "-"

    if ($jobArray[0] -match "Bounty" -or $jobArray[0] -match "Personnel In Stasis") {
        $target = (& "$homePath\game-world-generator\powershell-version\generator-random-character.ps1")
        $target
        [string]$targetName = $target.Name
        $jobArray[0] = "$($jobArray[0])"+"- $targetName"
    }

    $jobObj = @{}
    $jobObj.JobType = $jobArray[0].Trim()
    $jobObj.RiskLevel = $jobArray[1].Trim()
    $jobObj.CargoType = $jobArray[2].Trim()
    $jobObj.RiskType = $jobArray[3].Trim()
    $jobObj.Volume = [math]::ROUND((Get-Random -Minimum $($jobArray[4]) -Maximum $($jobArray[5])),2)
    [int]$jobPrice = (($jobArray[7]).Trim())
    $jobObj.DaysTravel = [math]::ROUND((Get-Random -Minimum 0.1 -Maximum 4),2)
    $jobObj.Price = [math]::ROUND(($jobPrice*($jobObj.Volume)*($jobObj.DaysTravel*0.5)/100)*100)
    [int]$jobDensity = ($jobArray[6]).Trim()
    $jobObj.Mass = ($jobDensity*(($jobObj.Volume*1000000)/1000)) #not working correctly
    $jobObj
}

$count = Get-Random -Minimum ($count/2) -Maximum ($count*2)

foreach ($n in 1..$count) {
    Get-Job
    Write-Host "`n"
}
