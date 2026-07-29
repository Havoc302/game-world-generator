// Seed-deterministic name generator for Colonial Alliance RPG web version.
// Replicates the logic of generate_place_names_script.ps1 and generator-random-character.ps1.

// Mulberry32 Seeded Random Generator
export function createRNG(seed) {
  let s = seed | 0;
  return function() {
    s = (s + 0x6D2B79F5) | 0;
    let t = Math.imul(s ^ (s >>> 15), 1 | s);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export function getRandomItem(array, rng) {
  if (!array || array.length === 0) return null;
  const index = Math.floor(rng() * array.length);
  return array[index];
}

export function getSeededRandomValue(min, max, rng) {
  return min + Math.floor(rng() * (max - min));
}

// Memory database for fetched names
export const namesDb = {
  namesMaster: [],
  femaleFirstNames: [],
  maleFirstNames: [],
  societies: [],
  isLoaded: false
};

// Available Faction shortcuts matching MajorFactionMetrics in generate_place_names_script.ps1
export const MAJOR_FACTION_METRICS = {
  CAP: { Government: "Technocratic", Sauer: 6, Industry: "Science", Language: "English" },
  CobaltMercenary: { Government: "Militaristic", Sauer: 5, Industry: "Military", Language: "English" },
  CrimsonCorsairs: { Government: "Anarchic", Sauer: 4, Industry: "Mining", Language: "English" },
  IronDominion: { Government: "Militaristic", Sauer: 5, Industry: "Military", Language: "Russian" },
  NewJerusalem: { Government: "Theocratic", Sauer: 3, Industry: "Agriculture", Language: "English" },
  PuritanAscendancy: { Government: "Theocratic", Sauer: 4, Industry: "Agriculture", Language: "English" },
  SerenityCollective: { Government: "Democratic", Sauer: 5, Industry: "Agriculture", Language: "English" },
  SisterhoodOfGaia: { Government: "Theocratic", Sauer: 4, Industry: "Agriculture", Language: "English" },
  StellarSolitude: { Government: "Militaristic", Sauer: 5, Industry: "Mining", Language: "Russian" },
  StellarTrade: { Government: "Corporate", Sauer: 5, Industry: "Trade", Language: "Spanish" },
  TechnocraticUnion: { Government: "Technocratic", Sauer: 6, Industry: "Science", Language: "Latin" },
  CaliphateNajm: { Government: "Theocratic", Sauer: 3, Industry: "Agriculture", Language: "Arabic" },
  UnionCelestialNations: { Government: "Democratic", Sauer: 4, Industry: "Trade", Language: "Chinese" },
  UnityAlliance: { Government: "Democratic", Sauer: 5, Industry: "Trade", Language: "English" },
  VanceConsortium: { Government: "Corporate", Sauer: 5, Industry: "Mining", Language: "English" },
  VerdantAlliance: { Government: "Democratic", Sauer: 3, Industry: "Agriculture", Language: "German" }
};

// Lexicon Matrix for the Dual-Layer Toponymic System
const LEXICON_MATRIX = {
  Ideology: {
    Theocratic: {
      Prefixes: ["Sanctus", "Grace", "Miriam", "Sacred", "Elders", "Divine", "Altar", "Caliph", "Faith", "Rashid", "Everhart", "Covenant", "Holy", "Prophet", "Temple", "Spiritual", "Qadr", "Sujud"],
      Suffixes: ["Rest", "Sanctuary", "Shrine", "Haven", "Garden", "Cradle", "Gate", "Ascendancy", "Crescent", "Altar"]
    },
    Militaristic: {
      Prefixes: ["Volkov", "Dragan", "Iron", "Steel", "Vanguard", "Shield", "Aegis", "Conquest", "Command", "Directive", "Order", "Vigilance", "Consul", "Thorne", "Tactical", "Phalanx"],
      Suffixes: ["Citadel", "Keep", "Redoubt", "Quarter", "Fortress", "Bulwark", "Watch", "Cantonment", "Garrison", "Billet", "Base"]
    },
    Corporate: {
      Prefixes: ["Vance", "Velasquez", "Zara", "Trade", "Logistics", "Consortium", "Ledger", "Exchange", "Merchant", "Customs", "Shipping", "Tariff", "Corporate", "Freight", "Broker"],
      Suffixes: ["Hub", "Slipway", "Terminal", "Vault", "Depot", "Heights", "Port", "Warehouse", "Exchange", "Broker-Enclave"]
    },
    Democratic: {
      Prefixes: ["Aria", "Nara", "Harmony", "Renewable", "Oasis", "Verdant", "Mampong", "Green", "Collective", "Common", "Alliance", "Cooperative", "Assembly", "Consensus"],
      Suffixes: ["Grove", "Canopy", "Glade", "Glacier", "Terrace", "Rise", "Cottage", "Commune", "Village", "District"]
    },
    Anarchic: {
      Prefixes: ["Marla", "Red-Eye", "Cutlass", "Scrap", "Rogue", "Smuggler", "Shadow", "Rust", "Plunder", "Outlaw", "Scuttle", "Drake", "Rebel", "Black-Market", "Corsair"],
      Suffixes: ["Cove", "Roost", "Den", "Trench", "Gully", "Crevice", "Slipway", "Hideout", "Scrap-Sump", "Anchorage"]
    },
    Technocratic: {
      Prefixes: ["Planck", "Noether", "Quantum", "Silicon", "Vector", "Matrix", "Sigma", "Eigen", "Turing", "Gödel", "Feynman", "Lovelace", "Curie", "Kardashev", "Sauer"],
      Suffixes: ["Lattice", "Core", "Nexus", "Matrix", "Manifold", "Grid", "Node", "Vector", "Array", "System", "Symmetry"]
    }
  },
  Industry: {
    Agriculture: ["Bio-Dome", "Canopy", "Nursery", "Eco-Refinery", "Bioponics", "Agritech", "Greenhouse", "Terrace", "Meadow", "Flora", "Harvest", "Agro"],
    Mining: ["Pit", "Quarry", "Smelter", "Foundry", "Slag", "Lode", "Vein", "Refinery", "Obsidian", "Sump", "Excavation", "Deep-Venter"],
    Military: ["Fort", "Depot", "HQ", "Terminal", "Range", "Shield-Node", "Barracks", "Garrison", "Ordnance-Shed", "Billet"],
    Trade: ["Wharf", "Warehouse", "Depot", "Terminal", "Customs-Dock", "Cargo-Shed", "Transit-Yard", "Freight-Hub", "Slip"],
    Science: ["Calibration-Shed", "Lab", "Array", "Beacon", "Observatory", "Isotope-Sump", "Vacuum-Lattice", "Synthesis", "Research"]
  },
  Language: {
    Arabic: { Prefixes: ["Al-", "Abu ", "Ibn ", "Sidi ", "Najm ", "Jebel ", "Wadi ", "Medina ", "Rabat "], Suffixes: ["-Najm", "-Medina", "-Rabat", "-Kasbah", "-Oasis"] },
    Chinese: { Prefixes: ["Xīwàng-", "Tiānmén-", "Qīnglóng-", "Yúshán-", "Kūnlún-", "Chéng-", "Guǎng-"], Suffixes: ["-Shān", "-Hé", "-Gǎng", "-Wān", "-Chéng", "-Yì"] },
    Japanese: { Prefixes: ["Fuji-", "Kuroshio-", "Shinano-", "Yamato-", "Tanegashima-", "Kyoto-"], Suffixes: ["-jima", "-yama", "-wan", "-gawa", "-hara"] },
    German: { Prefixes: ["Ziegler-", "Schwarzwald-", "Zugspitze-", "Rhein-", "Elbe-", "Heidelberg-"], Suffixes: ["burg", "hafen", "wald", "berg", "tal", "brücke"] },
    French: { Prefixes: ["La Fayette-", "Chamonix-", "Garonne-", "Ardennes-", "Provence-", "Bernard-"], Suffixes: ["sur-Mer", "Belvédère", "Sable", "Plateau", "Vallée", "Port"] },
    Russian: { Prefixes: ["Kirov-", "Volkov-", "Novy-", "Krasno-", "Cherno-", "Siberia-"], Suffixes: ["grad", "ovsk", "slavl", "gorod", "gorsk", "yar"] },
    English: { Prefixes: ["New Freedom ", "Eugene ", "Ashleigh ", "Appalachia ", "Shenandoah ", "Cotswold "], Suffixes: [" Landing", " Valley", " Ridge", " Reach", " Crest", " Flats"] }
  },
  SauerScale: {
    Local: ["Town", "Village", "Bridge", "Shire", "Creek", "Crossing", "Gully", "Meadow", "Valley", "Flats", "Hollow", "Ridge", "Hill"],
    Colonial: ["Colony", "Outpost", "Enclave", "Landing", "Habitat", "Port", "Dock", "Dome", "Sump", "Basin", "Sector", "Station", "Rim"],
    Interstellar: ["Nexus", "Core", "Lattice", "Matrix", "Manifold", "Spire", "Bastion", "Gateway", "Vector", "Singularity", "Node", "Zenith", "Apex"]
  },
  Colloquial: {
    EngineeringFlaws: [
      "Ground Loop", "Cavitation", "Cold Solder", "Thermal Throttle", "Signal Noise", 
      "Stack Overflow", "Cache Leak", "Bus Fault", "Bit Flip", "Deadlock", "Drift Error", 
      "Impedance", "Voltage Drop", "RF Bleed", "Solder Bridge", "Stray Current", "Phase Shift", 
      "Harmonic Distortion", "Capacitor Leak", "Slew Rate", "Thermal Runaway", "Packet Loss", 
      "Buffer Overflow", "Parity Error", "Zero Division", "Null Reference", "Choke Coil",
      "Bleed Line", "Bypass Valve", "Rust-Joint", "Backblast"
    ],
    Resources: [
      "Tungsten", "Cobalt", "Methanol", "Basalt", "Regolith", "Isotope", "Slag", "Deuterium", 
      "Lithium", "Osmium", "Nickel", "Thorium", "Silica", "Ammonia", "Methane", "Heavy-Water", 
      "Bauxite", "Graphite", "Gypsum", "Iron-Ore", "Copper", "Helium-3", "Titanium", "Uranium"
    ]
  }
};

const FEATURE_SUFFIX_MAP = {
  Settlement: {
    Local: ["Town", "Village", "Shire", "Settlement", "Cove", "Crossing"],
    Colonial: ["Colony", "Enclave", "Outpost", "Haven", "Sector", "Quarter", "Dome"],
    Interstellar: ["Symmetry-Crest", "Matrix-Haven", "Spiritual-Core", "Zenith", "Apex", "Horizon"]
  },
  SpaceStation: {
    Local: ["Tower", "Beacon", "Watch"],
    Colonial: ["Station", "Ring", "Dock", "Platform", "Terminal", "Beacon", "Lattice"],
    Interstellar: ["Nexus-Ring", "Singularity-Core", "Array-Core", "Matrix-Nexus", "Lattice-Anchor"]
  },
  Industrial: {
    Local: ["Pit", "Quarry", "Mine", "Shed", "Forge", "Mill"],
    Colonial: ["Refinery", "Depot", "Sump", "Facility", "Seam", "Lode", "Line", "Plant"],
    Interstellar: ["Isotope-Sump", "Vacuum-Lattice", "Complex", "Core-Vat", "Plume-Smelter"]
  },
  Port: {
    Local: ["Harbor", "Bay", "Dock", "Anchorage", "Wharf", "Slip"],
    Colonial: ["Port", "Gateway", "Freight-Slipway", "Customs-Dock", "Cargo-Terminal"],
    Interstellar: ["Vector-Anchor", "Planck-Gateway", "Coordinate-Slip", "Terminal-Nexus"]
  },
  Desert: {
    Local: ["Flats", "Dunes", "Sands", "Plains", "Barrens", "Wastes"],
    Colonial: ["Basin", "Depression", "Wastes", "Target-Flats"],
    Interstellar: ["Absolute-Zero-Flats", "Chiral-Sands", "Asymptotic-Wastes", "Obsidian-Wastes"]
  },
  Mountain: {
    Local: ["Crest", "Heights", "Ridge", "Mount", "Spire", "Peak", "Hills", "Cliffs"],
    Colonial: ["Heights-Ridge", "Watch-Crest", "Command-Bastion"],
    Interstellar: ["Eigen-Spire", "Planck-Peak", "Maxwell's-Heights", "Zenith-Ridge"]
  },
  Canyon: {
    Local: ["Gorge", "Gully", "Chasm", "Rift", "Hollow", "Valley", "Ravine"],
    Colonial: ["Canyon", "Fissure", "Strategic-Valley", "Command-Valley"],
    Interstellar: ["Fourier's-Chasm", "Heisenberg's-Rift", "Gradient-Fissure", "State-Chasm"]
  }
};

// Hardcoded Faction File Listing for dynamically fetching Faction profiles
export const FACTION_JSONS = [
  "Cobalt Mercenary Coalition.json",
  "Crimson Corsairs.json",
  "Iron Dominion.json",
  "New Jerusalem Republic.json",
  "Puritan Ascendancy.json",
  "Serenity Collective.json",
  "Sisterhood of Gaia.json",
  "Stellar Directorate of Solitude.json",
  "Stellar Trade Federation.json",
  "Technocratic Union of Nova Celestia.json",
  "The Caliphate of Najm.json",
  "Union of Celestial Nations.json",
  "Unity Alliance.json",
  "Vance Consortium.json",
  "Verdant Alliance.json"
];

// Asynchronously loads name lists and faction JSON profiles
export async function loadData() {
  if (namesDb.isLoaded) return;
  try {
    const fetchLines = async (url) => {
      const res = await fetch(url);
      if (!res.ok) throw new Error(`Failed to fetch ${url}`);
      const arrayBuffer = await res.arrayBuffer();
      const bytes = new Uint8Array(arrayBuffer);
      const isUtf16 = bytes.length >= 2 && bytes[0] === 0xFF && bytes[1] === 0xFE;
      const decoder = new TextDecoder(isUtf16 ? "utf-16le" : "utf-8");
      const text = decoder.decode(bytes);
      return text.split(/\r?\n/).map(line => line.trim()).filter(line => line.length > 0);
    };

    // Load static text files
    namesDb.namesMaster = await fetchLines("/data/namesMaster.txt");
    namesDb.femaleFirstNames = await fetchLines("/data/femaleFirstNames.txt");
    namesDb.maleFirstNames = await fetchLines("/data/maleFirstNames.txt");

    // Load faction data files
    const societies = [];
    for (const file of FACTION_JSONS) {
      try {
        const res = await fetch(`/data/Societies/${file}`);
        if (res.ok) {
          const json = await res.json();
          societies.push(json);
        }
      } catch (err) {
        console.error(`Failed loading society file: ${file}`, err);
      }
    }
    namesDb.societies = societies;
    namesDb.isLoaded = true;
    console.log("Names and societies loaded successfully.");
  } catch (err) {
    console.error("Error loading generator databases:", err);
  }
}

// Resolves features matching the Sauer Level scale
function getMetricSuffix(feature, sauer, industry, ideology, rng) {
  if (feature === "Any" || !feature) {
    if (sauer <= 3) return getRandomItem(LEXICON_MATRIX.SauerScale.Local, rng);
    if (sauer <= 5) return getRandomItem(LEXICON_MATRIX.SauerScale.Colonial, rng);
    return getRandomItem(LEXICON_MATRIX.SauerScale.Interstellar, rng);
  }

  const category = FEATURE_SUFFIX_MAP[feature];
  if (!category) return "Point";

  let scaleKey = "Colonial";
  if (sauer <= 3) scaleKey = "Local";
  else if (sauer >= 6) scaleKey = "Interstellar";

  const baseSuffixList = category[scaleKey] || [];
  const modifiedSuffixes = [...baseSuffixList];

  if (feature === "Industrial" && LEXICON_MATRIX.Industry[industry]) {
    modifiedSuffixes.push(getRandomItem(LEXICON_MATRIX.Industry[industry], rng));
  }

  if (LEXICON_MATRIX.Ideology[ideology]) {
    modifiedSuffixes.push(getRandomItem(LEXICON_MATRIX.Ideology[ideology].Suffixes, rng));
  }

  return getRandomItem(modifiedSuffixes, rng);
}

// Generate Place Name using metrics
export function generatePlaceName(options = {}) {
  const seed = options.seed !== undefined ? options.seed : Math.floor(Math.random() * 999999);
  const rng = createRNG(seed);

  const layer = options.layer || "Colloquial";
  const faction = options.faction || "Dynamic";
  const feature = options.feature || "Any";

  let gov = options.government || "Any";
  let sauer = options.sauer !== undefined ? options.sauer : 5;
  let ind = options.industry || "Any";
  let lang = options.language || "Any";

  // If using a Major Faction, map metrics as fallbacks
  if (faction !== "Dynamic" && MAJOR_FACTION_METRICS[faction]) {
    const fMetrics = MAJOR_FACTION_METRICS[faction];
    gov = fMetrics.Government;
    sauer = fMetrics.Sauer;
    ind = fMetrics.Industry;
    lang = fMetrics.Language;
  }

  // Resolve "Any" wildcards
  if (gov === "Any") gov = getRandomItem(["Theocratic", "Militaristic", "Corporate", "Democratic", "Anarchic", "Technocratic"], rng);
  if (ind === "Any") ind = getRandomItem(["Agriculture", "Mining", "Military", "Trade", "Science"], rng);
  if (lang === "Any") lang = getRandomItem(["Arabic", "Chinese", "Japanese", "German", "French", "Russian", "English"], rng);

  const suffix = getMetricSuffix(feature, sauer, ind, gov, rng);

  // Layer 1: Sovereign (Ideological & Monumental)
  if (layer === "Sovereign") {
    const prefix = getRandomItem(LEXICON_MATRIX.Ideology[gov].Prefixes, rng);

    if (lang !== "English" && LEXICON_MATRIX.Language[lang]) {
      const langData = LEXICON_MATRIX.Language[lang];
      const langPrefix = getRandomItem(langData.Prefixes, rng);
      const langSuffix = getRandomItem(langData.Suffixes, rng);

      if (["Chinese", "Japanese", "German", "French"].includes(lang)) {
        return `${langPrefix}${prefix}-${suffix}`;
      } else {
        return `${langPrefix}${prefix} ${suffix}`;
      }
    }

    if (gov === "Militaristic" && rng() <= 0.2) {
      return `Tactical-Billet ${getSeededRandomValue(10, 99, rng)}-${prefix}`;
    }

    return `${prefix} ${suffix}`;
  } 
  
  // Layer 2: Colloquial Tech Slang
  else {
    const colloquialType = getRandomItem(["Flaw", "Resource", "Wayfinder"], rng);
    switch (colloquialType) {
      case "Flaw":
        return `${getRandomItem(LEXICON_MATRIX.Colloquial.EngineeringFlaws, rng)} ${suffix}`;
      case "Resource":
        return `${getRandomItem(LEXICON_MATRIX.Colloquial.Resources, rng)} ${suffix}`;
      case "Wayfinder":
      default:
        const base = getRandomItem(LEXICON_MATRIX.Ideology[gov].Prefixes, rng);
        const distanceIndex = getSeededRandomValue(1, 99, rng);
        return `${base}-Sub${distanceIndex} ${suffix}`;
    }
  }
}

// Generate Character Profile
export function generateCharacterProfile(options = {}) {
  const seed = options.seed !== undefined ? options.seed : Math.floor(Math.random() * 999999);
  const rng = createRNG(seed);

  const sex = options.sex || (rng() < 0.5 ? "Female" : "Male");
  
  // Select first name
  let firstName = "";
  if (sex === "Female" && namesDb.femaleFirstNames.length > 0) {
    firstName = getRandomItem(namesDb.femaleFirstNames, rng);
  } else if (namesDb.maleFirstNames.length > 0) {
    firstName = getRandomItem(namesDb.maleFirstNames, rng);
  } else {
    // Fallback if db isn't fully loaded yet
    firstName = sex === "Female" ? "Sarah" : "John";
  }

  // Select last name
  let lastName = "";
  if (namesDb.namesMaster.length > 0) {
    lastName = getRandomItem(namesDb.namesMaster, rng);
  } else {
    lastName = "Smith";
  }

  // Age group random weight
  const ageRnd = rng() * 100;
  let age = 30;
  let ageGroup = "Adult";

  if (ageRnd < 3) { age = getSeededRandomValue(1, 2, rng); ageGroup = "Infant"; }
  else if (ageRnd < 8) { age = getSeededRandomValue(2, 4, rng); ageGroup = "Toddler"; }
  else if (ageRnd < 15) { age = getSeededRandomValue(5, 8, rng); ageGroup = "Child"; }
  else if (ageRnd < 23) { age = getSeededRandomValue(9, 12, rng); ageGroup = "Pre-Teen"; }
  else if (ageRnd < 36) { age = getSeededRandomValue(13, 19, rng); ageGroup = "Teen"; }
  else if (ageRnd < 61) { age = getSeededRandomValue(20, 39, rng); ageGroup = "Adult"; }
  else if (ageRnd < 83) { age = getSeededRandomValue(40, 59, rng); ageGroup = "Middle Aged"; }
  else { age = getSeededRandomValue(60, 95, rng); ageGroup = "Senior"; }

  // Character Base Ability Scores
  const baseStats = {
    STR: getSeededRandomValue(10, 18, rng),
    DEX: getSeededRandomValue(10, 18, rng),
    INT: getSeededRandomValue(10, 18, rng),
    MEM: getSeededRandomValue(10, 18, rng),
    CHA: getSeededRandomValue(10, 18, rng),
    CON: getSeededRandomValue(10, 18, rng)
  };

  const statBonuses = {};
  Object.keys(baseStats).forEach(stat => {
    statBonuses[stat] = Math.floor((baseStats[stat] - 10) / 2);
  });

  const hp = baseStats.CON + baseStats.STR;
  const combatSkill = Math.floor((statBonuses.DEX + statBonuses.INT) / 2);

  // Demeanor List
  const demeanourList = ["Active", "Ambitious", "Cautious", "Conscientious", "Creative", "Curious", "Logical", "Organized", "Perfectionist", "Anxious", "Lazy", "Altruistic", "Guarded", "Loner", "Maverick", "Reserved", "Affable", "Gregarious", "Talkative"];
  const demeanour = getRandomItem(demeanourList, rng);

  return {
    name: `${firstName} ${lastName}`,
    sex,
    age,
    ageGroup,
    stats: baseStats,
    bonuses: statBonuses,
    derived: {
      HP: hp,
      CombatSkill: combatSkill,
      InitiativeBonus: statBonuses.INT + statBonuses.DEX,
      Speed: Math.max(1, Math.ceil((getSeededRandomValue(1, 20, rng) + statBonuses.INT + statBonuses.DEX) / 2))
    },
    demeanour,
    language: options.language || "English"
  };
}
