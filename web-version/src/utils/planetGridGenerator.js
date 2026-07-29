// Procedural 10km Grid Generator for solid planets.
// Generates biomes, elevation heights, river networks, and mineral resource veins.

import { createRNG, getSeededRandomValue, getRandomItem } from "./nameGenerator";

const RESOURCE_LIBRARY = [
  { key: "Iron", label: "Iron", mineral: "Hematite", crustalAbundance: 5.63, enrichmentRange: [6, 12], minGrade: 12, maxGrade: 68, biomeBoosts: { Mountain: 1.2, Highlands: 1.1, Badlands: 0.9, Desert: 0.8, "Crater Ridge": 1.1, "Basalt Ridge": 1.2, "Ash Plain": 1.0, "Rocky Highland": 1.1, "Mesa Plain": 0.9 } },
  { key: "Copper", label: "Copper", mineral: "Chalcopyrite", crustalAbundance: 0.0068, enrichmentRange: [60, 180], minGrade: 0.15, maxGrade: 1.8, biomeBoosts: { Highlands: 1.2, Mountain: 1.1, "Temperate Forest": 0.7, Desert: 0.6, "Crater Ridge": 1.2, "Basalt Ridge": 1.1, "Ash Plain": 0.9, "Rocky Highland": 1.0, "Rubble Field": 1.0 } },
  { key: "Aluminum", label: "Aluminum", mineral: "Bauxite", crustalAbundance: 8.23, enrichmentRange: [2.2, 4.5], minGrade: 8, maxGrade: 35, biomeBoosts: { Highlands: 1.2, Mountain: 0.7, Rainforest: 0.9, "Temperate Forest": 0.8, "Rocky Highland": 1.1, "Mesa Plain": 0.9, Desert: 0.8, "Rubble Field": 0.8 } },
  { key: "Nickel", label: "Nickel", mineral: "Pentlandite", crustalAbundance: 0.0084, enrichmentRange: [70, 140], minGrade: 0.2, maxGrade: 1.4, biomeBoosts: { Mountain: 1.3, Badlands: 1.2, Highlands: 1.0, Desert: 0.8, "Crater Ridge": 1.25, "Basalt Ridge": 1.1, "Ash Plain": 0.9, "Rubble Field": 1.0 } },
  { key: "Silicates", label: "Silicates", mineral: "Olivine / pyroxene", crustalAbundance: 27.7, enrichmentRange: [0.6, 1.4], minGrade: 16, maxGrade: 85, biomeBoosts: { Desert: 1.3, Badlands: 1.2, Plains: 0.9, Rainforest: 0.7, "Salt Flat": 1.4, "Dune Sea": 1.2, "Stone Garden": 1.1, "Rubble Field": 1.0, "Rocky Highland": 1.1, "Mesa Plain": 0.9 } },
  { key: "Deuterium", label: "Deuterium", mineral: "Hydrogen isotope", crustalAbundance: 0.000015, enrichmentRange: [5000, 14000], minGrade: 0.001, maxGrade: 0.04, biomeBoosts: { Rainforest: 1.2, Plains: 1.1, Mountain: 0.8, Desert: 0.6, "Ice Sheet": 1.2, "Glacier Basin": 1.1, "Storm Band": 0.9, "Ice Swell": 1.0, "Cryo Shelf": 0.9 } },
  { key: "Osmium", label: "Osmium", mineral: "Osmiridium", crustalAbundance: 0.0000005, enrichmentRange: [1000, 5000], minGrade: 0.0002, maxGrade: 0.004, biomeBoosts: { Mountain: 1.6, Highlands: 1.1, Badlands: 0.7, "Crater Ridge": 1.4, "Basalt Ridge": 1.2 } },
  { key: "Gold", label: "Gold", mineral: "Native gold", crustalAbundance: 0.0000004, enrichmentRange: [3000, 11000], minGrade: 0.00005, maxGrade: 0.0025, biomeBoosts: { Mountain: 1.5, Highlands: 1.4, Badlands: 1.1, Desert: 0.8, "Crater Ridge": 1.35, "Basalt Ridge": 1.2, "Salt Flat": 0.9, "Dust Basin": 0.8 } },
  { key: "Uranium", label: "Uraninite", mineral: "Uraninite", crustalAbundance: 0.0002, enrichmentRange: [80, 250], minGrade: 0.009, maxGrade: 0.06, biomeBoosts: { Highlands: 1.3, Badlands: 1.1, Mountain: 0.9, Desert: 0.7, "Crater Ridge": 1.2, "Basalt Ridge": 1.1, "Stone Garden": 0.9 } },
  { key: "Water Ice", label: "Water Ice", mineral: "Water ice", crustalAbundance: 4.8, enrichmentRange: [1.2, 4.5], minGrade: 8, maxGrade: 30, biomeBoosts: { "Ice Sheet": 1.6, "Glacier Basin": 1.4, "Pressure Ridge": 1.3, "Cryo Shelf": 1.2, Ocean: 0.8, "Ice Swell": 1.4, "Storm Band": 0.9 } },
  { key: "Sulfur", label: "Sulfur", mineral: "Native sulfur", crustalAbundance: 0.0004, enrichmentRange: [150, 400], minGrade: 0.25, maxGrade: 3.2, biomeBoosts: { "Ash Plain": 1.6, "Lava Field": 1.5, "Sulfur Marsh": 1.2, Badlands: 0.9 } },
  { key: "Methane", label: "Methane", mineral: "Methane / hydrocarbon ice", crustalAbundance: 0.00001, enrichmentRange: [180, 4200], minGrade: 0.02, maxGrade: 0.75, biomeBoosts: { "Ice Swell": 1.6, "Storm Band": 1.4, "Cryo Shelf": 1.3, "Glacier Basin": 1.1, "Ice Sheet": 0.9 } },
  { key: "Ammonia", label: "Ammonia", mineral: "Ammonia hydrate", crustalAbundance: 0.00002, enrichmentRange: [140, 3600], minGrade: 0.015, maxGrade: 0.55, biomeBoosts: { "Ice Swell": 1.5, "Storm Band": 1.3, "Cryo Shelf": 1.2, "Pressure Ridge": 1.1, "Glacier Basin": 0.9 } },
  { key: "Hydrogen", label: "Hydrogen", mineral: "Molecular hydrogen", crustalAbundance: 0.000001, enrichmentRange: [100, 4000], minGrade: 0.01, maxGrade: 0.35, biomeBoosts: { "Storm Band": 1.7, "Cloud Bank": 1.5, "Upper Atmosphere": 1.3, "Ice Swell": 1.1 } },
  { key: "Helium", label: "Helium", mineral: "Helium gas", crustalAbundance: 0.0000008, enrichmentRange: [120, 3500], minGrade: 0.01, maxGrade: 0.3, biomeBoosts: { "Storm Band": 1.6, "Cloud Bank": 1.4, "Upper Atmosphere": 1.2, "Ice Swell": 0.9 } }
];

