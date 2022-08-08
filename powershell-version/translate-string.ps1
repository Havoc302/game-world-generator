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
        'Hindi',
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
    #elseif (Test-Path $Text -PathType Leaf) {
    #    $Text = Get-Content $Text -Raw
    #}
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
    
    return (Get-Culture).TextInfo.ToTitleCase($Translation)
}

((Translate-Name -Text $args[0] -TargetLanguage English) -replace "[^a-zA-Z\s:]").Trim()
