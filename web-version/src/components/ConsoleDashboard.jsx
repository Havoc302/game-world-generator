import React, { useRef, useEffect, useState } from "react";
import { Play, Pause, FastForward, Compass, Globe, Radio, Layers, ArrowRight, ShieldAlert, Cpu, Users, Database } from "lucide-react";
import { generatePlanetaryGrid } from "../utils/planetGridGenerator";
import { initializeColony, tickColony } from "../utils/colonySimulator";

/* ─── Shared inline style tokens ─── */
const S = {
  // Layout
  fillFlex: { display: "flex", flexDirection: "column", width: "100%", height: "100%", overflow: "hidden" },
  row: { display: "flex", flexDirection: "row", alignItems: "center" },
  rowGap4: { display: "flex", flexDirection: "row", alignItems: "center", gap: "16px" },
  // Borders & Backgrounds
  glassPanel: {
    background: "rgba(15,23,42,0.65)",
    backdropFilter: "blur(16px)",
    border: "1px solid rgba(255,255,255,0.08)",
    borderRadius: "12px",
    boxShadow: "0 8px 32px rgba(0,0,0,0.37)"
  },
  divider: { width: "1px", height: "24px", background: "rgba(255,255,255,0.1)" },
  hDivider: { height: "1px", background: "rgba(255,255,255,0.08)", margin: "4px 0" },
  // Text
  label: { fontSize: "10px", color: "#94a3b8", fontWeight: 700, letterSpacing: "0.1em", textTransform: "uppercase" },
  labelCyan: { fontSize: "10px", color: "#06b6d4", fontWeight: 800, letterSpacing: "0.1em", textTransform: "uppercase" },
  val: { fontSize: "12px", color: "#e2e8f0", fontWeight: 700 },
  micro: { fontSize: "9px", color: "#64748b", fontWeight: 700 },
};

const FACTION_COLORS_SOLID = {
  "Cobalt Mercenary Coalition": "#1e90ff",
  "Crimson Corsairs": "#dc143c",
  "Iron Dominion": "#696969",
  "New Jerusalem Republic": "#daa520",
  "Puritan Ascendancy": "#9370db",
  "Serenity Collective": "#2e8b57",
  "Sisterhood of Gaia": "#228b22",
  "Stellar Directorate of Solitude": "#708090",
  "Stellar Trade Federation": "#f4a460",
  "Technocratic Union of Nova Celestia": "#00ced1",
  "The Caliphate of Najm": "#bdb76b",
  "Union of Celestial Nations": "#b22222",
  "Unity Alliance": "#4682b4",
  "Vance Consortium": "#cd853f",
  "Verdant Alliance": "#9acd32"
};
const getFactionColorSolid = n => FACTION_COLORS_SOLID[n] || "#ffffff";

function getDistanceSq(x1, y1, x2, y2) {
  return (x2 - x1) ** 2 + (y2 - y1) ** 2;
}