function getResourceProfile(resourceKey, tile, rng) {
  const definition = RESOURCE_LIBRARY.find(item => item.key === resourceKey);
  if (!definition) return null;

  const biomeBoost = definition.biomeBoosts[tile.biome] || 1;
  const elevationBoost = tile.elevation > 0.7 ? 1.1 : tile.elevation > 0.55 ? 1.05 : 1;
  const moistureBoost = tile.moisture > 0.7 ? 1.05 : tile.moisture < 0.2 ? 0.95 : 1;
  const enrichmentFactor = definition.enrichmentRange[0] + rng() * (definition.enrichmentRange[1] - definition.enrichmentRange[0]);
  const gradePercent = Math.max(definition.minGrade, Math.min(definition.maxGrade, definition.crustalAbundance * enrichmentFactor * biomeBoost * elevationBoost * moistureBoost));
  const reserveTons = Math.round(400 + gradePercent * 1800 * (0.35 + rng() * 0.65));

  return {
    name: definition.label,
    mineral: definition.mineral,
    gradePercent: Number(gradePercent.toFixed(3)),
    reserveTons
  };
}

// ── 3D Value Noise with Seamless Cylindrical Mapping ─────────────────────
class ValueNoise3D {
  constructor(seed) {
    this.rng = createRNG(seed);
    this.grid = [];
    const size = 32;
    for (let z = 0; z < size; z++) {
      const plane = [];
      for (let y = 0; y < size; y++) {
        const row = [];
        for (let x = 0; x < size; x++) {
          row.push(this.rng());
        }
        plane.push(row);
      }
      this.grid.push(plane);
    }
    this.size = size;
  }

  noise(x, y, z) {
    const X = ((Math.floor(x) % this.size) + this.size) % this.size;
    const Y = ((Math.floor(y) % this.size) + this.size) % this.size;
    const Z = ((Math.floor(z) % this.size) + this.size) % this.size;

    const nextX = (X + 1) % this.size;
    const nextY = (Y + 1) % this.size;
    const nextZ = (Z + 1) % this.size;

    const fx = x - Math.floor(x);
    const fy = y - Math.floor(y);
    const fz = z - Math.floor(z);

    const u = fx * fx * (3.0 - 2.0 * fx);
    const v = fy * fy * (3.0 - 2.0 * fy);
    const w = fz * fz * (3.0 - 2.0 * fz);

    const c000 = this.grid[Z][Y][X];
    const c100 = this.grid[Z][Y][nextX];
    const c010 = this.grid[Z][nextY][X];
    const c110 = this.grid[Z][nextY][nextX];
    const c001 = this.grid[nextZ][Y][X];
    const c101 = this.grid[nextZ][Y][nextX];
    const c011 = this.grid[nextZ][nextY][X];
    const c111 = this.grid[nextZ][nextY][nextX];

    const nx00 = c000 * (1 - u) + c100 * u;
    const nx10 = c010 * (1 - u) + c110 * u;
    const nx01 = c001 * (1 - u) + c101 * u;
    const nx11 = c011 * (1 - u) + c111 * u;

    const nxy0 = nx00 * (1 - v) + nx10 * v;
    const nxy1 = nx01 * (1 - v) + nx11 * v;

    return nxy0 * (1 - w) + nxy1 * w;
  }

