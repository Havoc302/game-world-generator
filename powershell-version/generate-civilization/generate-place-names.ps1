$fix = "Terra Nova,Tesseract,Thalassa,Themyscira,Thule,Tikal,Titan,Tokyo,Transcendence,Utopia,Valhalla,Vega,Vesperia,Vienna,Vulcan,Wakanda,Xanadu,Xenon,Yggdrasil,Zhulong,Zion,Zora,
Nova Aurora,Terra Prime,Arcadia,Stardust Haven,Celestia,Horizon Reach,Nebula Outpost,Solaris Colony,Andromeda Station,Lunar Nexus,Nexus Prime,Elysium Settlement,Orions Haven,
Cosmo Frontier,Serenity Point,Stellaris Enclave,Galactica Outpost,Nova Gaia,Solara Habitat,Saturnia Outpost,Hyperion Station,Zenith City,Pandora Colony,Phobos Outpost,
Apollo Landing,Astral Dominion,Terra Nova,Centauri Colony,Astoria Station,Vortex Encampment,Atlantis Outpost,Nebulus Outpost,Nova Prime,Stardust Outpost,Aetheria Habitat,
Lunaris Settlement,Equinox Encampment,Utopia Station,Cosmo Haven,Seraphim Enclave,Celestial Nexus,Genesis Colony,Nebula Nexus,Epsilon Outpost,Lunar Haven,Artemis Settlement,
Vega Enclave,Pegasus Station,Zenith Colony,Pandora Haven,Phoenix Outpost,Cosmos Encampment,Alpha Prime,Solaris Encampment,Astralis Outpost,Terra Haven,Astra Enclosure,
Orions Reach,New Eden,Novus Terra,Horizon Colony,Lyra Outpost,Aurora Station,Lunaris Enclave,Hyperion Colony,Stardust Nexus,Apollo Outpost,Serenity Settlement,Nebula Haven,
Elysium Encampment,Titan Station,Celestis Outpost,Nova Encampment,Zenith Haven,Pandora Enclave,Artemis Outpost,Solaris Settlement,Nova Terra,Genesis Outpost,Astra Nexus,Astralis Haven,
Phoenix Enclave,Alpha Outpost,Lunaris Colony,Nova Haven,Orions Nexus,Elysium Station,Solara Outpost,Nebula Enclosure,Lyra Colony,Horizon Encampment,Stardust Settlement,Terra Enclave,
Apollo Colony,Celestia Station,Pandora Encampment,Nova Nexus,Serenity Outpost,Zenith Enclave,Astra Outpost" -split ","

$names = @()
$nouns = @()

foreach ($place in $fix) {
    $placeArray = $place -split " "
    Write-Host "Name: $($placeArray[0].trim())"
    $names += $placeArray[0]+","
    Write-Host "Noun: $($placeArray[1].trim())"
    $nouns += $placeArray[1]
}

$names