export default function ConsoleDashboard({ universe, activeColonies, setActiveColonies, isSimRunning, setIsSimRunning, simSpeed, setSimSpeed, scenarioConfig, setScenarioConfig }) {
  const [activeTab, setActiveTab] = useState("sector");
  const [selectedSystem, setSelectedSystem] = useState(null);
  const [selectedPlanet, setSelectedPlanet] = useState(null);
  const [selectedTile, setSelectedTile] = useState(null);
  const [draftConfig, setDraftConfig] = useState(scenarioConfig);
  const [planetZoom, setPlanetZoom] = useState(1);
  const [planetCanvasSize, setPlanetCanvasSize] = useState({ width: 640, height: 640 });
  const [planetPan, setPlanetPan] = useState({ x: 0, y: 0 });
  const [isPlanetPanning, setIsPlanetPanning] = useState(false);
  const planetDragStart = useRef({ x: 0, y: 0 });

  const sectorCanvasRef = useRef(null);
  const planetCanvasRef = useRef(null);

  const [sectorPan, setSectorPan] = useState({ x: -1000, y: -1000 });
  const [sectorZoom, setSectorZoom] = useState(0.18);
  const isDragging = useRef(false);
  const dragStart = useRef({ x: 0, y: 0 });
  const hasDragged = useRef(false);

  useEffect(() => {
    setDraftConfig(scenarioConfig);
  }, [scenarioConfig]);

  useEffect(() => {
    setSelectedSystem(null);
    setSelectedPlanet(null);
    setSelectedTile(null);
  }, [scenarioConfig.seed, scenarioConfig.systemCount, scenarioConfig.minimumHabitable]);

  // Auto-select first habitable system on load or after regeneration
  useEffect(() => {
    if (universe && !selectedSystem) {
      const hab = universe.starSystems.find(s => s.isHabitable) || universe.starSystems.find(s => s.planets?.some(p => p.type === "Terran Habitable"));
      if (hab) {
        setSelectedSystem(hab);
        const p = hab.planets.find(p => p.type === "Terran Habitable") || hab.planets[0] || null;
        if (p) setSelectedPlanet(p);
      }
    }
  }, [universe, selectedSystem]);

  /* ═══ Sector Starmap Canvas ═══ */
  useEffect(() => {
    if (activeTab !== "sector" || !sectorCanvasRef.current || !universe) return;
    const canvas = sectorCanvasRef.current;
    const ctx = canvas.getContext("2d");
    let animId;

    const render = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.save();
      ctx.translate(sectorPan.x, sectorPan.y);
      ctx.scale(sectorZoom, sectorZoom);

      // Background grid
      ctx.strokeStyle = "rgba(255,255,255,0.02)";
      ctx.lineWidth = 4;
      for (let g = 0; g <= 4800; g += 100) {
        ctx.beginPath(); ctx.moveTo(g, 0); ctx.lineTo(g, 4800); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(0, g); ctx.lineTo(4800, g); ctx.stroke();
      }

      // Faction territory rings
      universe.territories.forEach(t => {
        const hw = universe.starSystems.find(s => s.id === t.homeworldId);
        if (!hw) return;
        ctx.beginPath();
        ctx.arc(hw.x, hw.y, t.range, 0, 2 * Math.PI);
        ctx.fillStyle = t.color;
        ctx.fill();
        ctx.strokeStyle = t.color.replace("0.4", "0.7");
        ctx.lineWidth = 5;
        ctx.stroke();
      });

      // Stars
      universe.starSystems.forEach(sys => {
        const isSel = selectedSystem && selectedSystem.id === sys.id;
        const STAR_COLORS = { O: "#00b4d8", B: "#90e0ef", A: "#caf0f8", F: "#fff3b0", G: "#ffb703", K: "#fb8500", M: "#e63946" };
        const starCol = STAR_COLORS[sys.spectralType] || "#fff";

        if (isSel) {
          ctx.beginPath();
          ctx.arc(sys.x, sys.y, 50, 0, 2 * Math.PI);
          ctx.fillStyle = "rgba(6,182,212,0.25)";
          ctx.fill();
        }
        ctx.beginPath();
        ctx.arc(sys.x, sys.y, isSel ? 24 : 14, 0, 2 * Math.PI);
        ctx.fillStyle = starCol;
        ctx.shadowBlur = 28; ctx.shadowColor = starCol;
        ctx.fill();
        ctx.shadowBlur = 0;

        if (sys.faction) {
          ctx.strokeStyle = getFactionColorSolid(sys.faction);
          ctx.lineWidth = 4;
          ctx.beginPath();
          ctx.arc(sys.x, sys.y, isSel ? 34 : 22, 0, 2 * Math.PI);
          ctx.stroke();
        }

        ctx.font = isSel ? "700 34px 'Outfit', 'Segoe UI', sans-serif" : "600 22px 'Outfit', 'Segoe UI', sans-serif";
        ctx.textBaseline = "alphabetic";
        ctx.fillStyle = isSel ? "#06b6d4" : "#64748b";
        ctx.fillText(sys.name, sys.x + (isSel ? 44 : 28), sys.y + 10);
      });

      ctx.restore();
      animId = requestAnimationFrame(render);
    };
    render();
    return () => cancelAnimationFrame(animId);
  }, [activeTab, universe, selectedSystem, sectorPan, sectorZoom]);

  /* ═══ Planet Grid Canvas ═══ */
  useEffect(() => {
    if (activeTab !== "planet" || !planetCanvasRef.current || !selectedPlanet?.explorationGrid) return;
    const canvas = planetCanvasRef.current;
    const ctx = canvas.getContext("2d");
    const grid = selectedPlanet.explorationGrid;
    const size = grid.length;
    const targetSize = Math.max(640, Math.min(1400, size * 10));
    canvas.width = targetSize;
    canvas.height = targetSize;
    setPlanetCanvasSize({ width: targetSize, height: targetSize });
    const ts = targetSize / size;
    let animId;
    const colony = activeColonies[selectedPlanet.id];

    const render = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      for (let y = 0; y < size; y++) {
        for (let x = 0; x < size; x++) {
          const tile = grid[y][x];

          if (!tile.explored) {
            ctx.fillStyle = "#080c14";
            ctx.fillRect(x * ts, y * ts, ts, ts);
            ctx.strokeStyle = "rgba(255,255,255,0.02)";
            ctx.lineWidth = 1;
            ctx.strokeRect(x * ts, y * ts, ts, ts);
            continue;
          }

          ctx.fillStyle = tile.color;
          ctx.fillRect(x * ts, y * ts, ts, ts);

          if (tile.isRiver) {
            ctx.fillStyle = "#4895ef";
            ctx.fillRect(x * ts + ts * 0.3, y * ts + ts * 0.3, ts * 0.4, ts * 0.4);
          }

          if (tile.structures.includes("Capital")) {
            ctx.fillStyle = "#fb8500";
            ctx.beginPath();
            ctx.arc(x * ts + ts / 2, y * ts + ts / 2, ts * 0.38, 0, 2 * Math.PI);
            ctx.fill();
            ctx.strokeStyle = "#fff"; ctx.lineWidth = 2; ctx.stroke();
          } else if (tile.structures.includes("Mine")) {
            ctx.fillStyle = "#ef4444";
            ctx.fillRect(x * ts + ts * 0.2, y * ts + ts * 0.2, ts * 0.6, ts * 0.6);
            ctx.strokeStyle = "#fff"; ctx.lineWidth = 1;
            ctx.strokeRect(x * ts + ts * 0.2, y * ts + ts * 0.2, ts * 0.6, ts * 0.6);
          } else if (tile.structures.includes("Farm")) {
            ctx.fillStyle = "#10b981";
            ctx.beginPath();
            ctx.arc(x * ts + ts / 2, y * ts + ts / 2, ts * 0.25, 0, 2 * Math.PI);
            ctx.fill();
          }

          if (Object.keys(tile.resources).length > 0) {
            const resourceColor = tile.resources[Object.keys(tile.resources)[0]]?.name === "Water Ice"
              ? "#bae6fd"
              : tile.resources[Object.keys(tile.resources)[0]]?.name === "Gold"
                ? "#facc15"
                : tile.resources[Object.keys(tile.resources)[0]]?.name === "Sulfur"
                  ? "#fde68a"
                  : "#f59e0b";
            ctx.fillStyle = resourceColor;
            ctx.beginPath();
            ctx.arc(x * ts + ts * 0.82, y * ts + ts * 0.18, ts * 0.08, 0, 2 * Math.PI);
            ctx.fill();
          }

          ctx.strokeStyle = "rgba(255,255,255,0.04)"; ctx.lineWidth = 1;
          ctx.strokeRect(x * ts, y * ts, ts, ts);
        }
      }

      if (colony?.explorationQueue?.length > 0) {
        const ex = colony.explorationQueue[0];
        ctx.strokeStyle = "#06b6d4"; ctx.lineWidth = 3;
        ctx.strokeRect(ex.x * ts + 1, ex.y * ts + 1, ts - 2, ts - 2);
        ctx.fillStyle = `rgba(6,182,212,${0.35 + Math.sin(Date.now() / 200) * 0.25})`;
        ctx.beginPath();
        ctx.arc(ex.x * ts + ts / 2, ex.y * ts + ts / 2, ts * 0.22, 0, 2 * Math.PI);
        ctx.fill();
      }

      if (selectedTile) {
        ctx.strokeStyle = "#f59e0b"; ctx.lineWidth = 3;
        ctx.strokeRect(selectedTile.x * ts, selectedTile.y * ts, ts, ts);
      }

      animId = requestAnimationFrame(render);
    };
    render();
    return () => cancelAnimationFrame(animId);
  }, [activeTab, selectedPlanet, selectedTile, activeColonies]);

  /* ─── Event handlers ─── */
  const onSectorMouseDown = e => {
    isDragging.current = true;
    hasDragged.current = false;
    dragStart.current = { x: e.clientX - sectorPan.x, y: e.clientY - sectorPan.y };
  };
  const onSectorMouseMove = e => {
    if (!isDragging.current) return;
    hasDragged.current = true;
    setSectorPan({ x: e.clientX - dragStart.current.x, y: e.clientY - dragStart.current.y });
  };
  const onSectorMouseUp = () => { isDragging.current = false; };

  const onSectorClick = e => {
    if (hasDragged.current || !universe) return;
    const rect = sectorCanvasRef.current.getBoundingClientRect();
    const wx = (e.clientX - rect.left - sectorPan.x) / sectorZoom;
    const wy = (e.clientY - rect.top - sectorPan.y) / sectorZoom;
    const hit = universe.starSystems.find(s => getDistanceSq(wx, wy, s.x, s.y) <= 45 * 45);
    if (hit) {
      setSelectedSystem(hit);
      const p = hit.planets?.find(p => p.type === "Terran Habitable") || hit.planets?.[0] || null;
      setSelectedPlanet(p);
      setSelectedTile(null);
    }
  };

  const onPlanetMouseDown = e => {
    if (!selectedPlanet?.explorationGrid) return;
    setIsPlanetPanning(true);
    planetDragStart.current = { x: e.clientX - planetPan.x, y: e.clientY - planetPan.y };
  };

  const onPlanetMouseMove = e => {
    if (!isPlanetPanning || !selectedPlanet?.explorationGrid) return;
    setPlanetPan({ x: e.clientX - planetDragStart.current.x, y: e.clientY - planetDragStart.current.y });
  };

  const onPlanetMouseUp = () => setIsPlanetPanning(false);

  const onPlanetClick = e => {
    if (!selectedPlanet?.explorationGrid || isPlanetPanning) return;
    const canvas = planetCanvasRef.current;
    const rect = canvas.getBoundingClientRect();
    const size = selectedPlanet.explorationGrid.length;
    const scaleX = canvas.width / rect.width;
    const scaleY = canvas.height / rect.height;
    const ts = canvas.width / size;
    const gx = Math.floor((e.clientX - rect.left) * scaleX / ts);
    const gy = Math.floor((e.clientY - rect.top) * scaleY / ts);
    if (gx >= 0 && gx < size && gy >= 0 && gy < size) {
      setSelectedTile(selectedPlanet.explorationGrid[gy][gx]);
    }
  };

  useEffect(() => {
    if (activeTab !== "planet" || !selectedPlanet || selectedPlanet.explorationGrid) return;

    const deriveSeed = (planet, system) => {
      const base = `${system?.id || "system"}:${planet.id}:${scenarioConfig.seed || 1}`;
      return base.split("").reduce((acc, ch) => acc + ch.charCodeAt(0), 0);
    };

    const grid = generatePlanetaryGrid(
      selectedPlanet.id,
      deriveSeed(selectedPlanet, selectedSystem),
      selectedPlanet.type,
      selectedPlanet.climate,
      selectedPlanet.physicalProperties?.equatorialDiameterKm
    );
    setSelectedPlanet(prev => prev?.id === selectedPlanet.id ? { ...prev, explorationGrid: grid } : prev);
    setSelectedTile(null);
  }, [activeTab, selectedPlanet, selectedSystem, scenarioConfig.seed]);

  const handleLaunchColony = () => {
    if (!selectedPlanet || !selectedSystem) return;
    if (!selectedPlanet.explorationGrid) {
      const grid = generatePlanetaryGrid(
        selectedPlanet.id,
        Math.floor(Math.random() * 99999),
        selectedPlanet.type,
        selectedPlanet.climate,
        selectedPlanet.physicalProperties?.equatorialDiameterKm
      );
      setSelectedPlanet(prev => prev?.id === selectedPlanet.id ? { ...prev, explorationGrid: grid } : prev);
    }
    const colony = initializeColony(
      selectedSystem, selectedPlanet,
      selectedSystem.faction || "Independent Alliance",
      selectedPlanet.explorationGrid,
      Math.floor(Math.random() * 99999)
    );
    setActiveColonies(prev => ({ ...prev, [selectedPlanet.id]: colony }));
  };

  const totalPop = Object.values(activeColonies).reduce((s, c) => s + c.population, 0);
  const colonyHere = selectedPlanet ? activeColonies[selectedPlanet.id] : null;

  const updateDraftConfig = (field, value) => {
    const parsed = Number(value);
    const safeValue = Number.isFinite(parsed) ? Math.max(1, parsed) : 1;
    setDraftConfig(prev => ({ ...prev, [field]: field === "seed" ? safeValue : safeValue }));
  };

  const applyScenarioConfig = () => {
    setScenarioConfig({
      seed: Number(draftConfig.seed) || 1,
      systemCount: Math.max(50, Number(draftConfig.systemCount) || 50),
      minimumHabitable: Math.max(1, Number(draftConfig.minimumHabitable) || 1)
    });
  };

  /* ─── Tab helper ─── */
  const Tab = ({ id, label, icon: Icon }) => {
    const isActive = activeTab === id;
    return (
      <div
        onClick={() => setActiveTab(id)}
        style={{
          display: "flex", alignItems: "center", gap: "10px",
          padding: "10px 14px", borderRadius: "8px", cursor: "pointer",
          userSelect: "none", transition: "all 0.2s",
          background: isActive ? "rgba(6,182,212,0.1)" : "transparent",
          border: isActive ? "1px solid rgba(6,182,212,0.3)" : "1px solid transparent",
          color: isActive ? "#06b6d4" : "#64748b",
        }}
      >
        <Icon size={16} />
        <span style={{ fontSize: "11px", fontWeight: 700, letterSpacing: "0.1em" }}>{label}</span>
      </div>
    );
  };

  /* ─── Stat row ─── */
  const StatRow = ({ label, value, color }) => (
    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", borderBottom: "1px solid rgba(255,255,255,0.05)", paddingBottom: "6px", marginBottom: "6px" }}>
      <span style={S.label}>{label}</span>
      <span style={{ ...S.val, color: color || "#e2e8f0" }}>{value}</span>
    </div>
  );

  /* ─── Resource chip ─── */
  const ResChip = ({ label, value, color }) => (
    <div style={{ display: "flex", justifyContent: "space-between", background: "rgba(15,23,42,0.6)", padding: "6px 8px", borderRadius: "6px" }}>
      <span style={{ fontSize: "10px", color: "#64748b", fontWeight: 700 }}>{label}</span>
      <span style={{ fontSize: "10px", color: color || "#e2e8f0", fontWeight: 800 }}>{value}</span>
    </div>
  );

  return (
    <div style={{ ...S.fillFlex, background: "#020617", fontFamily: "'Outfit', sans-serif" }}>

      {/* ═══════ HEADER ═══════ */}
      <header style={{
        height: "56px", minHeight: "56px",
        display: "flex", alignItems: "center", justifyContent: "space-between",
        padding: "0 24px", borderBottom: "1px solid rgba(255,255,255,0.08)",
        background: "rgba(2,6,23,0.9)", backdropFilter: "blur(12px)", flexShrink: 0
      }}>
        <div style={{ display: "flex", alignItems: "center", gap: "20px" }}>
          <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
            <Radio size={18} color="#06b6d4" className="active-pulse" />
            <h1 style={{ margin: 0, fontSize: "14px", fontWeight: 800, color: "#06b6d4", letterSpacing: "0.15em", textShadow: "0 0 12px rgba(6,182,212,0.4)" }}>
              COSMIC TELEMETRY CONSOLE
            </h1>
          </div>
          <div style={S.divider} />
          <div style={{ display: "flex", gap: "20px", fontSize: "11px", fontWeight: 600, color: "#64748b", letterSpacing: "0.08em" }}>
            <span>SECTOR: <b style={{ color: "#cbd5e1" }}>2 (MESSIER 69)</b></span>
            <span>SYSTEMS: <b style={{ color: "#cbd5e1" }}>{universe?.starSystems.length ?? "—"}</b></span>
            <span>COLONIES: <b style={{ color: "#10b981" }}>{Object.keys(activeColonies).length}</b></span>
            <span>POPULATION: <b style={{ color: "#06b6d4" }}>{(totalPop / 1_000_000).toFixed(2)}M</b></span>
          </div>
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
          <button className="console-btn" onClick={() => setIsSimRunning(!isSimRunning)}>
            {isSimRunning
              ? <><Pause size={14} color="#fbbf24" /><span>PAUSE</span></>
              : <><Play size={14} color="#10b981" /><span>RESUME</span></>}
          </button>
          {[1, 2, 4].map(sp => (
            <button key={sp} className={`console-btn${simSpeed === sp ? " console-btn-primary" : ""}`} onClick={() => setSimSpeed(sp)}>
              {sp}x
            </button>
          ))}
        </div>
      </header>

      {/* ═══════ BODY ═══════ */}
      <div style={{ flex: 1, display: "flex", overflow: "hidden" }}>

        {/* LEFT SIDEBAR */}
        <aside style={{
          width: "256px", minWidth: "256px", flexShrink: 0,
          borderRight: "1px solid rgba(255,255,255,0.08)",
          background: "rgba(15,23,42,0.4)", padding: "16px",
          display: "flex", flexDirection: "column", gap: "16px", overflowY: "auto"
        }}>
          {/* Navigation tabs */}
          <div style={{ display: "flex", flexDirection: "column", gap: "4px" }}>
            <Tab id="sector" label="SECTOR STARMAP" icon={Compass} />
            <Tab id="system" label="SYSTEM DIAGRAM" icon={Layers} />
            <Tab id="planet" label="PLANETARY GRID" icon={Globe} />
          </div>

          <div style={S.hDivider} />

          <div style={{ ...S.glassPanel, padding: "12px", display: "flex", flexDirection: "column", gap: "8px" }}>
            <div style={{ ...S.labelCyan }}>Scenario Controls</div>
            <div style={{ fontSize: "10px", color: "#64748b", fontWeight: 700, letterSpacing: "0.08em" }}>
              Seed {scenarioConfig.seed} · {scenarioConfig.systemCount} systems · {scenarioConfig.minimumHabitable} habitable
            </div>
            <label style={{ display: "flex", flexDirection: "column", gap: "4px", fontSize: "10px", color: "#94a3b8", fontWeight: 700 }}>
              Seed
              <input
                type="number"
                value={draftConfig.seed}
                onChange={e => updateDraftConfig("seed", e.target.value)}
                style={{ background: "rgba(2,6,23,0.8)", border: "1px solid rgba(255,255,255,0.08)", borderRadius: "6px", color: "#e2e8f0", padding: "6px 8px" }}
              />
            </label>
            <label style={{ display: "flex", flexDirection: "column", gap: "4px", fontSize: "10px", color: "#94a3b8", fontWeight: 700 }}>
              Systems
              <input
                type="number"
                value={draftConfig.systemCount}
                onChange={e => updateDraftConfig("systemCount", e.target.value)}
                style={{ background: "rgba(2,6,23,0.8)", border: "1px solid rgba(255,255,255,0.08)", borderRadius: "6px", color: "#e2e8f0", padding: "6px 8px" }}
              />
            </label>
            <label style={{ display: "flex", flexDirection: "column", gap: "4px", fontSize: "10px", color: "#94a3b8", fontWeight: 700 }}>
              Minimum habitable
              <input
                type="number"
                value={draftConfig.minimumHabitable}
                onChange={e => updateDraftConfig("minimumHabitable", e.target.value)}
                style={{ background: "rgba(2,6,23,0.8)", border: "1px solid rgba(255,255,255,0.08)", borderRadius: "6px", color: "#e2e8f0", padding: "6px 8px" }}
              />
            </label>
            <button className="console-btn console-btn-primary" style={{ justifyContent: "center" }} onClick={applyScenarioConfig}>
              REGENERATE SECTOR
            </button>
          </div>

          <div style={S.hDivider} />

          {/* Faction list */}
          <div>
            <div style={{ ...S.labelCyan, marginBottom: "10px" }}>Sector Factions</div>
            <div style={{ display: "flex", flexDirection: "column", gap: "8px", maxHeight: "60vh", overflowY: "auto", paddingRight: "4px" }}>
              {universe?.societies.map((soc, i) => (
                <div
                  key={i}
                  onClick={() => {
                    // Click faction → select its homeworld
                    const hw = universe.starSystems.find(s => s.faction === soc.FactionName && s.isHomeworld);
                    if (hw) {
                      setSelectedSystem(hw);
                      const p = hw.planets?.find(p => p.type === "Terran Habitable") || hw.planets?.[0];
                      if (p) setSelectedPlanet(p);
                      setSelectedTile(null);
                      setActiveTab("system");
                    }
                  }}
                  style={{
                    ...S.glassPanel, padding: "10px", cursor: "pointer",
                    transition: "border-color 0.2s",
                  }}
                >
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "4px" }}>
                    <span style={{ fontSize: "11px", fontWeight: 700, color: "#e2e8f0", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap", maxWidth: "140px" }}>{soc.FactionName}</span>
                    <span style={{ fontSize: "9px", padding: "2px 5px", borderRadius: "4px", background: "rgba(6,182,212,0.1)", color: "#06b6d4", fontWeight: 800 }}>{soc.sovereigntyScore}</span>
                  </div>
                  <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                    <div style={{ width: "8px", height: "8px", borderRadius: "50%", background: getFactionColorSolid(soc.FactionName), flexShrink: 0 }} />
                    <span style={{ fontSize: "9px", color: "#475569", fontWeight: 700, letterSpacing: "0.08em" }}>{soc.GovernmentType || "Oligarchy"}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </aside>

        {/* CENTER VIEWPORT */}
        <main style={{ flex: 1, minHeight: 0, background: "#030712", display: "flex", alignItems: "stretch", justifyContent: "stretch", overflow: "hidden", position: "relative" }}>

          {/* ── Sector Starmap ── */}
          {activeTab === "sector" && (
            <div style={{ position: "relative", width: "100%", height: "100%", display: "flex" }}>
              {/* Zoom controls */}
              <div style={{ position: "absolute", top: "16px", left: "16px", zIndex: 10, display: "flex", gap: "8px" }}>
                {[["ZOOM OUT", () => setSectorZoom(z => Math.max(0.05, z - 0.05))],
                  ["ZOOM IN", () => setSectorZoom(z => Math.min(1.5, z + 0.05))],
                  ["RESET", () => { setSectorPan({ x: -1000, y: -1000 }); setSectorZoom(0.18); }]
                ].map(([label, fn]) => (
                  <button key={label} className="console-btn" style={{ fontSize: "10px" }} onClick={fn}>{label}</button>
                ))}
              </div>
              <canvas
                ref={sectorCanvasRef}
                width={1400} height={900}
                style={{ width: "100%", height: "100%", cursor: isDragging.current ? "grabbing" : "grab", display: "block" }}
                onMouseDown={onSectorMouseDown}
                onMouseMove={onSectorMouseMove}
                onMouseUp={onSectorMouseUp}
                onMouseLeave={onSectorMouseUp}
                onClick={onSectorClick}
              />
              {!selectedSystem && (
                <div style={{ position: "absolute", bottom: "24px", left: "50%", transform: "translateX(-50%)", background: "rgba(6,182,212,0.1)", border: "1px solid rgba(6,182,212,0.3)", borderRadius: "8px", padding: "8px 16px", fontSize: "11px", color: "#06b6d4", fontWeight: 700, pointerEvents: "none" }}>
                  Click any star to select a system
                </div>
              )}
            </div>
          )}

          {/* ── System Diagram ── */}
          {activeTab === "system" && (
            <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: selectedSystem ? "flex-start" : "center", padding: "24px", overflowY: "auto" }}>
              {!selectedSystem ? (
                <div style={{ textAlign: "center", color: "#475569" }}>
                  <Layers size={48} color="#1e293b" style={{ marginBottom: "16px" }} />
                  <p style={{ fontSize: "13px", fontWeight: 700 }}>No system selected</p>
                  <p style={{ fontSize: "11px", marginTop: "6px" }}>Go to the Sector Starmap and click a star, or click a faction in the sidebar.</p>
                </div>
              ) : (
                <div style={{ width: "100%", maxWidth: "900px" }}>
                  {/* System header */}
                  <div style={{ ...S.row, gap: "16px", marginBottom: "32px" }}>
                    {/* Star glyph */}
                    <div style={{ position: "relative", width: "80px", height: "80px", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "center" }}>
                      <div style={{
                        position: "absolute", width: "80px", height: "80px", borderRadius: "50%",
                        background: { G: "#ffb703", F: "#fff3b0", K: "#fb8500", M: "#e63946", A: "#caf0f8", B: "#90e0ef", O: "#00b4d8" }[selectedSystem.spectralType] || "#fff",
                        opacity: 0.15
                      }} className="active-pulse" />
                      <div style={{
                        width: "60px", height: "60px", borderRadius: "50%",
                        background: `radial-gradient(circle at 35% 35%, white, ${{ G: "#ffb703", F: "#fff9c4", K: "#fb8500", M: "#e63946", A: "#e2f4ff", B: "#90e0ef", O: "#00b4d8" }[selectedSystem.spectralType] || "#fff"})`,
                        display: "flex", alignItems: "center", justifyContent: "center",
                        fontSize: "11px", fontWeight: 800, color: "#020617", boxShadow: "0 0 24px rgba(255,183,3,0.4)"
                      }}>
                        {selectedSystem.spectralType}
                      </div>
                    </div>
                    <div>
                      <div style={{ fontSize: "20px", fontWeight: 800, color: "#e2e8f0", marginBottom: "4px" }}>{selectedSystem.name}</div>
                      <div style={{ fontSize: "11px", color: "#64748b", fontWeight: 600 }}>
                        Class {selectedSystem.spectralType} star · {selectedSystem.planets.length} planets
                        {selectedSystem.faction && <span style={{ marginLeft: "12px", color: getFactionColorSolid(selectedSystem.faction) }}>◆ {selectedSystem.faction}</span>}
                      </div>
                    </div>
                  </div>

                  {/* Planet cards */}
                  <div style={{ ...S.labelCyan, marginBottom: "12px" }}>Orbiting Bodies</div>
                  <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))", gap: "12px" }}>
                    {selectedSystem.planets.map((planet, i) => {
                      const isSel = selectedPlanet?.id === planet.id;
                      const colonized = !!activeColonies[planet.id];
                      const TYPE_COLORS = {
                        "Terran Habitable": "#10b981",
                        "Gas Giant": "#3b82f6",
                        "Ice Giant": "#06b6d4",
                        "Volcanic": "#ef4444",
                        "Desert": "#f59e0b",
                        "Barren Rocky": "#6b7280",
                        "Ice World": "#bae6fd"
                      };
                      return (
                        <div
                          key={i}
                          onClick={() => { setSelectedPlanet(planet); setSelectedTile(null); }}
                          style={{
                            ...S.glassPanel, padding: "14px", cursor: "pointer",
                            border: isSel ? "1px solid rgba(6,182,212,0.6)" : "1px solid rgba(255,255,255,0.08)",
                            background: isSel ? "rgba(6,182,212,0.08)" : "rgba(15,23,42,0.65)",
                            transition: "all 0.2s"
                          }}
                        >
                          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "8px" }}>
                            <div>
                              <div style={{ fontSize: "13px", fontWeight: 700, color: "#e2e8f0" }}>{planet.name}</div>
                              <div style={{ fontSize: "10px", color: "#64748b", marginTop: "2px" }}>Orbit: {planet.orbitalRadius.toFixed(2)} AU</div>
                            </div>
                            <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: "4px" }}>
                              <span style={{ fontSize: "9px", padding: "2px 6px", borderRadius: "4px", fontWeight: 800, background: `${TYPE_COLORS[planet.type] || "#6b7280"}22`, color: TYPE_COLORS[planet.type] || "#6b7280" }}>
                                {planet.type}
                              </span>
                              {colonized && <span style={{ fontSize: "9px", padding: "2px 6px", borderRadius: "4px", fontWeight: 800, background: "rgba(16,185,129,0.15)", color: "#10b981" }}>COLONY</span>}
                            </div>
                          </div>
                          <div style={{ display: "flex", gap: "8px", marginTop: "8px" }}>
                            <button
                              className="console-btn console-btn-primary"
                              style={{ fontSize: "10px", flex: 1, justifyContent: "center" }}
                              onClick={e => { e.stopPropagation(); setSelectedPlanet(planet); setActiveTab("planet"); }}
                            >
                              VIEW GRID
                            </button>
                            {planet.type === "Terran Habitable" && !colonized && (
                              <button
                                className="console-btn"
                                style={{ fontSize: "10px", flex: 1, justifyContent: "center" }}
                                onClick={e => {
                                  e.stopPropagation();
                                  setSelectedPlanet(planet);
                                  if (!planet.explorationGrid) {
                                    planet.explorationGrid = generatePlanetaryGrid(planet.id, Math.floor(Math.random() * 99999), planet.type);
                                  }
                                  const col = initializeColony(selectedSystem, planet, selectedSystem.faction || "Independent", planet.explorationGrid, Math.floor(Math.random() * 99999));
                                  setActiveColonies(prev => ({ ...prev, [planet.id]: col }));
                                }}
                              >
                                COLONIZE
                              </button>
                            )}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>
          )}

          {/* ── Planet Grid ── */}
          {activeTab === "planet" && (
            <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", padding: "16px", gap: "12px", overflow: "hidden", minHeight: 0 }}>
              {!selectedPlanet ? (
                <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", color: "#475569" }}>
                  <Globe size={48} color="#1e293b" style={{ marginBottom: "16px" }} />
                  <p style={{ fontSize: "13px", fontWeight: 700 }}>No planet selected</p>
                  <p style={{ fontSize: "11px", marginTop: "6px" }}>Select a system then click a planet from the System Diagram tab.</p>
                </div>
              ) : (
                <>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexShrink: 0 }}>
                    <div style={{ ...S.labelCyan }}>SURFACE GRID: {selectedPlanet.name} ({selectedPlanet.explorationGrid?.length ?? 0}×{selectedPlanet.explorationGrid?.length ?? 0} tiles · {selectedPlanet.physicalProperties?.surfaceTileSizeKm ?? 100}km each)</div>
                    <div style={{ fontSize: "10px", color: "#475569" }}>Scroll to pan, use the zoom slider to inspect</div>
                  </div>

                  <div style={{ flex: 1, display: "flex", gap: "12px", overflow: "hidden", minHeight: 0 }}>
                    {/* Canvas area */}
                    <div style={{ flex: 1, display: "flex", flexDirection: "column", minHeight: 0, background: "#01040b", border: "1px solid rgba(255,255,255,0.04)", borderRadius: "10px", overflow: "hidden", position: "relative" }}>
                      <div style={{ position: "sticky", top: "8px", left: "8px", zIndex: 10, display: "flex", alignItems: "center", gap: "8px", alignSelf: "flex-start", margin: "8px", padding: "8px 10px", borderRadius: "999px", background: "rgba(2,6,23,0.8)", border: "1px solid rgba(255,255,255,0.08)", boxShadow: "0 8px 24px rgba(0,0,0,0.24)" }}>
                        <button className="console-btn" style={{ fontSize: "10px", padding: "6px 8px" }} onClick={() => setPlanetZoom(z => Math.max(0.7, z - 0.2))}>−</button>
                        <input type="range" min="0.7" max="3" step="0.1" value={planetZoom} onChange={e => setPlanetZoom(Number(e.target.value))} style={{ width: "120px" }} />
                        <button className="console-btn" style={{ fontSize: "10px", padding: "6px 8px" }} onClick={() => setPlanetZoom(z => Math.min(3, z + 0.2))}>+</button>
                        <span style={{ fontSize: "10px", color: "#06b6d4", fontWeight: 800 }}>{planetZoom.toFixed(1)}×</span>
                        <button className="console-btn" style={{ fontSize: "10px", padding: "6px 8px" }} onClick={() => setPlanetPan({ x: 0, y: 0 })}>RESET VIEW</button>
                      </div>
                      {!selectedPlanet.explorationGrid ? (
                        <div style={{ textAlign: "center", padding: "32px" }}>
                          <Globe size={48} color="#1e293b" className="active-pulse" style={{ marginBottom: "16px" }} />
                          <p style={{ fontSize: "13px", fontWeight: 700, color: "#94a3b8", marginBottom: "8px" }}>Surface Scans Offline</p>
                          <p style={{ fontSize: "11px", color: "#475569", marginBottom: "20px", maxWidth: "300px" }}>
                            No surface data yet. Launch a colonization expedition to begin terrain mapping.
                          </p>
                          <button
                            className="console-btn console-btn-primary"
                            disabled={selectedPlanet.type !== "Terran Habitable"}
                            onClick={handleLaunchColony}
                          >
                            <Play size={14} />
                            LAUNCH COLONIZATION
                          </button>
                          {selectedPlanet.type !== "Terran Habitable" && (
                            <p style={{ fontSize: "10px", color: "#ef4444", marginTop: "10px" }}>Non-habitable planets cannot be colonized.</p>
                          )}
                        </div>
                      ) : (
                        <div
                          style={{ width: "100%", height: "100%", overflow: "hidden", position: "relative", cursor: isPlanetPanning ? "grabbing" : "grab", background: "#01040b" }}
                          onMouseDown={onPlanetMouseDown}
                          onMouseMove={onPlanetMouseMove}
                          onMouseUp={onPlanetMouseUp}
                          onMouseLeave={onPlanetMouseUp}
                        >
                          <canvas
                            ref={planetCanvasRef}
                            width={planetCanvasSize.width}
                            height={planetCanvasSize.height}
                            style={{ width: `${Math.max(640, planetCanvasSize.width * planetZoom)}px`, height: `${Math.max(640, planetCanvasSize.height * planetZoom)}px`, cursor: isPlanetPanning ? "grabbing" : "crosshair", display: "block", imageRendering: "pixelated", transform: `translate(${planetPan.x}px, ${planetPan.y}px)`, transformOrigin: "top left" }}
                            onClick={onPlanetClick}
                          />
                        </div>
                      )}
                    </div>

                    {/* Right inspector panel */}
                    {selectedPlanet.explorationGrid && (
                      <div style={{ width: "260px", flexShrink: 0, display: "flex", flexDirection: "column", gap: "10px", overflowY: "auto", minHeight: 0 }}>
                        {/* Tile Inspector */}
                        <div style={{ ...S.glassPanel, padding: "14px" }}>
                          <div style={{ ...S.labelCyan, marginBottom: "12px" }}>Scanner Inspector</div>
                          {selectedTile ? (
                            <>
                              <StatRow label="Grid Coords" value={`(${selectedTile.x}, ${selectedTile.y})`} />
                              <StatRow label="Biome" value={selectedTile.biome} color={selectedTile.color} />
                              <StatRow label="Temperature" value={`${selectedTile.temperature.toFixed(0)}°C`} />
                              <StatRow label="Elevation" value={`${(selectedTile.elevationKm ?? selectedTile.elevation * 10).toFixed(1)} km`} />
                              <StatRow label="River" value={selectedTile.isRiver ? "DETECTED" : "None"} color={selectedTile.isRiver ? "#06b6d4" : undefined} />
                              <div style={S.label}>Resources</div>
                              <div style={{ marginTop: "6px", fontSize: "11px", color: Object.keys(selectedTile.resources).length ? "#e2e8f0" : "#475569", lineHeight: 1.6 }}>
                                {Object.keys(selectedTile.resources).length
                                  ? Object.entries(selectedTile.resources).map(([k, deposit]) => {
                                      const grade = deposit?.gradePercent != null ? `${deposit.gradePercent.toFixed(2)}%` : "—";
                                      const reserve = deposit?.reserveTons != null ? `${Math.round(deposit.reserveTons).toLocaleString()} t` : "";
                                      return `${deposit?.mineral || k} (${k}): ${grade}${reserve ? ` • ${reserve}` : ""}`;
                                    }).join("\n")
                                  : "None detected"}
                              </div>
                              {selectedTile.structures.length > 0 && (
                                <>
                                  <div style={{ ...S.labelCyan, marginTop: "10px" }}>Structures</div>
                                  <div style={{ marginTop: "6px", fontSize: "11px", color: "#06b6d4", fontWeight: 700 }}>
                                    {selectedTile.structures.join(" · ")}
                                  </div>
                                </>
                              )}
                            </>
                          ) : (
                            <div style={{ fontSize: "11px", color: "#475569", fontStyle: "italic", padding: "16px 0", textAlign: "center" }}>
                              Click a tile on the grid to inspect it.
                            </div>
                          )}
                        </div>

                        {/* Legend */}
                        <div style={{ ...S.glassPanel, padding: "12px" }}>
                          <div style={{ ...S.label, marginBottom: "10px" }}>Terrain Legend</div>
                          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "6px" }}>
                            {(selectedPlanet?.type === "Volcanic"
                              ? [["#b33a1d","Lava Field"],["#7a4f2c","Ash Plain"],["#4b3c35","Basalt Ridge"],["#7a6a2f","Sulfur Marsh"],["#5b4b3a","Crater Ridge"]]
                              : selectedPlanet?.type === "Ice World"
                                ? [["#d9ecff","Ice Shelf"],["#cfe3ff","Ice Sheet"],["#a9c7ff","Glacier Basin"],["#f5f7ff","Pressure Ridge"]]
                                : selectedPlanet?.type === "Ice Giant"
                                  ? [["#b8d5ff","Cryo Shelf"],["#8fa9e5","Ice Swell"],["#7f95d8","Pressure Ridge"],["#5c7bd6","Storm Band"]]
                                  : selectedPlanet?.type === "Barren Rocky"
                                    ? [["#6b6f75","Crater Ridge"],["#4c4b48","Basalt Ridge"],["#8d7f6d","Dust Basin"],["#7d7267","Stone Garden"]]
                                    : selectedPlanet?.type === "Desert"
                                      ? [["#f2e0a4","Salt Flat"],["#e2b76d","Dune Sea"],["#c9a96f","Rock Garden"],["#7fbf6f","Oasis Margin"]]
                                      : selectedPlanet?.type === "Rocky"
                                        ? [["#6e5e56","Rocky Highland"],["#93827a","Rubble Field"],["#8e7b5b","Mesa Plain"]]
                                        : [["#1d3557","Ocean"],["#5c677d","Mountain"],["#1b4332","Forest"],["#80b918","Grasslands"],["#55a630","Plains"],["#b7cfe0","Tundra"],["#e9c46a","Desert"]]
                            ).map(([c,n]) => (
                              <div key={n} style={{ display: "flex", alignItems: "center", gap: "6px", fontSize: "10px", color: "#94a3b8", fontWeight: 600 }}>
                                <div style={{ width: "10px", height: "10px", borderRadius: "2px", background: c, flexShrink: 0 }} />{n}
                              </div>
                            ))}
                          </div>
                          <div style={{ marginTop: "10px", ...S.label }}>Structures</div>
                          <div style={{ display: "flex", flexDirection: "column", gap: "4px", marginTop: "6px" }}>
                            {[["#fb8500","● Capital"],["#ef4444","■ Mine"],["#10b981","● Farm"],["#06b6d4","□ Active Scout"]].map(([c,n]) => (
                              <div key={n} style={{ fontSize: "10px", color: c, fontWeight: 700 }}>{n}</div>
                            ))}
                          </div>
                        </div>
                      </div>
                    )}
                  </div>
                </>
              )}
            </div>
          )}
        </main>

        {/* RIGHT SIDEBAR */}
        <aside style={{
          width: "300px", minWidth: "300px", flexShrink: 0,
          borderLeft: "1px solid rgba(255,255,255,0.08)",
          background: "rgba(15,23,42,0.4)", padding: "16px",
          display: "flex", flexDirection: "column", gap: "14px", overflowY: "auto", minHeight: 0
        }}>
          {/* Planet Telemetry */}
          {selectedPlanet ? (
            <div style={{ ...S.glassPanel, padding: "14px" }}>
              <div style={{ ...S.labelCyan, marginBottom: "12px" }}>Planet Telemetry</div>
              <StatRow label="Designation" value={selectedPlanet.name} />
              <StatRow label="Class" value={selectedPlanet.type} />
              <StatRow label="Orbit" value={`${selectedPlanet.orbitalRadius.toFixed(2)} AU`} />
              <StatRow label="Hydrosphere" value={`${selectedPlanet.hydrospherePercent}%`} />
              {selectedPlanet.physicalProperties && (
                <StatRow label="Equator" value={`${selectedPlanet.physicalProperties.equatorialDiameterKm.toLocaleString()} km`} />
              )}
              {selectedPlanet.physicalProperties && (
                <StatRow label="Grid" value={`${selectedPlanet.physicalProperties.surfaceTilesPerSide}×${selectedPlanet.physicalProperties.surfaceTilesPerSide} tiles`} />
              )}
              {selectedPlanet.climate && (
                <StatRow label="Climate" value={`${selectedPlanet.climate.averageTempC}°C avg · ${selectedPlanet.climate.equatorTempC}°C eq · ${selectedPlanet.climate.poleTempC}°C poles`} />
              )}

              {colonyHere ? (
                <div style={{ marginTop: "12px", borderTop: "1px solid rgba(255,255,255,0.06)", paddingTop: "12px" }}>
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "10px" }}>
                    <span style={{ fontSize: "11px", fontWeight: 800, color: "#10b981" }}>COLONY ACTIVE</span>
                    <span style={{ fontSize: "9px", padding: "2px 6px", borderRadius: "4px", background: "rgba(16,185,129,0.15)", color: "#10b981", fontWeight: 800 }}>
                      SAUER {colonyHere.sauerScale}
                    </span>
                  </div>
                  <StatRow label="Population" value={colonyHere.population.toLocaleString()} color="#06b6d4" />
                  <StatRow label="Year (Kede)" value={colonyHere.kede} />
                  <div style={{ ...S.label, marginBottom: "8px", marginTop: "4px" }}>Resource Stockpile</div>
                  <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "6px" }}>
                    <ResChip label="Food" value={colonyHere.resources.Food} color="#10b981" />
                    <ResChip label="Iron" value={colonyHere.resources.Iron} color="#94a3b8" />
                    <ResChip label="Copper" value={colonyHere.resources.Copper} color="#f59e0b" />
                    <ResChip label="Osmium" value={colonyHere.resources.Osmium} color="#a78bfa" />
                    <ResChip label="Deuterium" value={colonyHere.resources.Deuterium} color="#06b6d4" />
                    <ResChip label="Silicates" value={colonyHere.resources.Silicates} color="#cbd5e1" />
                  </div>
                </div>
              ) : (
                <div style={{ marginTop: "12px", borderTop: "1px solid rgba(255,255,255,0.06)", paddingTop: "12px", textAlign: "center" }}>
                  <ShieldAlert size={24} color="#334155" style={{ marginBottom: "8px" }} />
                  <p style={{ fontSize: "11px", color: "#475569", fontWeight: 700 }}>No Active Colony</p>
                  {selectedPlanet.type === "Terran Habitable" && (
                    <button className="console-btn console-btn-primary" style={{ marginTop: "10px", fontSize: "10px", width: "100%", justifyContent: "center" }} onClick={handleLaunchColony}>
                      LAUNCH COLONY
                    </button>
                  )}
                </div>
              )}
            </div>
          ) : (
            <div style={{ textAlign: "center", fontSize: "11px", color: "#475569", padding: "24px 0", fontStyle: "italic" }}>
              Select a system and planet to view telemetry.
            </div>
          )}

          {/* Event log */}
          {colonyHere && (
            <div style={{ flex: 1, minHeight: "240px", display: "flex", flexDirection: "column", border: "1px solid rgba(255,255,255,0.08)", borderRadius: "10px", overflow: "hidden" }}>
              <div style={{ padding: "8px 12px", borderBottom: "1px solid rgba(255,255,255,0.06)", background: "#020617", display: "flex", alignItems: "center", gap: "8px", flexShrink: 0 }}>
                <Cpu size={14} color="#06b6d4" />
                <span style={{ fontSize: "10px", fontWeight: 800, color: "#e2e8f0", letterSpacing: "0.1em" }}>HISTORICAL TELEMETRY</span>
              </div>
              <div style={{ flex: 1, overflowY: "auto", padding: "10px", display: "flex", flexDirection: "column", gap: "5px" }}>
                {colonyHere.historyLog.slice(-50).map((log, i) => (
                  <div key={i} style={{ fontSize: "9px", color: "#94a3b8", lineHeight: "1.5", borderLeft: "2px solid rgba(6,182,212,0.15)", paddingLeft: "8px", fontFamily: "monospace" }}>
                    {log}
                  </div>
                ))}
              </div>
            </div>
          )}
        </aside>
      </div>
    </div>
  );
}
