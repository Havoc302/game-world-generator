// Seed-deterministic universe and stellar generator for Colonial Alliance RPG.
// Renders sector star maps and calculates orbits and planetary structures.

import { createRNG, getRandomItem, getSeededRandomValue, namesDb } from "./nameGenerator";

export const SPECTRAL_CLASSES = [
  { type: "M", color: "Red", temp: "2400-3700 K", massRange: [0.08, 0.45], freq: 76.45 },
  { type: "K", color: "Orange", temp: "3700-5200 K", massRange: [0.45, 0.80], freq: 12.09 },
  { type: "G", color: "Yellow", temp: "5200-6000 K", massRange: [0.80, 1.04], freq: 7.60 },
  { type: "F", color: "Pale", temp: "6000-7500 K", massRange: [1.04, 1.40], freq: 3.00 },
  { type: "A", color: "White", temp: "7500-10000 K", massRange: [1.40, 2.10], freq: 0.60 },
  { type: "B", color: "Blue", temp: "10000-30000 K", massRange: [2.10, 16.0], freq: 0.12 },
  { type: "O", color: "DeepBlue", temp: "30000-60000 K", massRange: [16.0, 90.0], freq: 0.04 } // Boosted slightly for gameplay variety
];

// Computes squared distance
export function getDistanceSq(x1, y1, x2, y2) {
  return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
}

// Stellar Luminosity (L / L_sun) from Mass (M_sun) using Mass-Luminosity Relation
export function getStellarLuminosity(mass) {
  const M = Math.max(0.08, mass);
  if (M < 0.43) return 0.23 * Math.pow(M, 2.3);
  if (M < 2.0)  return Math.pow(M, 4.0);
  return 1.5 * Math.pow(M, 3.5);
}

// Habitable (Goldilocks) Zone Range in AU [r_inner, r_outer]
export function getHabitableZone(luminosity) {
  const sqrtL = Math.sqrt(Math.max(0.0001, luminosity));
  return {
    innerAU: Number((0.95 * sqrtL).toFixed(3)),
    outerAU: Number((1.37 * sqrtL).toFixed(3)),
    centerAU: Number((1.12 * sqrtL).toFixed(3))
  };
}

// ── Global Energy Balance Climate Model (EBM) ───────────────────────────────
// Solves Stefan-Boltzmann radiation balance using dynamic Bond Albedo (A),
// atmospheric optical depth (tau_gh), hydrosphere fraction, volcanic outgassing,
// and atmospheric density polar heat transport.
function getPlanetClimate(type, orbitalRadiusAU, starLuminosity, hydrospherePercent = 0, rngRef = Math.random) {
  const d = Math.max(0.01, orbitalRadiusAU || 1.0);
  const L = Math.max(0.0001, starLuminosity || 1.0);

  // 1. Solar Irradiance Flux S (W/m^2)
  const S = 1361 * (L / (d * d));

  // 2. Dynamic Surface Component Fractions
  const hydroFrac = Math.max(0, Math.min(1, (hydrospherePercent || 0) / 100));

  // Base Atmospheric Pressure P_atm (atmospheres) & Greenhouse Optical Depth tau_gh
  let Patm = 1.0;
  let tauBase = 0.75; // Earth baseline (~33 K warming)
  let volcanicOutgassing = 0.1;
  let iceFrac = 0.05;

  if (type === "Terran Habitable") {
    Patm = getSeededRandomValue(0.85, 1.25, rngRef);
    tauBase = 0.72;
    iceFrac = 0.08;
    volcanicOutgassing = 0.15;
  } else if (type === "Volcanic") {
    Patm = getSeededRandomValue(3.5, 12.0, rngRef);
    tauBase = 2.4; // High CO2 / SO2 optical depth
    volcanicOutgassing = 0.85;
    iceFrac = 0.0;
  } else if (type === "Desert") {
    Patm = getSeededRandomValue(0.4, 0.9, rngRef);
    tauBase = 0.45;
    volcanicOutgassing = 0.05;
    iceFrac = 0.02;
  } else if (type === "Rocky" || type === "Barren Rocky") {
    Patm = getSeededRandomValue(0.01, 0.25, rngRef);
    tauBase = 0.10;
    volcanicOutgassing = 0.02;
    iceFrac = 0.01;
  } else if (type === "Ice World") {
    Patm = getSeededRandomValue(0.2, 0.8, rngRef);
    tauBase = 0.35;
    volcanicOutgassing = 0.05;
    iceFrac = 0.75; // High albedo ice cover
  } else if (type === "Ice Giant" || type === "Gas Giant") {
    Patm = 10.0;
    tauBase = 1.2;
    iceFrac = 0.3;
  }

  // 3. Dynamic Bond Albedo A
  const AlbedoOcean = 0.08;
  const AlbedoLand  = type === "Volcanic" ? 0.12 : 0.22;
  const AlbedoIce   = 0.68;

  const landFrac = Math.max(0, 1.0 - hydroFrac - iceFrac);
  const A = Math.max(0.05, Math.min(0.85,
    hydroFrac * AlbedoOcean + iceFrac * AlbedoIce + landFrac * AlbedoLand
  ));

  // 4. Atmospheric Optical Depth & Greenhouse Emissivity
  const tauGH = Math.max(0.01,
    tauBase * Patm + volcanicOutgassing * 0.8 + hydroFrac * 0.15
  );

  // Atmospheric thermal opacity (greenhouse trapping factor)
  const epsilonGH = 1.0 - Math.exp(-tauGH);

  // 5. Stefan-Boltzmann Surface Equilibrium Temperature (Kelvin)
  // sigma = 5.670374e-8 W/(m^2 K^4)
  const sigma = 5.670374e-8;
  const T_K = Math.pow((S * (1.0 - A)) / (4 * sigma * (1.0 - 0.5 * epsilonGH)), 0.25);
  const averageTempC = Math.round(T_K - 273.15);

  // 6. Polar Atmospheric Heat Transport (Thick atmospheres equalize equator-pole gradient)
  const tempGradientRange = Math.max(12, 38 / Math.sqrt(Patm + 0.1));
  const equatorTempC = Math.round(averageTempC + tempGradientRange * 0.55);
  const poleTempC    = Math.round(averageTempC - tempGradientRange * 0.75);

  return {
    averageTempC,
    equatorTempC,
    poleTempC,
    bondAlbedo: Number(A.toFixed(3)),
    greenhouseOpticalDepth: Number(tauGH.toFixed(3)),
    atmosphericPressureAtm: Number(Patm.toFixed(2)),
    axialTiltDeg: Math.round(getSeededRandomValue(8, 32, rngRef))
  };
}

