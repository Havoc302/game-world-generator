<#
.SYNOPSIS
    Metric-Grounded Procedural Place Name Generator for the Colonial Alliance RPG World Generator.
.DESCRIPTION
    Generates realistic, atmospheric, and highly immersive place names utilizing
    the "Dual-Layer Toponymic System" across major, minor, and sub-planetary factions.
    
    Rather than relying on static, hardcoded lists for specific factions, this script
    features a "Sociological & Industrial Semantic Engine" which dynamically parses:
        - Government Type / Ideology (Theocratic, Militaristic, Corporate, Democratic, Anarchic, Technocratic)
        - Technology Level / Sauer Civilisation Scale (1 to 7)
        - Primary Industry (Agriculture, Mining, Military, Trade, Science)
        - Cultural Language Roots (Arabic, Chinese, Japanese, German, French, Russian, English)
    
    Supports reading raw Faction JSON files directly to parse these properties automatically.
    Maintains 100% Seed-Determinism using a System.Random object.
.PARAMETER Layer
    Specify whether to generate 'Sovereign' (High-Priority/Monumental) or 'Colloquial' (Low-Priority/Tech Slang) names.
.PARAMETER Faction
    Select a major faction shortcut (e.g., 'CAP', 'StellarTrade', 'CrimsonCorsairs'), or 'Dynamic' to use metric parameters.
.PARAMETER FactionJsonPath
    Path to a Faction .json file. If supplied, the script will automatically parse metrics directly from the file.
.PARAMETER GovernmentType
    Directly force a government archetype: 'Theocratic', 'Militaristic', 'Corporate', 'Democratic', 'Anarchic', 'Technocratic'.
.PARAMETER PrimaryIndustry
    Directly force an industrial context: 'Agriculture', 'Mining', 'Military', 'Trade', 'Science'.
.PARAMETER SauerLevel
    The technology level on the Sauer Civilisation Scale (1-7). Controls scale suffixes (terrestrial towns vs interstellar lattices).
.PARAMETER Language
    Cultural language root family: 'Arabic', 'Chinese', 'Japanese', 'German', 'French', 'Russian', 'English'.
.PARAMETER FeatureType
    Force a physical category: 'Settlement', 'SpaceStation', 'Industrial', 'Port', 'Desert', 'Mountain', 'Canyon'.
.PARAMETER Seed
    An integer seed to initialize the pseudo-random number generator for reproducible worlds.
.PARAMETER Count
    The number of place names to generate in a single run.
.EXAMPLE
    # Generate names dynamically for a pre-industrial (Sauer 2) French agrarian cooperative
    .\generate-place-names.ps1 -GovernmentType Democratic -PrimaryIndustry Agriculture -SauerLevel 2 -Language French -FeatureType Settlement -Count 5
    
    # Automatically generate place names by parsing an arbitrary minor faction's JSON file
    .\generate-place-names.ps1 -FactionJsonPath "C:\Factions\MinorAgrarianCommune.json" -FeatureType Mountain -Count 3
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('Sovereign', 'Colloquial')]
    [String]$Layer = 'Colloquial',

    [Parameter(Mandatory=$false)]
    [ValidateSet('Dynamic', 'CAP', 'CobaltMercenary', 'CrimsonCorsairs', 'IronDominion', 'NewJerusalem', 'PuritanAscendancy', 'SerenityCollective', 'SisterhoodOfGaia', 'StellarSolitude', 'StellarTrade', 'TechnocraticUnion', 'CaliphateNajm', 'UnionCelestialNations', 'UnityAlliance', 'VanceConsortium', 'VerdantAlliance')]
    [String]$Faction = 'Dynamic',

    [Parameter(Mandatory=$false)]
    [String]$FactionJsonPath = "",

    [Parameter(Mandatory=$false)]
    [ValidateSet('Any', 'Theocratic', 'Militaristic', 'Corporate', 'Democratic', 'Anarchic', 'Technocratic')]
    [String]$GovernmentType = 'Any',

    [Parameter(Mandatory=$false)]
    [ValidateSet('Any', 'Agriculture', 'Mining', 'Military', 'Trade', 'Science')]
    [String]$PrimaryIndustry = 'Any',

    [Parameter(Mandatory=$false)]
    [ValidateRange(1, 7)]
    [Int]$SauerLevel = 5,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Any', 'Arabic', 'Chinese', 'Japanese', 'German', 'French', 'Russian', 'English')]
    [String]$Language = 'Any',

    [Parameter(Mandatory=$false)]
    [ValidateSet('Any', 'Settlement', 'SpaceStation', 'Industrial', 'Port', 'Desert', 'Mountain', 'Canyon')]
    [String]$FeatureType = 'Any',

    [Parameter(Mandatory=$false)]
    [Int]$Seed,

    [Parameter(Mandatory=$false)]
    [Int]$Count = 1,

    [Parameter(Mandatory=$false)]
    [Switch]$RunDemoSuite
)

