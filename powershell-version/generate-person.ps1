# Gets a name from a selection of languages

function Translate-Name {
    param (
        [Parameter(Mandatory=$false)]
        [ValidateSet('Arabic',
        'Chinese Simplified',
        'Danish',
        'Dutch',
        'English',
        'French',
        'German',
        'Greek',
        'Hebrew',
        #'Hindi',
        'Indonesian',
        'Italian',
        'Japanese',
        'Korean',
        'Polish',
        'Portuguese',
        'Russian',
        'Spanish',
        'Turkish',
        'Vietnamese')]
        [String]
        $TargetLanguage = "", # See list of possible languages in $LanguageHashTable below.

        [Parameter(Mandatory=$false)] 
        [String]
        $Text = "" # This can either be the text to translate, or the path to a file containing the text to translate
    )
    # Create a Hashtable containing the full names of languages as keys and the code for that language as values
    $LanguageHashTable = @{ 
    Arabic='ar'
    'Chinese Simplified'='zh-CN' 
    Danish='da' 
    Dutch='nl' 
    English='en' 
    French='fr' 
    German='de' 
    Greek='el' 
    Hebrew='iw' 
    Hindi='hi' 
    Indonesian='id'
    Italian='it'
    Japanese='ja'
    Korean='ko'
    Persian='fa' 
    Polish='pl' 
    Portuguese='pt' 
    Russian='ru' 
    Spanish='es' 
    Turkish='tr' 
    Vietnamese='vi' 
    }
    # Determine the target language
    if ($LanguageHashTable.ContainsKey($TargetLanguage)) {
        $TargetLanguageCode = $LanguageHashTable[$TargetLanguage]
    }
    elseif ($LanguageHashTable.ContainsValue($TargetLanguage)) {
        $TargetLanguageCode = $TargetLanguage
    }
    else {
        throw "Unknown target language. Use one of the languages in the `$LanguageHashTable hashtable."
    }
    # Create a list object to store the finished translation in.
    $Translation = New-Object System.Collections.Generic.List[System.Object]
    if ($Text -eq " ") {
    $Text = $args[1]
    }
    elseif (Test-Path $Text -PathType Leaf) {
        $Text = Get-Content $Text -Raw
    }
    $Uri = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$($TargetLanguageCode)&dt=t&q=$Text"
    # Get the response from the web request, then throw a bunch of regex at it to clean it up.
    $RawResponse = (Invoke-WebRequest -Uri $Uri -Method Get).Content
    $CleanResponse = $RawResponse -split '\\r\\n' -replace '^(","?)|(null.*?\[")|\[{3}"' -split '","'
    <# 
    Selecting every odd line and adding it to the $Translation list, we recreate the full translated text.
    Credit to: http://stuckinmypowershell.blogspot.com/2013/04/powershell-diy-reading-every-other-line.html
    for the $Linenumber%2 method. Check it out to learn what's happening if it looks weird.
    #>
    $LineNumber = 0
    foreach ($Line in $CleanResponse) {
        $LineNumber++
        if($LineNumber%2) {
            $Translation.Add($Line)
        }
    }
    return $Translation
}

function Generate-Character {
    param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("United States",
    "United Kingdom",
    "Saudia Arabia",
    "India",
    "Israel",
    "Greece",
    "Indonesia",
    "Korea",
    "Denmark",
    "Thailand",
    "Vietnam",
    "Netherlands",
    "Australia",
    "German",
    "Iceland",
    "Turkey",
    "Spain",
    "France",
    "Italy",
    "Japan",
    "Poland",
    "Brazil",
    "Russia",
    "Sweden",
    "China")]
    [string]$Nationality
    )

    $nationalityList = @("United States",
    "United Kingdom",
    "Saudia Arabia",
    "India",
    "Israel",
    "Greece",
    "Indonesia",
    "Korea",
    "Denmark",
    "Thailand",
    "Vietnam",
    "Netherlands",
    "Australia",
    "German",
    "Iceland",
    "Turkey",
    "Spain",
    "France",
    "Italy",
    "Japan",
    "Poland",
    "Brazil",
    "Russia",
    "Sweden",
    "China")

    if ($Nationality -eq $null) {
        Write-Host "No string detected, randomising"
        $Nationality = Get-Random $nationalityList
        $translateList = "Brazil","China","Denmark","France","German","Greece","Indonesia","Italy","Japan","Korea","Netherlands","Poland","Russia","Saudia Arabia","Spain","Turkey","Vietnam"
        if ($Nationality -contains $translateList) {
            $translate = $true
        }
    }

    switch ($nationality)
    {
        Australia {$language = "english-australia"}
        Brazil {$language = "portuguese-brazil"}
        Canada {$language = "english-canada"}
        China {$language = "chinese-china"}
        Denmark {$language = "danish-denmark"}
        France {$language = "french-france"}
        German {$language = "german_germany"}
        Greece {$language = "greek-greece"}
        Indonesia {$language = "indonesian-indonesia"}
        Italy {$language = "italian-italy"}
        Japan {$language = "japanese-japan"}
        Korea {$language = "korean-south-korea"}
        Netherlands {$language = "dutch-netherlands"}
        Poland {$language = "polish-poland"}
        Russia {$language = "russian-russia"}
        'Saudia Arabia' {$language = "arabic-jordan"}
        Spain {$language = "spanish-spain"}
        Turkey {$language = "turkish-turkey"}
        'United Kingdom' {$language = "english-united-kingdom"}
        'United States' {$language = "english-united-states"}
        Vietnam {$language = "vietnamese-vietnam"}
    }

    $return = Invoke-RestMethod -Uri api.namefake.com/$language/random
    
    return $return
}

$person1 = Generate-Character -Nationality German
Start-Sleep -Seconds 2
$person2 = Generate-Character -Nationality China

$language

$nationality = $null

$translatedName1 = ((Translate-Name -TargetLanguage English -Text "$($person1.name)") -split " ")[0]

$translatedName2 = ((Translate-Name -TargetLanguage English -Text "$($person2.name)") -split " ")[1]

$person1.name = "$translatedName1 $translatedName2"

$person1.name