function getPlanetPhysicalProperties(type, relativeSize, rngRef) {
  if (type === "Gas Giant") {
    const equatorialDiameterKm = getSeededRandomValue(120000, 160000, rngRef);
    const tilesPerSide = Math.min(256, Math.max(64, Math.ceil(equatorialDiameterKm / 100)));
    return {
      equatorialDiameterKm: Math.round(equatorialDiameterKm),
      surfaceTileSizeKm: 100,
      surfaceTilesPerSide: tilesPerSide
    };
  }

  if (type === "Ice Giant") {
    const equatorialDiameterKm = getSeededRandomValue(60000, 100000, rngRef);
    const tilesPerSide = Math.min(256, Math.max(64, Math.ceil(equatorialDiameterKm / 100)));
    return {
      equatorialDiameterKm: Math.round(equatorialDiameterKm),
      surfaceTileSizeKm: 100,
      surfaceTilesPerSide: tilesPerSide
    };
  }

  if (type === "Terran Habitable") {
    const equatorialDiameterKm = getSeededRandomValue(12000, 16000, rngRef) * (0.94 + ((relativeSize || 8) / 20) * 0.03);
    const tilesPerSide = Math.min(256, Math.max(64, Math.ceil(equatorialDiameterKm / 100)));
    return {
      equatorialDiameterKm: Math.round(equatorialDiameterKm),
      surfaceTileSizeKm: 100,
      surfaceTilesPerSide: tilesPerSide
    };
  }

  if (["Desert", "Volcanic", "Rocky", "Barren Rocky"].includes(type)) {
    const equatorialDiameterKm = getSeededRandomValue(8000, 14000, rngRef) * (0.92 + ((relativeSize || 8) / 20) * 0.025);
    const tilesPerSide = Math.min(256, Math.max(64, Math.ceil(equatorialDiameterKm / 100)));
    return {
      equatorialDiameterKm: Math.round(equatorialDiameterKm),
      surfaceTileSizeKm: 100,
      surfaceTilesPerSide: tilesPerSide
    };
  }

  if (["Ice World"].includes(type)) {
    const equatorialDiameterKm = getSeededRandomValue(8000, 14000, rngRef);
    const tilesPerSide = Math.min(256, Math.max(64, Math.ceil(equatorialDiameterKm / 100)));
    return {
      equatorialDiameterKm: Math.round(equatorialDiameterKm),
      surfaceTileSizeKm: 100,
      surfaceTilesPerSide: tilesPerSide
    };
  }

  const equatorialDiameterKm = getSeededRandomValue(6000, 12000, rngRef);
  const tilesPerSide = Math.min(256, Math.max(64, Math.ceil(equatorialDiameterKm / 100)));
  return {
    equatorialDiameterKm: Math.round(equatorialDiameterKm),
    surfaceTileSizeKm: 100,
    surfaceTilesPerSide: tilesPerSide
  };
}

