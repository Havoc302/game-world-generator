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
        "Free Colonies" {$free_colonies = (Invoke-WebRequest -Uri https://storage.googleapis.com/rp-game-star-files/character_gen/cities.csv | Select-Object -ExpandProperty RawContent) -split "`n";
                        Get-Random $free_colonies
                        $free_planets = Invoke-WebRequest -Uri https://storage.googleapis.com/rp-game-star-files/uninhabited_systems.htm | Select-Object -ExpandProperty Links | Select-Object -ExpandProperty InnerText
                        $free_planet = Get-Random $free_planets
                        $homeWorld = $free_planet -split "/" -split "-" | Select-Object -Last 3 | Select-Object -First 1
                        }
    }