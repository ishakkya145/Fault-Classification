# IEEE 14-bus simulation

`IEEE_14_Final.slx` is an unchanged copy of the author-selected model from `Updated_14_Bus`. `generate_dataset.m` adapts the accompanying `Gen_20.m`.

## Environment and execution

The SLX metadata records MATLAB R2024a. It references Simulink and Simscape Electrical Specialized Power Systems blocks, including three-phase fault and powergui blocks. Successful execution in a clean licensed environment has not yet been verified.

1. Open MATLAB in this repository's `simulation` directory.
2. Review `generate_dataset.m`. Set `Ncases` to `2` for an initial environment check; the default is **2,000**, despite the original `Gen_20.m` filename.
3. Run `generate_dataset`.
4. Inspect the MAT files in `data/raw/IEEE14_R1_<timestamp>/` under the repository root.

The script clears the workspace, closes open Simulink models, changes directory, and modifies model parameters in memory. Save other work first. These behaviors are retained from the original. The script does not save modified parameters back to the SLX file.

## Repository adaptations

- Resolve the model location relative to the script instead of a personal Windows path.
- Save outputs under ignored `data/raw/` with descriptive timestamped names.
- Refuse to reuse an existing timestamped output directory.

Simulation settings, seed, class configurations, normalization, and default case count are retained. Original hashes are recorded in [the source manifest](../docs/source-manifest.json). Autosave files and generated Simulink caches are excluded.

See [the dataset contract](../docs/data.md) for channel definitions and physical parameters.

## Attribution

The model metadata retains `Bharath` as creator and `Shakkya Gamage` as last modifier. Metadata alone does not identify the original distribution or license; upstream attribution remains to be established.
