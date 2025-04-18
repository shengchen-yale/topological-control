# Active Solid Fracture Simulation

This directory provides the COMSOL Multiphysics model and supporting files for simulating fracture in a 2D active nematic solid (F-actin–myosin network) as described in Section III of our manuscript.

## Model Description

We model the frangible active solid as a biphasic mixture of a 2D porous actomyosin network (solid fraction \(\phi(r,t)\)) immersed in fluid. Small network deformations are described by the linearized strain tensor:

\[\epsilon(r,t) = \tfrac12 \bigl(\nabla u + (\nabla u)^T\bigr),\]

where \(u(r,t)\) is the displacement field. Since fluid permeation in the z‑direction is free, the network velocity \(v(r,t)=\partial_t u\) governs in‑plane compressible dynamics (\(\nabla\cdot v \neq 0\)). Nematic microstructure is captured by a traceless tensor \(Q\), defined experimentally via

\[Q(r,t) = \langle nn - \tfrac12 I\rangle,\]

with \(n\) the local filament orientation and the average taken over a 4.1 µm square domain.

This framework couples: (1) oriented active stresses from myosin motors; (2) network elasticity and porosity evolution; and (3) fracture via loss of solid connectivity.

## Governing Equations

1. **Nematic order (\(Q\))**:
   \[\partial_t Q + \nabla\cdot(vQ) = \tfrac1\Gamma \bigl(L_1\nabla^2Q + A\phi\,Q + C(Q:Q)Q\bigr)\]
   - \(L_1\): Frank elastic constant
   - \(\Gamma\): rotational viscosity
   - \(A,C>0\): concentration‑dependent ordering coefficients

2. **Viscoelastic stress (\(\sigma^p\))** (Kelvin–Voigt):
   \[\sigma^p = 2\,G(\phi,\epsilon)\,\epsilon + \lambda\,\mathrm{tr}(\epsilon)\,I + 2\,\eta\,\dot\epsilon\]
   - \(G(\phi,\epsilon)\): shear modulus (see below)
   - \(\lambda\): Lamé coefficient, \(\lambda = \tfrac{2G\nu}{(1+\nu)^2(1-2\nu)}\), with \(\nu=0.3\)
   - \(\eta\): shear viscosity

3. **Active stress (\(\sigma^a\))**:
   \[\sigma^a = \alpha\phi\,(Q + \tfrac12 I)\]
   - \(\alpha>0\): contractile activity coefficient

4. **Force balance (overdamped)**:
   \[\nabla\cdot(\sigma^p + \sigma^a) = \gamma\,v,\]
   - \(\gamma\): substrate friction

5. **Solid fraction evolution (\(\phi\))** with fracture:
   \[\partial_t\phi + \nabla\cdot(v\phi) = D_t\nabla^2\phi - k\,\phi\,\Theta\bigl(|\mathrm{tr}(\epsilon)| - \epsilon^*\bigr)\]
   - \(D_t\): small diffusion for numerical stability
   - \(k\): breakage rate
   - \(\epsilon^* = (\epsilon_0 + \epsilon_1)/2\): critical areal strain threshold
   - \(\Theta(x) = \max(x,0)\)

### Nonlinear Shear Modulus

Shear modulus \(G\) depends on local \(\phi\) and areal strain \(\epsilon_{vol}=\mathrm{tr}(\epsilon)\):

\[G_\text{conc} = \begin{cases}
G_0 & \phi \le \phi_0, \\
G_0 + (G_1 - G_0)\,\text{step}(\tfrac{\phi - \phi_0}{\phi_1 - \phi_0}) & \phi_0 < \phi < \phi_1, \\
G_1 & \phi \ge \phi_1,
\end{cases}\]

\[G_\text{strain} = \begin{cases}
G_1 & \epsilon_{vol} \le \epsilon_0, \\
G_1 + (G_0 - G_1)\,\text{step}(\tfrac{\epsilon_{vol} - \epsilon_0}{\epsilon_1 - \epsilon_0}) & \epsilon_0 < \epsilon_{vol} < \epsilon_1, \\
G_0 & \epsilon_{vol} \ge \epsilon_1,
\end{cases}\]

where:
- \(\phi_0=0.65, \phi_1=0.95\)
- \(\epsilon_0=1.05, \epsilon_1=1.35\)
- \(G_0=100\,\mathrm{Pa}, G_1=2000\,\mathrm{Pa}\)
- Final \(G = \min(G_\text{conc}, G_\text{strain})\).

## Material Properties & Parameters

| Parameter | Symbol      | Value/Range                   |
|-----------|-------------|-------------------------------|
| Frank constant      | \(L_1\)        | see manuscript               |
| Rotational viscosity| \(\Gamma\)    | see manuscript               |
| Ordering coeff.     | \(A,C\)        | see manuscript               |
| Viscosity           | \(\eta\)      | see manuscript               |
| Activity            | \(\alpha\)    | see manuscript               |
| Friction            | \(\gamma\)    | see manuscript               |
| Diffusion           | \(D_t\)        | small (e.g. 1e-6)            |
| Breakage rate       | \(k\)          | see manuscript               |
| Critical strain     | \(\epsilon^*\)| (\(\epsilon_0+\epsilon_1)/2\) |

## Boundary Conditions

- **No‑flux on \(Q,\phi\)**: \(n_b\cdot\nabla Q =0, \; n_b\cdot\nabla\phi=0\)
- **Symmetry (zero normal stress)** on viscoelastic domain boundaries: \(n_b\cdot\sigma=0\)

## Initial Conditions

- **\(Q(r,0)\)**: interpolated from experimental data via Eq. (1).
- **\(\phi(r,0)\)**: normalized F-actin fluorescence intensity, scaled 0–1.

## Simulation Setup

1. **Geometry & Mesh**
   - Define 2D domain matching experimental FOV.
   - Use physics-controlled mesh with refinement near expected fracture zones.
2. **Physics Interfaces**
   - Add **General Form PDE** interfaces for each independent component of \(Q\) and \(\phi\).
   - Add **Viscoelasticity** (Generalized Maxwell) interface for displacement \(u\).
3. **Parameters**
   - Input all constants (\(L_1, \Gamma, A, C, \eta, \alpha, \gamma, D_t, k\)).
   - Set strain thresholds and modulus definitions via piecewise functions.
4. **Studies**
   - Time‐dependent solver from \(t=0\) to desired \(t_{sim}\).
   - Map simulation time to experimental time: \(t_{exp}=(t_{sim}-t_{0})/k_{se}\), with \(k_{se}=\Gamma/(\alpha U)\), \(U=3C/(3A+C)\). t_{0} is the time in simulation for the passive nematic structure to stabilize, after which, active stress is applied. 
5. **Solver Settings**
   - Use fully coupled BDF; set tolerances for nonlinear convergence.

## Running the Model

Run COMSOL in batch mode:
```bash
comsol batch \
  -inputfile comsol/active_solid_fracture_model_example.mph \
  -outputfile results/active_solid_results.mph \
  -study "std1"
```
To vary \(k_{se}\), add `-param k_se=value`.

## Post‑Processing & Output

- Export fields via **Export → Data Sets → Solution** as TXT.
- Visualize strain, \(Q\) eigenvalues, and \(\phi\) maps within COMSOL or ParaView.


