$ageRange = $args[0]

$IQRange = $args[1]

$surname = $args[2]

$skillPoints = $args[3]

$homePath = 'G:\Colonial_Alliance_Game'

Function Translate-String {
    param (
        [Parameter(Mandatory=$true,ParameterSetName="String")]$String
    )
    (& "$homePath\game-world-generator\powershell-version\translate-string.ps1" $String -TargetLanguage English) -split " " | Select-Object -First 1
}

Function Generate-PhysicalMetrics {
    param (
        [Parameter(Mandatory=$false)][ValidateSet('Infant','Toddler','Child','Pre-Teen','Teen','Adult','Middle Aged','Senior','Early Old Age','Late Old Age')]$ageRange,
        [Parameter(Mandatory=$false)][ValidateSet('Female','Male')]$Sex
    )
    
    $ageValues = @('Infant','Toddler','Child','Pre-Teen','Teen','Adult','Middle Aged','Senior','Early Old Age','Late Old Age')

    if ($ageValues -notcontains $ageRange) {
        $ageRnd = Get-Random -Minimum 0 -Maximum 100
    }

    if ($Sex -notmatch "Female" -or $Sex -notmatch "Male") {
        $Sex = Get-Random -InputObject "Female","Male"
    }

    # Set for Female average height and weight
    if ($AgeRnd -in 0..2 -or $ageRange -match 'Infant') {$age = Get-Random -Minimum 0.1 -Maximum 1;$height = Get-Random -Minimum 55 -Maximum 75} # ages 0-1
    elseif ($AgeRnd -in 3..7 -or $ageRange -match 'Toddler') {$age = Get-Random -Minimum 2 -Maximum 4;$height = Get-Random -Minimum 65 -Maximum 85} # ages 2-4 
    elseif ($AgeRnd -in 8..14 -or $ageRange -match 'Child') {$age = Get-Random -Minimum 5 -Maximum 8;$height = Get-Random -Minimum 80 -Maximum 130} # ages 5-8
    elseif ($AgeRnd -in 15..22 -or $ageRange -match 'Pre-Teen') {$age = Get-Random -Minimum 9 -Maximum 12;$height = Get-Random -Minimum 130 -Maximum 150} # ages 9-12
    elseif ($AgeRnd -in 23..35 -or $ageRange -match 'Teen') {$age = Get-Random -Minimum 13 -Maximum 19;$height = Get-Random -Minimum 150 -Maximum 175} # ages 13-19
    elseif ($AgeRnd -in 36..60 -or $ageRange -match 'Adult') {$age = Get-Random -Minimum 20 -Maximum 39;$height = Get-Random -Minimum 160 -Maximum 185} # ages 20-39
    elseif ($AgeRnd -in 61..82 -or $ageRange -match 'Middle Aged') {$age = Get-Random -Minimum 40 -Maximum 59;$height = Get-Random -Minimum 160 -Maximum 200} # ages 40-59
    elseif ($AgeRnd -in 83..92 -or $ageRange -match 'Senior') {$age = Get-Random -Minimum 60 -Maximum 79;$height = Get-Random -Minimum 140 -Maximum 195} # ages 60-79
    elseif ($AgeRnd -in 93..97 -or $ageRange -match 'Early Old Age') {$age = Get-Random -Minimum 80 -Maximum 99;$height = Get-Random -Minimum 140 -Maximum 192} # ages 80-99
    elseif ($AgeRnd -in 98..100 -or $ageRange -match 'Late Old Age') {$age = Get-Random -Minimum 100 -Maximum 150;$height = Get-Random -Minimum 140 -Maximum 190} # ages 100-150

    $rndWeightMod = Get-Random -Minimum 0.6 -Maximum 1.4
    $weight = [math]::ROUND((24*($height*$height)/10000))*$rndWeightMod

    if ($sex -match "Male") {
        $height = $height * 1.07
        $weight = $weight * 1.15
    }

    $age = [math]::ROUND(($age),2)
    $height = [math]::ROUND(($height),2)
    $weight = [math]::ROUND(($weight),2)

    return $age,$height,$weight
}

