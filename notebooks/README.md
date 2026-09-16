# Running Model 04

`model_04.ipynb` was downloaded from the [author-provided Colab notebook](https://colab.research.google.com/drive/1PDTpz4ldBI_ZPMiWIZBGzQL8Q1W2mTEB) on 2026-09-16. Its six code cells are unchanged. An introduction was added, execution metadata and outputs were cleared, and saved text outputs were archived under `results/`.

## Colab setup

1. Open `model_04.ipynb` in Google Colab. The code uses `google.colab.drive`; it is currently Colab-specific.
2. Place the training archive in your Google Drive. Cell 01 defaults to `/content/drive/MyDrive/FYP_Dataset/Training_2000_14_Bus.zip`; change `DRIVE_ZIP_PATH` if needed.
3. Start a fresh runtime and run Cell 01 to mount Drive and extract the archive. The recorded run printed TensorFlow **2.19.0**. Other exact dependency versions were not captured, so this is not a locked environment.
4. Run Cell 02 to load, validate, split and normalize the data. It expects 2,000 recordings and 1,201 x 6 source arrays. Review [the data contract](../docs/data.md) before changing these settings.
5. Run Cell 03 to train and save the best checkpoint and matching preprocessing. It defaults to 30 epochs, batch size 128. The subsequent overlap diagnostic is supplementary; rounded subsampling does not prove scenario independence.
6. Run Cell 04 once for the internal held-out evaluation after model selection.
7. Configure `VALIDATION_SOURCE` in Cell 05 to the intended external ZIP, folder, or MAT file, then run the cell. The imported default is `Validation(Indika).zip`, not Laxapana.

Dependencies imported by the notebook include TensorFlow/Keras, NumPy, pandas, SciPy, scikit-learn and Matplotlib, plus the Colab Drive integration. A tested dependency lockfile is still pending; installing arbitrary latest versions is not claimed to reproduce the archived run.

## Execution details

- Cell 01 reuses its extraction folder if it already exists. When switching training archives, use a fresh runtime or a new `EXTRACT_PATH` to avoid using stale extracted data.
- `TIMEBASE_POLICY="auto"` uses physical timing if available, otherwise maps each entire recording by relative position. This does not recover an unknown physical sample rate.
- Use `TIMEBASE_POLICY="physical"` when the experiment requires verified timing; provide measured metadata or a known sampling rate/duration for untimed inputs.
- `INVALID_SAMPLE_POLICY="report"` evaluates valid files and reports every rejection. Report coverage and correct/all-attempted alongside accuracy on evaluated records.
- Save `cnn_bilstm_runs/<run>/` and `external_validation_results/` before resetting Colab. These runtime-relative directories are temporary unless copied to persistent storage.
- Keep `.keras`, `preprocessing.npz`, `history.json` and `split_files.json` together. The trained checkpoint is not bundled in this repository.

## Verification status

Notebook JSON and Python syntax have been checked, and all original code cells match the download exactly. No new training run or inference result is claimed. Saved historical outputs are documented separately in [results](../docs/results.md).