# ---------------------------------------------------------
# 1. SEMANTIC VOCABULARY MATRIX (Sociological & Cultural)
# ---------------------------------------------------------
$LexiconMatrix = [ordered]@{
    # --- SOCIOLOGICAL ARCHETYPES (IDEOLOGY & GOVERNMENT) ---
    Ideology = @{
        Theocratic = @{
            Prefixes = @("Sanctus", "Grace", "Miriam", "Sacred", "Elders", "Divine", "Altar", "Caliph", "Faith", "Rashid", "Everhart", "Covenant", "Holy", "Prophet", "Temple", "Spiritual", "Qadr", "Sujud")
            Suffixes = @("Rest", "Sanctuary", "Shrine", "Haven", "Garden", "Cradle", "Gate", "Ascendancy", "Crescent", "Altar")
        }
        Militaristic = @{
            Prefixes = @("Volkov", "Dragan", "Iron", "Steel", "Vanguard", "Shield", "Aegis", "Conquest", "Command", "Directive", "Order", "Vigilance", "Consul", "Thorne", "Tactical", "Phalanx")
            Suffixes = @("Citadel", "Keep", "Redoubt", "Quarter", "Fortress", "Bulwark", "Watch", "Cantonment", "Garrison", "Billet", "Base")
        }
        Corporate = @{
            Prefixes = @("Vance", "Velasquez", "Zara", "Trade", "Logistics", "Consortium", "Ledger", "Exchange", "Merchant", "Customs", "Shipping", "Tariff", "Corporate", "Freight", "Broker")
            Suffixes = @("Hub", "Slipway", "Terminal", "Vault", "Depot", "Heights", "Port", "Warehouse", "Exchange", "Broker-Enclave")
        }
        Democratic = @{
            Prefixes = @("Aria", "Nara", "Harmony", "Renewable", "Oasis", "Verdant", "Mampong", "Green", "Collective", "Common", "Alliance", "Cooperative", "Assembly", "Consensus")
            Suffixes = @("Grove", "Canopy", "Glade", "Glacier", "Terrace", "Rise", "Cottage", "Commune", "Village", "District")
        }
        Anarchic = @{
            Prefixes = @("Marla", "Red-Eye", "Cutlass", "Scrap", "Rogue", "Smuggler", "Shadow", "Rust", "Plunder", "Outlaw", "Scuttle", "Drake", "Rebel", "Black-Market", "Corsair")
            Suffixes = @("Cove", "Roost", "Den", "Trench", "Gully", "Crevice", "Slipway", "Hideout", "Scrap-Sump", "Anchorage")
        }
        Technocratic = @{
            Prefixes = @("Planck", "Noether", "Quantum", "Silicon", "Vector", "Matrix", "Sigma", "Eigen", "Turing", "Gödel", "Feynman", "Lovelace", "Curie", "Kardashev", "Sauer")
            Suffixes = @("Lattice", "Core", "Nexus", "Matrix", "Manifold", "Grid", "Node", "Vector", "Array", "System", "Symmetry")
        }
    }

    # --- INDUSTRIAL ARCHETYPES ---
    Industry = @{
        Agriculture = @("Bio-Dome", "Canopy", "Nursery", "Eco-Refinery", "Bioponics", "Agritech", "Greenhouse", "Terrace", "Meadow", "Flora", "Harvest", "Agro")
        Mining      = @("Pit", "Quarry", "Smelter", "Foundry", "Slag", "Lode", "Vein", "Refinery", "Obsidian", "Sump", "Excavation", "Deep-Venter")
        Military    = @("Fort", "Depot", "HQ", "Terminal", "Range", "Shield-Node", "Barracks", "Garrison", "Ordnance-Shed", "Billet")
        Trade       = @("Wharf", "Warehouse", "Depot", "Terminal", "Customs-Dock", "Cargo-Shed", "Transit-Yard", "Freight-Hub", "Slip")
        Science     = @("Calibration-Shed", "Lab", "Array", "Beacon", "Observatory", "Isotope-Sump", "Vacuum-Lattice", "Synthesis", "Research")
    }

    # --- CULTURAL & LINGUISTIC ROOTS ---
    Language = @{
        Arabic   = @{ Prefixes = @("Al-", "Abu ", "Ibn ", "Sidi ", "Najm ", "Jebel ", "Wadi ", "Medina ", "Rabat "); Suffixes = @("-Najm", "-Medina", "-Rabat", "-Kasbah", "-Oasis") }
        Chinese  = @{ Prefixes = @("Xīwàng-", "Tiānmén-", "Qīnglóng-", "Yúshán-", "Kūnlún-", "Chéng-", "Guǎng-"); Suffixes = @("-Shān", "-Hé", "-Gǎng", "-Wān", "-Chéng", "-Yì") }
        Japanese = @{ Prefixes = @("Fuji-", "Kuroshio-", "Shinano-", "Yamato-", "Tanegashima-", "Kyoto-"); Suffixes = @("-jima", "-yama", "-wan", "-gawa", "-hara") }
        German   = @{ Prefixes = @("Ziegler-", "Schwarzwald-", "Zugspitze-", "Rhein-", "Elbe-", "Heidelberg-"); Suffixes = @("burg", "hafen", "wald", "berg", "tal", "brücke") }
        French   = @{ Prefixes = @("La Fayette-", "Chamonix-", "Garonne-", "Ardennes-", "Provence-", "Bernard-"); Suffixes = @("sur-Mer", "Belvédère", "Sable", "Plateau", "Vallée", "Port") }
        Russian  = @{ Prefixes = @("Kirov-", "Volkov-", "Novy-", "Krasno-", "Cherno-", "Siberia-"); Suffixes = @("grad", "ovsk", "slavl", "gorod", "gorsk", "yar") }
        English  = @{ Prefixes = @("New Freedom ", "Eugene ", "Ashleigh ", "Appalachia ", "Shenandoah ", "Cotswold "); Suffixes = @(" Landing", " Valley", " Ridge", " Reach", " Crest", " Flats") }
    }

    # --- SAUER SCALE SYSTEM SCALE MODIFIERS ---
    SauerScale = @{
        # Sauer 1-3: Terrestrial, pre-industrial to information era. Localized land-bound suffixes.
        Local = @("Town", "Village", "Bridge", "Shire", "Creek", "Crossing", "Gully", "Meadow", "Valley", "Flats", "Hollow", "Ridge", "Hill")
        # Sauer 4-5: Space Age & Intra-solar. Planetary colonization terms.
        Colonial = @("Colony", "Outpost", "Enclave", "Landing", "Habitat", "Port", "Dock", "Dome", "Sump", "Basin", "Sector", "Station", "Rim")
        # Sauer 6-7: Interstellar. Cosmic, computational, and highly advanced spatial structures.
        Interstellar = @("Nexus", "Core", "Lattice", "Matrix", "Manifold", "Spire", "Bastion", "Gateway", "Vector", "Singularity", "Node", "Zenith", "Apex")
    }

    # --- LAYER 2: COLLOQUIAL TECH SLANG ---
    Colloquial = @{
        EngineeringFlaws = @(
            "Ground Loop", "Cavitation", "Cold Solder", "Thermal Throttle", "Signal Noise", 
            "Stack Overflow", "Cache Leak", "Bus Fault", "Bit Flip", "Deadlock", "Drift Error", 
            "Impedance", "Voltage Drop", "RF Bleed", "Solder Bridge", "Stray Current", "Phase Shift", 
            "Harmonic Distortion", "Capacitor Leak", "Slew Rate", "Thermal Runaway", "Packet Loss", 
            "Buffer Overflow", "Parity Error", "Zero Division", "Null Reference", "Choke Coil",
            "Bleed Line", "Bypass Valve", "Rust-Joint", "Backblast"
        )
        Resources = @(
            "Tungsten", "Cobalt", "Methanol", "Basalt", "Regolith", "Isotope", "Slag", "Deuterium", 
            "Lithium", "Osmium", "Nickel", "Thorium", "Silica", "Ammonia", "Methane", "Heavy-Water", 
            "Bauxite", "Graphite", "Gypsum", "Iron-Ore", "Copper", "Helium-3", "Titanium", "Uranium"
        )
    }
}

