# Archived results

Source: [Model 04 Laxapana PDF](archive/model_04_laxapana.pdf), exported 2026-09-13. These are saved notebook outputs, not measurements reproduced from this checkout.

| Evaluation | Records | Accuracy | Additional metric |
| --- | ---: | ---: | --- |
| Internal held-out test | 400 | 100.00% | Balanced accuracy: 100.00% |
| External Laxapana | 165 | 92.12% | Balanced accuracy: 92.12%; macro F1: 0.9225 |

The external output reports 165 loaded recordings, zero auxiliary MAT files, and unchanged resampling for all 165 inputs of length 1,201. The input window is 0.000-0.200 s. The external per-class report is clipped after the first few rows; a full report or confusion matrix has not been reconstructed from that fragment.

## Interpretation and limits

- Internal testing uses a split of the training-domain archive; it does not measure unseen-network performance.
- A separate external archive name does not prove independence of physical simulation scenarios.
- The external cell declares a 6 kHz fallback sample rate; its physical validity needs confirmation from data-generation metadata.
- The 11-class task has no healthy class and does not demonstrate fault-versus-healthy detection.
- ABC/ABCG separability depends on the simulated network and measurement.
- No embedded latency, complete relay operation, or field reliability result is claimed.

## Current Colab snapshot: different external evaluation

The notebook downloaded on 2026-09-16 retains a later training run (`20260914_144935_0939b6`) and evaluates `Validation(Indika).zip`. The [saved text output](../results/colab_2026-09-16_outputs.txt) records:

| Quantity | Value |
| --- | --- |
| Attempted / evaluated / rejected | 154 / 149 / 5 |
| Evaluation coverage | 96.75% |
| Accuracy on evaluated recordings | 51.68% |
| Correct / all attempted | 50.00% |
| Balanced accuracy, classes present | 54.55% |
| Macro F1, classes present | 0.4724 |

All 149 evaluated records used relative-position mapping without verified physical timing. Five ABCG files were rejected because normalized magnitudes exceeded float32 range. Accuracy on 149 valid records does not include the five rejected recordings. The saved internal test output remains 100.00% on 400 records.

The imported notebook does not reproduce the older 92.12% Laxapana result merely by running its current defaults. Both observations are retained with their separate sources and limitations.

## Reproduction artifacts still needed

Exact training and external archives with checksums; matching `.keras` and `preprocessing.npz`; split manifest; history; full per-record predictions; a tested environment and a fresh run. The original executable notebook is now included, but it is not a trained checkpoint.
