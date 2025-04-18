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


### Self-Attention Layer Implementation

Below is the Keras implementation of the `SelfAttention` layer used after the convolutional blocks. It implements the SAGAN-style self-attention mechanism to recalibrate feature maps by computing query, key, and value projections and applying learned attention weights.

```python
import tensorflow as tf

class SelfAttention(tf.keras.layers.Layer):
    def __init__(self):
        super(SelfAttention, self).__init__()

    def build(self, input_shape):
        # Number of input channels
        self.channels = input_shape[-1]
        # 1×1 convolutions for query, key, and value
        self.query_conv = tf.keras.layers.Conv2D(filters=self.channels // 8,
                                                 kernel_size=1,
                                                 name='query_conv')
        self.key_conv = tf.keras.layers.Conv2D(filters=self.channels // 8,
                                               kernel_size=1,
                                               name='key_conv')
        self.value_conv = tf.keras.layers.Conv2D(filters=self.channels,
                                                 kernel_size=1,
                                                 name='value_conv')
        # Learnable scalar to balance attention output
        self.gamma = self.add_weight(name='gamma',
                                     shape=[1],
                                     initializer='zeros',
                                     trainable=True)

    def call(self, inputs):
        # Shape: (batch_size, height, width, channels)
        batch_size, height, width, channels = tf.shape(inputs)[0], tf.shape(inputs)[1], tf.shape(inputs)[2], tf.shape(inputs)[3]

        # Project inputs to query, key, and value tensors
        query = self.query_conv(inputs)   # (B, H, W, C/8)
        key = self.key_conv(inputs)       # (B, H, W, C/8)
        value = self.value_conv(inputs)   # (B, H, W, C)

        # Reshape for matrix multiplication
        query = tf.reshape(query, [batch_size, -1, height * width])  # (B, C/8, H*W)
        key = tf.reshape(key, [batch_size, -1, height * width])      # (B, C/8, H*W)

        # Attention score: Q×Kᵀ -> (B, H*W, H*W)
        attention = tf.matmul(query, key, transpose_b=True)
        attention = tf.nn.softmax(attention, axis=-1)

        # Reshape attention map back to spatial layout
        attention = tf.reshape(attention, [batch_size, height * width, height, width])
        attention = tf.transpose(attention, perm=[0, 2, 3, 1])        # (B, H, W, H*W)
        attention = tf.expand_dims(attention, axis=-1)

        # Weighted sum of values
        attended_value = value * attention                           # broadcasting
        attended_value = tf.reduce_sum(attended_value, axis=[2, 3])  # (B, H, W, C)
        attended_value = tf.reshape(attended_value, [batch_size, height, width, channels])

        # Combine with original inputs
        outputs = self.gamma * attended_value + inputs
        return outputs
```

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
jupyter notebook binary_class_v1.ipynb
```

Scripts:
- `binary_class_v1.ipnb`: training script with the basic covolutional neural network
- `binary_class_v2.ipnb`: training script with the addition of self-attention mechanism

## File Structure

```
├── training_validation_test_example/    # example of training, validation, test input images
│   ├── train/          # training folder, with two subfolder contain two groups: aster or noaster
│   ├── validation/     # validaiton folder, with two subfolder contain two groups: aster or noaster
│   ├── test/           # test folder   
├── Jupyter/              # Jupyter notebooks
│   └── binary_class_v1.ipynb
│   └── binary_class_v2.ipynb
├── pre_analysis/                # Matlab scripts of using sliding window to generate input images from the experimental data
│   ├── input_file_gen.m
├── example/                # example images of the experimental data
├── defect_example/         # example images of the topological defect in experiment
└── README_DL.md            # this file
```

## Reference
[1] Moriel, N., Ricci, M. and Nitzan, M., 2023. Let's do the time-warp-attend: Learning topological invariants of dynamical systems. arXiv preprint arXiv:2312.09234.

[2] Zhang, H., Goodfellow, I., Metaxas, D. and Odena, A., 2019, May. Self-attention generative adversarial networks. In International conference on machine learning (pp. 7354-7363). PMLR.