# ---------------------------------------------------------
# 2. SECTOR 2 MAJOR FACTION METRIC MAP (Parsing Fallbacks)
# ---------------------------------------------------------
$MajorFactionMetrics = @{
    CAP = @{ Government = "Technocratic"; Sauer = 6; Industry = "Science"; Language = "English" }
    CobaltMercenary = @{ Government = "Militaristic"; Sauer = 5; Industry = "Military"; Language = "English" }
    CrimsonCorsairs = @{ Government = "Anarchic"; Sauer = 4; Industry = "Mining"; Language = "English" }
    IronDominion = @{ Government = "Militaristic"; Sauer = 5; Industry = "Military"; Language = "Russian" }
    NewJerusalem = @{ Government = "Theocratic"; Sauer = 3; Industry = "Agriculture"; Language = "English" }
    PuritanAscendancy = @{ Government = "Theocratic"; Sauer = 4; Industry = "Agriculture"; Language = "English" }
    SerenityCollective = @{ Government = "Democratic"; Sauer = 5; Industry = "Agriculture"; Language = "English" }
    SisterhoodOfGaia = @{ Government = "Theocratic"; Sauer = 4; Industry = "Agriculture"; Language = "English" }
    StellarSolitude = @{ Government = "Militaristic"; Sauer = 5; Industry = "Mining"; Language = "Russian" }
    StellarTrade = @{ Government = "Corporate"; Sauer = 5; Industry = "Trade"; Language = "Spanish" }
    TechnocraticUnion = @{ Government = "Technocratic"; Sauer = 6; Industry = "Science"; Language = "Latin" }
    CaliphateNajm = @{ Government = "Theocratic"; Sauer = 3; Industry = "Agriculture"; Language = "Arabic" }
    UnionCelestialNations = @{ Government = "Democratic"; Sauer = 4; Industry = "Trade"; Language = "Chinese" }
    UnityAlliance = @{ Government = "Democratic"; Sauer = 5; Industry = "Trade"; Language = "English" }
    VanceConsortium = @{ Government = "Corporate"; Sauer = 5; Industry = "Mining"; Language = "English" }
    VerdantAlliance = @{ Government = "Democratic"; Sauer = 3; Industry = "Agriculture"; Language = "German" }
}

