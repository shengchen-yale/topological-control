# Active Solid Fracture Model Simulation Package

## Overview
This repository contains the simulation package for the Active Solid Fracture Model, which is designed to study the frangible active solid as a biphasic mixture of a two-dimensional (2D) porous network of actomyosin submerged in a background fluid. This model captures the complex dynamics involving elastic deformations, active stresses, and evolving porosity caused by material breakage.

## Model and Simulation Details

### Active Solid Fracture Model
The model includes:
- **Two-dimensional (2D) porous network of actomyosin (solid fraction: ϕ(r,t))** submerged in a background fluid.
- **Linearized strain tensor** capturing small deformations of the network.
- **Network velocity (v(r,t))** dominates all motion due to fluid being freely exchanged in the z-direction.
- **Nematic microstructure** of the F-actin filament network described by a traceless second-rank tensor \( Q \).
  
#### Key Equations:
1. **Q-tensor Construction**:
    $$
    Q(r,t) = \langle nn - \frac{I}{2} \rangle
    $$
    where \( n \) is the local filament orientation vector and \( I \) is the identity matrix.
    
2. **Dynamics of Q**:
    $$
    \frac{\partial Q}{\partial t} + \nabla \cdot (vQ) = \frac{1}{\Gamma} \left( L_1 \nabla^2 Q + AϕQ + C(Q:Q)Q \right)
    $$
    where \( L_1 \) is the Frank elastic constant, \( \Gamma \) is the rotational viscosity, and \( A, C > 0 \) are energetic coefficients.

3. **Stress Tensor (\( σ \))**:
    $$
    σ = σ^p + σ^a
    $$
    where \( σ^p \) is the passive stress and \( σ^a \) is the active stress.

    **Passive Stress (\( σ^p \))**:
    $$
    σ^p = 2G(ϕ, ε)ε + λ \, \text{tr}(ϵ)I + 2η \dot{ε}
    $$
    **Active Stress (\( σ^a \))**:
    $$
    σ^a = αϕ(Q + \frac{I}{2})
    $$

4. **Network Breakage**:
    $$
    \frac{\partial ϕ}{\partial t} + \nabla \cdot (vϕ) = D_t \nabla^2 ϕ - kϕ \Theta \left( |\text{tr}(ϵ)| - ϵ^* \right)
    $$
    where \( D_t \) is the diffusion constant and \( k \) is the breakage rate.

### Finite Element Simulation
The coupled dynamical equations for \( Q \), \( ϕ \), and \( ϵ \) are solved using COMSOL Multiphysics software with:

- **Generalized Maxwell Viscoelasticity** and **General Form PDE** modules.
- **No-flux boundary conditions**:
    $$
    n_b \cdot \nabla Q = 0 \quad \text{and} \quad n_b \cdot \nabla ϕ = 0
    $$
- **Symmetric boundary conditions** for the viscoelastic material.
- **Initial conditions** from experimental measurements and normalized F-actin fluorescence.

### Parameters and Values
- **Shear modulus parameters**: \( G_0 = 100 \) Pa, \( G_1 = 2000 \) Pa.
- **Threshold values**: \( ϕ_0 = 0.65 \), \( ϕ_1 = 0.95 \), \( ℇ_0 = 1.05 \), \( ℇ_1 = 1.35 \).
- **Other Parameters**: \( L_1 \), \( γ \), \( λ \), \( η \), \( α \), \( k \).
