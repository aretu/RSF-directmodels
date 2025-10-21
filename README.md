# Unified Documentation: Multi-Platform Rate-and-State Friction (RSF) Direct Modeling

This project implements and analyzes the **Rate-and-State Friction (RSF) direct models** for coupled **fluid injection** and **frictional slip** on a fault. The modeling effort has evolved from the original **Mathcad implementation by John Rudnicki (2023)** through two independent codebases developed by the user:
1.  An initial **MATLAB Codebase**.
2.  A modern **Julia (RSF-directmodels) + Python/Jupyter Notebook** environment.

Both the MATLAB and Julia/Python codebases are **independent implementations** of the same core physics, validated to produce **equivalent results** in benchmark tests.

---

## I. Core Modeling Framework and Physics

The foundation of the project is the solution of a system of stiff **Ordinary Differential Equations (ODEs)** that describe the evolution of a state vector $\mathbf{u}$ in **normalized (dimensionless) units**.

### A. State Vector and Variables

The fault behavior is tracked using a **7-element state vector** (explicit in the Julia implementation):

$$\mathbf{u} = [\mathrm{T}, \Theta, V, U, \Phi, P, \text{Prev}]$$

| Variable | Description |
| :--- | :--- |
| **$\mathrm{T}$** | Normalized Shear Stress |
| **$\Theta$** | State Variable (related to $d_c$) |
| **$V$** | Normalized Slip Rate |
| **$U$** | Normalized Cumulative Slip |
| **$P$** | Normalized Fault Pore Pressure |
| **$\text{Prev}$** | Normalized Reservoir/Previous Pore Pressure |

### B. Multi-Stage Simulation Sequence

All simulations follow the same three-stage sequence:
1.  **Zero Load Point (ZLP):** Initial ODE phase to establish a steady-state friction condition.
2.  **Creep:** Continued constant-stress ODE evolution.
3.  **Fluid Injection/Stepping:** The core simulation phase where ODE integration for duration $\Delta t$ is coupled with **instantaneous updates** (jumps) to initial conditions via discrete pressure steps ($\Delta P$), simulating progressive injection.

---

## II. Julia Refactoring & Python Analysis (Independent Codebase 1)

This codebase focuses on modularity, performance, and Global Sensitivity Analysis (GSA).

### A. Julia Implementation (`RSF-directmodels`)

Uses `DifferentialEquations.jl` (e.g., `Rodas5`) for stiff ODE solving.

| File Name | Role | Purpose |
| :--- | :--- | :--- |
| **`myfunctions_reltime.jl`** | **Core Library** | Defines all ODE systems (e.g., `creepinjshale!`) and the parameter normalization utility. |
| **`JRmodel_reltime.jl`** | **Main Runner** | Orchestrates the three-stage simulation for single models and handles output saving (`.csv`, `.png`). |
| **`JRmodel_reltime sensitivity.jl`** | **Sensitivity Driver (GSA)** | Automates GSA by looping through a multi-dimensional parameter grid, running a unique full simulation for each combination. |
| **`JRmodel_reltime sensitivity plots.jl`** | **Data Aggregator** | Calculates the **key performance metric** (e.g., final slip rate $V$) from GSA runs and aggregates the results into a summary CSV. |

### B. Python Post-Processing (`JRmodel_reltime sensitivity plots.ipynb`)

This notebook is the dedicated GSA visualization tool.

| Library | Function |
| :--- | :--- |
| **`pandas`** / **`numpy`** | Loads the GSA summary CSV and calculates $\log_{10}(V_{final})$. |
| **`plotly.graph_objects`** | Creates and renders advanced **3D scatter plots** for visualizing the parameter space against the aggregated metric. |

---

## III. MATLAB Codebase (Independent Codebase 2)

This codebase uses MATLAB's `ode45` solver and is focused on execution control and comprehensive visualization tools.

| File Name | Role | Precision Detail |
| :--- | :--- | :--- |
| **`model_script.m`** | **Master Execution** | Runs batch simulations defined in **`model.list`** by iterating over model groups. |
| **`AllCreep.m`** | **Orchestration** | Chains the Initial Creep and Stepping phases. |
| **`CreepManyJumpsComplex.m`**| **Injection Core** | Manages the **instantaneous jumps** in state variables necessary for the coupled injection model. |
| **`plotter.m` / `dimplotter.m`** | **Visualization Utility** | Creates standard 8-subplot figures from normalized and dimensional data. Can optionally include experimental data via `dataoverlayer`. |
| **`benchmark_script.m`** | **Benchmarking Tool** | Compares the current model output against external **"JR23" benchmark data** defined in **`benchmark.list`**. Configures $\mathbf{log}$ **y-scales** for Sliprate and Slip subplots. |
| **`JRcarb2mat.m` / `JRshale2mat.m`** | **Data Import** | Utilities to import and map external benchmark data formats (Carbonate/Shale) into the standard 8-column model output format. |

## Installation
Data for benchmarking has to be downloaded from [this zenodo repository](https://zenodo.org/records/7793232) and placed into the /benchmark folder. Generates plots saved as .fig, .png and .svg into the /benchmark/plots folder.