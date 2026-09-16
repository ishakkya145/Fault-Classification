# Reproducibility checklist

Use this checklist when selecting and publishing an experiment. Unchecked items are release requirements, not completed capabilities.

## Implementation and environment

- [ ] Identify the canonical training notebook or script and its source revision.
- [ ] Include all preprocessing, label-encoding, model-building, training, and evaluation steps; notebook fragments relying on hidden state are insufficient.
- [ ] Record tested Python, TensorFlow/Keras, MATLAB, Simulink, and required toolbox versions as applicable.
- [ ] Provide a dependency file based on the actual implementation and a verified installation command.
- [ ] Replace machine-specific paths with documented configuration.
- [ ] Verify the full workflow in a clean environment or a freshly restarted notebook runtime.

## Dataset contract

- [ ] Document dataset provenance, access, and reuse permissions.
- [ ] Provide simulation model dependencies and generation instructions where distributable.
- [ ] Define every class and the exact numeric label mapping, including whether a healthy class exists.
- [ ] Specify file format, field names, array orientation, channel order, physical units, and per-unit bases if used.
- [ ] Specify timing metadata, sampling rate, record duration, and fault timing.
- [ ] Document resampling, window selection, engineered channels, and missing/invalid-record handling.
- [ ] Provide a small distributable sample or deterministic smoke-test fixture.
- [ ] Record dataset counts, checksums, scenario identifiers, and train/validation/test membership.

## Training and evaluation

- [ ] Keep related recordings from the same simulation scenario in the same split.
- [ ] Fit normalization and other learned preprocessing on the training split only.
- [ ] Save the preprocessing statistics and label mapping with the matching checkpoint.
- [ ] Record the random seed, hyperparameters, checkpoint selection rule, and hardware.
- [ ] Publish runnable training and evaluation instructions with expected output paths.
- [ ] Report accuracy, macro F1, per-class precision/recall, class support, and a labelled confusion matrix.
- [ ] Separate internal testing from external generalization; document changes in network, operating conditions, and signal processing.
- [ ] Report attempted, evaluated, and rejected recording counts and rejection reasons.
- [ ] Link every reported result to its dataset manifest, configuration, checkpoint, and saved evaluation output.
- [ ] Explain unresolved discrepancies between experiment versions instead of combining incompatible scores.

## Deployment evidence

- [ ] Identify target hardware and the exported model format.
- [ ] Measure model size, memory use, and latency on the actual target.
- [ ] Distinguish offline classification, hardware inference, and a complete protection-relay demonstration.
- [ ] Document the operating assumptions and limitations supported by the tests.

## Publication review

- [ ] Credit project collaborators and identify individual contributions.
- [ ] Select a license with the project owners before adding a license file.
- [ ] Review third-party documents and replace copies with citations where appropriate.
- [ ] Exclude credentials, private data, local paths, and unrelated coursework.
- [ ] Choose an explicit storage and download method for large datasets and checkpoints.