// Generate the sector universe
export function generateUniverse(config = {}) {
  const seed = config.seed !== undefined ? config.seed : 42;
  const rng = createRNG(seed);
  
  const systemCount = config.systemCount || 300;
  const mapSizeX = config.mapSizeX || 4800; // 48 dividers * 100px
  const mapSizeY = config.mapSizeY || 4800;
  const minimumHabitable = config.minimumHabitable || 14;

  const starSystems = [];
  const minDistanceSq = 120 * 120; // Prevent systems from overlapping too closely

  // Generate unique 2D coordinates for systems (Poisson-disc like verification)
  const generateCoords = () => {
    let attempts = 0;
    while (attempts < 500) {
      const x = getSeededRandomValue(200, mapSizeX - 200, rng);
      const y = getSeededRandomValue(200, mapSizeY - 200, rng);
      let farEnough = true;
      for (const sys of starSystems) {
        if (getDistanceSq(x, y, sys.x, sys.y) < minDistanceSq) {
          farEnough = false;
          break;
        }
      }
      if (farEnough) return { x, y };
      attempts++;
    }
    // Fallback if space is crowded
    return {
      x: getSeededRandomValue(200, mapSizeX - 200, rng),
      y: getSeededRandomValue(200, mapSizeY - 200, rng)
    };
  };

  // Pre-calculate class weights
  const cumulativeFreqs = [];
  let totalFreq = 0;
  SPECTRAL_CLASSES.forEach(cls => {
    totalFreq += cls.freq;
    cumulativeFreqs.push({ cls, threshold: totalFreq });
  });

  const selectSpectralClass = (forceHabitable) => {
    if (forceHabitable) {
      return rng() < 0.6 
        ? SPECTRAL_CLASSES.find(c => c.type === "G")
        : SPECTRAL_CLASSES.find(c => c.type === "F");
    }
    const val = rng() * totalFreq;
    for (const entry of cumulativeFreqs) {
      if (val <= entry.threshold) return entry.cls;
    }
    return SPECTRAL_CLASSES[0];
  };

  const getPlanetType = (spectralType, orbitalRadius, isHabPlanet, starLuminosity, rngRef) => {
    if (isHabPlanet) return "Terran Habitable";

    const sqrtL = Math.sqrt(Math.max(0.0001, starLuminosity || 1.0));
    const habOuterAU = 1.37 * sqrtL;
    const frostLineAU = 2.7 * sqrtL; // Frost line / snow line in star system

    // Beyond the frost line: Ice Giants, Gas Giants, and Ice Worlds dominate
    if (orbitalRadius > frostLineAU * 2.0) {
      const roll = rngRef();
      if (roll < 0.55) return "Ice Giant";
      if (roll < 0.85) return "Gas Giant";
      return "Ice World";
    }

    if (orbitalRadius > frostLineAU) {
      const roll = rngRef();
      if (roll < 0.45) return "Gas Giant";
      if (roll < 0.80) return "Ice Giant";
      return "Ice World";
    }

    // Between Goldilocks zone outer edge and frost line: Cold Rocky, Ice World, Desert
    if (orbitalRadius > habOuterAU) {
      const roll = rngRef();
      if (roll < 0.40) return "Ice World";
      if (roll < 0.70) return "Desert";
      return "Barren Rocky";
    }

    // Inside or near inner Goldilocks zone: Volcanic, Desert, Rocky, Barren
    const roll = rngRef();
    if (roll < 0.30) return "Volcanic";
    if (roll < 0.60) return "Barren Rocky";
    if (roll < 0.85) return "Desert";
    return "Rocky";
  };

  let habitableCreated = 0;

  for (let i = 1; i <= systemCount; i++) {
    const coords = generateCoords();
    const forceHabitable = habitableCreated < minimumHabitable;
    const spectral = selectSpectralClass(forceHabitable);
    const mass = getSeededRandomValue(spectral.massRange[0] * 100, spectral.massRange[1] * 100, rng) / 100;
    
    // Naming
    let name = `SEC_2-${String(i).padStart(4, "0")}`;
    const namePool = namesDb.namesMaster;
    if (forceHabitable && namePool && namePool.length > 0) {
      // Pick a unique name from database
      const attempts = 10;
      let pickedName = "";
      for (let k = 0; k < attempts; k++) {
        pickedName = getRandomItem(namePool, rng);
        if (!starSystems.some(s => s.name === pickedName)) {
          name = pickedName;
          break;
        }
      }
    }

    const planetChanceByType = {
      M: 0.7,
      K: 0.8,
      G: 0.9,
      F: 0.85,
      A: 0.05,
      B: 0.0,
      O: 0.0
    };

    const habitableChanceByType = {
      M: 0.03,
      K: 0.06,
      G: 0.18,
      F: 0.14,
      A: 0.0,
      B: 0.0,
      O: 0.0
    };

    const hasPlanets = forceHabitable || rng() < (planetChanceByType[spectral.type] ?? 0.25);
    let isHabitable = forceHabitable;

    if (!isHabitable && ["G", "F"].includes(spectral.type) && rng() < (habitableChanceByType[spectral.type] ?? 0.0)) {
      isHabitable = true;
    }

    const luminosity = getStellarLuminosity(mass);
    const goldilocks = getHabitableZone(luminosity);

    const system = {
      id: `sys-${i}`,
      name,
      designation: `2_${String(i).padStart(4, "0")}`,
      x: coords.x,
      y: coords.y,
      spectralType: spectral.type,
      color: spectral.color,
      mass,
      luminosity: Number(luminosity.toFixed(4)),
      goldilocksZoneAU: goldilocks,
      hasPlanets,
      isHabitable,
      planets: []
    };

    if (system.hasPlanets) {
      const planetCount = getSeededRandomValue(3, 10, rng);
      const habitableIndex = isHabitable ? getSeededRandomValue(1, Math.max(1, planetCount - 1), rng) : -1;
      const sqrtL = Math.sqrt(luminosity);
      
      for (let p = 0; p < planetCount; p++) {
        const isHabPlanet = p === habitableIndex;
        let orbitalRadius = 1.0;

        if (isHabPlanet) {
          // Terran Habitable planets MUST orbit strictly inside the Goldilocks zone
          orbitalRadius = Number(getSeededRandomValue(goldilocks.innerAU * 100, goldilocks.outerAU * 100, rng) / 100);
        } else {
          // Other planet orbits scale with sqrt(Luminosity)
          const baseDistAU = getSeededRandomValue(12 * (p + 1), 32 * (p + 1), rng) / 10;
          orbitalRadius = Number((baseDistAU * sqrtL).toFixed(3));
        }

        const type = getPlanetType(spectral.type, orbitalRadius, isHabPlanet, luminosity, rng);
        const hydrospherePercent = type === "Terran Habitable" ? Math.round(getSeededRandomValue(45, 80, rng)) : 0;
        const relativeSize = type.includes("Giant") ? getSeededRandomValue(25, 90, rng) : getSeededRandomValue(3, 12, rng);
        const physicalProperties = getPlanetPhysicalProperties(type, relativeSize, rng);
        const climate = getPlanetClimate(type, orbitalRadius, luminosity, hydrospherePercent, rng);

        system.planets.push({
          id: `${system.id}-p-${p}`,
          index: p + 1,
          name: `${system.name} ${String.fromCharCode(98 + p)}`, // b, c, d...
          orbitalRadius,
          type,
          hasHydrosphere: type === "Terran Habitable",
          hydrospherePercent: type === "Terran Habitable" ? getSeededRandomValue(45, 80, rng) : 0,
          size: relativeSize,
          climate,
          physicalProperties,
          explorationGrid: null // Seeded dynamically when explored
        });
      }

      if (forceHabitable) {
        habitableCreated++;
      }
    }

    starSystems.push(system);
  }

  // Faction Sovereignty Placement (fnc_GetSovereigntyRanges in JS)
  // 1. Calculate weights & sovereignty scores for loaded societies
  const societiesWithScores = namesDb.societies.map(soc => {
    const eco = soc.EconomyScore || 5;
    const mil = soc.MilitaryScore || 5;
    const edu = soc.EducationScore || 5;
    const lead = soc.LeadershipScore || 5;
    const pop = soc.PopulationScore || 3;
    const tech = soc.TechnologyScore || 5;
    const unity = soc.UnityScore || 5;

    const score = Math.round(
      (eco * 2) +
      (mil * 5) +
      (edu / 2) +
      (lead / 2) +
      (pop / 2) +
      tech +
      (unity / 2)
    );
    return { ...soc, sovereigntyScore: score };
  });

  // Sort societies descending by sovereignty
  societiesWithScores.sort((a, b) => b.sovereigntyScore - a.sovereigntyScore);

  const claimedSystemIds = new Set();
  const territories = [];

  // Helper to determine systems within range
  const getSystemsWithinRange = (sourceSys, range, systemsPool) => {
    const rangeSq = range * range;
    const results = [];
    for (const sys of systemsPool) {
      if (sys.id === sourceSys.id) continue;
      if (getDistanceSq(sourceSys.x, sourceSys.y, sys.x, sys.y) <= rangeSq) {
        results.push(sys);
      }
    }
    return results;
  };

  const SOVEREIGNTY_RANGE_MULTIPLIER = 8.5; // Maps score directly to pixel ranges

  societiesWithScores.forEach(faction => {
    // Find named systems with planets not already claimed
    const candidateHomeworlds = starSystems.filter(sys => {
      if (claimedSystemIds.has(sys.id)) return false;
      return sys.isHabitable; // Homeworlds must be habitable
    });

    if (candidateHomeworlds.length === 0) return;

    let bestHomeworld = null;
    let maxConnections = -1;
    let systemsInRangeOfBest = [];

    const factionRange = faction.sovereigntyScore * SOVEREIGNTY_RANGE_MULTIPLIER;

    // Search for homeworld that maximizes density of unclaimed systems in range
    candidateHomeworlds.forEach(sys => {
      const inRangeList = getSystemsWithinRange(sys, factionRange, starSystems.filter(s => !claimedSystemIds.has(s.id)));
      if (inRangeList.length > maxConnections) {
        maxConnections = inRangeList.length;
        bestHomeworld = sys;
        systemsInRangeOfBest = inRangeList;
      }
    });

    if (bestHomeworld) {
      // Claim the homeworld and all systems in range
      claimedSystemIds.add(bestHomeworld.id);
      bestHomeworld.faction = faction.FactionName;
      bestHomeworld.isHomeworld = true;

      systemsInRangeOfBest.forEach(sys => {
        claimedSystemIds.add(sys.id);
        sys.faction = faction.FactionName;
      });

      territories.push({
        factionName: faction.FactionName,
        color: getFactionColor(faction.FactionName),
        homeworldId: bestHomeworld.id,
        range: factionRange,
        systems: [bestHomeworld, ...systemsInRangeOfBest]
      });

      // Update the Faction JSON properties
      faction.homeworld = bestHomeworld.name;
      faction.xCoord = bestHomeworld.x;
      faction.yCoord = bestHomeworld.y;
    }
  });

  return {
    starSystems,
    territories,
    societies: societiesWithScores
  };
}

