import React, { useState, useEffect } from "react";
import { loadData, createRNG } from "./utils/nameGenerator";
import { generateUniverse } from "./utils/universeGenerator";
import { generatePlanetaryGrid } from "./utils/planetGridGenerator";
import { initializeColony, tickColony } from "./utils/colonySimulator";
import ConsoleDashboard from "./components/ConsoleDashboard";
import { Radio, Loader2 } from "lucide-react";

export default function App() {
  const [loading, setLoading] = useState(true);
  const [universe, setUniverse] = useState(null);
  const [activeColonies, setActiveColonies] = useState({});
  const [isSimRunning, setIsSimRunning] = useState(false);
  const [simSpeed, setSimSpeed] = useState(1);
  const [scenarioConfig, setScenarioConfig] = useState({
    seed: 42,
    systemCount: 300,
    minimumHabitable: 15
  });

  useEffect(() => {
    let cancelled = false;

    async function init() {
      setLoading(true);
      setUniverse(null);
      setActiveColonies({});
      await loadData();

      if (cancelled) return;

      const generated = generateUniverse({
        seed: scenarioConfig.seed,
        systemCount: scenarioConfig.systemCount,
        minimumHabitable: scenarioConfig.minimumHabitable
      });

      setUniverse(generated);

      const startingColonies = {};
      const rng = createRNG(scenarioConfig.seed + 101);

      generated.starSystems.forEach(sys => {
        if (sys.faction && sys.isHomeworld) {
          const habPlanet = sys.planets.find(p => p.type === "Terran Habitable");
          if (habPlanet) {
            const gridSeed = Math.floor(rng() * 999999);
            habPlanet.explorationGrid = generatePlanetaryGrid(
              habPlanet.id,
              gridSeed,
              habPlanet.type,
              habPlanet.climate,
              habPlanet.physicalProperties?.equatorialDiameterKm
            );
            const colony = initializeColony(sys, habPlanet, sys.faction, habPlanet.explorationGrid, gridSeed + 1);
            startingColonies[habPlanet.id] = colony;
          }
        }
      });

      if (!cancelled) {
        setActiveColonies(startingColonies);
        setIsSimRunning(false);
        setLoading(false);
      }
    }

    init();

    return () => {
      cancelled = true;
    };
  }, [scenarioConfig.seed, scenarioConfig.systemCount, scenarioConfig.minimumHabitable]);

  useEffect(() => {
    if (!isSimRunning || loading || !universe) return;

    const interval = setInterval(() => {
      setActiveColonies(prevColonies => {
        const updated = { ...prevColonies };
        const rng = createRNG(Math.floor(Math.random() * 99999));

        for (let speedTick = 0; speedTick < simSpeed; speedTick++) {
          Object.keys(updated).forEach(planetId => {
            const colony = { ...updated[planetId] };

            let targetPlanet = null;
            for (const sys of universe.starSystems) {
              const p = sys.planets.find(item => item.id === planetId);
              if (p) {
                targetPlanet = p;
                break;
              }
            }

            if (targetPlanet && targetPlanet.explorationGrid) {
              updated[planetId] = tickColony(colony, targetPlanet.explorationGrid, rng);
            }
          });
        }
        return updated;
      });
    }, 1000);

    return () => clearInterval(interval);
  }, [isSimRunning, simSpeed, loading, universe]);

  if (loading) {
    return (
      <div className="w-screen h-screen flex flex-col items-center justify-center bg-[#020617] text-cyan-400 gap-6">
        <Radio className="w-16 h-16 text-cyan-400 active-pulse" />
        <div className="flex items-center gap-3">
          <Loader2 className="w-6 h-6 animate-spin text-cyan-400" />
          <h2 className="text-xl font-extrabold tracking-widest text-neon-cyan uppercase">
            BOOTING WORLD GENERATOR & SIMULATOR
          </h2>
        </div>
        <p className="text-xs text-slate-500 font-semibold tracking-wider">
          Loading names library & seeding planetary veins...
        </p>
      </div>
    );
  }

  return (
    <div className="w-screen h-screen overflow-hidden bg-[#020617]">
      <ConsoleDashboard
        universe={universe}
        setUniverse={setUniverse}
        activeColonies={activeColonies}
        setActiveColonies={setActiveColonies}
        isSimRunning={isSimRunning}
        setIsSimRunning={setIsSimRunning}
        simSpeed={simSpeed}
        setSimSpeed={setSimSpeed}
        scenarioConfig={scenarioConfig}
        setScenarioConfig={setScenarioConfig}
      />
    </div>
  );
}
