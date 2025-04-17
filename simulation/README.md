# Active Solid Fracture Model Simulation Package

## Overview
This repository contains the simulation package for the **Active Solid Fracture Model**, which studies a biphasic mixture of a 2D porous actomyosin network submerged in a background fluid. The model captures elastic deformations, active stresses, and material fracture dynamics.

---

## Model and Simulation Details

### Active Solid Fracture Model
The model includes:
- **2D porous actomyosin network** (solid fraction: **\(\phi(\mathbf{r}, t)\)**)
- **Linearized strain tensor**:  
  \[
  \epsilon(\mathbf{r}, t) = \frac{1}{2} \left[ \nabla \mathbf{u} + (\nabla \mathbf{u})^\text{T} \right]
  \]
  where \(\mathbf{u}\) is the displacement field.
- **Network velocity**: \(\mathbf{v}(\mathbf{r}, t) = \partial_t \mathbf{u}\)
- **Nematic microstructure** described by the \(Q\)-tensor.

---

#### Key Equations
1. **\(Q\)-Tensor Construction**:  
   \[
   Q(\mathbf{r}, t) = \left\langle \mathbf{n} \mathbf{n} - \frac{I}{2} \right\rangle
   \]  
   where \(\mathbf{n}\) is the local filament orientation vector.

2. **Dynamics of \(Q\)**:  
   \[
   \frac{\partial Q}{\partial t} + \nabla \cdot (\mathbf{v} Q) = \frac{1}{\Gamma} \left( L_1 \nabla^2 Q + A\phi Q + C(Q : Q)Q \right)
   \]

3. **Stress Tensor**:  
   \[
   \sigma = \sigma^p + \sigma^a
   \]
   - **Passive Stress** (\(\sigma^p\)):  
     \[
     \sigma^p = 2G(\phi, \epsilon)\epsilon + \lambda \, \text{tr}(\epsilon)I + 2\eta \dot{\epsilon}
     \]
   - **Active Stress** (\(\sigma^a\)):  
     \[
     \sigma^a = \alpha \phi \left( Q + \frac{I}{2} \right)
     \]

4. **Network Breakage**:  
   \[
   \frac{\partial \phi}{\partial t} + \nabla \cdot (\mathbf{v} \phi) = D_t \nabla^2 \phi - k\phi \, \Theta \left( |\text{tr}(\epsilon)| - \epsilon^* \right)
   \]

---

### Finite Element Simulation
The equations are solved using **COMSOL Multiphysics** with:
- **Modules**: Generalized Maxwell Viscoelasticity + General Form PDE
- **Boundary Conditions**:  
  \[
  \mathbf{n}_b \cdot \nabla Q = 0, \quad \mathbf{n}_b \cdot \nabla \phi = 0
  \]
  (Symmetric BCs for displacements)
- **Initial Conditions**:  
  - \(Q\)-tensor from experimental data
  - \(\phi\) normalized to F-actin fluorescence (\(0 \leq \phi(t=0) \leq 1\))

---

### Parameters
| Parameter | Symbol | Value | Unit |
|-----------|--------|-------|------|
| Base shear modulus | \(G_0\) | 100 | Pa |
| Stiffened shear modulus | \(G_1\) | 2000 | Pa |
| Porosity thresholds | \(\phi_0, \phi_1\) | 0.65, 0.95 | - |
| Strain thresholds | \(\mathcal{E}_0, \mathcal{E}_1\) | 1.05, 1.35 | - |
| Activity coefficient | \(\alpha\) | 1–10 | kPa |
| Breakage rate | \(k\) | User-defined | s⁻¹ |

---

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/active-solid-fracture.git
