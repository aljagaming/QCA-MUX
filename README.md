# Reversible QCA Multiplexers (2:1, 4:1, 8:1, 16:1)

Implementation and analysis of reversible multiplexers in quantum-dot cellular automata (QCA), made in QCADesigner-E. The 2:1, 4:1 and 8:1 circuits are rebuilt from:

Alharbi, Edwards, Stocker. *An Ultra-Energy-Efficient Reversible Quantum-Dot Cellular Automata 8:1 Multiplexer Circuit.* Quantum Reports 6(1):41-57, 2024. https://doi.org/10.3390/quantum6010004

The 16:1 multiplexer is our own extension.

## Files
| File | Circuit | 2:1 muxes used |
|---|---|---|
| `mux2_1.qca` | 2:1 multiplexer | 1 |
| `mux4_1.qca` | 4:1 multiplexer | 3 |
| `mux8_1.qca` | 8:1 multiplexer | 7 |
| `mux16_1.qca` | 16:1 multiplexer (ours) | 15 |

## Design
- **Building blocks:** single-branch inverter and reversible majority gates. A majority gate with a fixed -1 input (logic 0) is an AND, with a fixed +1 input (logic 1) it is an OR. Inputs are kept as copies (Acp, Bcp, Scp, S'cp), and unused outputs are marked g.
- **2:1 mux:** two reversible ANDs, one reversible OR and one inverter. Mux = S'·A + S·B.
- **Larger muxes:** a mux with n select inputs has 2^n data inputs and 2^n - 1 2:1 muxes arranged in a tree. 4:1 = 3 × 2:1, 8:1 = 2 × 4:1 + 1 × 2:1, 16:1 = 2 × 8:1 + 1 × 2:1.
- **Clocking:** four clock zones (switch, hold, release, relax).
- **Wire crossings:** the 8:1 (as in the paper) and our 16:1 use vertical and crossover cells so select signals can cross other wires.

## Naming
- Data inputs: A, B, C, ... (A to P for 16:1). Output: MUX.
- Selects: S0 is the least significant bit. S3S2S1S0 = 0000 selects A and 1111 selects P.

| S1 | S0 | Y (4:1) |
|----|----|---|
| 0 | 0 | A |
| 0 | 1 | B |
| 1 | 0 | C |
| 1 | 1 | D |

8:1 uses S2S1S0 (000 = A ... 111 = H). 16:1 uses S3S2S1S0 (0000 = A ... 1111 = P).

## How to simulate
1. Open a `.qca` file in QCADesigner-E.
2. Go to Simulation > Simulation Type Setup and choose **coherence vector** (QCADesigner-E energy simulation, as in the paper).
3. Set the parameters. Reference values from the paper: cell 18 × 18 nm, cell spacing 2 nm, radius of effect 80 nm, clock high 9.8e-22 J, clock low 3.8e-23 J, relative permittivity 12.9, layer separation 11.5 nm, temperature 1 K, relaxation time 1e-15 s, time step 1e-16 s, Gaussian clock, clock period and input period 1e-9 s, clock slope 1e-10 s, total simulation time 8e-9 s.
   Ours: the same values for the energy runs. For the function and delay checks we used a faster clock to keep runs short: clock period and input period 4e-12 s, clock slope 1e-12 s, total simulation time 5e-11 s, everything else unchanged (Euler method, Gaussian clock, randomized simulation order, zeroing of inputs on).
4. Create input vectors covering every select combination, then run the simulation.
5. Compare the output waveform with the truth table, allowing for the clock delay.

## Results
Metrics: number of cells, area, clock delay.

| Circuit | Cells | Area (µm²) | Delay (clock cycles) | Source |
|---|---|---|---|---|
| 2:1 | 56 | 0.09 | 1 | paper |
| 2:1 | 56 | 0.09 | 1 | ours |
| 4:1 | 213 | 0.46 | 3 | paper |
| 4:1 | 204 | 0.42 | 3 | ours |
| 8:1 | 646 | 1.36 | 5.5 | paper |
| 8:1 | 618 | 1.30 | 5.5 | ours |
| 16:1 | n/a | n/a | n/a | paper |
| 16:1 | 1679 | 4.10 | 11.25 | ours |

> Note: the paper states 213 cells (4:1) and 646 cells (8:1), with areas of 0.46 and 1.36 µm². A recount of the layouts shown in the paper gives 204 and 618 cells, which agrees with our circuits.

## Does each design work in simulation?
Yes. All four circuits were simulated in QCADesigner-E and the output matches the truth table for every select combination, allowing for the clock delay.

| Circuit | Truth table verified | Notes |
|---|---|---|
| 2:1 | yes | all 8 combinations of S0, A, B match Mux = S0 ? B : A, delay 1 cycle |
| 4:1 | yes | all 4 select combinations (S1S0 = 00 to 11) give A to D, delay 3 cycles |
| 8:1 | yes | all 8 select combinations (S2S1S0 = 000 to 111) give A to H, delay 5.5 cycles |
| 16:1 | yes | all 16 select combinations (S3S2S1S0 = 0000 to 1111) give A to P, delay 11.25 cycles |

## Authors
Strahinja Đorđević, Alja Eremić, Simona Cholakova
