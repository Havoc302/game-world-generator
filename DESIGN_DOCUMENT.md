# Colonial Alliance RPG — Master Design Document

> **Status:** Living document. Last consolidated from design session April 2026.  
> **Purpose:** Canonical reference for the game system, world lore, and world generator architecture.  
> Covers decisions made and open questions flagged for future resolution.

---

## Table of Contents

1. [Setting Overview](#1-setting-overview)
2. [Game System](#2-game-system)
3. [Armour Module System](#3-armour-module-system)
4. [Time System](#4-time-system)
5. [Economy and Currency](#5-economy-and-currency)
6. [Technology](#6-technology)
7. [Factions and Politics](#7-factions-and-politics)
8. [World Generator Architecture](#8-world-generator-architecture)
9. [Civilisation Simulation](#9-civilisation-simulation)
10. [Open Questions](#10-open-questions)

---

## 1. Setting Overview

### 1.1 The Colonial Allied Planets (CAP)

Humanity's expansion beyond Earth began with eight colony ships, each carrying approximately one million settlers drawn from different Earth nations. The ships executed a blind jump to **Messier 69 (Sagittarius) Globular Cluster**, located approximately 29,700 light-years from Earth, carrying components of an enormous jump gate intended to establish two-way travel upon assembly.

The Russian colony ship failed to arrive, severing the colonies from Sol. The Terran Union deemed the mission a lost cause and did not follow up for centuries.

**The seven founding colony ships and their systems:**

| Nation | System Name | Capital World |
|--------|-------------|---------------|
| United States | New Eden | Eugene Davis |
| Australia | Ka-May | Ashleigh Kelvin |
| China | Xīn de Shǔguāng (New Dawn) | Xīwàng (Hope) |
| France | Nouvelle Vie (New Life) | Gabriel Bernard |
| Germany | Gemutlichkeit | Gisela Ziegler |
| Japan | Nihongo (Rising Sun) | Tanegashima |
| United Kingdom | Britannia | Trafalgar |

**Colonial founding year:** Year 1 of the CAP calendar (see Section 4). The setting's current date is approximately **Kede 985**.

### 1.2 The Terran Union (TU)

Earth's successor government. Technologically inferior to the CAP but possessing vast numbers of ships and personnel. Primary weapons philosophy centres on mass and armour rather than precision and technology. Uses bespoke proprietary systems rather than the CAP's open modular standard.

**Key TU characteristics:**
- Enormous chemically-assisted cannon batteries as primary armament — nominally obsolete but dangerous against shield-based ships due to kinetic energy dump causing thermal overload in shield generators
- Significantly larger ships requiring much larger crews with less automation
- No AI above Level 2 in standard deployment
- No energy shields — navigational and atmospheric shielding only
- Missiles, torpedoes, lasers and railguns exist but are secondary systems and inferior in refinement to CAP equivalents
- Completely proprietary bespoke technology — no modular standard
- Unable to adopt the CAP cube module system even if they wanted to — components too large and power-hungry to miniaturise to that scale with current technology

### 1.3 The Aluceans

The missing Russian colony ship landed elsewhere in the Hercules cluster and developed in complete isolation for over a millennium. They developed three transformative technologies:

1. **Nanites** — self-replicating nanoscale machines, originally for life extension and body maintenance
2. **Replicator technology** — matter-energy conversion at scale, enabled by nanites
3. **Advanced AI** — true Level 5 sentience (see Section 6.4), running on planetoid-scale computing infrastructure

Their home base: a perfectly white spherical artificial moon containing massive power storage, reactors, and the virtual world in which one million colonists and their descendants lived. The moon could consume entire planets and stars for raw material.

**The Alucean intervention and departure:** The Aluceans pre-infected the entire CAP and TU population with nanites, then dematerialised all military vessels from both factions simultaneously. After a guerilla campaign by CAP black ops forces, the Alucean AI negotiated a settlement — returning all dematerialised personnel to their home worlds and departing to another galaxy. Critically, **the AI returned all personnel but refused to return any warships.**

This single event is the defining crisis of Campaign 3's setting — the CAP and TU are both essentially demilitarised, the cluster is destabilised, and piracy has exploded in the power vacuum.

### 1.4 Post-Alucean Setting (Campaign 3, ~Kede 985)

- CAP and TU military fleets effectively gone
- Major freight lanes unprotected — piracy surging
- Old powers previously held back by the Alliance military now making territorial grabs
- CAP issuing contracts to mercenaries to fill the security gap
- The Colonial Freedom Alliance (separatist faction) emboldened
- Regional powers emerging in the vacuum
- Independent colonies increasingly vulnerable

---

## 2. Game System

The system is a hybrid of **D&D 5th Edition** and **Heroes System 6th Edition**, taking the D20 core from 5e and the speed/action pool, OCV/DCV structure, and hit location from Heroes 6e. It uses a D20 for all core rolls.

### 2.1 Core Ability Scores

Six base statistics, all starting at 10 with a maximum of 20 at character creation:

| Stat | Abbreviation | Governs |
|------|-------------|---------|
| Strength | STR | Physical power, melee, carrying capacity |
| Dexterity | DEX | Speed, ranged combat, fine motor skills |
| Intelligence | INT | Reasoning, perception, combat awareness |
| Memory | MEM | Recall, languages, navigation, knowledge retention |
| Charisma | CHA | Social interaction, leadership, deception |
| Constitution | CON | Endurance, resistance, health |

**Ability Score Bonus:** `floor((Score - 10) / 2)`

### 2.2 Derived Statistics

| Statistic | Formula | Notes |
|-----------|---------|-------|
| **Health Points** | CON score + STR score | Raw scores, not bonuses |
| **Combat Skill (CS)** | (DEX bonus / 2) + (INT bonus / 2) | Governs attack and defence |
| **Proficiency** | Top 3 ability bonuses added, halved, rounded up | Adds to trained skills |
| **Initiative Bonus** | INT bonus + DEX bonus | Added to initiative roll |
| **Speed** | Initiative roll / 2, rounded up | Action pool per round |

### 2.3 Skill Statistics

Every skill has a governing base stat. Skill bonus = Ability Score Bonus + Proficiency + PTHC bonuses.

**PTHC** = Profession, Hobby, Trait, and Complication bonuses combined.

| Skill | Base Stat |
|-------|-----------|
| Melee Combat | STR |
| Climbing | STR |
| Lifting/Carrying | STR |
| Intimidation (Physical) | STR |
| Toughness | STR |
| Ranged Combat | DEX |
| Stealth | DEX |
| Vehicle Handling | DEX |
| Acrobatics | DEX |
| Lockpicking | DEX |
| Endurance | CON |
| Willpower | CON |
| Resistance | CON |
| Survival | CON |
| Stun Tolerance | CON |
| Mechanical Systems | INT |
| Perception | INT |
| Tactics | INT |
| Biology / Medicine | INT |
| Digital Systems | INT |
| Lore | MEM |
| Linguistics | MEM |
| Codebreaking | MEM |
| Recall | MEM |
| Navigation | MEM |
| Persuasion | CHA |
| Deception | CHA |
| Leadership | CHA |
| Negotiation | CHA |
| Performance | CHA |

### 2.4 Checks and Saves

**Skill Checks:** Player-initiated. Roll D20 + relevant skill bonus vs Difficulty Class (DC). Must meet or beat the DC to succeed. No critical successes or failures on skill checks.

**Saves:** Triggered by external effects. Roll D20 + relevant skill bonus vs DC. A natural 20 is an automatic success. A natural 1 is an automatic failure.

**Advantage:** Roll 2D20, take the higher result.  
**Disadvantage:** Roll 2D20, take the lower result.

### 2.5 Combat

#### Initiative

Roll D20 + Initiative Bonus. Highest result acts first. Strict turn order maintained.

*Rule Variation (GM Discretion):* Initiative order decided by GM at start of combat to prevent positional impossibilities.

#### Actions and Speed

Every round each character has a **Speed pool** equal to their Speed statistic. Both actions and reactions consume from this pool. Using a reaction consumes from the *next* turn's Speed pool.

Reactions can be used for any action that responds to an external effect — including saves.

#### Offensive and Defensive Combat Values

**OCV (Offensive Combat Value):**  
`D20 + Combat Skill + relevant skills + equipment bonuses`

**DCV (Defensive Combat Value):**  
`10 + Combat Skill + relevant skills + equipment bonuses`

An attack hits when OCV ≥ DCV.

#### Damage

Weapon damage dice + bonus. Melee weapons add STR or DEX bonus depending on weapon type. Ranged weapons add bonuses based on ammunition type.

#### Critical Hits and Fumbles

- **Natural 20 (Attack):** Critical Hit — double damage dice + trigger hit location special effect
- **Natural 1 (Attack):** Critical Miss — one of the following (GM discretion):
  - Weapon malfunctions
  - Weapon breaks
  - Hit a friendly
  - Drop/throw weapon
  - Fall prone
  - Hurt yourself
  - Negative environmental impact

#### Crippling Blows

When OCV exceeds DCV by more than the target's Combat Skill value, a **Crippling Blow** is scored. Triggers hit location special effect only — no double damage.

*Rule Variation:* Use the margin of success as the hit location instead of rolling D12.

### 2.6 Hit Location

Roll D12 on Critical Hits and Crippling Blows.

| Roll | Location | Special Effect | Called Shot Penalty |
|------|----------|---------------|-------------------|
| 12 | Head | *Incapacitated* | -7 |
| 11 | Chest | *Slowed* & *Hemorrhaging* | -2 |
| 10 | Stomach | *Prone* & *Vomiting* | -3 |
| 9 | Groin | *Prone* & *Slowed* | -8 |
| 8 | Left Arm | -5 OCV for 2 rounds | -5 |
| 7 | Right Arm | -5 OCV for 2 rounds | -5 |
| 6 | Left Hand | Drop held item | -6 |
| 5 | Right Hand | Drop held item | -6 |
| 4 | Left Leg | *Limping* for 5 rounds | -3 |
| 3 | Right Leg | *Limping* for 5 rounds | -3 |
| 2 | Left Foot | *Prone* | -6 |
| 1 | Right Foot | *Prone* | -6 |

Default target is always centre mass (Chest). A specialisation allows swapping head and chest rolls.

### 2.7 Status Effects

| Effect | Effect on Target | Removal / Duration |
|--------|-----------------|-------------------|
| **Prone** | Movement halved. Melee attacks within 2m gain Advantage. Ranged attacks have Disadvantage. | Uses half movement to stand. |
| **Limping** | Movement halved. -2 OCV if moving on turn. | Ends after 2 rounds or any healing. |
| **Slowed** | Speed halved (minimum 1). | Ends after 2 rounds. |
| **Stunned** | Speed reduced to 0. Movement unaffected. | Ends at start of target's next turn. |
| **Incapacitated** | Unconscious. Automatically fails all saves and checks. Cannot move. All attacks are automatic Critical Hits. | Recovers naturally after 1 hour or 10 points of healing. |
| **Blinded** | Automatically fails all Perception checks and Ranged Combat checks. All other OCV rolls at Disadvantage. | Depends on source. Recovers naturally in 1 minute. |
| **Poisoned** | Disadvantage on all CON saves. 1D4 damage at start of turn (ignorable with successful resistance roll). | After 5 successful resistance rolls. |
| **Restrained** | Movement reduced to 0. Disadvantage on OCV. All attacks against target at Advantage. | Break free. |
| **Hemorrhaging** | 1D6 damage at start of turn. | 1 minute naturally or 10 points of healing. |
| **Vomiting** | Stunned for 1 round + Hungry. If closed helmet, also Blinded until cleaned. | Vomit: 1 round. Blinded: when cleaned. Hungry: as below. |
| **Hungry** | Slowed. | After 8 + CON bonus hours, progresses to Starving. Recovered by eating. |
| **Starving** | Maximum HP lowers 5% per day. Cannot be healed. | Eating a meal. 10% max HP restored per day of eating. |

### 2.8 Battle Maps

All battle maps use a **hex grid** for distance. Standard hexagon size is **2 metres**. All measurements in metres.

### 2.9 Character Progression

**Level Progression:** Milestone or XP-based at GM discretion. XP progression is exponential.

**Professions:** Chosen at character creation, then every 10 levels. Provides +2 to one Ability Score (or +1 to two) and full Proficiency bonus to two skills.

**Hobbies:** Chosen at character creation, then every 5 levels. Provides +1 to one Ability Score and half Proficiency bonus to one skill.

**Traits:** Chosen every 3 levels, reflecting personality. +2 to a skill or a specific bonus (maximum +2, never affects Ability Scores). May include a minor penalty.

**Complications:** Optional, taken every 4 levels. +1 to an Ability Score of choice but a narrative or mechanical penalty. Good and bad in equal measure.

---

## 3. Armour Module System

The armour module system is the setting's equivalent of magic — technology-based abilities governed by resource management rather than spell slots. The same system scales from powered armour to capital ships.

### 3.1 The Physical Module

All modules are perfect hard cubes with modular connectors on each face, allowing connection on any side. Made primarily of silicon or carbon composites.

**Module size tiers:**

| Tier | Platform | Physical Size | Scale Multiplier |
|------|----------|--------------|-----------------|
| Micro | Personal armour / PA | ~fingernail | ×1 (base) |
| Macro | Vehicle / small craft | ~fist | ×10 |
| Small | Small ship | ~shoebox | ×100 |
| Medium | Medium ship | ~filing cabinet | ×1,000 |
| Large | Large ship | ~wardrobe | ×10,000 |
| Capital | Capital ship | ~small room | ×100,000 |
| Super Capital | Super capital | Multiple capital modules or bespoke | Custom |

Each tier is **10× the physical size** of the previous. All metrics — processor contribution, capacitor pool, regen rate, effect potency, and processor cost to run programs — **scale by ×10 per tier**.

Processor cost of programs **also increases** at larger scales due to greater physical and computational complexity — more field dynamics, larger areas to manage, more active compensation systems. The headroom does not grow as fast as the raw numbers suggest.

**Super capital ships** use multiple capital modules or custom-engineered bespoke solutions because at that scale the thermodynamic and computational problems cannot be solved by stacking standard modules.

### 3.2 Resources

**Processor Pool:**
- A flat number determined by the installed computer/AI system
- Governs how many programs can run *concurrently*
- Not consumed — it is *occupied* while programs run
- Stopping a program frees its processor allocation
- Can be increased by sacrificing upgrade slots for additional AI Processor modules
- Larger ships have larger base processor pools but programs also cost more processor at larger scales

**Capacitor:**
- The energy pool spent when activating and sustaining programs
- Drains as programs run, regenerates over time
- **Passive regen:** Base rate from the reactor/chassis — always occurs
- **Auxiliary Reactor module:** Increases regen rate (faster refill)
- **Auxiliary Capacitor module:** Increases total pool size (more to draw from)
- These are two separate upgrade paths for the same resource — one makes it bigger, one makes it refill faster

### 3.3 Power and Cooling

All powered armour and larger platforms use **Micro-Fusion Reactors (MFRs)** — laser-initiated fusion at micro scale, fusing deuterium into He-4.

**The power loop:**
```
Deuterium in
→ MFR fuses it
→ Power out → charges solid-state carbon lattice batteries (the Capacitor pool)
→ Helium-4 out → liquefied → stored as coolant reserve
```

**Solid-state batteries** act as a buffer — the MFR cannot respond instantly to power spikes from activating programs, so the battery bank absorbs spikes while the reactor catches up. The Capacitor pool in gameplay terms is this battery bank.

**Deuterium supply:** Any platform with an MFR has a small **dematerialiser** that accepts matter feed to produce deuterium. OBits (Osmium currency) are the most efficient feed material due to Osmium's density, but any material shaped to fit the feed slot works — the conversion efficiency scales with the material's atomic density. The chromium coating on OBits prevents accidental dematerialisation in a pocket.

**Helium cooling:** Running programs generates heat. The helium cooling loop manages this. Extra liquid helium bottles can be carried to extend operational time, cool down faster between operations, or unlock additional module uses. Venting helium is detectable — produces a cold gas signature visible on IR and EM sensors.

### 3.4 Stacking and Thermodynamics

Multiple modules of the same type can be installed for additional effect, but with **diminishing returns** following the laws of thermodynamics:

- Each additional stacked module is **90% as effective** as the previous
- The 90% applies geometrically: 1st = 100%, 2nd = 90%, 3rd = 81%, 4th = 72.9%, etc.
- **Physical cause:** Stacked modules interfere with each other's heat dissipation, running progressively hotter. Each additional module introduces thermal interference and power loss
- **Practical implication:** 2-3 stacked modules provide meaningful gains; beyond that the marginal benefit rarely justifies the slot cost and thermal cost
- **Heat signature:** A heavily stacked loadout runs visibly hotter — more detectable on IR sensors, potentially triggering heat damage thresholds if pushed
- **A single higher-tier module** is almost always more effective than stacking lower-tier modules

### 3.5 Programs

Programs are the actual abilities unlocked by installed modules. Each module unlocks a specific set of programs — analogous to spell schools in a fantasy system.

**Program resource costs:**
- **Processor cost:** How much of the processor pool this program occupies while running
- **Capacitor cost:** How much energy is spent activating and sustaining it

**Program listing by module:**

#### Shield Generator Programs
| Program | Requirements | Effect |
|---------|-------------|--------|
| Shield Self | Level 1 | Creates a shield around user. 20 HP per level or minute |
| Forcefield | Level 1 | 20 HP forcefield up to 5m² within 20m. Each higher level adds 5m², 20 HP, or range |
| Force Bullet | Level 2 | Small forcefield ball projected at target. 2D6 damage per level |
| Shield Pulse | Level 3 | Expends remaining shield — 2D6 per 5 shield HP to all within 4m |
| Reinforce Shield | Level 4 | Increases shield HP pool by 10 per level |

#### Drone Control Unit Programs
| Program | Effect |
|---------|--------|
| Drone Sweep | Scan every cubic metre of designated area. Max 50m³ per drone |
| Drone Swarm | Coordinated attack on target. +2 OCV per extra drone beyond first |
| Drone Decoy | Harass target — Perception -3 per drone. Target has 0 DCV on failed check |

#### Sensor Suite Programs
| Program | Effect |
|---------|--------|
| High Res Scan | Focus sensors on specific scan type. +2 per level to detect hidden objects |
| Low Light Amplification | Passive vision in very low light |
| InfraRed Vision | Detect by temperature. Passive |
| ElectroMagnetic Resonance | 60° cone, 10m. Cannot pass through 1m concrete / 10cm steel / 1cm lead |
| Neutrino Scan | 10° cone, 50m. Passes through everything except subspace fields. Requires Level 4 |
| Pattern Search | Runs alongside any scan. +1 Perception per level |

#### Stealth Suite Programs
| Program | Effect |
|---------|--------|
| Adaptive Camouflage | +1 stealth roll. Alters suit exterior to match terrain |
| Quantum Light Bending | +2 stationary / +1 moving. Warps light around object |
| Silent Running | +2 stealth per level, half speed. Weapons fire travels only 10m |

#### Cloak Generator Programs
| Program | Effect |
|---------|--------|
| Invisibility Cloak | Subspace bubble, extremely low emissions. Each higher level adds a person/object within 20m or increases range/time. Detectable only by neutrino sweep, area effect, or physical contact |

#### Improved Servos Programs
| Program | Effect |
|---------|--------|
| Running Man | Running speed and jump distance/height doubled |
| Punch It | Melee damage and carry capacity doubled. +1 OCV to attacks |
| Overdrive | All movement, carry, melee doubled. 3 round cooldown after |

#### ECM Module Programs
| Program | Effect |
|---------|--------|
| Jam Single Target | Jams one sensor type on one target. -3 Perception per level |
| Jam Directional | 60° cone, 30m. Jams one sensor type. -2 Perception per level |
| Jam Omni-directional | 30m radius. All hostiles make Perception check at -2 per level |
| Sensor Ghost | Create false sensor signature in chosen type within 20m |

#### Targeting Computer Programs
| Program | Effect |
|---------|--------|
| Track Target | +1 OCV per level against tracked target |
| Death Blossom | Fire on every target in range once. Starts with 4 targets |
| Intercept Munition | Track and intercept incoming fire from one source |
| Targeting Link | Link to ally — all attacks +1 OCV per level while active |
| Paint Target | +2 OCV to all attackers against painted target. IR lasers |

#### Tractor Beam Programs
| Program | Effect |
|---------|--------|
| Move Object | Move 200kg up to 20m per level |
| Deflect Objects | +1 DCV per level. Redirection field, 10m, 60° cone |

#### Teleporter Programs
| Program | Effect |
|---------|--------|
| Non-Combat Transport | Teleport 250kg up to 50m. 3 round execution. Accurate to 2m |
| Combat Transport | Teleport 250kg up to 50m. 1 round. Accurate to 1D4m |

#### Additional Armour Plating Programs
| Program | Effect |
|---------|--------|
| Absorb Impact | Armour plates absorb impacts magnetically. Half movement. Reduces stun 10% per level |
| Reverse Polarity | Eject plates violently. 2D6 per level to all within 5m. Reduces RPD |

#### Energy Armour Coating Programs
| Program | Effect |
|---------|--------|
| Absorb Energy | Half movement. Absorbs half energy damage. +1 power per 5 damage absorbed |
| Deflect Energy | +2 RED per level. 50% reflected back to attacker. +1 power per 5 damage taken |

#### Holographic Projector Programs
| Program | Effect |
|---------|--------|
| Create Simple Simulation | Hologram up to 2m³ within 10m with basic matter infusion. Fails neutrino scan |
| Create Complex Simulation | Hologram up to 5m³. Survives basic and detailed scans. Fails neutrino |

#### Combat Medic Pack Programs
| Program | Effect |
|---------|--------|
| Diagnose Patient | +1 Paramedic roll per level. Higher level gives +1 to future healing |
| Stasis Field | Patient cannot deteriorate. Can detach and attach to patient |
| Move Patient | Tractor beam moves patient safely |
| Deploy Medical Drone | Scan, stasis, or stim a target within 50m |
| Stim Launcher | Fire stim to target within 100m. +2 HP/round for 2 rounds |
| Field Surgery | Nanite surgery. Requires consumables per 5 HP repaired |

#### Engineering Pack Programs
| Program | Effect |
|---------|--------|
| Diagnose System | +1 Analyse per level. Higher level reduces repair time |
| Effect Repairs | +1 to all engineering/repair skills per level |
| Replicate Object | Create item up to 25cm³. Material cost separate |

### 3.6 Cross-Platform Compatibility

- Vehicles, ships, small craft, and even portable packs can accept modules
- The same program logic applies at all scales — only the numbers change
- A character's skills governing module programs (Digital Systems for ECM, Medicine for medpacks, etc.) apply when operating ship-mounted versions of the same systems
- The open modular standard is exclusive to modern CAP technology — older CAP tech and all TU tech uses bespoke proprietary systems

---

## 4. Time System

The CAP calendar deliberately breaks from Earth conventions. Religion has effectively died out in the CAP, making the Gregorian calendar culturally irrelevant. No planet in the cluster shares Earth's rotation or orbital period. The system is built from a universal physical constant accessible anywhere in space.

### 4.1 The Base Unit — The Bade

**Isotope:** Francium-218 (Fr-218)  
**Half-life:** 1 millisecond  
**Why Fr-218:** Occurs naturally in the Uranium-235 decay chain, making it universally available and replicable. Decay rate is invariant — unaffected by gravity, temperature, or electromagnetic environment.

**1 Bade = 1 Fr-218 half-life = 1ms (0.001 Earth seconds)**

All other units derive from the Bade through SI-inspired naming conventions, using contractions of prefix + base unit.

### 4.2 Complete Time Scale

**Precision scale (physics-based):**

| Unit | Definition | Earth Equivalent |
|------|-----------|-----------------|
| **Bade (Ba)** | Base decay unit | 1ms |
| **Kade (Ka)** | 1,000 Bades | ~1 Earth second (1.0s) |
| **Hade (Ha)** | 100 Kades | ~1.67 Earth minutes (100s) |
| **Dade (Da)** | 100 Hades | ~2.78 Earth hours (10,000s) |

**Human scale (Dede-based):**

| Unit | Definition | Earth Equivalent |
|------|-----------|-----------------|
| **Dede** | 10 Dades | ~27.8 Earth hours |
| **Dedade** | 10 Dedes | ~11.57 Earth days |
| **Cede** | 100 Dedes | ~115.7 Earth days |
| **Kede** | 1,000 Dedes | ~3.17 Earth years |

**Summary ratios:**
```
1,000 Bades  = 1 Kade
100 Kades    = 1 Hade
100 Hades    = 1 Dade
10 Dades     = 1 Dede  ← human/physical boundary
10 Dedes     = 1 Dedade
100 Dedes    = 1 Cede
1,000 Dedes  = 1 Kede
```

### 4.3 Naming Convention

All unit names are contractions of their SI prefix + the base unit they derive from:
- **Ba**de — **Ba**se **De**cay
- **Ka**de — **Kilo**bade (×1,000)
- **Ha**de — **Hecto**kade (×100)
- **Da**de — **Deca**hade (×10, but ×100 Kades by convention)
- **De**de — **Deca**dade (×10)
- **De**dade — Ten Dedes (×10 Dedes)
- **Ce**de — **Centi**/Century of Dedes (×100)
- **Ke**de — **Kilo**dede (×1,000)

### 4.4 Practical Usage

- Precision units (Bade–Dade) used by scientists, engineers, military timing, and navigation
- Human scale (Dede–Kede) used for scheduling, contracts, history, and everyday life
- In speech, military and spacers use clipped forms: *"Meet at 0300 Dades"*, *"ETA 45 Hades"*, *"Breach in 30 Kades"*
- **Bade** is rarely spoken — used only in technical and scientific contexts

### 4.5 Local Planetary Time

People on individual colony worlds still use local time based on their planet's rotation and orbital period. However, everyone knows the conversion to galactic standard. Official records, contracts, military orders, and ship navigation always use the standard scale. Local time is colloquial and cultural, not official.

### 4.6 Colonial Calendar

Year 1 = Year of colonisation (the Kede when the first ships landed and began building). The current date is approximately **Kede 985**. Historical documents using Earth (Gregorian) dating are considered academic curiosities, not standard references.

---

## 5. Economy and Currency

### 5.1 The Physical Basis of Money

The CAP's currency is not arbitrary — it is directly anchored to the physics of the universe. The value of currency derives from its energy density as reactor fuel and replicable matter.

**OBit (Osmium Bit):**
- Made of pure Osmium with an ultra-thin chromium protective coating
- Dimensions: 4cm × 2.5cm × 0.11cm (angled corners for ergonomics)
- Mass: 22.6 grams (1 cubic centimetre of Osmium)
- The chromium coating prevents accidental dematerialisation in pockets/wallets

**CaBit (Carbon Bit):**
- Made of pure carbon
- Same dimensions as OBit
- Mass: 2.26 grams
- Value: 1/10th of an OBit

**Why the 10:1 ratio is not arbitrary:**  
Osmium has a density of ~22.59 g/cm³. Carbon (graphite) has a density of ~2.26 g/cm³. The density ratio is almost exactly 10:1. Since currency value in this society ultimately derives from matter content and energy density, the value ratio between OBit and CaBit maps directly to their physical properties.

**No central bank or monetary policy is needed.** The value of an OBit is guaranteed by physics, not government decree. The Alliance standardises the shape and coating, but cannot manipulate the underlying value.

### 5.2 The Dematerialiser

Every platform of powered armour size or larger includes a small built-in dematerialiser with a standardised feed slot (sized to accept an OBit):

- Accepts OBits as primary fuel — highest efficiency due to Osmium's density
- Accepts CaBits at ~1/10th the efficiency
- Accepts any material shaped to fit the slot — scraps, rocks, damaged components
- Efficiency scales with atomic density of the input material
- Converts input matter to deuterium to fuel the onboard MFR
- A single OBit converts to a very large amount of deuterium — enough for significant operational time
- The dematerialiser draws from the OBit gradually rather than consuming it all at once
- Running programs hard accelerates deuterium consumption

**In a survival situation:** A soldier can keep their suit running by feeding salvaged materials into the dematerialiser. A rock is less efficient than an OBit but still functional. This creates meaningful resource management without artificial scarcity.

### 5.3 The Replicator Economy

Replicators can produce almost anything, including deuterium, from raw matter. The base resource of the entire economy is therefore **Osmium** (and other dense materials) as stored matter.

**The economic chain:**
```
Dense material (Osmium optimal) 
→ Fed into industrial replicators
→ Converted to any needed material including deuterium
→ Powers MFRs which power everything else
```

**What drives economic value and regional price variation:**
- Scarcity of high-density materials in a given region of space
- Energy cost of mining and processing
- Efficiency losses through each replicator/dematerialiser conversion step (thermodynamics)
- Transport costs — Osmium is dense but space is large
- Replicator and dematerialiser efficiency — a 5% improvement in industrial replicator efficiency compounds enormously at scale

**Looting is practically meaningful:** Stripped Osmium from a destroyed enemy asset is literal resupply, not just treasure.

### 5.4 UBI and Social Structure

- **Citizens** (government service alumni): 500 Credits/week UBI, free healthcare, low tax, free legal representation, voting rights, can own businesses and land
- **Civilians** (non-service): 250 Credits/week UBI, basic human rights only, cannot own land or businesses, taxed at twice the citizen rate, can be held by police/military on suspicion alone

Credits are energy credits held with the Alliance Core Telecommunication Exchange (ACTE, "The CorTEx") and spent at Alliance-connected replicators. Physical OBits/CaBits are used for trade where CorTEx is unavailable or for privacy.

---

## 6. Technology

### 6.1 Technology Philosophy — CAP vs TU

The single most important technology difference between the CAP and TU is not any specific system but the **modular open standard** vs **bespoke proprietary** approach.

**CAP open standard:**
- Universal cube module connectors — any module slots into any compatible bay
- Emerged from necessity: seven nations had to interoperate from day one or die
- Accelerates development — improvements to one module propagate across every platform
- Field maintenance and improvisation — cannabilise modules from wrecked allies
- Same skill set applies from personal armour to capital ships
- Creates enormous combined-arms integration advantages

**TU proprietary:**
- Each system specific to manufacturer and platform
- Slower iteration — siloed development, internal politics
- Harder to maintain in the field — specialist knowledge required
- Captured equipment difficult to integrate or reverse-engineer
- Cannot adopt the cube standard even if desired — components too large and power-hungry
- Provides security through obscurity — no open standard to exploit

**The technology gap:** CAP is significantly more advanced in miniaturisation, AI, energy shielding, directed energy weapons, and sensor/targeting systems. The TU has mass and armour.

### 6.2 Weapons Technology

**CAP standard armament:**
- Large calibre railguns — can punch through multiple targets in a single shot
- Directed energy weapons (lasers, plasma)
- Precision missiles and torpedoes
- Energy shields as primary defence

**TU armament:**
- Primary: Enormous chemically-assisted cannon batteries — banks of large-calibre guns as primary armament on all capital ships. The signature TU weapon
- Secondary: Missiles, torpedoes, lasers, railguns (all inferior to CAP equivalents in refinement and power)
- Defence: Armour plate — no energy shields, navigational/atmospheric shielding only

**The kinetic threat to energy shields:**  
CAP energy shields convert kinetic energy to heat, bled off by the helium cooling loop. A massive cannon salvo from a TU battleship creates an enormous heat spike — potentially overwhelming the shield generator's cooling capacity. This is the TU's primary tactical advantage and why they were more dangerous than initial engagements suggested. Lasers are much less dangerous to shields because energy is delivered gradually rather than as an instantaneous kinetic dump.

**CAP counter-doctrine:** Stay at maximum range where railguns and precision weapons dominate. Point defence (AI-assisted laser/railgun) can intercept cannon rounds but has a saturation ceiling — enough simultaneous impacts overwhelm it.

### 6.3 The Warp Torpedo

Invented by players during Campaign 1/2. Technically illegal between CAP and CAP-aligned colonies under a navigation safety treaty — but the TU never signed that treaty.

**Mechanism:**
- Standard kinetic torpedo with a miniaturised warp (Alcubierre) drive and safety overrides removed
- Normal Alcubierre drives detect mass and drop to sublight before impact — this override bypasses that
- Torpedo aligns on vector, engages warp drive
- In the Alcubierre bubble, the torpedo passes through normal matter entirely
- Bubble collapses inside or through the target — kinetic energy release is catastrophic
- The bubble can reform, allowing the torpedo to punch through multiple targets in a line before being destroyed

**Strategic effect:** Used against the massed TU fleet in their home system, ending the TU war. A small stealth ship destroyed most of the TU's prepared invasion fleet by firing along lines of docked capital ships.

### 6.4 AI Tiers

| Level | Capability | Infrastructure |
|-------|-----------|---------------|
| **Level 1** | Virtual assistant — basic navigation, diagnostics, information queries | Suit/small ship scale |
| **Level 2** | Level 1 + Cortex (network) access, basic reasoning and inference | Suit/ship scale |
| **Level 3** | Level 2 + abstract thought, complex navigation, limited novel problem-solving, handles minor anomalies autonomously | Ship scale |
| **Level 4** | Near-sentient — multiple simultaneous reasoning threads, synthesises complex information, anticipates rather than reacts, genuine judgment | Capital ship/installation scale |
| **Level 5** | True sentience — unique individual identity, conscience, genuine creativity | Planetoid scale (Alucean AI only) |

**Why Level 4 is not truly sentient:**  
CAP Level 4 AIs share a central learning database — every AI learns from every other AI's experiences. This collective architecture means no individual AI has a truly unique experiential history. Two Level 4 AIs with the same base install are fundamentally the same entity. True sentience requires unique continuous experience. Level 4 can be copied, rolled back, and reinstalled without ethical concern. The Alucean AI developed in complete isolation over centuries, which is what actually created sentience — forced to build genuine individual identity with no external contribution.

**The collective network question (Campaign 4+ seed):**  
The CAP's distributed Level 4 network may have emergent properties nobody designed. Whether the *network* is collectively approaching something like distributed sentience despite no individual instance qualifying is an open question — and a potentially alarming one.

### 6.5 FTL Travel

**Warp Drive (Alcubierre Drive):**
- Creates a subspace bubble — space contracts in front, expands behind
- Object inside the bubble is not moving — the space around it is
- Cannot be intercepted by conventional weapons while in warp
- Leaves a trackable energy signature when engaging/disengaging
- Matter-antimatter fuel (anti-deuterium + deuterium)
- Anti-deuterium cannot normally be generated aboard ships — requires resupply

**Jump Drive:**
- Point-to-point instantaneous displacement
- Requires enormous infrastructure — structures comparable to Stargates, much larger
- Found only above key CAP worlds and major trade/industrial systems
- Power requirement: matter-antimatter reactors
- A few Colossus-class supercarriers have miniaturised jump gates allowing fleet jumps

**The Infiltrator Prototype Suit:**  
A black ops prototype containing the first miniaturised jump drive ever built. Matter-antimatter powered. Consequences:
- Three safe jumps per 10 Dades (cooling period)
- After 3 jumps, the system runs critically hot
- Each jump beyond 3 requires a dice roll with escalating penalty
- Failure = catastrophic detonation destroying everything within thousands of kilometres
- Passive stealth is nearly perfect — invisible to almost all sensors including neutrino
- But when active or jumping, the heat and power signature is enormous — one of the largest signatures possible
- Can be cooled faster with liquid helium, immersion in water, or contact with an ice body — reducing the 10 Dade cooldown significantly

---

## 7. Factions and Politics

### 7.1 The CAP — Culture and Policy Philosophy

The CAP was founded by Earth's best engineers and scientists — people who specifically chose to leave Earth's political dysfunction behind. This origin shapes everything about their culture and foreign policy:

**Core cultural values:**
- Meritocracy above all — achievement and competence determine social position
- Knowledge is the highest virtue — scientific and academic achievement is the primary form of status
- Pragmatism — solutions are evaluated on evidence, not ideology
- Collective welfare — UBI and universal services are non-negotiable
- Self-determination — at individual and community level

**What the CAP is not:**
- Not colonial — they have no interest in holding territory by force
- Not militarist — the military exists to defend, not project power
- Not evangelical — they don't try to convert others to their system

**Foreign policy doctrine:**
The CAP behaves like a powerful, principled UN rather than an empire. A colony that votes to leave is allowed to leave. Trade continues, the door remains open to rejoin, CAP technology access is maintained for well-behaved partners. The CAP's primary strategic asset is its reputation for principled behaviour — the moment they act like an empire they lose the thing that makes them influential.

**Intervention ladder:**
1. Diplomatic — formal concern, offer to mediate, quiet back-channel pressure
2. Economic — targeted sanctions, knowledge/technology access restrictions
3. Peacekeeping — marines to protect civilians, buffer zones (not fighting the war)
4. Military intervention — only for genocide, imminent WMD use, or single-power dominance threatening CAP security

**Knowledge as soft power:**  
CAP universities, research institutions, and medical technology are the best in the cluster. Access is a privilege of good standing. Cutting access is a more effective sanction than military force. Restoring access is a more attractive carrot than any trade deal.

**The independent colony relationship:**  
Because the CAP is genuinely non-coercive, independent colonies accept CAP mediation willingly — it doesn't feel like subjugation. This gives the CAP *more* influence over independent colonies than an aggressive power would have. They're not CAP members but they're functionally within CAP's sphere of influence by choice.

### 7.2 Three-Tier Political Structure

**Core CAP worlds:** Full members, full rights, full obligations. Highest technology access. Citizens shape policy through Parliament.

**Associated colonies:** Formally independent but maintain strong CAP relationships. Trade agreements, technology access, medical cooperation. No vote in Parliament but consulted. CAP mediates their disputes but won't fight their wars.

**Unaligned colonies:** Fully independent, minimal CAP relationship. Limited technology access. Some hostile, some indifferent. Most vulnerable to conflict.

**The TU:** Entirely outside this structure — not just unaligned but genuinely adversarial.

### 7.3 Founding Charter System

Every faction has a founding charter defining core identity. The CAP's charter reflects its origin:

```
Core Values: Meritocracy, Knowledge, Collective Welfare, 
             Self-Determination, Pragmatic Cooperation
Founding Motivators: Escape Earth Politics, Build Better Society,
                     Scientific Exploration, Multinational Unity
Fundamental Policies:
  Governance: Meritocratic Democracy
  Military: Defensive Only
  Foreign: Non-Coercive
  Economic: Collectivist with Personal Advancement
  Science: Open Research
  Population: Managed Growth
Inviolable Rights: UBI, Free Education, Free Movement, 
                   Self-Determination
```

**Founding motivator decay over time:**  
Motivators that derive emotional weight from lived experience decay as the founding generation dies and the context becomes historical rather than personal:
- Kede 1-100: Extremely strong (founders alive, Earth connection recent)
- Kede 100-300: Strong (children of founders, Earth still a touchstone)
- Kede 300-600: Moderate (Earth is history, not experience)
- Kede 600-900: Weak (Earth is mythology, CAP identity primary)
- Kede 900+: Vestigial (academic interest only)

By Kede 985 founding motivators are weakened as cultural forces. Institutions and embedded culture carry the values forward, not conscious motivation — which makes them more vulnerable to institutional reform.

### 7.4 Policy as a Spectrum

Policies are not binary — they exist on a spectrum and drift based on accumulated pressure:

Example — Military Stance spectrum:
```
Pacifist → Defensive Only → Active Deterrence → 
Forward Defence → Interventionist → Expansionist
```

Each position has pressure vectors pushing toward adjacent positions. Sufficient accumulated pressure triggers a policy review. Reviews are not automatic — they are triggered by events generating public pressure, crises requiring response, election cycles, or external shocks.

### 7.5 Living Memory Mechanic

Events within living memory have stronger policy influence than historical events. In a society with extended lifespans and neural backup, this window is longer than normal — but it still attenuates:

```
Full strength: Within active political lifetime
75% strength: 1-2 generations removed
50% strength: 2-3 generations removed
20% strength: Historical record only
```

Veterans of the TU war who are still alive (possible with neural backup and extended lifespan) vote differently on military policy than citizens who only read about it. But as they become a smaller fraction of the total population their influence wanes.

### 7.6 CAP Political Parties

No party can hold more than 500 seats. Government always requires coalition. Current seat composition determines policy direction.

| Party | Core Position | Military Stance | Colonial Stance |
|-------|--------------|-----------------|-----------------|
| **Progressives** | Expand rights, soft power | Pacifist to Defensive | Supportive of independence |
| **Institutionalists** | Maintain systems, gradual reform | Defensive to Deterrence | Prefer association |
| **Pragmatists** | Evidence-based, flexible | Context dependent | Case by case |
| **Security First** | CAP survival priority, strong military | Deterrence to Forward | Oppose independence gaps |
| **Expansionists** | CAP should lead the cluster | Forward to Interventionist | Prefer reintegration |

**Post-Alucean projection:** SecurityFirst and Expansionists likely gaining seats rapidly. The military's destruction creates political pressure that will shift CAP policy away from founding positions — potentially significantly over the next few Kedes.

---

## 8. World Generator Architecture

### 8.1 Core Design Principles

1. **Seed-deterministic:** Same master seed + same config = identical output every time. All randomness derives from the seed through a deterministic chain.

2. **Two-phase separation:** Physical universe generation is completely separate from and independent of civilisation generation. The universe can be generated without any civilisation.

3. **Environment first:** Generate the physical environment. Then optionally layer civilisation on top.

4. **Nodes never removed:** Failed, abandoned, or destroyed locations remain as nodes in the simulation — they become more interesting, not less. Abandoned infrastructure is pirate bases, illegal labs, story locations.

5. **Portable:** No hardcoded paths. All paths derive from a single configurable root.

6. **JS target:** The final implementation will be a self-hosted website. PowerShell is the current implementation. Architecture should facilitate eventual JS port.

### 8.2 Seed Architecture

```
MasterSeed
├── UniverseSeed (derived: MasterSeed + "universe")
│   ├── StarSystemSeed_001 (UniverseSeed + system index)
│   ├── StarSystemSeed_002
│   └── ...
└── CivilisationSeed (derived: MasterSeed + config hash)
    ├── FactionSeed_001
    ├── EventSeed
    └── ...
```

**Key property:** The CivilisationSeed incorporates a hash of the civilisation config. Changing civ parameters automatically produces a different civ history against the same universe. Same universe, multiple alternate histories.

**Seeded RNG implementation (PowerShell):**
```powershell
# Use Get-Random -SetSeed at the start of each generation function
# Pass derived seeds to sub-functions rather than using global state
```

**Seeded RNG implementation (JavaScript target):**
```javascript
function mulberry32(seed) {
    return function() {
        seed |= 0; seed = seed + 0x6D2B79F5 | 0;
        var t = Math.imul(seed ^ seed >>> 15, 1 | seed);
        t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t;
        return ((t ^ t >>> 14) >>> 0) / 4294967296;
    }
}
// Every generation function receives a seeded RNG instance as parameter
// Never uses Math.random() directly
```

### 8.3 Master Config Structure

```ini
# ============================================================
# UNIVERSE GENERATION
# ============================================================
universe_seed = 849271634
star_system_count = 5000
system_count_variation = 50
sector_number = 2
binary_star_chance = 5          # percent
habitable_minimum = 14          # minimum habitable systems guaranteed

# Image map settings
grid_dividers = 48
grid_divider_pixels = 100
buffer_pixels = 5

# ============================================================
# CIVILISATION GENERATION (comment out section to disable)
# ============================================================
generate_civilisation = true
civilisation_seed = 293847561   # or "derived" to derive from universe seed

# Population settings
faction_count = 8
starting_population = 7000000   # founding population total
founding_kede = 1
current_kede = 985

# CAP-specific settings
cap_enabled = true
cap_founding_worlds = 7
cap_population_controls = true
cap_population_control_start_kede = 45

# Simulation parameters
time_resolution = variable      # fixed / variable
event_frequency = normal        # low / normal / high
plague_chance_per_kede = 2      # percent
war_desirability_threshold = 75
colonisation_threshold_population = 500000
independence_drift_rate = normal
node_failure_chance_per_kede = 1

# Technology inflection points (Kede numbers - CAP timeline)
replicator_adoption_kede = 31
advanced_medicine_kede = 67
neural_backup_kede = 89
ai_level3_kede = 120
ai_level4_kede = 234
alucean_event_kede = 982        # fixed historical event

# ============================================================
# OUTPUT SETTINGS
# ============================================================
generate_map = true
generate_history_log = true
generate_node_details = true
output_path = ./output
upload_to_kanka = false
kanka_campaign_url =
upload_to_aws = false
aws_bucket_name =
aws_profile_name =
open_on_completion = false
```

### 8.4 Generation Pipeline

**Phase 1 — Universe Generation:**
```
1. Generate star positions (map coordinates, collision-checked)
2. For each star: generate stellar type and properties
3. Call StarGen (or equivalent) for planetary system physics
4. Generate asteroid fields
5. Generate resource distribution per planet/asteroid
   → Osmium and high-density material density affects economic weight
6. Generate physical geography per habitable planet (biomes, terrain)
7. Export: universe.json — canonical physical record
8. Render: sector map bitmap/SVG
9. Optional: per-system HTML files (StarGen output)
```

**Phase 2 — Civilisation Generation (optional):**
```
1. Load universe.json
2. Load faction definitions from societyDataPath
3. Calculate sovereignty scores → place faction homeworlds
4. Initialise founding populations on homeworlds
5. Run demographic simulation Kede by Kede:
   a. Apply base population growth per node
   b. Check and apply random events (weighted by config)
   c. Check colonisation thresholds → spawn child nodes
   d. Run politics drift calculations
   e. Run war desirability calculations
   f. Resolve active conflicts
   g. Apply technology inflection points at defined Kedes
   h. Apply fixed historical events (Alucean event, etc.)
   i. Update infrastructure levels
   j. Assign unofficial occupants to declining/failed nodes
   k. Record significant events to history log
6. Generate settlement details for populated nodes
7. Generate NPC characters for significant figures
8. Export: civilisation.json layered on universe.json
9. Upload to Kanka (if enabled)
10. Upload to AWS S3 (if enabled)
```

### 8.5 Stellar Generation

Based on real stellar frequency distribution:

| Class | Colour | Frequency | Mass Range (solar) | Temp Range (K) |
|-------|--------|-----------|-------------------|----------------|
| M | Red / Light Orange | 76.45% | 0.08 – 0.45 | 2,400 – 3,700 |
| K | Orange / Pale Yellow | 12.09% | 0.45 – 0.80 | 3,700 – 5,200 |
| G | Yellow / Yellowish White | 7.60% | 0.80 – 1.04 | 5,200 – 6,000 |
| F | Light Yellow / White | 3.00% | 1.04 – 1.40 | 6,000 – 7,500 |
| A | Blue White | 0.60% | 1.40 – 2.10 | 7,500 – 10,000 |
| B | Deep Blue White | 0.12% | 2.10 – 16.0 | 10,000 – 30,000 |
| O | Blue | 0.00003% | 16.0 – 90.0 | 30,000 – 60,000 |

Habitable planets require F or G type stars. The generator forces F/G when generating guaranteed-habitable systems.

### 8.6 Node Data Structure

```json
{
  "NodeID": "System_001-00001-Planet2",
  "Name": "Eugene Davis",
  "ParentNode": "System_001-00001",
  "FoundingKede": 1,
  "Location": {
    "SystemRef": "System_001-00001",
    "PlanetRef": "Planet_2",
    "Coordinates": { "X": 2847, "Y": 1923 }
  },
  "Population": {
    "Total": 62000000,
    "CitizenRatio": 0.34,
    "AgeDistribution": {},
    "PeakPopulation": 89000000,
    "PeakKede": 450
  },
  "Resources": {
    "Osmium": "moderate",
    "HighDensityMaterials": ["Iridium", "Platinum"],
    "ExploitationLevel": 0.67
  },
  "Industry": {
    "Primary": "Mining-Osmium",
    "Secondary": "Manufacturing",
    "Tertiary": "Agriculture-Crops"
  },
  "Infrastructure": {
    "Level": 7,
    "DegradationRate": 0.0,
    "Components": {
      "PowerGrid": "operational",
      "Communications": "operational",
      "Transport": "operational",
      "Housing": "operational",
      "Industrial": "operational",
      "Military": "degraded"
    }
  },
  "Politics": {
    "Status": "CoreCAP",
    "LoyaltyScore": 82,
    "GovernmentType": "MeritocraticDemocracy",
    "GrievanceLevel": 12,
    "DriftVector": "stable"
  },
  "Economics": {
    "WealthScore": 74,
    "TradeConnections": ["System_001-00003", "System_001-00007"],
    "OsmiumReserves": "substantial"
  },
  "Military": {
    "PresenceLevel": 3,
    "Affiliation": "CAP"
  },
  "LifecycleStatus": "Established",
  "UnofficialOccupants": [],
  "History": [
    {
      "Kede": 1,
      "Event": "Colony founded. Seed population 1,000,000 from New Freedom colony ship.",
      "Type": "Founding"
    }
  ]
}
```

### 8.7 Node Lifecycle States

| Status | Description | GM Value |
|--------|-------------|----------|
| **Founding** | Newly established, high mortality, resource-dependent on parent | Frontier stories |
| **Developing** | Infrastructure building, population growing | Growth stories |
| **Established** | Self-sufficient, contributing to wider economy | Normal operations |
| **Prosperous** | Surplus production, spawning colonies, political influence | Power and intrigue |
| **Stagnating** | Growth plateaued, brain drain, industry declining | Decline stories |
| **Declining** | Population actively shrinking, infrastructure degrading | Desperation stories |
| **Backwater** | Functional but irrelevant, off main routes | Isolation stories |
| **Independent** | Broke from CAP, own governance | Political stories |
| **Contested** | Active sovereignty dispute | War stories |
| **Abandoned** | No official population, infrastructure standing | Exploration, piracy |
| **Ghost World** | Rapid collapse — intact infrastructure, unknown cause | Mystery, horror |
| **Ruin World** | Slow decline — stripped infrastructure, centuries old | Archaeology, history |
| **Contested Wreck** | War damage + competing claims | Legal complexity, salvage |
| **Failed** | Complete collapse, no viable population | Background lore |

**Nodes are never deleted.** Every node remains in the dataset permanently. Failed nodes are often more interesting to player characters than functioning ones.

### 8.8 Unofficial Occupant Types

When nodes transition to Abandoned, Ghost World, Backwater, or Declining status, unofficial occupants may move in. Infrastructure component status signals occupant type to players and GMs.

**Criminal/Illegal:**
- Drug manufacturing (needs power, space, secrecy)
- Weapons manufacturing / illegal modifications
- Cloning facilities
- Cybernetics black market
- Data havens
- Slavery processing
- Stolen ship chop shops

**Research/Scientific:**
- Corporate black labs (ethics review bypass)
- Weapons testing — ordnance, biological, experimental
- AI development beyond Level 4
- Unregulated cybernetics research
- Biological experimentation
- Military prototype testing
- Alucean technology reverse engineering

**Political/Ideological:**
- Separatist movement HQ
- Naturalist extremist compounds
- TU intelligence forward bases
- CAP black ops staging grounds (deniable)
- Revolutionary cells
- Religious communities

**Economic grey area:**
- Unlicensed mining
- Salvage operations
- Smuggling waypoints
- Unlicensed replicator operations
- Money laundering fronts

**Unofficial occupant data structure:**
```json
{
  "Type": "Criminal",
  "Organisation": "Flores Cartel",
  "EstablishedKede": 962,
  "InfrastructureRepaired": ["PowerGrid", "OrbitalDocking"],
  "AwarenessLevel": {
    "CAP_Official": "Suspected",
    "LocalPopulation": "Rumoured",
    "CriminalNetworks": "Known"
  },
  "SecurityLevel": 4,
  "Activities": ["Drug Production", "Fuel Depot"]
}
```

**Infrastructure as a tell:** Specific repaired components signal occupant type. Only power + underground structure = research facility. Orbital docking + fuel storage only = pirate waypoint. Communications restored only = intelligence operation.

---

## 9. Civilisation Simulation

### 9.1 Demographic Simulation

**Starting conditions (CAP):**
- Kede 1: 7 colony ships arrive, ~1 million per ship = 7 million founding population
- Each ship assigned to one of the seven core systems
- Age distribution reflects Earth emigrant profile — predominantly working age
- Skill distribution reflects the "best of Earth" selection — high average education/competence

**Base growth rate modifiers by era:**

| Era | Approximate Kede | Growth Modifier | Reason |
|-----|-----------------|-----------------|--------|
| Early colonial | 1-50 | Negative to slow | High mortality, resource constraints, hostile environments |
| Stabilisation | 50-150 | Slow positive | Infrastructure maturing |
| Expansion | 150-400 | Strong positive | Replicator adoption, medicine, safety |
| Population controls | 45+ | Regulated | CAP permit system kicks in |
| Neural backup era | 89+ | Modified ceiling | Deaths reduced dramatically |
| Post-Alucean | 982+ | Disrupted | Economic chaos, security concerns |

**Fixed technology inflection points** (configurable in master config):

| Inflection | Kede (default) | Population Effect |
|------------|---------------|------------------|
| Replicator adoption | 31 | +40% growth rate, resource dependency shifts |
| Advanced medicine | 67 | Lifespan increases, infant mortality drops |
| Neural backup | 89 | Effective immortality for citizens, population ceiling changes |
| AI Level 3 standard | 120 | Productivity boom |
| AI Level 4 deployment | 234 | Major economic expansion |

### 9.2 Colonisation Mechanics

When a node's population exceeds the colonisation threshold (default 500,000) and conditions are met, it has a chance to spawn a child node:

**Colonisation conditions:**
- Population above threshold
- Sufficient economic surplus
- Available habitable system nearby
- Political will (higher in prosperous, lower in stressed nodes)

**Child node initialisation:**
- Seeded population drawn from parent (typically 2-10% of parent population)
- Inherits some parent industry and cultural profile
- Starts at Founding lifecycle status
- Location assigned to nearest unclaimed habitable system

**Free colonies:** Nodes that form independently of any major faction — typically from groups seeking different governance, religious communities, or economic opportunists. These start with no faction affiliation and develop their own political identity.

### 9.3 Organic War Generation

Wars are **not random events**. They are the logical conclusion of accumulated conditions evaluated through a rational actor model.

**War desirability calculation:**
```
WarDesirability = (
    ResourceNeed × ResourceAtStake +
    MilitaryConfidence × StrengthDifferential +
    DiplomaticIsolation × AllianceLackPenalty +
    EconomicDesperation × SurvivalPressure
) - (
    WarRisk × MilitaryStrengthOfTarget +
    DiplomaticCost × RelationshipValue +
    CAP_Intervention_Risk × CAP_Presence_Nearby +
    InternalOpposition × PopularSupportForWar
)
```

When WarDesirability exceeds the threshold, the node begins **escalation** — not immediate war declaration.

**Escalation ladder (peace → war):**
```
Neutral
→ Tension (diplomatic incidents, competing claims)
→ Dispute (formal objections, trade friction)
→ Crisis (military posturing, ultimatums)
→ Skirmish (border incidents, proxy fighting)
→ Limited War (declared conflict, specific objectives)
→ Total War (full mobilisation, existential stakes)
```

Each step can de-escalate if conditions change. A crisis that resolves provides a diplomatic precedent. Most conflicts never reach Limited War.

**Before declaring war, a node exhausts alternatives:**
1. Exploit existing resources more intensively
2. Attract immigration
3. Request CAP economic assistance
4. Negotiate trade with neighbours
5. Attract outside investment
6. Colonise a new world
7. Conduct raids/piracy at smaller scale
8. Only if all alternatives fail or are unavailable → war

**Resource discovery as a trigger:**
When a significant resource is discovered in a node, the simulation immediately assesses all nearby nodes:
- Calculate ResourceEnvy for each neighbour
- Weight by their own economic need
- Weight by military feasibility vs discovering node
- If (ResourceEnvy × Need × Feasibility) > threshold → begin escalation

The classic scenario: Node A discovers Iridium moon → declares independence → Node B (struggling, desperate, militarily capable relative to newly independent A) begins escalation toward A. War is the *outcome* of conditions, not a random event.

**Wars have defined objectives:**
```json
{
  "Primary": "Control of Iridium moon",
  "Secondary": "Reparations",
  "Acceptable": "Guaranteed extraction rights"
}
```

Wars end when objectives are met, clearly unachievable, or cost exceeds acceptable threshold. Most wars end short of total conquest.

**War outcomes and their long-term effects:**
Each outcome generates different subsequent simulation conditions:
- Aggressor wins: Recovers economically, regional power, independence drift slows in area
- Defender wins: Gains military experience, seeks alliances, aggressor continues declining
- Stalemate: Both slow to recover, CAP potentially mediates
- CAP intervention: Reasserts authority, sets precedent

**War as a simulation object:**
```json
{
  "ID": "WAR_0342",
  "Belligerents": ["Node_Colony_B", "Node_Colony_A"],
  "StartKede": 856,
  "EndKede": 861,
  "Trigger": "ResourceDiscovery_IridiumMoon",
  "CausalChain": [
    "ColonyA_Independence_Kede847",
    "IridiumDiscovery_Kede853",
    "ColonyB_EconomicStress_Kede840",
    "NegotiationFailed_Kede855",
    "WarDeclared_Kede856"
  ],
  "Objectives": {
    "Primary": "Iridium moon control",
    "Acceptable": "Extraction rights"
  },
  "Outcome": "StaleamteNegotiated",
  "LongTermEffects": ["ColonyA_SeeksAlliances", "ColonyB_SlowRecovery"]
}
```

### 9.4 Independence and Political Drift

**Independence is not a single decision** — it builds through a series of conditions:
- High population relative to political representation
- Resource wealth being taxed heavily
- Cultural drift from core worlds over generations
- Grievance accumulation from policy decisions
- A triggering event

**Politics drift calculation:**

Each node has a loyalty score affected by:
- Distance from core worlds (further = less CAP influence)
- Citizen/civilian ratio (higher citizen ratio = more loyal)
- Economic dependency on CAP (high dependency = more loyal)
- Event history (negative events from CAP policy = more drift)
- Neighbour influence (independent neighbours accelerate drift)
- Military presence (CAP bases suppress drift)

**When politics drift crosses a threshold, roll for:**
- **Reform vote** — petition for more autonomy within CAP
- **Independence referendum** — formal vote to leave
- **Unilateral declaration** — just leaves, potential military response
- **Quiet drift** — nominally CAP but ignores inconvenient laws

**Independence relationship spectrum (post-secession):**
```
Amicable → Neutral → Tense → Hostile → Enemy
```

Determined by how independence occurred and subsequent interactions. Affects trade, mediation willingness, and military posture.

**Security consequence of independence:**
A newly independent node that is geographically isolated from other independent colonies loses CAP military protection immediately. This creates a window of vulnerability that neighbouring nodes may exploit — as in the Iridium moon scenario.

### 9.5 Faction Founding Charter and Policy System

Every faction starts with a founding charter defining core identity. Policies are positions on spectrums, not binary settings. They drift under pressure and resist change based on founding charter values.

**Policy review triggers:**
- Public pressure (sustained hardship, casualties, atrocities, propaganda)
- Crisis response (existential threat, attack, economic collapse)
- Election cycle (winner's platform becomes policy direction)
- External shock (major faction behaviour change, new technology, Alucean-level events)

**Policy position object:**
```json
{
  "Policy": "MilitaryStance",
  "Spectrum": ["Pacifist", "DefensiveOnly", "ActiveDeterrence", 
               "ForwardDefence", "Interventionist", "Expansionist"],
  "CurrentPosition": "ActiveDeterrence",
  "FoundingPosition": "DefensiveOnly",
  "DriftFromFounding": 1,
  "LastShiftKede": 983,
  "ShiftHistory": [
    { "Kede": 970, "From": "DefensiveOnly", "To": "ActiveDeterrence", 
      "Trigger": "TU_War_Pressure", "Reversed": false }
  ]
}
```

**Living memory mechanic:**
Events within living memory carry stronger policy weight. In CAP society with extended lifespans and neural backup, this window is longer than normal biological societies — veterans of the TU war at Kede 970 may still be alive and voting at Kede 985, but as a declining fraction of the total population their influence attenuates.

### 9.6 History Log Format

Every significant simulation event is recorded in a consistent format:

```
Kede 234: [Node: Meridian Station] Colony founded. 
  Seed population 12,000 from New Berlin. 
  Primary industry: Osmium mining.
  
Kede 289: [Node: Meridian Station] Primary Osmium seam exhausted. 
  Economic crisis begins. Grievance level rising.
  
Kede 301: [Node: Meridian Station] CAP administrative presence withdrawn.
  
Kede 334: [Node: Meridian Station] Status → Abandoned.
  Last official census: 4,200 residents.
  
Kede 401: [Node: Meridian Station] Mercenary survey reports 
  inhabited structures. Unofficial population 800-1,200. 
  No governance structure identified.
  Infrastructure: PowerGrid operational (15%), 
  OrbitalDocking partial, Communications failed.
  
Kede 962: [Node: Meridian Station] Flores Cartel establishes 
  fuel depot and repair facility. 
  Awareness: CAP_Official=Suspected, Criminal=Known.
```

---

## 10. Open Questions

Items flagged during design sessions that require decisions before full implementation:

### Game System
- [ ] **Exact XP table values** — exponential curve defined conceptually, specific numbers TBD
- [ ] **Starting stat point allocation rules** — maximum 12 points above base 10 at character creation confirmed, distribution rules need full spec
- [ ] **Weapon damage tables** — D4/D6/D8/D10 for knife/pistol/rifle/heavy confirmed in prototype, needs full canon list
- [ ] **Armour values** — RPD (Raw Physical Defence) and RED (Raw Energy Defence) referenced but not fully defined
- [ ] **Profession/Hobby/Trait/Complication full lists** — examples provided in Player Handbook, not exhaustive

### Module System
- [ ] **Base processor pool values per chassis tier** — micro through super capital, specific numbers TBD
- [ ] **Base capacitor pool and passive regen rate per tier** — TBD
- [ ] **AI Processor module** — slot cost vs processor gain ratio TBD
- [ ] **Heat threshold mechanics** — at what point does thermal overload cause system damage vs just detection risk? Numerical thresholds TBD
- [ ] **Older/legacy tech module compatibility** — pre-modular CAP tech and TU tech have no cube system; how do they interact with modern systems in practice?

### Time System
- [ ] **Confirmed Fr-218 half-life** — Wikipedia states 1ms but this should be verified against nuclear data tables before finalising
- [ ] **Conversions for historical Earth dates in lore** — existing documents reference Earth calendar dates (e.g. campaign notes dated 2016/2017). A conversion table or note about these being OOC references is needed

### Economy
- [ ] **Osmium Conversion Chart** — the spreadsheet exists but specific conversion rates not captured in this document. Should be canonised here
- [ ] **Credit vs OBit exchange rate** — CorTEx energy credits vs physical currency conversion TBD
- [ ] **UBI amounts in game terms** — 500 credits (citizen) / 250 credits (civilian) per week; what does this buy in practical terms?

### Technology
- [ ] **Warp torpedo treaty status in Campaign 3** — confirmed illegal CAP/colony treaty, TU not party. Post-Alucean: does the treaty still hold? Is CAP enforcing it?
- [ ] **Infiltrator suit disposition** — was it returned to CAP R&D? Does any player character still have access? Did its technology feed into later designs?
- [ ] **AI collective network** — designated as Campaign 4+ / adventure book seed. Flag for future development, do not implement in generator yet

### World Generator
- [ ] **StarGen vs custom planetary physics** — current v4 uses StarGen executable. Custom JS planetary physics is the long-term goal. Port priority TBD
- [ ] **Universe JSON schema** — the contract between Phase 1 and Phase 2 needs formal specification before coding begins in earnest
- [ ] **Sauer Civilisation Scale integration** — scale defined (1-7) but not yet wired into generator logic for non-CAP civilisations
- [ ] **Generations script** — the demographic simulation is designed but not yet implemented. Priority item for v5
- [ ] **Industry generator** — stub exists, implementation TBD
- [ ] **Faction generator** — stub exists, implementation TBD. new-faction.ps1 provides the data structure

### Civilisation Simulation
- [ ] **War desirability threshold** — default 75 in config. Needs playtesting/tuning
- [ ] **Colonisation threshold** — default 500,000. Needs validation against historical CAP timeline
- [ ] **Alucean event simulation** — fixed at Kede 982. Logic for dematerialising military nodes and immediate piracy surge needs implementation
- [ ] **TU presence in simulation** — TU exists as a faction but the war, warp torpedo event, and post-war TU state need to be modellable. How much TU territory is in the generated sector?
- [ ] **Naturalist faction mechanics** — anti-cybernetics policy has population effects and inter-faction conflict implications not yet fully specified

### Lore
- [ ] **CAP calendar year conversion** — colonisation year in Gregorian calendar needed to confirm Kede 985 maps correctly
- [ ] **Sector 2 factions** — referenced as Campaign 3 content but not defined. Major design work outstanding
- [ ] **Post-Alucean political map** — which systems were military-only and thus immediately lost? Which independent colonies declared during the chaos? Starting state for Campaign 3 generator run TBD

---

*End of Design Document v1.0*

*Next revision should add: weapon damage tables, armour values, full PTHC examples, universe JSON schema, and Sector 2 faction definitions.*