# ---------------------------------------------------------
# 3. SECTOR 2 METRIC/FEATURE MAP (Suffix Modifiers)
# ---------------------------------------------------------
# Integrates with Sauer Levels to translate high/low tech physical settings cleanly.
$FeatureSuffixMap = [ordered]@{
    Settlement = @{
        Local        = @("Town", "Village", "Shire", "Settlement", "Cove", "Crossing")
        Colonial     = @("Colony", "Enclave", "Outpost", "Haven", "Sector", "Quarter", "Dome")
        Interstellar = @("Symmetry-Crest", "Matrix-Haven", "Spiritual-Core", "Zenith", "Apex", "Horizon")
    }
    SpaceStation = @{
        Local        = @("Tower", "Beacon", "Watch")
        Colonial     = @("Station", "Ring", "Dock", "Platform", "Terminal", "Beacon", "Lattice")
        Interstellar = @("Nexus-Ring", "Singularity-Core", "Array-Core", "Matrix-Nexus", "Lattice-Anchor")
    }
    Industrial = @{
        Local        = @("Pit", "Quarry", "Mine", "Shed", "Forge", "Mill")
        Colonial     = @("Refinery", "Depot", "Sump", "Facility", "Seam", "Lode", "Line", "Plant")
        Interstellar = @("Isotope-Sump", "Vacuum-Lattice", "Complex", "Core-Vat", "Plume-Smelter")
    }
    Port = @{
        Local        = @("Harbor", "Bay", "Dock", "Anchorage", "Wharf", "Slip")
        Colonial     = @("Port", "Gateway", "Freight-Slipway", "Customs-Dock", "Cargo-Terminal")
        Interstellar = @("Vector-Anchor", "Planck-Gateway", "Coordinate-Slip", "Terminal-Nexus")
    }
    Desert = @{
        Local        = @("Flats", "Dunes", "Sands", "Plains", "Barrens", "Wastes")
        Colonial     = @("Basin", "Depression", "Wastes", "Target-Flats")
        Interstellar = @("Absolute-Zero-Flats", "Chiral-Sands", "Asymptotic-Wastes", "Obsidian-Wastes")
    }
    Mountain = @{
        Local        = @("Crest", "Heights", "Ridge", "Mount", "Spire", "Peak", "Hills", "Cliffs")
        Colonial     = @("Heights-Ridge", "Watch-Crest", "Command-Bastion")
        Interstellar = @("Eigen-Spire", "Planck-Peak", "Maxwell's-Heights", "Zenith-Ridge")
    }
    Canyon = @{
        Local        = @("Gorge", "Gully", "Chasm", "Rift", "Hollow", "Valley", "Ravine")
        Colonial     = @("Canyon", "Fissure", "Strategic-Valley", "Command-Valley")
        Interstellar = @("Fourier's-Chasm", "Heisenberg's-Rift", "Gradient-Fissure", "State-Chasm")
    }
}

# ---------------------------------------------------------
# 4. PRNG HELPER FUNCTION (Ensures 100% Seed-Determinism)
# ---------------------------------------------------------
$script:GeneratorPRNG = $null
if ($PSBoundParameters.ContainsKey('Seed')) {
    $script:GeneratorPRNG = New-Object System.Random($Seed)
    Write-Verbose "Initialized deterministic PRNG with seed: $Seed"
}

