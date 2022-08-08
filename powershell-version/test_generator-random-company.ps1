# Random company name generator

# Translates any name fed into it to English using Google Translate.
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

Function Get-CityName {
    $rnd_cityid = Get-Random -Minimum 1 -Maximum 24152
    $city = Invoke-RestMethod -uri "http://geodb-free-service.wirefreethought.com/v1/geo/cities?limit=1&offset=$rnd_cityid&hateoasMode=off"
    return (($city.data.city) -split " ")[0]
}

# NameFake API Key
function Get-Country {
    $rnd = Get-Random -Minimum 1 -Maximum 100
    switch ($rnd) {
        {$_ -ge 1 -and $_ -le 10} {"german_germany"}
        {$_ -ge 11 -and $_ -le 15} {"korean-south-korea"}
        {$_ -ge 16 -and $_ -le 20} {"japanese-japan"}
        {$_ -ge 21 -and $_ -le 23} {"english-australia"}
        {$_ -ge 24 -and $_ -le 40} {"english-united-states"}
        {$_ -ge 41 -and $_ -le 48} {"english-united-kingdom"}
        {$_ -ge 49 -and $_ -le 54} {"english-canada"}
        {$_ -ge 55 -and $_ -le 60} {"french-france"}
        {$_ -ge 61 -and $_ -le 70} {"chinese-china"}
        {$_ -ge 71 -and $_ -le 78} {"arabic-jordan"}
        {$_ -ge 79 -and $_ -le 82} {"italian-italy"}
        {$_ -ge 83 -and $_ -le 90} {"russian-russia"}
        {$_ -ge 91 -and $_ -le 95} {"spanish-spain"}
        {$_ -ge 96 -and $_ -le 100} {"portuguese-brazil"}
    }
}

Function Get-RandomCompany {

    $orgTypeArray = "Systems,Incorporated,Defence,Technologies,Associates,Intergalactic,Services,Industries,Group,Enterprises,Collective,Ventures,Partners,Holdings,Labs,& Son,Brothers,Properties,Development,Dynamics,Consulting,Works,Unlimited,Scientific,Logistics,Brands,Productions,Creative,Media,Limited,Companies"

    $orgTypeArray = $orgTypeArray -split ","

    $orgType = Get-Random -InputObject $orgTypeArray

    $pickSource = Get-Random -Minimum 0 -Maximum 1

    if ($pickSource -eq 0) {

        $country = Get-Country

        $orgName1 = ((Invoke-RestMethod -Uri api.namefake.com/$country/random | Select-Object -ExpandProperty name) -split " ")[1]

        $orgName1 = (Translate-Name -Text $($orgName1) -TargetLanguage English) -split " " | Select-Object -First 1

    } else {

        $orgName1 = Get-CityName

    }

    $orgName = ("$orgName1 $orgType").Trim()

    return $orgName

}

foreach (
Get-RandomCompany