Function New-StatBlock {
    param (
        [Parameter(Mandatory=$false,ParameterSetName="Skill Range")][ValidateSet("Boss","Expert","Highly Skilled","Average","Low Skilled")]$SkillRange
    )
    if ($null -eq $SkillRange) {
        $SkillRange = Get-Random ("Boss","Expert","Expert","Highly Skilled","Highly Skilled","Highly Skilled","Average","Average","Average","Average","Average","Low Skilled")
    }

    switch ($SkillRange) {
        "Boss" {($skillMin = 12),($skillMax = 19),($statMin = 14), ($statMax = 25)}
        "Expert" {($skillMin = 11),($skillMax = 17),($statMin = 13), ($statMax = 22)}
        "Highly Skilled" {($skillMin = 10),($skillMax = 15),($statMin = 12), ($statMax = 18)}
        "Average" {($skillMin = 9),($skillMax = 13),($statMin = 9), ($statMax = 14)}
        "Low Skilled" {($skillMin = 8),($skillMax = 11),($statMin = 7), ($statMax = 12)}
    }

    $baseStatList= @{}
    $baseStatList.Add("Stat_Strength",(0,1))
    $baseStatList.Add("Stat_Dexterity",(0,2))
    $baseStatList.Add("Stat_Constitution",(0,2))
    $baseStatList.Add("Stat_Body",(0,2))
    $baseStatList.Add("Stat_Intelligence",(0,1))
    $baseStatList.Add("Stat_Tech",(0,2))
    $baseStatList.Add("Stat_Ego",(0,1))
    $baseStatList.Add("Stat_Presence",(0,1))
    $baseStatList.Add("Stat_Comeliness",(0,0.5))

    $baseStatListFinal = @{}

    foreach ($stat in $($baseStatList.keys)) {
        $value = Get-Random -Minimum $StatMin -Maximum $StatMax
        $rate = $baseStatList[$stat][1]
        $cost = ($value-10)*$rate
        #$skillPoints = $skill Points-$cost
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

    $abilities =@{}
    $abilities.Add("KS_Familarity_Melee",$(Get-Random -InputObject "Yes","No"))
    if ($abilities.'KS_Familarity_Melee' -eq "Yes") {
        $meleePick = Get-Random -InputObject 1,2,3 -Count (Get-Random -InputObject 1,2,3)
        if (1 -in $meleePick){$abilities.Add("KS_Bladed_Weapons_Rank",$(Get-Random -Minimum 1 -Maximum 4))}
        if (2 -in $meleePick){$abilities.Add("KS_Energy_Melee_Rank",$(Get-Random -Minimum 1 -Maximum 4))}
        if (3 -in $meleePick){$abilities.Add("KS_Blunt_Melee_Rank",$(Get-Random -Minimum 1 -Maximum 4))}
    }
    $abilities.Add("KS_Familarity_Firearms",$(Get-Random -InputObject "Yes","No"))
    if ($abilities.'KS_Familarity_Firearms' -eq "Yes") {
        $firearmsPick = Get-Random -InputObject 1,2,3,4 -Count (Get-Random -InputObject 1,2,3,4)
        if (1 -in $firearmsPick){$abilities.Add("KS_Pistols_Rank",$(Get-Random -Minimum 1 -Maximum 4))}
        if (2 -in $firearmsPick){$abilities.Add("KS_Rifle_Rank",$(Get-Random -Minimum 1 -Maximum 4))}
        if (3 -in $firearmsPick){$abilities.Add("KS_LMG_Rank",$(Get-Random -Minimum 1 -Maximum 4))}
        if (4 -in $firearmsPick){$abilities.Add("KS_Sniper_Rifle_Rank",$(Get-Random -Minimum 1 -Maximum 4))}
    }

    if (11..12 -contains $skillMax) {$skillCount = 2}
    elseif (13..14 -contains $skillMax) {$skillCount = 3}
    elseif (15..16 -contains $skillMax) {$skillCount = 5}
    elseif (17 -contains $skillMax) {$skillCount = 7}
    elseif (18 -contains $skillMax) {$skillCount = 9}
    elseif ($skillMax -ge 19) {$skillCount = 12}
    
    $skillSelection = Get-Random -InputObject @($skillList.keys) -Count $skillCount

    $skillListFinal = @{}

    foreach ($stat in $($skillList.keys)) {
        if ($skillSelection -contains $stat) {
            $rndValue = Get-Random -Minimum $skillMin -Maximum $skillMax
            if ($rndValue -eq 11) {$value = $skillList.$stat[0]} elseif ($rndValue -ge 12) {$value = ($skillList.$stat[0]+($rndValue-11))}
            $skillListFinal.Add($stat,$value)
        }
    }

    return $baseStatListFinal,$skillListFinal,$abilities
}

Function New-Character {
    param (
        [ValidateSet('Infant','Toddler','Child','Teen','Adult','Middle Aged','Senior','Early Old Age','Late Old Age')]$AgeRange,
        [ValidateSet("Boss","Expert","Highly Skilled","Average","Low Skilled")]$SkillRange,
        $Surname
    )
    
    $rollDivider = 4

    $rollBase = 9

    $namefakeAPI = Invoke-RestMethod -Uri api.namefake.com/random

    do {
        $randomuserAPI = (Invoke-RestMethod -Uri https://randomuser.me/api/).results
        if ($randomuserAPI -match "\?" -or $null -eq $randomuserAPI) {
            Start-Sleep -Seconds 2
        }
            
    } until ($randomuserAPI -notmatch "\?" -and $null -ne $randomuserAPI)

    if ($null -ne $Surname) {
        $surnameTranslated = $surname
    } else {
        $surnameTranslated =  Translate-String -String ($randomuserAPI.name.last)
        $surnameTranslated = (Get-Culture).TextInfo.ToTitleCase($surnameTranslated)
    }

    $hobbies = (& "$homePath\game-world-generator\powershell-version\generate-civilization\generator-random-hobbies.ps1")

    $firstNameTranslated = Translate-String -String ($randomuserAPI.name.first)

    $firstNameTranslated = (Get-Culture).TextInfo.ToTitleCase($firstNameTranslated)

    $maidenNameTranslated = Translate-String -String ($namefakeAPI.maiden_name)

    $maidenNameTranslated = (Get-Culture).TextInfo.ToTitleCase($maidenNameTranslated)

    $name = $firstNameTranslated+" "+$surnameTranslated

    $hairStyleMasculine = @("Bowl Cut,Business Pofessional,Buzz Cut,Crew Cut,Business Pofessional,Buzz Cut,Crew Cut,Business Pofessional,Buzz Cut,Crew Cut,
        Business Pofessional,Buzz Cut,Crew Cut,Business Pofessional,Buzz Cut,Crew Cut,
        Tonsure,Undercut,Flattop,Butch Cut,Caesar Cut,Hi-Top Fade,
        Ivy League,High and Tight,Mohawk,Pageboy,Fauxhawk,Chonmage,Conk,Curtained Hair,
        Ducktail,Mop-Top,Afro,Frosted Tips,Liberty Spikes,Mod Cut,Pompadour,PonyHawk,
        Ponytail,Psychobilly Wedge,Spiked,Surfer,Waves,Mullet" -split ",").Trim()
        
    $hairStyleFeminine = @("Bob Cut,Crop,Feather Cut,Surfer,Frosted Tips,Spiked,Bowl Cut,Ponytail,Spiked,
        Mohawk,Buzz Cut,Flattop,Bouffant,Bun,Pigtails,Chignon,Crown Braid,
        Braid,Short and Choppy,Double Buns,Fallera,Feathered Hair,Afro,Beehive,Bangs,
        Blowout,French Braid,French Twist,Half Updo,Lob,Straight Perm,Curl Perm,Pixie Cut,
        Ringlets,Shag Cut,Updo,Cornrows,Dreadlocks,Finger Waves,Fishtail" -split ",").Trim()

    $hairStyleAny = $hairStyleFeminine.Trim() + $hairStyleMasculine.Trim()

    $hairColour = @("Ash Blonde,Ash Brown,Auburn,Black,Blonde,Blue,Bright Red,Brown,Burgundy,Caramel Brown,Chestnut Brown,Cinnamon,Copper,Copper Red,Dark Blonde,Dark Blue,Dark Brown,Dark Purple,Dark Red,Dirty Blonde,Golden Blonde,Golden Brown,
        Gray,Jet black,Lavender,Light blonde,Light Brown,Mahogany,Medium Blonde,Medium Brown,Pastel Pink,Pink,Platinum Blonde,Red,Rose Gold,Salt and Pepper,Sandy Blonde,Silver/grey,Strawberry Blonde,Teal,Violet" -split ",").Trim()
        

    $facialHair = @("Anchor Beard,Balbo Beard with a Soul Patch,Balbo,Bandholz,Boxed Beard,Chevron mustache,Chevron,Chin Curtain,Chin Strap,Circle Beard,Classic Old Dutch,Clean Shaven,Clean-Shaven,Dali Mustache,Dali,Designer Stubble,Ducktail,
        English Mustache,Extended Goatee,Five O'Clock Shadow,French Fork,Friendly Mutton Chops,Fu Manchu,Full Beard,Garibaldi,Goatee,Handlebar Mustache,Horseshoe Mustache with Chin Beard,Horseshoe Mustache,Horseshoe,Hulihee Beard,Hungarian Mustache,
        Imperial Mustache,Imperial,Mustache,Mutton Chops with a Mustache,Mutton Chops,Old Dutch,Paintbrush Mustache,Painter’s Brush Mustache,Pencil Mustache,Pencil,Petite Goatee,Pyramidal Mustache,Royale Beard,Scruff,Short Boxed Beard,Sideburns,
        Soul Patch,Stubble,Tapered Beard,Terminal beard,The 3-Day Beard,The Amish Beard,The Anchor Beard with Mustache,The Bandholz Beard with Mustache,The Chevron Mustache,The Chinstrap Beard with Mustache,The Chinstrap Beard with Soul Patch,
        The Circle Beard with Mustache,The Classic Beard with Soul Patch,The Classic Beard,The Classic Mustache,The Colonial Beard,The Corporate Beard,The Dali Beard,The Ducktail Beard with Soul Patch,The Dutch Beard with Mustache,The Dutch Beard,
        The English Beard with Mustache,The English Beard with Soul Patch,The Extended Goatee with Chin Curtain,The Extended Goatee with Mustache,The French Beard,The French Fork Beard with Mustache,The Friendly Mutton Chops with Mustache,
        The Goatee with Soul Patch,The Hollywood Beard,The Hollywoodian Beard with Mustache,The Hollywoodian Beard with Soul Patch,The Hollywoodian Beard,The Horseshoe Beard with Chin Strap,The Imperial Beard with Mustache,The Pencil Beard,
        The Pencil Mustache with Chin Curtain,The Petite Goatee with Chin Strap,The Petite Soul Patch,The Pyramidal Beard,The Royale Beard with Mustache,The Short Boxed Beard with Chevron Mustache,The Short Boxed Beard with Mustache,
        The Short Boxed Beard with Soul Patch,The Short Stubble with Chin Strap,The Short Stubble with Mustache,The Tailback,The Verdi Beard with Mustache,The Verdi Beard,The Wolverine,The Zappa Beard with Chevron Mustache,
        The Zappa Beard with Chin Strap,The Zappa,Toothbrush Mustache,Toothbrush,Van Dyke,Verdi,Viking Beard,Walrus Mustache,Zorro Mustache" -split ",").Trim()

    $demeanour = ("Active,Ambitious,Cautious,Conscientious,Creative,Curious,Logical,Organized,Perfectionist,Precise,Anxious,Careless,Impatient,Lazy,Rigid,Scatterbrained,
                Slapdash,Sober,Undisciplined,Volatile,Altruistic,Caring,Compassionate,Considerate,Faithful,Impartial,Kind,Pleasant,Polite,Sincere,Aggressive,Argumentative,
                Bossy,Deceitful,Domineering,Flaky,Inconsiderate,Manipulative,Rude,Spiteful,Guarded,Loner,Maverick,Reflective,Reticent,Retiring,Reserved,Self-aware,Sensitive,
                Shy,Affable,Amiable,Assertive,Authoritative,Charismatic,Enthusiastic,Gregarious,Persuasive,Self-assured,Talkative" -split ",").Trim()

    $languages = "Arabic,Chinese Simplified,Danish,Dutch,English,French,German,Greek,Hebrew,Indonesian,Italian,Japanese,Korean,Polish,Portuguese,Russian,Spanish,Turkish,Vietnamese" -split ","

    $secondaryLanguages = @("None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None",
        "None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None")+$languages

    $racialAppearance = ("European","European","European","European","Middle Eastern","Middle Eastern","Middle Eastern","Asian","Asian","Asian","Asian","African","African","Latino","Latino","Indian Subcontinent","Indian Subcontinent","Indian Subcontinent","Pacifc Islander")

    if ($null -ne $SkillRange) {
        $statBlock = Generate-StatBlock -SkillRange $SkillRange
    } else {
        $statBlock = Generate-StatBlock
    }

    if ($null -ne $AgeRange) {
        $physicalMetrics = Generate-PhysicalMetrics -ageRange $AgeRange -Sex ($randomuserAPI.Gender)
    } else {
        $physicalMetrics = Generate-PhysicalMetrics -Sex ($randomuserAPI.Gender)
    }

    $person = [ordered]@{}
    $person.Name = $name
    $person.Age = $physicalMetrics[0]
    $person.Birth_Date = ((Get-Date).AddYears(1157-($person.age)).AddMonths((Get-Random -Minimum 2 -Maximum 10)).AddHours((Get-Random -Minimum 1 -Maximum 22)).AddMinutes((Get-Random -Minimum 1 -Maximum 59))).ToString()
    #$person.BirthPlace = $homeWorld,(Get-Random -InputObject $towns)
    $person.Sex = $randomuserAPI.Gender #$namefakeAPI.pict -replace '^\d+',''
    $person.Height = $physicalMetrics[1]
    $person.Weight = $physicalMetrics[2]
    $person.BMI = [Math]::Round($person.weight/($person.Height*$person.Height)*10000)
    $person.Body_Type = if ($person.BMI -le 15) {Get-Random -InputObject ("Athletic","Athletic","Athletic","Slim","Slim","Slim")} elseif ($person.BMI -in 16..24) {Get-Random -InputObject ("Athletic","Athletic","Athletic","Athletic","Average","Average","Average","Average","Average","Average","Average","Average")} elseif ($person.BMI -in 25..30) {Get-Random -InputObject ("Muscular","Muscular","Muscular","Body Builder","Body Builder","Slightly Overweight","Slightly Overweight","Slightly Overweight","Slightly Overweight","Slightly Overweight","Overweight","Overweight")}elseif ($person.BMI -ge 30) {Get-Random -InputObject ("Power Lifter","Obese","Obese","Obese","Obese","Obese")}
    $person.Racial_Appearance = Get-Random -InputObject $racialAppearance
    $person.Demeanour = Get-Random -InputObject $demeanour
    $person.Hair = "$(($namefakeAPI.hair -split ",")[0]), $(Get-Random -InputObject $hairColour)"
    if ($person.Gender -match "male") {
        if ((Get-Random -Minimum 1 -Maximum 7) -le 8) {
            ($person.Hair_Style = Get-Random -InputObject $hairStyleAny).trim()
        } else {
            ($person.Hair_Style = Get-Random -InputObject $hairStyleMasculine).trim()
        }
        if (($physicalMetrics[0]) -ge 18) {
            if ((Get-Random -Minimum 1 -Maximum 55) -le 55) {
               $person.Facial_Hair = Get-Random -InputObject $facialHair
            }
        }
    } else {
        if ((Get-Random -Minimum 1 -Maximum 7) -le 8) {
            ($person.Hair_Style = Get-Random -InputObject $hairStyleAny).trim()
        } else {
            ($person.Hair_Style = Get-Random -InputObject $hairStyleFeminine).trim()
        }
    }
    $person.Eye_Colour = $namefakeAPI.eye
    $person.Blood_Type = $namefakeAPI.blood
    $person.CommunicationID = "$(Get-Random -Minimum 100000 -Maximum 999999)"+"-"+"$(Get-Random -Minimum 10000000 -Maximum 99999999)"
    if (($physicalMetrics[0]) -ge 15) {
        $person.Second_Language = Get-Random -InputObject $secondaryLanguages
        $person.Married = Get-Random -InputObject ([bool]$True,[bool]$False)
        if ($person.Married -eq $True) {
            $person.Maiden_Name = Get-Random -InputObject $surnameTranslated,$surnameTranslated,$surnameTranslated,$surnameTranslated,$maidenNameTranslated
        }
        $person.Main_Hobby = ($hobbies[0]).trim()
        $person.Secondary_Hobby = ($hobbies[1]).trim()
        $person.AccountID = $namefakeAPI.plasticcard
    }
    $person.Strength = $statBlock.Stat_Strength
    $person.Constitution = $statBlock.Stat_Constitution
    $person.Ego = $statBlock.Stat_Ego
    $person.Intelligence = $statBlock.Stat_Intelligence
    $person.Tech = $statBlock.Stat_Tech
    $person.Dexterity = $statBlock.Stat_Dexterity
    $person.Body = $statBlock.Stat_Body
    $person.Presence = $statBlock.Stat_Presence
    $person.Comeliness = $statBlock.Stat_Comeliness
    $person.Health_Points = [math]::Floor($person.Body+($person.Constitution/2))
    $person.PD = [math]::Floor($person.Strength/10)
    $person.ED = 1
    $person.ActionPoints = [math]::Floor(1+([decimal](($person.Dexterity/30)+($person.Intelligence/(30*2)))))
    $person.Endurance = [math]::Floor(($person.Constitution/2)+($person.Body/2))
    $person.Recovery = [math]::Floor(($person.Strength/5)+($person.Constitution/5))
    $person.Stun = ($person.Strength+$person.Constitution+$person.Body+$person.Intelligence)
    $person.Stun_Recovery = [math]::Floor(($person.Constitution/2)+($person.Body/2))
    $person.Running = [math]::Floor(($person.Strength/2)+($person.Constitution/2))
    $person.Swimming_Leaping = [math]::Floor(($person.Running/5))
    $person.Strength_Roll = [math]::Floor(($person.Strength/$rollDivider)+$rollBase)
    $person.Constitution_Roll = [math]::Floor(($person.Constitution/$rollDivider)+$rollBase)
    $person.Perception_Roll = [math]::Floor(($person.Intelligence/$rollDivider)+$rollBase)
    $person.Ego_Roll = [math]::Floor(($person.Ego/$rollDivider)+9)
    $person.Intelligence_Roll = [math]::Floor(($person.Intelligence/$rollDivider)+$rollBase)
    $person.Tech_Roll = [math]::Floor(($person.Tech/$rollDivider)+$rollBase)
    $person.Dexterity_Roll = [math]::Floor(($person.Dexterity/$rollDivider)+$rollBase)
    $person.Presence_Roll = [math]::Floor(($person.Presence/$rollDivider)+$rollBase)
    $person.Comeliness_Roll = [math]::Floor(($person.Comeliness/$rollDivider)+$rollBase)
    $person.CV = 3+[math]::Floor([decimal]($person.ActionPoints))
    if (($physicalMetrics[0]) -ge 15) {
        $skills = ($statBlock | Where-Object {$_.keys -match "skill_" -or $_.keys -match "KS_"})
        foreach ($skill in $($skills.Keys)) {
            $skillName = $skill -replace "Skill_" -replace "KS_"
            $person.$skillName=$skills.$skill
        }
    }

    return $person
}
do {
    [pscustomobject]$character = New-Character

    $character

    $YesNo = Read-Host -Prompt "Save Character?"
    "`n`n`n"
} until ($YesNo -imatch "Yes" -or $YesNo -imatch "Y")

if ($YesNo -imatch "Yes" -or $YesNo -imatch "Y") {
    $userInput = Read-Host -Prompt "Enter context details"
    Add-Content 'E:\My Drive\TTRPG\Colonial Alliance RP Game\GM\Episodes\Campaign 3 log.txt' "`n$userInput"
    Add-Content 'E:\My Drive\TTRPG\Colonial Alliance RP Game\GM\Episodes\Campaign 3 log.txt' $(Get-Date)
    Add-Content 'E:\My Drive\TTRPG\Colonial Alliance RP Game\GM\Episodes\Campaign 3 log.txt' $($character | ConvertTo-Json)
}