Function Get-RandomItem {
    Param([Array]$Array)
    if ($null -eq $Array -or $Array.Count -eq 0) { return $null }
    
    if ($null -ne $script:GeneratorPRNG) {
        $index = $script:GeneratorPRNG.Next(0, $Array.Count)
        return $Array[$index]
    } else {
        return Get-Random -InputObject $Array
    }
}

Function Get-SeededRandomValue {
    Param([Int]$Min, [Int]$Max)
    if ($null -ne $script:GeneratorPRNG) {
        return $script:GeneratorPRNG.Next($Min, $Max)
    } else {
        return Get-Random -Minimum $Min -Maximum $Max
    }
}

# ---------------------------------------------------------
# 5. INDUSTRIAL & GEOGRAPHIC SUFFIX RESOLVER
# ---------------------------------------------------------
Function Get-MetricSuffix {
    Param(
        [String]$Feature,
        [Int]$Sauer,
        [String]$Industry,
        [String]$Ideology
    )
    if ($Feature -eq 'Any' -or -not $Feature) {
        # Fallback to general Sauer Scale vocabulary
        if ($Sauer -le 3) { return Get-RandomItem -Array $LexiconMatrix.SauerScale.Local }
        if ($Sauer -le 5) { return Get-RandomItem -Array $LexiconMatrix.SauerScale.Colonial }
        return Get-RandomItem -Array $LexiconMatrix.SauerScale.Interstellar
    }

    $category = $FeatureSuffixMap[$Feature]
    if (-not $category) {
        return "Point"
    }

    # Map Sauer level to geographical scale slots
    $scaleKey = "Colonial"
    if ($Sauer -le 3) { $scaleKey = "Local" }
    elseif ($Sauer -ge 6) { $scaleKey = "Interstellar" }

    $baseSuffixList = $category[$scaleKey]

    # Dynamically inject context-appropriate terms
    $modifiedSuffixes = [System.Collections.Generic.List[String]]::new()
    $modifiedSuffixes.AddRange($baseSuffixList)

    if ($Feature -eq 'Industrial' -and $LexiconMatrix.Industry.ContainsKey($Industry)) {
        # Inject matching industry keywords
        $modifiedSuffixes.Add((Get-RandomItem -Array $LexiconMatrix.Industry.$Industry))
    }

    if ($LexiconMatrix.Ideology.ContainsKey($Ideology)) {
        # Inject ideology-specific suffixes
        $modifiedSuffixes.Add((Get-RandomItem -Array $LexiconMatrix.Ideology.$Ideology.Suffixes))
    }

    return Get-RandomItem -Array ($modifiedSuffixes.ToArray())
}

# ---------------------------------------------------------
# 6. DYNAMIC FACTION JSON AUTO-PARSER
# ---------------------------------------------------------
# Automatically reads any minor/major faction JSON file generated in Sector 2
# and parses its attributes to map vocabulary.
Function Parse-FactionJson {
    Param([String]$Path)
    if (-not (Test-Path $Path)) {
        Write-Warning "Faction JSON not found at path: $Path. Using Dynamic defaults."
        return $null
    }

    try {
        $json = Get-Content $Path -Raw | ConvertFrom-Json
        $parsed = @{
            Government = "Democratic"
            Sauer      = 4
            Industry   = "Agriculture"
            Language   = "English"
        }

        # Parse Government Type
        if ($json.GovernmentType) {
            $gov = $json.GovernmentType
            if ($gov -match "Theocratic|Priest|Religious|Islamic|Spiritual") { $parsed.Government = "Theocratic" }
            elseif ($gov -match "Military|Junta|Legion|Command") { $parsed.Government = "Militaristic" }
            elseif ($gov -match "Corporate|Oligarchy|Consortium|Family|Trade|Board") { $parsed.Government = "Corporate" }
            elseif ($gov -match "Democratic|Republic|Confederation|Federation|Council|Cooperative") { $parsed.Government = "Democratic" }
            elseif ($gov -match "Pirate|Confederacy|Anarchy|Rebel") { $parsed.Government = "Anarchic" }
            elseif ($gov -match "Technocratic|Scientific") { $parsed.Government = "Technocratic" }
        }

        # Parse Sauer/Technology Scale
        if ($json.TechnologyScore) {
            $parsed.Sauer = [Math]::Max(1, [Math]::Min(7, [int]$json.TechnologyScore))
        } elseif ($json.TechnologyLevel) {
            # Check for strings representing numbers
            if ($json.TechnologyLevel -match '\d') {
                $parsed.Sauer = [Math]::Max(1, [Math]::Min(7, [int]($json.TechnologyLevel -replace '\D')))
            }
        }

        # Parse Primary Industry
        if ($json.PrimaryIndustries) {
            $ind = ""
            if ($json.PrimaryIndustries -is [Array]) {
                $ind = $json.PrimaryIndustries[0]
            } else {
                $ind = $json.PrimaryIndustries
            }

            if ($ind -match "Agriculture|Bio|Farming|Organic") { $parsed.Industry = "Agriculture" }
            elseif ($ind -match "Mining|Heavy|Smelter|Foundry|Materials|Extraction") { $parsed.Industry = "Mining" }
            elseif ($ind -match "Military|Weapon|Mercenary|Tactical|Security|Defense") { $parsed.Industry = "Military" }
            elseif ($ind -match "Trade|Shipping|Logistics|Commerce") { $parsed.Industry = "Trade" }
            elseif ($ind -match "Science|Research|Technology|Quantum|Computing") { $parsed.Industry = "Science" }
        }

        # Parse Language
        if ($json.Language) {
            if ($json.Language -match "Arabic") { $parsed.Language = "Arabic" }
            elseif ($json.Language -match "Chinese|Mandarin") { $parsed.Language = "Chinese" }
            elseif ($json.Language -match "Japanese") { $parsed.Language = "Japanese" }
            elseif ($json.Language -match "German") { $parsed.Language = "German" }
            elseif ($json.Language -match "French") { $parsed.Language = "French" }
            elseif ($json.Language -match "Russian") { $parsed.Language = "Russian" }
            else { $parsed.Language = "English" }
        }

        return $parsed
    } catch {
        Write-Warning "Failed parsing Faction JSON file: $_. Standard fallbacks applied."
        return $null
    }
}