  // Multi-octave Fractional Brownian Motion
  fbm(x, y, z, octaves = 6) {
    let value = 0.0;
    let amplitude = 1.0;
    let frequency = 1.0;
    let maxVal = 0.0;
    for (let i = 0; i < octaves; i++) {
      value += this.noise(x * frequency, y * frequency, z * frequency) * amplitude;
      maxVal += amplitude;
      amplitude *= 0.5;
      frequency *= 2.0;
    }
    return value / maxVal;
  }
}

function hashSeed(value) {
  return String(value).split("").reduce((acc, ch) => acc + ch.charCodeAt(0), 0);
}

// Global Sea Level Cutoff per planet type
const PLANET_SEA_LEVEL = {
  "Terran Habitable": 0.45, // 45% ocean, 55% land
  "Volcanic":         0.0,  // Dry planet (0% ocean)
  "Desert":           0.0,  // Dry planet
  "Rocky":            0.0,  // Dry planet
  "Barren Rocky":     0.0,  // Dry planet
  "Ice World":        0.0,  // Dry / fully frozen planet
  "Ice Giant":        0.0,  // Atmosphere / surface layer
  "Gas Giant":        0.0   // Atmosphere layer
};

// Max land height (km) and max ocean depth (km) per planet type
const PLANET_ELEVATION_SCALES = {
  "Terran Habitable": { maxMountainKm: 8.8,  maxOceanDepthKm: 8.0 },
  "Volcanic":         { maxMountainKm: 21.0, maxOceanDepthKm: 0.0 },
  "Desert":           { maxMountainKm: 6.5,  maxOceanDepthKm: 0.0 },
  "Rocky":            { maxMountainKm: 5.0,  maxOceanDepthKm: 0.0 },
  "Barren Rocky":     { maxMountainKm: 4.0,  maxOceanDepthKm: 0.0 },
  "Ice World":        { maxMountainKm: 3.5,  maxOceanDepthKm: 0.0 },
  "Ice Giant":        { maxMountainKm: 3.0,  maxOceanDepthKm: 0.0 },
  "Gas Giant":        { maxMountainKm: 2.0,  maxOceanDepthKm: 0.0 }
};

