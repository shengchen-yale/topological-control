# Repository Structure

```
├── 3D_streamline/    # example of training, validation, test input images
│   ├── showPIV_3D_streamline.m       # Visualizes 3D streamlines of the displacement field
│
├── PIV_track/                        # A example of Particle Image Velocimetry (PIV) tracking data
│
├── colormap/              # Matlab scripts of using sliding window to generate input images from the experimental data
│   ├── colorData.mat                 # Custom color data for visualizations
│   ├── othercolor.m                 # Script to modify or generate colormaps
│
├── curl/                
│   ├── showPIV_curl.m               # Calculates and displays the curl of the displacement field
│ 
├── divergence/        # example images of the topological defect in experiment
│   ├── showPIV_deform.m             # Calculates and visualizes the divergence (deformation) field
│
├── README.md                        # This file
```


# Features

3D Streamlines: Reconstruct and visualize the 3D displacement field from experimental data.
Curl Computation: Analyze local rotational motion in the active nematic solid to highlight vortex-like structures.
Divergence Calculation: Quantify local expansion or compression regions in the active material.
Custom Colormaps: Enhance the clarity of visualization with tailored color schemes.

# Getting Started

Requirements
MATLAB R2021a or later (older versions may work but are not tested)
Image Processing Toolbox (for PIV-related analysis)

# Usage
## Clone or download the repository:

git clone https://github.com/shengchen-yale/topological-control.git
cd data_analysis

## Open MATLAB and add the repository to your MATLAB path:

addpath(genpath('path_to/data_analysis'));

## Run the main scripts depending on the type of analysis you want:

For 3D streamlines visualization: showPIV_3D_streamline.m
For curl analysis and visualization: showPIV_curl.m
For divergence analysis and visualization: showPIV_deform.m

## Function
This toolkit supports quantitative analysis of cytoskeletal dynamics and active matter systems. It is especially suited for visualizing and quantifying flows and mechanical deformations in systems exhibiting active contractility.
