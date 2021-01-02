$skill_points = $args[0]

$colony = $args[1]

Function Create-Character {
    param ($Skill_Points,$Skill_Min,$Skill_Max,
        [Parameter(Mandatory=$true,ParameterSetName="Colony")][ValidateSet("New Washington","New London","New Tokyo","New Berlin","New Paris","New Beijing","New Canberra","Free Colonies")]$Colony        
        )

    $result = Invoke-RestMethod -Uri api.namefake.com/random

    $hair_style_men =@(
        "Bowl Cut","Business Pofessional","Buzz Cut","Butch Cut","Caesar Cut","Crew Cut","Tonsure","Undercut","Flattop","Hi-Top Fade",
        "Ivy League","High and Tight","Mohawk","Pageboy","Fauxhawk","Chonmage","Conk","Curtained Hair",
        "Ducktail","Mop-Top","Afro","Frosted Tips","Liberty Spikes","Mod Cut","Pompadour","PonyHawk",
        "Ponytail","Psychobilly Wedge","Spiked","Surfer","Waves","Mullet"
    )
        
     $hair_style_women = (
        "Bob Cut","Crop","Feather Cut","Surfer","Frosted Tips","Spiked","Bowl Cut","Ponytail","Spiked",
        "Mohawk","Buzz Cut","Flattop","Bouffant","Bun","Pigtails","Chignon","Crown Braid",
        "Braid","Short and Choppy","Double Buns","Fallera","Feathered Hair","Afro","Beehive","Bangs",
        "Blowout","French Braid","French Twist","Half Updo","Lob","Straight Perm","Curl Perm","Pixie Cut",
        "Ringlets","Shag Cut","Updo","Cornrows","Dreadlocks","Finger Waves","Fishtail"
    )

    $professions =@(

    )

    if ($colony -eq $null) {
        $colony = Get-Random ("New Washington","New London","New Tokyo","New Berlin","New Paris","New Beijing","New Canberra")
    }

    switch ($colony) {
        "New Washington" {$towns = @("McKinney","Hillsboro","Orange","De Land","North Hempstead","Revere","Sacramento","Bayonne","Fairhaven","Susanville","Glens Falls","Danville","Sweetwater","Bowling Green","Worthington","Sunnyvale",
                           "Jeannette","Toledo","Boothbay Harbor","Victorville","Oakland","Edgartown","French Lick","East Orange","Hayward","Priest River","Bastrop","Reading","Keokuk","Arkadelphia")
                          $language = "English"}
        "New London" {$towns = @("Gains","Bewdley","Har","Tring","Birmingham","Chudleigh","Bexley","Harrow","Gateshead","Wivenhoe","Huddersfield","Whitnash","Swanley","Chatteris","Syston","Hedge End","Welsh cities","Neston",
                        "Northfleet","Louth","Soham","Lough","Ashington","Wadebridge","Didcot","Alford","Rochford","Dorchester","Brackley","Nuneaton")
                      $language = "English"}
        "New Tokyo" {$towns = @("Shumukarikotan","Kawakami","Niburi","Iroma","Funakoshi","Sembon","Kamikita","Ninomata","Miyaoki","Shimo-oribe","Kami-renjaku","Nakasato","Hazako","TakanyÅ«ta","Taruma","Hachitanda","Togutshi",
                                "Tatsumiya","ZanadÅ","Yokogake","Osaka","Kanetsu","Kawaziri","Ikuho","HakushÅ«","Iwaizumi","Banbanchi","Ozarizawa","Hagashi","Saigane")
                     $language = "Japanese"}
        "New Berlin" {$towns = @("Caaschwitz","Gestratz","Liebem","Krumhermersdorf","Tiefental","Bettingerschmelz","Waidholz","Zelz","Oyten","Lehrbach","Wiedersberg","Dyck","Gospoldshofen","Erbenweiler","Kirchhoffwarft",
                                    "Zschaiten","Dannenfels","Fronlohe","Kleinwitzeetze","Schildertschlag","Kaster","Oberelles","Meckatz","Eichenhof","Jedenhofen","Kappalen","Suschow","Bergfelden","Pentz","Hamburg")
                      $language = "German"}
        "New Paris"  {$towns = @("Marmignolle","Carnetin","Balayes","Honnechy","Malesoute","Landremont","Bonnemazon","Langlechais","Zoebersdoff","Coussieux","Buglou","Puygros","Lapugnoy","Linac","Francarville","Brethou",
                                    "Sornac","Vantelay","Ricquebourg","Quenoche","Aubevoie","Rions","Champfleury","Lyon","Mesaudon","Villemaur","Limeyrat","Rodemack","Cousolre","Breurey")
                      $language = "French"}
        "New Beijing" {$towns = @("Guolukeng","Yuanjiang","Pan-chia-lien","Maji","Qucun","Zhahashan","Liaozipai","Laxiejiatai","Niulingxia","Liangzeng","Dunhua","Dakeng","Dushuling","Dujiayangpo","Jiangjia","Fenshuijie","Qiaozhong",
                                    "Heihumiao","Nanshi","Shanghai","Chuan-pi","Baishi","Dakeng","Lijiacun","Xiachong","Dishuiya","Xiajiabang","Licunshang","Shexia","Huangsifang")
                       $language = "Mandarin"}
        "New Canberra" {$towns = @("Gympie","Kerang","Hobart","Melbourne","Coolgardie","Seymour","Ballarat","Bega","Mount Gambier","Cowra","Yeppoon","Kiama","Narrandera","Gawler","Hay","Singleton","Geraldton","Yarrawonga","Port Macquarie",
                                    "Blackwater","Nowra-Bomaderry","Lakes Entrance","West Wyalong","Goondiwindi","Wonthaggi","Sydney","Sea Lake","Kyabram","Moranbah","Gosford")
                        $language = "English"}
        "Free Colonies" {$free_colonies = (Invoke-WebRequest -Uri https://storage.googleapis.com/rp-game-star-files/character_gen/cities.csv | Select-Object -ExpandProperty Content) -split "`n";
                        Get-Random $free_colonies
                        $free_planets = Invoke-WebRequest -Uri https://storage.googleapis.com/rp-game-star-files/uninhabited_systems.htm | Select-Object -ExpandProperty Links | Select-Object -ExpandProperty InnerText
                        $free_planet = Get-Random $free_planets
                        $colony = $free_planet -split "/" -split "-" | Select-Object -Last 3 | Select-Object -First 1
                        $languages = (Invoke-WebRequest -Uri https://storage.googleapis.com/rp-game-star-files/character_gen/languages.txt | Select-Object -ExpandProperty Content) -split "`n";
                        $language = Get-Random -InputObject $languages
                        }
    }

    $secondary_languages = @(
        "Mandarin","English","German","French","Japanese","Arabic","Spanish","Hindi","Bengali","Portuguese","Russian","Punjabi","Marathi","Telugu","Wu Chinese","Korean","Italian",
        "None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None",
        "None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None"
    )
    

    $person = @{}

    $person.Name = $result.name    
    $person.BirthDate = (Get-Date $result.birth_data).AddYears(1156).AddHours((Get-Random -Minimum 1 -Maximum 22)).AddMinutes((Get-Random -Minimum 1 -Maximum 59))
    $person.Age = 3176 - ($person.BirthDate -split " " -split "/")[2]
    $person.BirthPlace = $colony,(Get-Random -InputObject $towns)
    $person.Gender = $result.pict -replace '^\d+',''
    $person.Height = $result.height
    $person.Weight = $result.weight
    if ($person.Gender -eq "male") {
        $hair_style = Get-Random -InputObject $hair_style_men
    } else {
        $hair_style = Get-Random -InputObject $hair_style_women
    }
    $person.Hair = $result.hair+", styled: "+$hair_style
    $person.EyeColour = $result.eye
    $person.BloodType = $result.blood
    $married = Get-Random -InputObject ([bool]$True,[bool]$False)
    $person.Married = $married
    $surname = $result.name -split " " | Select-Object -Last 1
    $surnames = @($surname,$surname,$surname,$surname,$result.maiden_name)
    if ($married -eq $True) {
        $person.MaidenName = Get-Random -InputObject $surnames
    }
    $person.CommunicationID = $result.phone_h
    $person.FavouriteSport = $result.sport
    $person.Second_Language = Get-Random -InputObject $secondary_languages
    $person.AccountID = $result.plasticcard
    $person.Strength = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.Strength-$Skill_min)
    $person.Dexterity = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.Dexterity-$Skill_min)
    $person.Constitution = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.Constituion-$Skill_min)
    $person.Body = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.Body-$Skill_min)
    $person.Intelligence = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.Intelligence-$Skill_min)
    $person.Tech = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.Tech-$Skill_min)
    $person.SelfDiscipline = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.SelfDiscipline-$Skill_min)
    $person.Presence = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.Presence-$Skill_min)
    $person.Comeliness = $Skill_Min+(Get-Random -Minimum 0 -Maximum $skill_max)
    $skill_points = $skill_points-($person.Comeliness-$Skill_min)
    $person.PD = 1
    if ((($person.Dexterity/25)+($person.Intelligence/25)) -le 1) {$speed = 1} else {$speed = ($person.Dexterity/25)+($person.Intelligence/25)}
    $person.Speed = $speed
    $person.Endurance = ($person.Constitution*2)
    $person.Recovery = ($person.Strength/5)+($person.Constitution/5)
    $person.Stun = ($person.Strength+$person.Constitution+$person.Body+$person.Intelligence)
    $person.SkillPointsRemaining = $Skill_Points
    $person.Profession = Get-Random -InputObject $professions

    return $person
}

#$colonies = Get-Content -Path 'C:\Temp\Cities and Core Planets.txt'

$skill_points = 150

$character = Create-Character -Skill_Points $skill_points -Skill_Min 8 -Skill_Max 20 -Colony 'Free Colonies'

return $character


$professions = Get-Content -Path C:\Temp\professions.txt