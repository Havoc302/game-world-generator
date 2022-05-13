# Random organised crime generator

$count = $args[0]

$size = $args[1]

$criminalOrgs = @{}

if ($count -eq $null) {
    $count = 1
}

foreach ($n in 1..$count) {

$org = @{}

$orgName2Array = "Cartel
Organisation
Army
Family
Company
Crew
Gang
Clan
Forum
Connection
Commandos
Incorporated
Nation" -split "`n"

if ($size -eq $null) {
    $size = Get-Random -InputObject "Small","Small","Small","Small","Small","Small","Small","Small","Medium","Medium","Medium","Medium","Large","Large","Conglomerate"
}

switch ($size) {
    small {$orgTypeArray = "Criminal - Local - Small - Street,Criminal - Planetary - Small - Compartmentalised,Criminal - Planetary - Small - Family,Criminal - Planetary - Small - Pseudo-Corporate,Criminal - Planetary - Small - Rebellion,Criminal - Interstellar - Small - Compartmentalised,Criminal - Interstellar - Small - Family,Criminal - Interstellar - Small - Pseudo-Corporate,Criminal - Interstellar - Small - Rebellion" -split","}
    medium {$orgTypeArray = "Criminal - Local - Medium - Street,Criminal - Planetary - Medium - Compartmentalised,Criminal - Planetary - Medium - Family,Criminal - Planetary - Medium - Pseudo-Corporate,Criminal - Planetary - Medium - Rebellion,Criminal - Interstellar - Medium - Compartmentalised,Criminal - Interstellar - Medium - Family,Criminal - Interstellar - Medium - Pseudo-Corporate,Criminal - Interstellar - Medium - Rebellion" -split","}
    large {$orgTypeArray = "Criminal - Local - Large - Street,Criminal - Planetary - Large - Compartmentalised,Criminal - Planetary - Large - Family,Criminal - Planetary - Large - Pseudo-Corporate,Criminal - Planetary - Large - Rebellion,Criminal - Interstellar - Large - Compartmentalised,Criminal - Interstellar - Large - Family,Criminal - Interstellar - Large - Pseudo-Corporate,Criminal - Interstellar - Large - Rebellion" -split","}
    conglomerate {$orgTypeArray = "Criminal - Interstellar - Conglomerate - Compartmentalised,Criminal - Interstellar - Conglomerate - Family,Criminal - Interstellar - Conglomerate - Pseudo-Corporate,Criminal - Interstellar - Conglomerate - Rebellion" -split","}
}

$criminalActivity = "Slavery,Sex Slavery,Illegal Immigration,Identity Forgery,Sale of Illegal Items,Safe Houses,Illegal Holopornography,Drug Production,Drug Distribution,Drug Production and Distribution,Theft,Piracy,Protection Racket,Extortion,Assassination,Tax Evasion,Counterfeiting,Cyberwarfare,Copyright Infringement,Computer Viruses,Political Corruption,Biowarfare" -split ","

$rebellionActivity = "Terrorism,Arson,Piracy,Cyberwarfare,Computer Viruses,Political Corruption,Biowarfare,Terrorial Control,Assassination" -split ","

$orgList =  (Get-Random -Minimum 1 -Maximum 3) | where {$_ -le 1}

if ($orgList -eq 1) {
$orgName1 = "The Demon Blooddrop Company
The Ebony Hog Syndicate
The Violet Knife Gang
The Brass Alligator Company
The Violet Horns
The Blue Tigers
The Fangs
The Brown Bloods
The Hopeless
The Women Of Limbo
The Electric Pistol Association
The Cardinal Pygmy Company
The Onyx Hand Posse
The Green Mammoth Gang
The Cardinal Bats
The Copper Horns
The Copper Sharks
The Demon Mambas
The Anonymous
The Voiceless Ones
The Yellow Forsaken Posse
The Jade Viper Gang
The Sanguine Needle Association
Brown Jackal Riders
Ebony Roses
Bronze Warthogs
Forever" -split "`n" -replace "`r"

$org.Name = Get-Random -InputObject $orgName1

} else {

    $orgName1 = $name = (& "G:\Colonial_Alliance_Game\game-world-generator\powershell-version\translate-string.ps1" (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name.last) | Select-Object -First 1
    
    $orgName2 = Get-Random -InputObject $orgName2Array

    $org.Name = ("$orgName1 $orgName2").Trim()
}

    $org.Type = Get-Random -InputObject $orgTypeArray

    if (($org.Type) -match "Small") {
        $memberCount = Get-Random -Minimum 5 -Maximum 30
        $activityMax = 3
    } elseif ($org.Type -match "Medium") {
        $memberCount = Get-Random -Minimum 31 -Maximum 1000
        $activityMax = 4
    } elseif ($org.Type -match "Large") {
        $memberCount = Get-Random -Minimum 1001 -Maximum 10000
        $activityMax = 5
    }  elseif ($org.Type -match "Conglomerate") {
        $memberCount = Get-Random -Minimum 10001 -Maximum 50000
        $activityMax = 7
    }

    $org.MemberCount = $memberCount

    if (($org.Name) -match "Rebellion") {
        $activityCount = (Get-Random -Minimum 1 -Maximum $activityMax)
        $activities = Get-Random $criminalActivity -Count $activityCount
        $activities += Get-Random $rebellionActivity -Count 2
    } else {
        $activityCount = (Get-Random -Minimum 1 -Maximum $activityMax)
        $activities = Get-Random $criminalActivity -Count $activityCount
    }

    $org.Activities = $activities

    $criminalOrgs.Add($org.Name,$org)
}

$criminalOrgs