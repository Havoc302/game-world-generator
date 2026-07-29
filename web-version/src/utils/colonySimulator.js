// Colony simulation loop.
// Simulates landing site suitability, yearly exploration, agricultural growth, resource mining, and road expansions.

import { createRNG, getRandomItem, getSeededRandomValue } from "./nameGenerator";
// (universeGenerator not needed here)

export function initializeColony(system, planet, factionName, grid, seed) {
  const rng = createRNG(seed);
  const size = grid.length;

  // 1. Landing Suitability Assessment
  let bestTile = null;
  let maxSuitability = -9999;

  const forestBiomes = new Set(["Forest", "Temperate Forest", "Rainforest", "Taiga", "Conifer Forest", "Woodland"]);
  const grasslandBiomes = new Set(["Grasslands", "Plains", "Savanna", "Steppe", "Shrubland", "Meadow"]);
  const hostileBiomes = new Set(["Ocean", "Mountain", "Rocky Highland", "Crater Ridge", "Basalt Ridge", "Ice Sheet", "Glacier Basin", "Tundra", "Cryo Shelf", "Ice Swell", "Pressure Ridge"]);

  for (let y = 5; y < size - 5; y++) {
    for (let x = 0; x < size; x++) {
      const tile = grid[y][x];
      if (tile.biome && hostileBiomes.has(tile.biome)) continue;

      let score = 0;
      const biome = tile.biome || "";
      const isForest = forestBiomes.has(biome);
      const isGrassland = grasslandBiomes.has(biome);
      const isRiverbank = Boolean(tile.isRiver);

      if (isForest) score += 55;
      if (isGrassland) score += 70;
      if (biome === "Temperate Forest") score += 10;
      if (biome === "Rainforest") score += 5;
      if (biome === "Grasslands") score += 10;
      if (biome === "Plains") score += 5;
      if (biome === "Desert") score -= 45;
      if (biome === "Badlands") score -= 25;
      if (tile.elevation > 0.65) score -= 35;
      if (tile.elevation > 0.55) score -= 10;

      // Adjacency checks (cylinder wrapping on X)
      let adjacentToRiver = false;
      let adjacentToOcean = false;
      let adjacentToForest = false;
      let adjacentToGrassland = false;
      let adjacentToMountain = false;

      const directions = [
        { dx: -1, dy: -1 }, { dx: 0, dy: -1 }, { dx: 1, dy: -1 },
        { dx: -1, dy: 0 },                    { dx: 1, dy: 0 },
        { dx: -1, dy: 1 },  { dx: 0, dy: 1 },  { dx: 1, dy: 1 }
      ];

      directions.forEach(d => {
        const nx = (x + d.dx + size) % size;
        const ny = y + d.dy;
        if (ny >= 0 && ny < size) {
          const adj = grid[ny][nx];
          if (adj.isRiver) adjacentToRiver = true;
          if (adj.biome === "Ocean") adjacentToOcean = true;
          if (adj.biome && forestBiomes.has(adj.biome)) adjacentToForest = true;
          if (adj.biome && grasslandBiomes.has(adj.biome)) adjacentToGrassland = true;
          if (adj.biome && hostileBiomes.has(adj.biome)) adjacentToMountain = true;
        }
      });

      if (adjacentToRiver) score += 55;
      if (adjacentToOcean) score += 45;
      if (adjacentToForest) score += 35;
      if (adjacentToGrassland) score += 35;
      if (isRiverbank) score += 10;
      if (adjacentToMountain) score -= 20;

      const temp = Number.isFinite(tile.temperature) ? tile.temperature : 15;
      if (temp < -5 || temp > 35) score -= 90;
      else if (temp < 5 || temp > 28) score -= 40;
      else if (temp >= 10 && temp <= 22) score += 35;
      else if (temp >= 6 && temp <= 26) score += 10;
      else score -= 10;

      if (score > maxSuitability) {
        maxSuitability = score;
        bestTile = tile;
      }
    }
  }

  // Fallback if no tile is found
  if (!bestTile) {
    bestTile = grid[20][20];
  }

  // 2. Establish Capital City at best tile
  const cx = bestTile.x;
  const cy = bestTile.y;
  bestTile.explored = true;
  bestTile.structures.push("Capital");

  const farmCandidates = [];
  for (let dy = -2; dy <= 2; dy++) {
    for (let dx = -2; dx <= 2; dx++) {
      if (dx === 0 && dy === 0) continue;
      const nx = (cx + dx + size) % size;
      const ny = cy + dy;
      if (ny < 0 || ny >= size) continue;
      const tile = grid[ny][nx];
      if (!tile || tile.biome === "Ocean" || tile.biome === "Mountain" || tile.elevation > 0.6) continue;
      if (tile.temperature < 2 || tile.temperature > 30) continue;
      if ((tile.biome && forestBiomes.has(tile.biome)) || (tile.biome && grasslandBiomes.has(tile.biome)) || tile.biome === "Plains") {
        farmCandidates.push(tile);
      }
    }
  }

  farmCandidates.slice(0, 3).forEach(tile => {
    if (!tile.structures.includes("Farm")) tile.structures.push("Farm");
  });

  // Reveal surrounding tiles (Initial survey region)
  const revealDirs = [
    { dx: -1, dy: -1 }, { dx: 0, dy: -1 }, { dx: 1, dy: -1 },
    { dx: -1, dy: 0 },  { dx: 0, dy: 0 },  { dx: 1, dy: 0 },
    { dx: -1, dy: 1 },  { dx: 0, dy: 1 },  { dx: 1, dy: 1 }
  ];

  revealDirs.forEach(d => {
    const nx = (cx + d.dx + size) % size;
    const ny = cy + d.dy;
    if (ny >= 0 && ny < size) {
      grid[ny][nx].explored = true;
    }
  });

  const historyLog = [
    `Kede 1: Colony ship lands on ${planet.name} at coordinates (${cx}, ${cy}).`,
    `Capital founded at suitability score ${maxSuitability}. Colonists arrive with preserved food stores and begin cultivating edible local species.`,
    `Water supply verified from adjacent ${bestTile.isRiver ? "river bank" : "sea reservoir"}.`
  ];

  return {
    planetId: planet.id,
    planetName: planet.name,
    factionName,
    kede: 1,
    sauerScale: 4, // Starts at Space Age, pre-replicator
    population: 1000000,
    growthRate: 0.025,
    resources: {
      Iron: 350,
      Copper: 150,
      Osmium: 40,
      Deuterium: 30,
      Silicates: 120,
      Food: 50000
    },
    capitalCoords: { x: cx, y: cy },
    historyLog,
    explorationQueue: [],
    minedOutposts: [],
    farms: []
  };
}

