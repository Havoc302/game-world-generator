$ageRange = $args[0]

$IQRange = $args[1]

$surname = $args[2]

$skillPoints = $args[3]

$homePath = 'G:\Colonial_Alliance_Game'

Function Generate-SkillLevel {
    param(
        [Parameter(Mandatory=$false,ParameterSetName="Person Type")][ValidateSet("Expert","Highly Skilled","Average","Low Skilled")]$personType
    )

    if (![string]$personType) {
        $personType = Get-Random ("Expert","Highly Skilled","Highly Skilled","Highly Skilled","Average","Average","Average","Average","Average","Low Skilled")
    }

    switch ($personType) {
        "Expert" {($skillMax = 17),($skillTotal = 100)}
        "Highly Skilled" {($skillMax = 15),($skillTotal = 75)}
        "Average" {($skillMax = 13),($skillTotal = 50)}
        "Low Skilled" {($skillMax = 11),($skillTotal = 25)}
    }
}

Function Generate-StatBlock {
    $skillData = Generate-SkillLevel

    $skillMax = $skillData[0]+1
    $skillPoints = $skillData[1]

    $baseStatList= @{}
    $baseStatList.Add("Stat_Strength",(0,1))
    $baseStatList.Add("Stat_Dexterity",(0,3))
    $baseStatList.Add("Stat_Constitution",(0,2))
    $baseStatList.Add("Stat_Body",(0,2))
    $baseStatList.Add("Stat_Intelligence",(0,1))
    $baseStatList.Add("Stat_Tech",(0,2))
    $baseStatList.Add("Stat_Ego",(0,1))
    $baseStatList.Add("Stat_Presence",(0,1))
    $baseStatList.Add("Stat_Comeliness",(0,0.5))

    $baseStatListFinal = @{}

    foreach ($stat in $($baseStatList.keys)) {
        $value = Get-Random -Minimum 8 -Maximum $skillMax
        $rate = $baseStatList[$stat][1]
        $cost = ($value-10)*$rate
        $skillPoints = $skillPoints-$cost
        $baseStatList[$stat][0] = $value
        $baseStatListFinal.Add($stat,$value)
    }

    $skillList = @{}
    $skillList.Add("Skill_Acrobatics",$($baseStatList.Stat_Dexterity[0],0))
    $skillList.Add("Skill_Acting",$($baseStatList.Stat_Presence[0],0))
    $skillList.Add("Skill_Analyse",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Animal Handler",$($baseStatList.Stat_Presence[0],0))
    $skillList.Add("Skill_Break Fall",$($baseStatList.Stat_Dexterity[0],0))
    $skillList.Add("Skill_Bugging",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Bureaucratic/Admin",$($baseStatList.Stat_Presence[0],0))
    $skillList.Add("Skill_Climbing",$($baseStatList.Stat_Dexterity[0],0))
    $skillList.Add("Skill_Computer Operation",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Conversation",$($baseStatList.Stat_Presence[0],0))
    $skillList.Add("Skill_Cryptography",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Deduction",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Demolition/Sapping",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Disguise",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Driving",$($baseStatList.Stat_Dexterity[0],0))
    $skillList.Add("Skill_Electronics",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Engineering",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Forgery",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Gambling",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Interrogation",$($baseStatList.Stat_Presence[0],0))
    $skillList.Add("Skill_Lip Reading",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Lock Picking",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Mechanics",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Navigation",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Paramedic",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Persuasion",$($baseStatList.Stat_Presence[0],0))
    $skillList.Add("Skill_Piloting",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Security Systems",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Seduction",$($baseStatList.Stat_Comeliness[0],0))
    $skillList.Add("Skill_Shadowing",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Slight of Hand",$($baseStatList.Stat_Dexterity[0],0))
    $skillList.Add("Skill_Starship Engineering",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Stealth",$($baseStatList.Stat_Dexterity[0],0))
    $skillList.Add("Skill_Streetwise",$($baseStatList.Stat_Presence[0],0))
    $skillList.Add("Skill_Survival",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Systems Operation",$($baseStatList.Stat_Tech[0],0))
    $skillList.Add("Skill_Tactics",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Teamwork",$($baseStatList.Stat_Dexterity[0],0))
    $skillList.Add("Skill_Torture",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Tracking",$($baseStatList.Stat_Intelligence[0],0))
    $skillList.Add("Skill_Trading",$($baseStatList.Stat_Presence[0],0))
    $skillList.Add("Skill_Weapon Smith",$($baseStatList.Stat_Tech[0],0))

    if (11..12 -contains $skillMax) {$skillCount = 2}
    elseif (13..14 -contains $skillMax) {$skillCount = 4}
    elseif (15..16 -contains $skillMax) {$skillCount = 6}
    elseif (17 -contains $skillMax) {$skillCount = 8}
    
    $skillSelection = Get-Random -InputObject @($skillList.keys) -Count $skillCount

    $skillListFinal = @{}

    foreach ($stat in $($skillList.keys)) {
        if ($skillSelection -contains $stat) {
            $rndValue = Get-Random -Minimum 11 -Maximum $skillMax
            if ($rndValue -eq 11) {$value = $skillList.$stat[0]} elseif ($rndValue -ge 12) {$value = ($skillList.$stat[0]+($rndValue-11))}
            $skillListFinal.Add($stat,$value)
        }
    }

    return $baseStatListFinal,$skillListFinal
}

Function Create-Character {
    param (
        [ValidateSet('Infant','Early Childhood','Preschool','Primary school','Adolescence','Young Adult','Middle Aged','Late Adulthood','Early Old Age','Middle Old Age','Senior')]$AgeRange,
        [ValidateSet('Gifted','Extremely High','Very High','High Average','Average','Low Average','Very Low','Extremely Low')]$IQRange,
        $Surname,
        [ValidateSet("Low Skilled","Average","Highly SKilled","Expert")]$SkillPoints
        )
    
    $result = Invoke-RestMethod -Uri api.namefake.com/random

    do {
        $nameAPI = (Invoke-RestMethod -Uri https://randomuser.me/api/).results.name
    } until ($nameAPI -notmatch "\?")

    $surnameTranslated = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" ($nameAPI.last) -TargetLanguage English) -split " " | Select-Object -First 1

    $surnameTranslated = (Get-Culture).TextInfo.ToTitleCase($surnameTranslated)

    $firstNameTranslated = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" ($nameAPI.first) -TargetLanguage English) -split " " | Select-Object -First 1

    $firstNameTranslated = (Get-Culture).TextInfo.ToTitleCase($firstNameTranslated)

    $maidenNameTranslated = (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" $result.maiden_name -TargetLanguage English)[0]

    $maidenNameTranslated = (Get-Culture).TextInfo.ToTitleCase($maidenNameTranslated)

    $name = $firstNameTranslated+" "+$surnameTranslated

    $hairStyleMen = @("Bowl Cut","Business Pofessional","Buzz Cut","Crew Cut","Business Pofessional","Buzz Cut","Crew Cut","Business Pofessional","Buzz Cut","Crew Cut",
        "Business Pofessional","Buzz Cut","Crew Cut","Business Pofessional","Buzz Cut","Crew Cut",
        "Tonsure","Undercut","Flattop","Butch Cut","Caesar Cut","Hi-Top Fade",
        "Ivy League","High and Tight","Mohawk","Pageboy","Fauxhawk","Chonmage","Conk","Curtained Hair",
        "Ducktail","Mop-Top","Afro","Frosted Tips","Liberty Spikes","Mod Cut","Pompadour","PonyHawk",
        "Ponytail","Psychobilly Wedge","Spiked","Surfer","Waves","Mullet")
        
    $hairStyleWomen = @("Bob Cut","Crop","Feather Cut","Surfer","Frosted Tips","Spiked","Bowl Cut","Ponytail","Spiked",
        "Mohawk","Buzz Cut","Flattop","Bouffant","Bun","Pigtails","Chignon","Crown Braid",
        "Braid","Short and Choppy","Double Buns","Fallera","Feathered Hair","Afro","Beehive","Bangs",
        "Blowout","French Braid","French Twist","Half Updo","Lob","Straight Perm","Curl Perm","Pixie Cut",
        "Ringlets","Shag Cut","Updo","Cornrows","Dreadlocks","Finger Waves","Fishtail")

    $demeanour = "Active,Ambitious,Cautious,Conscientious,Creative,Curious,Logical,Organized,Perfectionist,Precise,Anxious,Careless,Impatient,Lazy,Rigid,Scatterbrained,
                Slapdash,Sober,Undisciplined,Volatile,Altruistic,Caring,Compassionate,Considerate,Faithful,Impartial,Kind,Pleasant,Polite,Sincere,Aggressive,Argumentative,
                Bossy,Deceitful,Domineering,Flaky,Inconsiderate,Manipulative,Rude,Spiteful,Guarded,Loner,Maverick,Reflective,Reticent,Retiring,Reserved,Self-aware,Sensitive,
                Shy,Affable,Amiable,Assertive,Authoritative,Charismatic,Enthusiastic,Gregarious,Persuasive,Self-assured,Talkative" -split ","

    $languages = "Arabic,Chinese Simplified,Danish,Dutch,English,French,German,Greek,Hebrew,Indonesian,Italian,Japanese,Korean,Polish,Portuguese,Russian,Spanish,Turkish,Vietnamese" -split ","

    $secondaryLanguages = @("None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None",
        "None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None")+$languages

    $person = @{}

    $statBlock = Generate-StatBlock

    $skills = ($statBlock | where {$_.keys -match "skill_"})
    foreach ($skill in $($skills.Keys)) {
        $skillName = $skill -replace "Skill_"
        $person.$skillName=$skills.$skill
    }

    $person.Name = $name
    $person.Age = Get-Random -Minimum 16 -Maximum 120
    $person.BirthDate = (Get-Date).AddYears(1156-($person.age)).AddMonths((Get-Random -Minimum 2 -Maximum 10)).AddHours((Get-Random -Minimum 1 -Maximum 22)).AddMinutes((Get-Random -Minimum 1 -Maximum 59))
    #$person.BirthPlace = $homeWorld,(Get-Random -InputObject $towns)
    $person.Gender = $result.pict -replace '^\d+',''
    $person.Height = $result.height
    $person.Weight = $result.weight
    $person.BMI = [Math]::Round($person.weight/($person.Height*$person.Height)*10000)
    $person.BodyType = Get-Random -InputObject ("Athletic","Athletic","Athletic","Athletic","Muscular","Muscular","Muscular","Slim","Slim","Average","Average","Average","Average","Average","Average","Average","Average","Slightly Overweight","Slightly Overweight","Slightly Overweight","Overweight","Overweight","Obese")
    $person.RacialAppearance = Get-Random -InputObject ("European","European","European","European","Middle Eastern","Middle Eastern","Middle Eastern","Asian","Asian","Asian","Asian","African","African","Latino","Latino","Indian Subcontinent","Indian Subcontinent","Indian Subcontinent","Pacifc Islander")
    $person.Demeanour = Get-Random -InputObject $demeanour
    if ($person.Gender -eq "male") {
        $hairStyle = Get-Random -InputObject $hairStyleMen
    } else {
        $hairStyle = Get-Random -InputObject $hairStyleWomen
    }
    $person.Hair = $result.hair+". Style: "+$hairStyle
    $person.EyeColour = $result.eye
    $person.BloodType = $result.blood
    $person.Married = Get-Random -InputObject ([bool]$True,[bool]$False)
    if ($person.Married -eq $True) {
        $person.MaidenName = Get-Random -InputObject $surnameTranslated,$surnameTranslated,$surnameTranslated,$surnameTranslated,$maidenNameTranslated
    }
    $person.CommunicationID = "$(Get-Random -Minimum 100000 -Maximum 999999)"+"-"+"$(Get-Random -Minimum 10000000 -Maximum 99999999)"
    $person.FavouriteSport = $result.sport
    $person.Second_Language = Get-Random -InputObject $secondaryLanguages
    $person.AccountID = $result.plasticcard
    $person.Strength = $statBlock.Stat_Strength
    $person.Dexterity = $statBlock.Stat_Dexterity
    $person.Constitution = $statBlock.Stat_Constitution
    $person.Body = $statBlock.Stat_Body
    $person.Intelligence = $statBlock.Stat_Intelligence
    $person.Tech = $statBlock.Stat_Tech
    $person.Ego = $statBlock.Stat_Ego
    $person.Presence = $statBlock.Stat_Presence
    $person.Comeliness = $statBlock.Stat_Comeliness
    $person.PD = [math]::Floor($person.Strength/10)
    $person.Speed = [Math]::Floor([decimal](($person.Dexterity/13)+($person.Intelligence/13)))
    $person.Endurance = [math]::Floor(($person.Constitution*2))
    $person.Recovery = [math]::Floor(($person.Strength/5)+($person.Constitution/5))
    $person.Stun = ($person.Strength+$person.Constitution+$person.Body+$person.Intelligence)

    return $person
}

#$colonies = Get-Content -Path 'C:\Temp\Cities and Core Planets.txt'

#$skillPoints = 50

[pscustomobject]$character = Create-Character

return $character