function getPlanetBiomeDefinition(planetType, elevation, moisture, temperature, rng) {
  const normalizedType = (planetType || "Terran Habitable").toString();

  if (normalizedType === "Volcanic") {
    if (elevation > 0.82) return { name: "Crater Ridge", color: "#5b4b3a" };
    if (elevation < 0.3) return { name: "Lava Field", color: "#b33a1d" };
    if (moisture > 0.58) return { name: "Sulfur Marsh", color: "#7a6a2f" };
    if (moisture < 0.22) return { name: "Ash Plain", color: "#7a4f2c" };
    return { name: "Basalt Ridge", color: "#4b3c35" };
  }

  if (normalizedType === "Ice World") {
    if (temperature < -28) return { name: "Pressure Ridge", color: "#f5f7ff" };
    if (moisture > 0.62) return { name: "Glacier Basin", color: "#a9c7ff" };
    if (elevation < 0.2) return { name: "Ice Shelf", color: "#d9ecff" };
    return { name: "Ice Sheet", color: "#cfe3ff" };
  }

  if (normalizedType === "Ice Giant") {
    if (moisture > 0.66) return { name: "Storm Band", color: "#5c7bd6" };
    if (elevation > 0.73) return { name: "Pressure Ridge", color: "#7f95d8" };
    if (moisture < 0.25) return { name: "Cryo Shelf", color: "#b8d5ff" };
    return { name: "Ice Swell", color: "#8fa9e5" };
  }

  if (normalizedType === "Barren Rocky") {
    if (elevation > 0.82) return { name: "Crater Ridge", color: "#6b6f75" };
    if (moisture < 0.2) return { name: "Dust Basin", color: "#8d7f6d" };
    if (elevation > 0.56) return { name: "Basalt Ridge", color: "#4c4b48" };
    return { name: "Stone Garden", color: "#7d7267" };
  }

  if (normalizedType === "Desert") {
    if (temperature > 28) return { name: "Salt Flat", color: "#f2e0a4" };
    if (moisture > 0.62) return { name: "Oasis Margin", color: "#7fbf6f" };
    if (elevation > 0.68) return { name: "Rock Garden", color: "#c9a96f" };
    if (moisture < 0.2) return { name: "Salt Flat", color: "#f2e0a4" };
    return { name: "Dune Sea", color: "#e2b76d" };
  }

  if (normalizedType === "Rocky") {
    if (elevation > 0.72) return { name: "Rocky Highland", color: "#6e5e56" };
    if (moisture > 0.55) return { name: "Mesa Plain", color: "#8e7b5b" };
    return { name: "Rubble Field", color: "#93827a" };
  }

  if (normalizedType === "Gas Giant") {
    if (rng() < 0.35) return { name: "Cloud Bank", color: "#5b6fd6" };
    if (rng() < 0.7) return { name: "Storm Band", color: "#7e5dc3" };
    return { name: "Upper Atmosphere", color: "#3d4fb8" };
  }

  // Default terrestrial style
  const seaLevel = 0.0;
  const mountainThreshold = 0.62;
  const continentalThreshold = 0.18;

  if (temperature < -10) {
    return { name: "Tundra", color: "#b7cfe0" };
  }
  if (elevation < seaLevel) {
    return { name: "Ocean", color: "#1d3557" };
  }
  if (elevation > mountainThreshold) {
    return { name: "Mountain", color: "#5c677d" };
  }
  if (elevation > continentalThreshold) {
    if (moisture > 0.7) return { name: temperature > 20 ? "Rainforest" : "Temperate Forest", color: temperature > 20 ? "#1b4332" : "#2d6a4f" };
    if (moisture > 0.45) return { name: temperature > 24 ? "Grasslands" : "Highlands", color: temperature > 24 ? "#80b918" : "#6b8f71" };
    if (moisture < 0.2) return { name: "Badlands", color: "#b45309" };
    return { name: temperature > 24 ? "Grasslands" : "Highlands", color: temperature > 24 ? "#80b918" : "#6b8f71" };
  }
  if (moisture > 0.72) return { name: temperature > 24 ? "Rainforest" : "Temperate Forest", color: temperature > 24 ? "#1b4332" : "#2d6a4f" };
  if (moisture > 0.55) return { name: temperature > 18 ? "Temperate Forest" : "Plains", color: temperature > 18 ? "#2d6a4f" : "#55a630" };
  if (moisture > 0.35) return { name: temperature > 20 ? "Grasslands" : "Plains", color: temperature > 20 ? "#80b918" : "#55a630" };
  if (moisture < 0.18) return { name: temperature > 24 ? "Desert" : "Badlands", color: temperature > 24 ? "#e9c46a" : "#b45309" };
  return { name: temperature > 24 ? "Grasslands" : "Plains", color: temperature > 24 ? "#80b918" : "#55a630" };
}

