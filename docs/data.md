# Dataset contract

This describes the selected generator and Model 04 export; a newly generated dataset is not claimed to reproduce the archived result exactly.

## Recording format

Filename: `R1_Case_<number>_<fault>_<line>.mat`.

| Variable | Format | Meaning |
| --- | --- | --- |
| `faultData` | 1201 x 6, single precision | `Va, Vb, Vc, Ia, Ib, Ic`, normalized to peak bases |
| `t` | 1201 x 1, single precision | Seconds from 0 through 0.2 |
| `metadata` | MATLAB structure | Fault type, line, location, segment distances, start/end, resistances, sample rate and simulation wall time |

The generator uses 33 kV line-to-line and 25 MVA bases. Voltage samples are divided by `sqrt(2)*33000/sqrt(3)` and currents by `sqrt(2)*25000000/(sqrt(3)*33000)`. External data require compatible units/bases or a documented physical conversion.

## Class indices in the archived run

| Index | Label | Fault |
| ---: | --- | --- |
| 0 | AB | Phase A-B |
| 1 | BC | Phase B-C |
| 2 | AC | Phase A-C |
| 3 | AG | Phase A-ground |
| 4 | BG | Phase B-ground |
| 5 | CG | Phase C-ground |
| 6 | ABG | Phases A-B-ground |
| 7 | BCG | Phases B-C-ground |
| 8 | ACG | Phases A-C-ground |
| 9 | ABC | Three-phase |
| 10 | ABCG | Three-phase-ground |

The generator's selection order differs from this encoding: do not use its `typeIndex` as a model class ID. The notebook has a `Norm` alias, but no healthy examples appear in the archived run.

## Generator settings

| Setting | Value |
| --- | --- |
| Default cases / random seed | 2,000 / 11001 |
| Measurement | `R1_data` |
| Sampling / duration | 6,000 Hz / 0.2 s |
| Fault lines | L01_02 (20 km), L03_04 (18 km), L06_11 (8 km), L09_10 (10 km) |
| Location | Random 10-90% of line length |
| Start / duration | Random 0.04-0.10 s / 0.03-0.06 s |
| Fault / ground resistance | 0.01 ohm / 0.001 ohm |

Line and fault type are randomly selected; class counts are not forced equal. Fixed resistances and a single relay measurement limit operating-condition coverage.

## Availability and provenance

The selected local folder contains `Training_2000_14_Bus.zip` and `Gale_14_Bus_Validate.zip`. The notebook uses the first name for training and a separate `Laxapana_Data.zip` for external evaluation. **Gale is not Laxapana.** Names alone do not establish the exact archive bytes used in a run.

Raw datasets are excluded from this source checkout. A reproducible release needs checksums, access instructions, source/generation information, split membership and a small distributable sample. The matching Laxapana archive and model artifacts are still needed.

The historical PDF's external cell declares a fallback sampling rate of 6 kHz. Confirm it against the external generation source; recording length alone cannot establish physical sample rate. The current imported notebook instead defaults to automatic timing handling, with relative-position mapping for untimed records, and selects `Validation(Indika).zip`.