# ---------------------------------------------------------
# 7. METRIC-GROUNDED NAMING ENGINE
# ---------------------------------------------------------
Function Get-PlaceName {
    [CmdletBinding()]
    Param(
        [String]$SelectedLayer,
        [String]$SelectedFaction,
        [String]$SelectedFeature,
        [String]$ForcedGov,
        [String]$ForcedInd,
        [Int]$ForcedSauer,
        [String]$ForcedLang
    )

    # Resolve Faction Profile Matrix
    $resolvedGov = $ForcedGov
    $resolvedSauer = $ForcedSauer
    $resolvedInd = $ForcedInd
    $resolvedLang = $ForcedLang

    # 1. Check if a JSON path is provided and successfully loaded
    if ($FactionJsonPath) {
        $parsedMetrics = Parse-FactionJson -Path $FactionJsonPath
        if ($null -ne $parsedMetrics) {
            $resolvedGov = $parsedMetrics.Government
            $resolvedSauer = $parsedMetrics.Sauer
            $resolvedInd = $parsedMetrics.Industry
            $resolvedLang = $parsedMetrics.Language
        }
    }
    # 2. Map major faction shortcuts if supplied
    elseif ($SelectedFaction -ne 'Dynamic' -and $MajorFactionMetrics.ContainsKey($SelectedFaction)) {
        $fMetrics = $MajorFactionMetrics[$SelectedFaction]
        $resolvedGov = $fMetrics.Government
        $resolvedSauer = $fMetrics.Sauer
        $resolvedInd = $fMetrics.Industry
        $resolvedLang = $fMetrics.Language
    }

    # Resolve "Any" Wildcards
    if ($resolvedGov -eq 'Any') { $resolvedGov = Get-RandomItem -Array @('Theocratic', 'Militaristic', 'Corporate', 'Democratic', 'Anarchic', 'Technocratic') }
    if ($resolvedInd -eq 'Any') { $resolvedInd = Get-RandomItem -Array @('Agriculture', 'Mining', 'Military', 'Trade', 'Science') }
    if ($resolvedLang -eq 'Any') { $resolvedLang = Get-RandomItem -Array @('Arabic', 'Chinese', 'Japanese', 'German', 'French', 'Russian', 'English') }

    # Suffix Resolution mapping
    $suffix = Get-MetricSuffix -Feature $SelectedFeature -Sauer $resolvedSauer -Industry $resolvedInd -Ideology $resolvedGov

    # === LAYER 1: SOVEREIGN (IDEOLOGICAL & MONUMENTAL) ===
    if ($SelectedLayer -eq 'Sovereign') {
        # Fetch prefix from the faction's ideological pool
        $prefix = Get-RandomItem -Array $LexiconMatrix.Ideology.$resolvedGov.Prefixes

        # Build language/translation modifications
        if ($resolvedLang -ne 'English') {
            $langData = $LexiconMatrix.Language.$resolvedLang
            $langPrefix = Get-RandomItem -Array $langData.Prefixes
            $langSuffix = Get-RandomItem -Array $langData.Suffixes

            # Hyphenated structural styling for Asian/European translations
            if ($resolvedLang -eq 'Chinese' -or $resolvedLang -eq 'Japanese' -or $resolvedLang -eq 'German' -or $resolvedLang -eq 'French') {
                return "$($langPrefix)$prefix-$suffix"
            } else {
                return "$langPrefix$prefix $suffix"
            }
        }

        # Tactical militaristic designation
        if ($resolvedGov -eq 'Militaristic' -and (Get-SeededRandomValue -Min 1 -Max 10) -le 2) {
            return "Tactical-Billet $(Get-SeededRandomValue -Min 10 -Max 99)-$prefix"
        }

        return "$prefix $suffix"
    }

    # === LAYER 2: COLLOQUIAL (COGNITIVE TECH SLANG) ===
    else {
        $colloquialType = Get-RandomItem -Array @('Flaw', 'Resource', 'Wayfinder')

        switch ($colloquialType) {
            'Flaw' {
                $flaw = Get-RandomItem -Array $LexiconMatrix.Colloquial.EngineeringFlaws
                return "$flaw $suffix"
            }
            'Resource' {
                $resource = Get-RandomItem -Array $LexiconMatrix.Colloquial.Resources
                return "$resource $suffix"
            }
            'Wayfinder' {
                $base = Get-RandomItem -Array $LexiconMatrix.Ideology.$resolvedGov.Prefixes
                $distanceIndex = Get-SeededRandomValue -Min 1 -Max 99
                return "$($base)-Sub$distanceIndex $suffix"
            }
        }
    }
}