$townNames = ("Johnville, Londontown, Emilyburgh, Parishire, Micheltown, New Yorkton, Sophiaville, Tokyoburg, Davidsburg, Berlinville, Emma City, Sydneyton,
Williamstown, Romeville, Oliviatown, Barcelonaville, Jamesville, Vienna City, Charlotteburg, Pragueville, Danielton, Amsterdamtown, Avashire, Stockholmton,
Matthewville, Dublinburg, Gracetown, Athenstown, Benjaminville, Moscowton, Mia City, Cairoville, Jacobville, Seoulton, Sofiaburg, Beijington, Alexanderburg,
Bangkokville, Harper City, Oslotown, Loganton, Helsinkiburg, Liamville, Lisbonshire, Ariatown, Mumbaiton, Ethanburg, Rio de Janeirotown, Ellaville, Torontoburg,
Josephville, Melbournetown, Madisonton, San Franciscoburg, Oliver City, Vancouverton, Chloeville, Dubaitown, Danielburg, Zurichville, Ameliashire, Edinburghtown,
Lucastown, Singapore City, Lilyburg, Budapeston, Sebastianton, Veniceville, Averytown, Copenhagenville, Henryville, Krakowtown, Evelynburg, Reykjavikton, Jackville,
Havatown, Abigailburg, Florenceville, Andrewton, Jerusalemtown, Elizabethtown, Cape City, Owentown, Nairobiburg, Victoriaville, Montrealton, Ryanton, Wellingtonburg,
Averyton, Dublinville, Scarletttown, Viennashire, Nathantown, Mexico Cityville, Gracetown, Osakaville, Samuelton, Buenos Airestown, Hannahburg, Gabrielton,
Maricenter, Harrisity, Emervillage, Griffhamlet, Sawyertown, Bennettpolis, Delaneyside, Maddoxsettlement, Kingstonham, Sulligrove, Presleywood, Jaxonville,
Bradytown, Reagancity, Paxtonville, Emersonburg, Alainatown, Zaratropolis, Kieraville, Declanhamlet, Landrytown, Selahside, Lennoxsettlement, Lilaport,
Trevormouth, Matteoville, Kallieborough, Zuritown, Finnleyopolis, Anahiville, Casetown, Lelandside, Simeonville, Hadleighham, Avianagrove, Kendracity,
Crewcenter, Alvaroville, Amaliamunity, Ettatown, Samsonhamlet, Analiatown, Colbysettlement, Marlonham, Lucianville, Gracelyncity, Ceciliaside, Aleahport,
Keatonmouth, Jaylenetown, Uriahburg, Ainsleyhamlet, Jayleencenter, Callentown, Frankieside, Adrienvillage, Blaisesettlement, Sariahham, Marcellusgrove,
Miracenter, Kaisoncity, Raquelville, Kodyside, Katalinatown, Bridgertropolis, Marensettlement, Channingham, Jovanniburg, Keiratown, Nathalyhamlet, Ronanville,
Miragrove, Kaisonham, Reagancenter, Sawyerburg, Emerytown, Mariaport, Maddoxside, Harpersettlement, Griffinsburg, Kingstonhamlet, Sullivanville, Zaratgrove,
Lennoxham, Anahitown, Selahcenter, Landrycity, Reaganham, Kendraville, Crewtown, Matteohamlet, Alvaroburg, Lilasettlement, Hadleighport, Uriahside, Callieville,
Emersontown, Marcellusburg, Ainsleyham, Jaxonhamlet, Bradyburg, Harpercenter, Sawyerham, Kingstonville, Sullivanhamlet, Reaganport, Delaneycenter, Maddoxville,
Zaratburg, Kieraopolis, Lennoxcity, Selahhamlet, Emerytown, Sawyerport, Harpercenter, Jaxonsettlement, Emersonham, Kingstoncenter, Reaganhamlet, Zaratville,
Selahside, Lennoxhamlet, Emerytown, Sawyerport, Harpercenter, Jaxonsettlement, Emersonham, Kingstoncenter, Reaganhamlet, Zaratville, Selahside, Lennoxhamlet,
Emerytown, Sawyerport, Harpercenter, Jaxonsettlement, Emersonham, Kingstoncenter, Reaganhamlet, Zaratville, Selahside, Lennoxhamlet, Emerytown, Sawyerport,
Harpercenter, Jaxonsettlement, Emersonham, Kingstoncenter, Reaganhamlet, Zaratville, Selahside, Lennoxhamlet, Emerytown, Sawyerport, Harpercenter,
Jaxonsettlement, Emersonham, Kingstoncenter, Reaganhamlet, Zaratville, Selahside, Lennoxhamlet, Emerytown, Sawyerport, Harpercenter, Jaxonsettlement,
Emersonham, Kingstoncenter, Reaganhamlet, Zaratville, Selahside, Lennoxhamlet, Emerytown, Sawyerport, Harpercenter, Jaxonsettlement, Emersonham" -split ",").trim()