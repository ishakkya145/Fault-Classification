# Model 04 Laxapana

The author selected Model 04 Laxapana and the `Updated_14_Bus` simulation on 2026-09-16. The [original Colab notebook](https://colab.research.google.com/drive/1PDTpz4ldBI_ZPMiWIZBGzQL8Q1W2mTEB) has been imported as [model_04.ipynb](../notebooks/model_04.ipynb). Its newer external evaluation cell differs from the historical [Laxapana PDF](archive/model_04_laxapana.pdf); the architecture and training settings below are present in both.

## Input and preprocessing

- Training archive: `Training_2000_14_Bus.zip`, 2,000 records.
- Source channels: `Va, Vb, Vc, Ia, Ib, Ic`; shape `(1201, 6)` or its transpose.
- Engineered channels: `V0 = (Va + Vb + Vc) / 3` and `I0 = (Ia + Ib + Ic) / 3`.
- Model input: `(1201, 8)`; 6 kHz, 0.2-second window.
- Standardization: per-channel mean and standard deviation fitted on training records only; standard-deviation floor `1e-6`.
- Split: 1,280 training, 320 validation, 400 test records, stratified by parsed simulation ID with seed 42.
- Exact duplicate augmented inputs are rejected. Parsed IDs alone do not prove physical independence across archives.

The loader does not convert raw signals to per-unit; the MATLAB generator performs that conversion.

## Architecture

| Stage | Configuration |
| --- | --- |
| Conv block 1 | 32 filters, kernel 9, same padding, ReLU; batch normalization; max pooling 2; spatial dropout 0.15 |
| Conv block 2 | 48 filters, kernel 7, same padding, ReLU; batch normalization; max pooling 2; spatial dropout 0.20 |
| Conv block 3 | 64 filters, kernel 5, same padding, ReLU; batch normalization; max pooling 2; spatial dropout 0.20 |
| BiLSTM | 48 units per direction, return sequences, dropout 0.20, recurrent dropout 0.15 |
| Pooling | Concatenated global average and maximum pooling |
| Dense | 64 units, ReLU, dropout 0.40 |
| Output | 11 classes, softmax, float32 |

The visible code applies L2 regularization (`1e-4`) to convolution, LSTM input kernels, and dense kernels.

## Training

The export records TensorFlow 2.19.0, seed 42, 30 maximum epochs, batch size 128, and Adam with learning rate `5e-4` and clip norm 1.0. Loss is sparse categorical cross-entropy. Checkpoint selection minimizes validation loss; early-stopping patience is 10. Learning-rate reduction uses factor 0.5, patience 4, and minimum `1e-6`.

Expected run artifacts are `stable_3cnn_bilstm.keras`, `preprocessing.npz`, `history.json`, and `split_files.json`. They were not found with the selected local sources. Preserve the normalization statistics and class mapping with their exact checkpoint.

## Source status

The original notebook's six code cells are preserved exactly, with saved outputs archived separately. See [execution instructions](../notebooks/README.md). A complete tested dependency lockfile and a fresh end-to-end run remain outstanding.

The current external cell supports batching, explicit invalid-record reporting, and physical-time or relative-position conversion. Its default source is `Validation(Indika).zip`. These updates must not be attributed to the older Laxapana score.