function buildResourceDefinitions(planetType) {
  const normalizedType = (planetType || "Terran Habitable").toString();

  if (normalizedType === "Volcanic") {
    return [
      { key: "Iron", maxVeins: 7, maxGrowth: 5, weight: (t) => (t.biome === "Crater Ridge" || t.biome === "Basalt Ridge" ? 1.7 : t.biome === "Ash Plain" ? 1.2 : 0.35) },
      { key: "Copper", maxVeins: 6, maxGrowth: 5, weight: (t) => (t.biome === "Crater Ridge" || t.biome === "Basalt Ridge" ? 1.5 : t.biome === "Sulfur Marsh" ? 0.9 : 0.25) },
      { key: "Sulfur", maxVeins: 6, maxGrowth: 5, weight: (t) => (t.biome === "Ash Plain" || t.biome === "Sulfur Marsh" || t.biome === "Lava Field" ? 1.8 : 0.2) },
      { key: "Nickel", maxVeins: 4, maxGrowth: 4, weight: (t) => (t.biome === "Crater Ridge" ? 1.4 : t.biome === "Basalt Ridge" ? 1.0 : 0.15) }
    ];
  }

  if (normalizedType === "Gas Giant") {
    return [
      { key: "Hydrogen", maxVeins: 8, maxGrowth: 6, weight: (t) => (t.biome === "Storm Band" ? 1.7 : t.biome === "Cloud Bank" ? 1.4 : 0.2) },
      { key: "Helium", maxVeins: 6, maxGrowth: 5, weight: (t) => (t.biome === "Storm Band" ? 1.5 : t.biome === "Upper Atmosphere" ? 1.2 : 0.15) },
      { key: "Methane", maxVeins: 5, maxGrowth: 5, weight: (t) => (t.biome === "Cloud Bank" ? 1.3 : t.biome === "Upper Atmosphere" ? 0.9 : 0.1) },
      { key: "Ammonia", maxVeins: 4, maxGrowth: 4, weight: (t) => (t.biome === "Storm Band" ? 1.1 : t.biome === "Cloud Bank" ? 0.9 : 0.08) }
    ];
  }

  if (normalizedType === "Ice World") {
    return [
      { key: "Water Ice", maxVeins: 10, maxGrowth: 6, weight: (t) => (t.biome === "Ice Sheet" || t.biome === "Glacier Basin" ? 1.8 : t.biome === "Pressure Ridge" ? 1.2 : 0.3) },
      { key: "Deuterium", maxVeins: 5, maxGrowth: 4, weight: (t) => (t.biome === "Glacier Basin" || t.biome === "Ice Shelf" ? 1.3 : 0.2) },
      { key: "Methane", maxVeins: 4, maxGrowth: 4, weight: (t) => (t.biome === "Ice Sheet" ? 1.0 : t.biome === "Glacier Basin" ? 0.8 : 0.1) },
      { key: "Ammonia", maxVeins: 3, maxGrowth: 3, weight: (t) => (t.biome === "Pressure Ridge" ? 0.9 : 0.1) }
    ];
  }

  if (normalizedType === "Ice Giant") {
    return [
      { key: "Water Ice", maxVeins: 8, maxGrowth: 6, weight: (t) => (t.biome === "Ice Swell" || t.biome === "Pressure Ridge" ? 1.6 : t.biome === "Cryo Shelf" ? 1.3 : 0.2) },
      { key: "Methane", maxVeins: 6, maxGrowth: 5, weight: (t) => (t.biome === "Storm Band" ? 1.5 : t.biome === "Ice Swell" ? 1.1 : 0.18) },
      { key: "Ammonia", maxVeins: 5, maxGrowth: 4, weight: (t) => (t.biome === "Storm Band" ? 1.3 : t.biome === "Cryo Shelf" ? 1.0 : 0.12) },
      { key: "Hydrogen", maxVeins: 4, maxGrowth: 4, weight: (t) => (t.biome === "Storm Band" ? 1.4 : t.biome === "Cloud Bank" ? 1.0 : 0.1) }
    ];
  }

  if (normalizedType === "Barren Rocky") {
    return [
      { key: "Iron", maxVeins: 8, maxGrowth: 5, weight: (t) => (t.biome === "Crater Ridge" ? 1.8 : t.biome === "Basalt Ridge" ? 1.3 : 0.25) },
      { key: "Nickel", maxVeins: 5, maxGrowth: 4, weight: (t) => (t.biome === "Crater Ridge" || t.biome === "Basalt Ridge" ? 1.3 : 0.1) },
      { key: "Gold", maxVeins: 2, maxGrowth: 3, weight: (t) => (t.biome === "Dust Basin" ? 0.9 : 0.05) },
      { key: "Uranium", maxVeins: 3, maxGrowth: 3, weight: (t) => (t.biome === "Stone Garden" ? 0.8 : 0.1) }
    ];
  }

  if (normalizedType === "Desert") {
    return [
      { key: "Silicates", maxVeins: 7, maxGrowth: 5, weight: (t) => (t.biome === "Salt Flat" || t.biome === "Dune Sea" ? 1.4 : t.biome === "Rock Garden" ? 0.9 : 0.2) },
      { key: "Copper", maxVeins: 5, maxGrowth: 4, weight: (t) => (t.biome === "Rock Garden" ? 1.1 : t.biome === "Dune Sea" ? 0.7 : 0.15) },
      { key: "Gold", maxVeins: 3, maxGrowth: 3, weight: (t) => (t.biome === "Rock Garden" ? 0.9 : 0.05) },
      { key: "Aluminum", maxVeins: 4, maxGrowth: 4, weight: (t) => (t.biome === "Salt Flat" ? 0.8 : 0.15) }
    ];
  }

  if (normalizedType === "Rocky") {
    return [
      { key: "Iron", maxVeins: 6, maxGrowth: 4, weight: (t) => (t.biome === "Rocky Highland" ? 1.4 : t.biome === "Mesa Plain" ? 0.8 : 0.2) },
      { key: "Aluminum", maxVeins: 5, maxGrowth: 4, weight: (t) => (t.biome === "Rocky Highland" ? 1.1 : t.biome === "Mesa Plain" ? 0.8 : 0.1) },
      { key: "Copper", maxVeins: 4, maxGrowth: 4, weight: (t) => (t.biome === "Rubble Field" ? 1.0 : 0.1) }
    ];
  }

  return [
    { key: "Iron", maxVeins: 12, maxGrowth: 7, weight: (t) => (t.biome === "Mountain" ? 1.9 : t.biome === "Highlands" ? 1.2 : t.biome === "Badlands" ? 0.9 : 0.25) },
    { key: "Copper", maxVeins: 12, maxGrowth: 7, weight: (t) => (t.elevation > 0.35 ? 1.5 : t.biome === "Highlands" ? 1.1 : t.biome === "Temperate Forest" ? 0.8 : 0.25) },
    { key: "Osmium", maxVeins: 5, maxGrowth: 4, weight: (t) => (t.biome === "Mountain" ? 1.6 : t.biome === "Highlands" ? 0.9 : 0.08) },
    { key: "Silicates", maxVeins: 10, maxGrowth: 8, weight: (t) => (t.biome === "Desert" || t.biome === "Badlands" ? 1.4 : t.biome === "Plains" ? 0.9 : 0.25) },
    { key: "Deuterium", maxVeins: 7, maxGrowth: 5, weight: (t) => (t.isRiver || t.moisture > 0.65 ? 1.4 : t.biome === "Rainforest" ? 0.9 : 0.18) },
    { key: "Aluminum", maxVeins: 8, maxGrowth: 6, weight: (t) => (t.biome === "Highlands" || t.biome === "Mountain" ? 1.3 : t.biome === "Temperate Forest" ? 0.8 : 0.22) },
    { key: "Nickel", maxVeins: 6, maxGrowth: 5, weight: (t) => (t.biome === "Mountain" || t.biome === "Badlands" ? 1.1 : t.biome === "Highlands" ? 0.8 : 0.12) },
    { key: "Gold", maxVeins: 6, maxGrowth: 4, weight: (t) => (t.biome === "Mountain" || t.biome === "Highlands" || t.biome === "Badlands" ? 1.1 : t.biome === "Plains" ? 0.25 : 0.12) },
    { key: "Uranium", maxVeins: 4, maxGrowth: 3, weight: (t) => (t.biome === "Highlands" || t.biome === "Badlands" ? 0.8 : t.biome === "Mountain" ? 0.55 : 0.1) }
  ];
}