// Return colors for known factions
function getFactionColor(name) {
  const map = {
    "Cobalt Mercenary Coalition": "rgba(30, 144, 255, 0.4)", // Blue
    "Crimson Corsairs": "rgba(220, 20, 60, 0.4)", // Red
    "Iron Dominion": "rgba(105, 105, 105, 0.4)", // Dark Grey
    "New Jerusalem Republic": "rgba(218, 165, 32, 0.4)", // Golden
    "Puritan Ascendancy": "rgba(147, 112, 219, 0.4)", // Purple
    "Serenity Collective": "rgba(46, 139, 87, 0.4)", // Sea Green
    "Sisterhood of Gaia": "rgba(34, 139, 34, 0.4)", // Green
    "Stellar Directorate of Solitude": "rgba(112, 128, 144, 0.4)", // Slate
    "Stellar Trade Federation": "rgba(244, 164, 96, 0.4)", // Sandy
    "Technocratic Union of Nova Celestia": "rgba(0, 206, 209, 0.4)", // Turquoise
    "The Caliphate of Najm": "rgba(189, 183, 107, 0.4)", // Dark Khaki
    "Union of Celestial Nations": "rgba(178, 34, 34, 0.4)", // Firebrick
    "Unity Alliance": "rgba(70, 130, 180, 0.4)", // Steel Blue
    "Vance Consortium": "rgba(205, 133, 63, 0.4)", // Peru Brown
    "Verdant Alliance": "rgba(154, 205, 50, 0.4)" // Yellow Green
  };
  return map[name] || "rgba(255, 255, 255, 0.3)";
}
