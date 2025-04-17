# Deep Learning Model for Actin Aster Prediction

This directory contains the physics-informed convolutional neural network (CNN) model used to predict local actin aster formation from initial filament orientation fields.

## Overview

Our model performs binary classification on 64×64 grayscale orientation-field images to predict the presence (1) or absence (0) of an actin aster at the image center.

- **Feature extraction:** Three convolutional blocks (32→64→128 filters, 3×3 kernel, ReLU activations) each followed by 2×2 max pooling
- **Self-attention module:** SAGAN-style self-attention layer recalibrates feature maps before flattening
- **Classification head:** Dense layer (512 units, ReLU) + Dropout(0.5) → Sigmoid output neuron
- **Implementation:** TensorFlow 2.15.1 in Python 3.10.9 + Jupyter Notebook

## Requirements

- **Python** ≥ 3.10.9
- **TensorFlow** == 2.15.1
- **NumPy**, **SciPy**, **Pandas**, **Matplotlib**
- **Jupyter Notebook**

Install Python dependencies:
```bash
pip install -r requirements.txt
```

Contents of `requirements.txt`:
```
tensorflow==2.15.1
numpy
scipy
pandas
matplotlib
```

## Data Preparation

1. **Orientation field extraction:**
   - Source images: actin fluorescence (1210×1650 px)
   - Plugin: Fiji/ImageJ OrientationJ → angle θ∊[0, π]
   - Rescale: θ×(255/π) → 8-bit grayscale (0–255)
2. **Sliding window:** 64×64 px crop, 4 px stride →
   - Training: 118,524 samples from n=5 experiments
   - Validation: 39,281 samples from same experiments
   - Test: separate n=5 experiments

## Architecture Details

```python
# Pseudocode
model = Sequential()
# Feature extraction
model.add(Conv2D(32, (3,3), activation='relu', input_shape=(64,64,1)))
model.add(MaxPooling2D((2,2)))
model.add(Conv2D(64, (3,3), activation='relu'))
model.add(MaxPooling2D((2,2)))
model.add(Conv2D(128, (3,3), activation='relu'))
model.add(MaxPooling2D((2,2)))
# Self-attention block (SAGAN discriminator style)
model.add(SelfAttention())
# Classification head
model.add(Flatten())
model.add(Dense(512, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(1, activation='sigmoid'))
```

> **Diagram:** Include a block diagram here (e.g., in `architecture.png`)

## Training and Evaluation

- **Optimizer:** Adam (learning rate = 1e-4)
- **Loss:** Binary cross-entropy
- **Data pipeline:** Keras `ImageDataGenerator(rescale=1/255)`
- **Epochs:** 100
- **Batch size:** 64 (≈248 batches/epoch)
- **Validation steps:** 80/epoch

**Hardware:** Intel Xeon Gold 6226 CPU @ 2.70 GHz

## Usage

Launch the Jupyter notebook for interactive analysis:
```bash
jupyter notebook cnn_aster_prediction.ipynb
```

Scripts:
- `train_cnn.py`: training script with command-line arguments
- `evaluate_cnn.py`: computes accuracy, precision, recall on test set

## File Structure

```
├── data/                   # orientation-field images and sliding-window outputs
│   ├── processed/          # training, validation, test folders
├── notebooks/              # Jupyter notebooks
│   └── cnn_aster_prediction.ipynb
├── scripts/                # Python scripts
│   ├── train_cnn.py
│   └── evaluate_cnn.py
├── requirements.txt
├── architecture.png        # network block diagram (add manually)
└── README_DL.md            # this file
```

## Reference
[1] Moriel, N., Ricci, M. and Nitzan, M., 2023. Let's do the time-warp-attend: Learning topological invariants of dynamical systems. arXiv preprint arXiv:2312.09234.
[2] Zhang, H., Goodfellow, I., Metaxas, D. and Odena, A., 2019, May. Self-attention generative adversarial networks. In International conference on machine learning (pp. 7354-7363). PMLR.