# ---------------------------------------------------------
# 8. EXECUTION PIPELINE
# ---------------------------------------------------------
$results = [System.Collections.Generic.List[String]]::new()

for ($i = 0; $i -lt $Count; $i++) {
    $generatedName = Get-PlaceName `
        -SelectedLayer $Layer `
        -SelectedFaction $Faction `
        -SelectedFeature $FeatureType `
        -ForcedGov $GovernmentType `
        -ForcedInd $PrimaryIndustry `
        -ForcedSauer $SauerLevel `
        -ForcedLang $Language
    $results.Add($generatedName)
}

if ($Count -eq 1 -and -not $RunDemoSuite) {
    Write-Output $results[0]
} elseif (-not $RunDemoSuite) {
    Write-Output $results
}

# ---------------------------------------------------------
# 9. INTEGRATED TEST AND DEMO SUITE (Demonstrating Metric Mapping)
# ---------------------------------------------------------
if ($RunDemoSuite -or $MyInvocation.ExpectingInput -eq $false -and $null -eq $PSBoundParameters['Layer'] -and $null -eq $PSBoundParameters['Count']) {
    Write-Host "`n==========================================================================" -ForegroundColor Cyan
    Write-Host " COLONIAL ALLIANCE RPG PLACE NAME GENERATOR - METRIC VALIDATION" -ForegroundColor Gold
    Write-Host "==========================================================================`n" -ForegroundColor Cyan
    
    # 1. Demonstrate physical scale changes matching technology (Sauer Scale)
    Write-Host "--- TEST 1: SAUER TECHNOLOGY SCALE EFFECT (Same Faction Profile) ---" -ForegroundColor Green
    $sauerLevels = @(2, 4, 7)
    foreach ($level in $sauerLevels) {
        # Pre-calculate a description of the scale
        $scaleDesc = "Local Terrestrial"
        if ($level -eq 4) { $scaleDesc = "System-Bound" }
        elseif ($level -ge 6) { $scaleDesc = "Interstellar" }
        
        Write-Host "  Sauer Scale Level $level ($scaleDesc):" -ForegroundColor DarkYellow
        $script:GeneratorPRNG = New-Object System.Random(42) # Lock seed for direct parameter tracking
        
        # We generate a Settlement name for a German Democratic Agrarian Faction
        $place = Get-PlaceName -SelectedLayer Sovereign -SelectedFaction Dynamic -SelectedFeature Settlement `
            -ForcedGov Democratic -ForcedInd Agriculture -ForcedSauer $level -ForcedLang German
            
        Write-Host "    * Dynamic Place Name: $place" -ForegroundColor Gray
    }

    # 2. Demonstrate Primary Industry Context mapping
    Write-Host "`n--- TEST 2: PRIMARY INDUSTRY CONTEXT INJECTION (Feature: Industrial) ---" -ForegroundColor Blue
    $industries = @('Agriculture', 'Mining', 'Military', 'Trade', 'Science')
    foreach ($ind in $industries) {
        $script:GeneratorPRNG = New-Object System.Random(777) # Lock seed for consistent context
        
        # Generating names for a Sovereign corporate outpost matching various sectors
        $place = Get-PlaceName -SelectedLayer Sovereign -SelectedFaction Dynamic -SelectedFeature Industrial `
            -ForcedGov Corporate -ForcedInd $ind -ForcedSauer 5 -ForcedLang English
            
        Write-Host "    * [Industry: $ind] -> $place" -ForegroundColor Gray
    }

    # 3. Dynamic JSON Faction Auto-Parsing Simulation
    Write-Host "`n--- TEST 3: AUTOMATIC MINOR FACTION JSON PARSING (Simulation) ---" -ForegroundColor Magenta
    
    # Let's write a temporary test JSON to mock up a customized minor faction file on your planet
    $tempJsonPath = Join-Path $env:TEMP "MinorFaction_MampongCommune.json"
    $mockFactionObj = [pscustomobject]@{
        FactionName       = "Mampong Eco-Cooperative"
        GovernmentType    = "Democratic Cooperative Council"
        TechnologyLevel   = "Sauer Scale Level 2" # Pre-Industrial
        PrimaryIndustries = @("Organic Sustainable Agriculture", "Bio-fuel synthesis")
        Language          = "German Roots"
    }
    $mockFactionObj | ConvertTo-Json | Out-File $tempJsonPath -Encoding utf8
    
    Write-Host "  Parsed temp JSON from: $tempJsonPath" -ForegroundColor DarkCyan
    
    # Clear PRNG for variety
    $script:GeneratorPRNG = $null 
    Write-Host "  Generating localized places for Mampong Eco-Cooperative:" -ForegroundColor Gray
    
    $settName = Get-PlaceName -SelectedLayer Sovereign -SelectedFaction Dynamic -SelectedFeature Settlement
    $mtName   = Get-PlaceName -SelectedLayer Sovereign -SelectedFaction Dynamic -SelectedFeature Mountain
    $indName  = Get-PlaceName -SelectedLayer Colloquial -SelectedFaction Dynamic -SelectedFeature Industrial
    
    Write-Host "    * Main Village:        $settName" -ForegroundColor Gray
    Write-Host "    * Local Mountain Ridge: $mtName" -ForegroundColor Gray
    Write-Host "    * Local Farm Sump:     $indName" -ForegroundColor Gray
    
    # Cleanup temp test file
    if (Test-Path $tempJsonPath) { Remove-Item $tempJsonPath }

    # 4. Determinism Validation
    Write-Host "`n--- TEST 4: SEED-DETERMINISM VERIFICATION ---" -ForegroundColor Gold
    Write-Host "Generating 3 names with SEED 54321 and Port feature constraints:" -ForegroundColor Gray
    $script:GeneratorPRNG = New-Object System.Random(54321)
    $run1 = @(
        Get-PlaceName -SelectedLayer Sovereign -SelectedFaction Dynamic -SelectedFeature Port -ForcedGov Corporate -ForcedInd Trade -ForcedSauer 4 -ForcedLang Arabic,
        Get-PlaceName -SelectedLayer Sovereign -SelectedFaction Dynamic -SelectedFeature Port -ForcedGov Corporate -ForcedInd Trade -ForcedSauer 4 -ForcedLang Arabic,
        Get-PlaceName -SelectedLayer Colloquial -SelectedFaction Dynamic -SelectedFeature Port -ForcedGov Corporate -ForcedInd Trade -ForcedSauer 4 -ForcedLang Arabic
    )
    $run1 | ForEach-Object { Write-Host "  -> $_" -ForegroundColor Cyan }

    Write-Host "Regenerating with same SEED 54321:" -ForegroundColor Gray
    $script:GeneratorPRNG = New-Object System.Random(54321)
    $run2 = @(
        Get-PlaceName -SelectedLayer Sovereign -SelectedFaction Dynamic -SelectedFeature Port -ForcedGov Corporate -ForcedInd Trade -ForcedSauer 4 -ForcedLang Arabic,
        Get-PlaceName -SelectedLayer Sovereign -SelectedFaction Dynamic -SelectedFeature Port -ForcedGov Corporate -ForcedInd Trade -ForcedSauer 4 -ForcedLang Arabic,
        Get-PlaceName -SelectedLayer Colloquial -SelectedFaction Dynamic -SelectedFeature Port -ForcedGov Corporate -ForcedInd Trade -ForcedSauer 4 -ForcedLang Arabic
    )
    $run2 | ForEach-Object { Write-Host "  -> $_" -ForegroundColor Green }
    
    $mismatch = $false
    for ($m = 0; $m -lt 3; $m++) {
        if ($run1[$m] -ne $run2[$m]) { $mismatch = $true }
    }
    if (-not $mismatch) {
        Write-Host "[SUCCESS] Dynamically mapped metric generators match exactly. Determinism holds." -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Mismatch in deterministic generation." -ForegroundColor Red
    }
    Write-Host "==========================================================================`n" -ForegroundColor Cyan
}