export function tickColony(colony, grid, rng) {
  colony.kede++;
  const size = grid.length;

  // 1. Consume Food & Resources
  const foodConsumption = Math.ceil(colony.population * 0.0005);
  colony.resources.Food -= foodConsumption;

  // Starvation penalty
  if (colony.resources.Food <= 0) {
    colony.resources.Food = 0;
    colony.growthRate = -0.04; // Population drops
    if (colony.kede % 2 === 0) {
      colony.historyLog.push(`Kede ${colony.kede}: CRITICAL: Severe food shortage! Colonists are starving on ${colony.planetName}.`);
    }
  } else {
    // Normal growth
    colony.growthRate = 0.015 + (colony.resources.Food > colony.population ? 0.01 : 0);
  }

  // Apply population growth
  colony.population = Math.max(10000, Math.floor(colony.population * (1 + colony.growthRate)));

  // 2. Harvest Mines and Farms
  let foodProduced = 0;
  let ironMined = 0;
  let copperMined = 0;
  let osmiumMined = 0;
  let deuteriumHarvested = 0;
  let silicatesHarvested = 0;

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const tile = grid[y][x];
      
      // Farm Production
      if (tile.structures.includes("Farm")) {
        foodProduced += 120;
      }

      // Mine / Harvesting Outpost Production
      if (tile.structures.includes("Mine")) {
        const harvest = (resName, rate) => {
          const deposit = tile.resources[resName];
          if (deposit && deposit.reserveTons > 0) {
            const amount = Math.min(rate, deposit.reserveTons);
            deposit.reserveTons -= amount;
            if (deposit.reserveTons <= 0) {
              delete tile.resources[resName];
              colony.historyLog.push(`Kede ${colony.kede}: Mineral node of ${resName} exhausted at tile (${x}, ${y}).`);
            }
            return amount;
          }
          return 0;
        };

        ironMined += harvest("Iron", 35);
        copperMined += harvest("Copper", 25);
        osmiumMined += harvest("Osmium", 8);
        deuteriumHarvested += harvest("Deuterium", 15);
        silicatesHarvested += harvest("Silicates", 30);
      }
    }
  }

  colony.resources.Food += foodProduced;
  colony.resources.Iron += ironMined;
  colony.resources.Copper += copperMined;
  colony.resources.Osmium += osmiumMined;
  colony.resources.Deuterium += deuteriumHarvested;
  colony.resources.Silicates += silicatesHarvested;

  // 3. Process Exploration Queue
  if (colony.explorationQueue.length > 0) {
    const expedition = colony.explorationQueue[0];
    expedition.duration--;

    if (expedition.duration <= 0) {
      // Completed survey
      const tile = grid[expedition.y][expedition.x];
      tile.explored = true;

      const discoveredResources = Object.entries(tile.resources)
        .map(([key, deposit]) => `${deposit?.mineral || key} (${deposit?.gradePercent?.toFixed(2)}%)`)
        .filter(Boolean);
      const resText = discoveredResources.length > 0 
        ? `containing ${discoveredResources.join(", ")}`
        : `with no major mineral deposits`;

      colony.historyLog.push(
        `Kede ${colony.kede}: Scouts completed survey of tile (${expedition.x}, ${expedition.y}) to the ${expedition.direction}. Found ${tile.biome} terrain ${resText}.`
      );

      // Remove from queue
      colony.explorationQueue.shift();

      // Progressive Decisional Building logic:
      // A: Seed Mines if valuable veins found
      const hasMetalVein = ["Iron", "Copper", "Osmium", "Aluminum", "Nickel"].some(key => {
        const deposit = tile.resources[key];
        return deposit && deposit.reserveTons > 200;
      });
      if (hasMetalVein && colony.resources.Iron >= 50 && colony.resources.Silicates >= 30) {
        colony.resources.Iron -= 50;
        colony.resources.Silicates -= 30;
        tile.structures.push("Mine");
        tile.structures.push("Road");
        colony.historyLog.push(`Kede ${colony.kede}: Constructed mining outpost and heavy metal smelter on tile (${expedition.x}, ${expedition.y}).`);
      } 
      // B: Seed Farms on high moisture fertile plains
      else if ((tile.biome === "Grasslands" || tile.biome === "Forest") && colony.resources.Food < colony.population * 0.8 && colony.resources.Iron >= 30) {
        colony.resources.Iron -= 30;
        tile.structures.push("Farm");
        tile.structures.push("Road");
        colony.historyLog.push(`Kede ${colony.kede}: Established agricultural commune and food silos on tile (${expedition.x}, ${expedition.y}).`);
      }
    }
  } else {
    // Dispatch new Scouts
    // Find unexplored coordinates directly bordering explored coordinates
    const borderTiles = [];
    
    for (let y = 1; y < size - 1; y++) {
      for (let x = 0; x < size; x++) {
        if (!grid[y][x].explored) {
          // Check neighbors
          let hasExploredNeighbor = false;
          let direction = "North";
          
          const adjDirs = [
            { dx: 0, dy: -1, label: "North" },
            { dx: 0, dy: 1, label: "South" },
            { dx: -1, dy: 0, label: "West" },
            { dx: 1, dy: 0, label: "East" }
          ];

          for (const d of adjDirs) {
            const nx = (x + d.dx + size) % size;
            const ny = y + d.dy;
            if (ny >= 0 && ny < size && grid[ny][nx].explored) {
              hasExploredNeighbor = true;
              direction = d.label;
              break;
            }
          }

          if (hasExploredNeighbor) {
            borderTiles.push({ x, y, direction });
          }
        }
      }
    }

    if (borderTiles.length > 0) {
      // Pick a random border tile to survey
      const target = getRandomItem(borderTiles, rng);
      const targetTile = grid[target.y][target.x];
      
      // Survey duration depends on terrain difficulty
      let duration = 2; // Plains/Grasslands
      if (targetTile.biome === "Mountain") duration = 4;
      else if (targetTile.biome === "Forest") duration = 3;

      colony.explorationQueue.push({
        x: target.x,
        y: target.y,
        direction: target.direction,
        duration
      });

      colony.historyLog.push(
        `Kede ${colony.kede}: Expedition dispatched to explore tile (${target.x}, ${target.y}) to the ${target.direction}. ETA ${duration} Kedes.`
      );
    }
  }

  // 4. Technology Advancements (Sauer Scale progress)
  if (colony.sauerScale === 4 && colony.population > 2500000 && colony.resources.Iron >= 800 && colony.resources.Osmium >= 200) {
    colony.sauerScale = 5; // Reached Intra-Solar era
    colony.resources.Iron -= 800;
    colony.resources.Osmium -= 200;
    colony.historyLog.push(`Kede ${colony.kede}: RESEARCH INFLECTION: Developed advanced plasma engines and orbital shipyard hubs. Unlocked sector-wide star colonization!`);
  }

  return colony;
}