function resolveClimateProfile(planetType, climate, rng) {
  if (climate && typeof climate === "object") {
    const averageTempC = Number.isFinite(climate.averageTempC) ? climate.averageTempC : 15;
    const equatorTempC = Number.isFinite(climate.equatorTempC) ? climate.equatorTempC : averageTempC + 16;
    const poleTempC = Number.isFinite(climate.poleTempC) ? climate.poleTempC : averageTempC - 18;
    return { averageTempC, equatorTempC, poleTempC };
  }

  if (planetType === "Terran Habitable") {
    return { averageTempC: 15, equatorTempC: 32, poleTempC: -6 };
  }
  if (["Desert", "Volcanic", "Rocky", "Barren Rocky"].includes(planetType)) {
    return { averageTempC: 18, equatorTempC: 32, poleTempC: -4 };
  }
  if (["Ice World", "Ice Giant"].includes(planetType)) {
    return { averageTempC: -15, equatorTempC: -2, poleTempC: -38 };
  }
  return { averageTempC: 0, equatorTempC: 10, poleTempC: -20 };
}

export function generatePlanetaryGrid(planetId, seed, planetType = "Terran Habitable", climate = null, diameterKm = null) {
  const rng = createRNG(seed + hashSeed(`${planetId}:${planetType}`));
  const tileSizeKm = 100;
  const derivedDiameter = Number.isFinite(diameterKm) && diameterKm > 0 ? diameterKm : 12742;
  const size = Math.min(256, Math.max(64, Math.ceil(derivedDiameter / tileSizeKm)));
  const grid = [];
  const normalizedType = (planetType || "Terran Habitable").toString();
  const climateProfile = resolveClimateProfile(normalizedType, climate, rng);

  const heightNoise   = new ValueNoise3D(seed + 100 + hashSeed(normalizedType));
  const warpNoiseX    = new ValueNoise3D(seed + 150 + hashSeed(normalizedType));
  const warpNoiseY    = new ValueNoise3D(seed + 160 + hashSeed(normalizedType));
  const warpNoiseZ    = new ValueNoise3D(seed + 170 + hashSeed(normalizedType));
  const moistureNoise = new ValueNoise3D(seed + 200 + hashSeed(normalizedType));
  const climateNoise  = new ValueNoise3D(seed + 300 + hashSeed(normalizedType));

  const seaLevel = PLANET_SEA_LEVEL[normalizedType] ?? 0.45;
  const scales   = PLANET_ELEVATION_SCALES[normalizedType] ?? PLANET_ELEVATION_SCALES["Terran Habitable"];

  // Radius for 3D sphere sampling
  const sphereRadius = 4.0;

  // Generate Tectonic Plates (8 seed centers distributed on 3D sphere)
  const plateCount = 8;
  const plateRNG   = createRNG(seed + 777 + hashSeed(normalizedType));
  const plates     = [];

  for (let p = 0; p < plateCount; p++) {
    // Uniform spherical distribution using Golden Spiral / Fibonacci sphere method
    const pTheta = plateRNG() * Math.PI * 2; // Longitude [0, 2π]
    const pPhi   = (plateRNG() - 0.5) * Math.PI * 0.85; // Latitude [-85°, +85°]
    const cosPhi = Math.cos(pPhi);

    const pX = sphereRadius * cosPhi * Math.cos(pTheta);
    const pY = sphereRadius * cosPhi * Math.sin(pTheta);
    const pZ = sphereRadius * Math.sin(pPhi);

    const isContinental = normalizedType === "Terran Habitable" ? (p % 2 === 0) : true;
    plates.push({
      x: pX,
      y: pY,
      z: pZ,
      isContinental,
      baseHeight: isContinental ? (0.48 + plateRNG() * 0.22) : (0.12 + plateRNG() * 0.18)
    });
  }

  for (let y = 0; y < size; y++) {
    const row = [];
    // Latitude phi ∈ [-π/2, +π/2] (North Pole to South Pole)
    const latFrac = (y / (size - 1)) - 0.5; // [-0.5, +0.5]
    const phi     = latFrac * Math.PI;      // [-π/2, +π/2]
    const cosPhi  = Math.cos(phi);
    const sinPhi  = Math.sin(phi);

    for (let x = 0; x < size; x++) {
      // 1. 3D Spherical Coordinates (X, Y, Z on sphere radius R)
      // At poles (y=0 or y=size-1), cosPhi=0 → X=0, Y=0, Z=±R (All longitudes converge at single point)
      const theta = (x / size) * Math.PI * 2; // Longitude [0, 2π]
      const rawSx = sphereRadius * cosPhi * Math.cos(theta);
      const rawSy = sphereRadius * cosPhi * Math.sin(theta);
      const rawSz = sphereRadius * sinPhi;

      // 2. Domain Warping: Organic coastlines, peninsulas & archipelagos
      const warpMag = 0.75;
      const wx = rawSx + (warpNoiseX.fbm(rawSx * 0.6, rawSy * 0.6, rawSz * 0.6, 3) - 0.5) * warpMag;
      const wy = rawSy + (warpNoiseY.fbm(rawSx * 0.6, rawSy * 0.6, rawSz * 0.6, 3) - 0.5) * warpMag;
      const wz = rawSz + (warpNoiseZ.fbm(rawSx * 0.6, rawSy * 0.6, rawSz * 0.6, 3) - 0.5) * warpMag;

      // 3. Voronoi Distance Field to Tectonic Plates
      let d1 = 9999;
      let d2 = 9999;
      let closestPlate = plates[0];
      let secondPlate = plates[1];

      for (let p = 0; p < plateCount; p++) {
        const plate = plates[p];
        const dx = wx - plate.x;
        const dy = wy - plate.y;
        const dz = wz - plate.z;
        const dist = Math.sqrt(dx * dx + dy * dy + dz * dz);

        if (dist < d1) {
          d2 = d1;
          secondPlate = closestPlate;
          d1 = dist;
          closestPlate = plate;
        } else if (dist < d2) {
          d2 = dist;
          secondPlate = plate;
        }
      }

      // Plate Boundary Collision (Himalayan / Andean mountain belt effect)
      const boundaryProximity = Math.max(0, 1.0 - (d2 - d1) / 1.4);
      const isCollisionZone = closestPlate.isContinental && secondPlate.isContinental;
      const mountainBelt = isCollisionZone ? Math.pow(boundaryProximity, 1.4) * 0.45 : boundaryProximity * 0.15;

      // 4. Composite Raw Height H ∈ [0.0, 1.0]
      const detailNoise = heightNoise.fbm(wx * 1.8, wy * 1.8, wz * 1.8, 5);
      const rawH = Math.max(0.0, Math.min(1.0,
        closestPlate.baseHeight * 0.55 + mountainBelt + detailNoise * 0.35
      ));

      // 5. Normalized Elevation E & Real-World elevationKm
      let elevation = 0.0;
      let elevationKm = 0.0;

      if (rawH < seaLevel) {
        // Ocean Tile
        const depthRatio = (seaLevel - rawH) / seaLevel;
        elevation = -depthRatio; // [-1.0, 0.0)
        elevationKm = Number((-depthRatio * scales.maxOceanDepthKm).toFixed(2));
      } else {
        // Land Tile
        const landRatio = (rawH - seaLevel) / (1.0 - seaLevel); // [0.0, 1.0]
        elevation = landRatio;

        // Exponential power curve for realistic peaks: coastal plains sit low, peaks rise high
        const mountainCurve = Math.pow(landRatio, 1.6);
        elevationKm = Number((mountainCurve * scales.maxMountainKm).toFixed(2));
      }

      // 6. Climate Logic — 100% UNTOUCHED (Latitude gradient cold poles, warm equator)
      const moisture = moistureNoise.fbm(rawSx * 1.5, rawSy * 1.5, rawSz * 1.5, 4);
      const latitude = (y / (size - 1) - 0.5) * 180;
      const latitudeGradient = 1 - Math.abs(latitude) / 90;
      const climateNoiseValue = climateNoise.fbm(rawSx * 1.2, rawSy * 1.2, rawSz * 1.2, 3);
      const baseTemperature = climateProfile.poleTempC + (climateProfile.equatorTempC - climateProfile.poleTempC) * latitudeGradient;
      const temperature = Math.max(climateProfile.poleTempC - 10, Math.min(climateProfile.equatorTempC + 10, baseTemperature + (climateNoiseValue - 0.5) * 10));

      const biomeProfile = getPlanetBiomeDefinition(normalizedType, elevation, moisture, temperature, rng);

      row.push({
        x,
        y,
        elevation,
        elevationKm,
        moisture,
        temperature,
        latitude,
        biome: biomeProfile.name,
        color: biomeProfile.color,
        isRiver: false,
        resources: {},
        explored: true,
        structures: [],
        roadConnections: []
      });
    }
    grid.push(row);
  }

  if (["Terran Habitable", "Desert", "Rocky"].includes(normalizedType)) {
    const sources = [];
    for (let y = 1; y < size - 1; y++) {
      for (let x = 1; x < size - 1; x++) {
        if (grid[y][x].biome === "Mountain" && sources.length < 3 && rng() < 0.05) {
          sources.push({ x, y });
        }
      }
    }

    sources.forEach(src => {
      let curr = src;
      let pathLength = 0;
      while (pathLength < 80) {
        grid[curr.y][curr.x].isRiver = true;

        let downhill = null;
        let minElevation = grid[curr.y][curr.x].elevation;
        const directions = [
          { dx: 0, dy: -1 }, { dx: 0, dy: 1 },
          { dx: -1, dy: 0 }, { dx: 1, dy: 0 }
        ];

        directions.forEach(d => {
          const nx = (curr.x + d.dx + size) % size;
          const ny = curr.y + d.dy;
          if (ny >= 0 && ny < size) {
            const neighbor = grid[ny][nx];
            if (neighbor.elevation < minElevation) {
              minElevation = neighbor.elevation;
              downhill = { x: nx, y: ny };
            }
          }
        });

        if (!downhill) {
          const randomDir = getRandomItem(directions, rng);
          const rx = (curr.x + randomDir.dx + size) % size;
          const ry = curr.y + randomDir.dy;
          if (ry >= 0 && ry < size) {
            downhill = { x: rx, y: ry };
          } else {
            break;
          }
        }

        if (downhill.x === curr.x && downhill.y === curr.y) break;
        curr = downhill;
        pathLength++;
      }
    });
  }

  const resourceDefinitions = buildResourceDefinitions(normalizedType);
  const addCompanionResource = (tile, primaryKey, rng) => {
    if (!tile || !tile.resources || Object.keys(tile.resources).length === 0) return;
    const companions = {
      Gold: ["Iron", "Copper", "Nickel", "Osmium", "Uranium"],
      Iron: ["Copper", "Gold", "Nickel", "Uranium"],
      Copper: ["Iron", "Gold", "Aluminum", "Nickel"],
      Aluminum: ["Copper", "Silicates", "Gold"],
      Nickel: ["Iron", "Gold"],
      Silicates: ["Aluminum", "Gold", "Deuterium"],
      Deuterium: ["Silicates", "Gold"]
    };

    const candidateKeys = companions[primaryKey] || [];
    if (candidateKeys.length === 0) return;

    const candidateKey = candidateKeys.find(key => !tile.resources[key]);
    if (!candidateKey) return;

    if (rng() < 0.4) {
      const profile = getResourceProfile(candidateKey, tile, rng);
      if (profile) {
        tile.resources[candidateKey] = {
          ...profile,
          gradePercent: Number((profile.gradePercent * 0.8).toFixed(3)),
          reserveTons: Math.round(profile.reserveTons * 0.6)
        };
      }
    }
  };

  const seedVeins = (resourceDefinition) => {
    const { key, maxVeins, maxGrowth, weight } = resourceDefinition;
    let veinsSeeded = 0;
    while (veinsSeeded < maxVeins) {
      const sx = getSeededRandomValue(0, size, rng);
      const sy = getSeededRandomValue(0, size, rng);
      const tile = grid[sy][sx];

      if (weight(tile) > 0 && rng() < weight(tile)) {
        let curr = { x: sx, y: sy };
        let growth = 0;
        while (growth < maxGrowth) {
          const cTile = grid[curr.y][curr.x];
          if (cTile.biome !== "Ocean") {
            const profile = getResourceProfile(key, cTile, rng);
            if (profile) {
              const gradeMultiplier = 1 - growth * 0.12;
              cTile.resources[key] = {
                ...profile,
                gradePercent: Number((profile.gradePercent * gradeMultiplier).toFixed(3)),
                reserveTons: Math.round(profile.reserveTons * (0.8 + 0.2 * gradeMultiplier))
              };
              if (Object.keys(cTile.resources).length > 1 && rng() < 0.35) {
                addCompanionResource(cTile, key, rng);
              }
            }
          }

          const nextDir = getRandomItem([
            { dx: -1, dy: 0 }, { dx: 1, dy: 0 },
            { dx: 0, dy: -1 }, { dx: 0, dy: 1 }
          ], rng);
          const nx = (curr.x + nextDir.dx + size) % size;
          const ny = curr.y + nextDir.dy;

          if (ny >= 0 && ny < size) {
            curr = { x: nx, y: ny };
          }
          growth++;
        }
        veinsSeeded++;
      }
    }
  };

  resourceDefinitions.forEach(seedVeins);
  return grid;
}
