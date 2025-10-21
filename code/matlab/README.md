# Complete Code Documentation: Rate-and-State Creep and Injection Models (MATLAB)

This codebase simulates fault friction experiments using the Rate-and-State Friction (RSF) framework, focusing on creep, zero load point (ZLP), and fluid/stress stepping (injection) phases. All core simulations primarily use **dimensionless (normalized) units** and rely on MATLAB's ODE solvers, primarily `ode45`.

***

## I. Simulation Workflow and Orchestration

The simulation process is driven by configuration files, executed by a script, and orchestrated by a high-level function.

### 1. Execution Scripts (`model_script.m`, `runmodel.m`)

| File | Type | Description |
| :--- | :--- | :--- |
| **`model_script.m`** | Script | The **master execution script** that runs a batch of simulations. It reads model names from **`model.list`**, selects a predefined group (e.g., `"all shiva BG bare-rock models"`), and iterates through them, calling `runmodel` for each one. |
| **`runmodel.m`** | Function | Manages a single simulation run. It loads parameters, sets the ODE solver options (`RelTol=1e-9`, `AbsTol=1e-12`), executes the main calculation (`AllCreep`), calls plotting functions, and saves the final output as a MATLAB `.mat` file if the `savemod` flag is `'True'`. |
| **`AllCreep.m`** | Function | The main orchestration function. It calculates the entire experiment by chaining the two main phases: **Initial Creep** (`SCreep`) followed by **Stepping** (Injection or Stress Change). |

**`AllCreep.m` Logic Flow:**
1.  **Initial Phase:** Calls `SCreep(parameters)` to run the steady-state and creep phases.
2.  **Pore Fluid Stepping:** If `parameters.DPInj > 0` and `parameters.DtauInj == 0`: calls either **`CreepManyJumps`** (simple model) or **`CreepManyJumpsComplex`** (coupled flow model). The simple model uses **`pressure.m`** to populate the pressure output columns.
3.  **Shear Stress Stepping:** Otherwise (if $\Delta \tau > 0$), calls **`CreepManyJumpsTauCRP`** or **`CreepManyJumpsTauZLP`**.
4.  **Output:** Concatenates `Initial` and `Jumps` results.

***

## II. Core Simulation Phase Functions

These functions integrate the ODE system for specific experimental phases using `ode45`.

| File | Function | Phase Modeled | Key Logic / Integration Strategy |
| :--- | :--- | :--- | :--- |
| **`SCreep.m`** | `output = SCreep(...)` | **Steady-State (SS) and Creep:** Models the initial state. | 1. If `parameters.zlp == 'True'`, calls **`ScuderiSSZLP`**. 2. Calculates the instantaneous **velocity jump** after ZLP using **`vafter2`**. 3. Integrates the Creep phase (constant shear stress) using `ode45`. |
| **`ScuderiSSZLP.m`**| `output = ScuderiSSZLP(...)` | **Zero Load Point (ZLP):** Models the transient response after a stress jump where shear stress ($\tau$) evolves with stiffness ($k$). | Establishes SS initial conditions, then integrates the ZLP ODE (defined by `define_function`) over the duration `parameters.deltZLP`. |
| **`CreepManyJumps.m`** | `output = CreepManyJumps(...)` | **Simple Pore Fluid Stepping:** Models multiple $\Delta p$ steps using the simple RSF formulation. | At each step, it calculates the **instantaneous jump** in state ($\theta$) and velocity ($v$) using **`statenew`** and **`velnew`** before calling `ode45`. |
| **`CreepManyJumpsComplex.m`**| `output = CreepManyJumpsComplex(...)` | **Complex/Coupled Pore Fluid Stepping:** Uses the full RSF-coupled-to-flow ODE system. | The ICs for `ode45` include pressure ($p$) and a cumulative pressure history term ($d_{prev}$), which are tracked by the complex ODE. |
| **`CreepManyJumpsTauCRP.m`**| `output = CreepManyJumpsTauCRP(...)` | **Shear Stress Stepping (CRP Steptype):** Models multiple $\Delta \tau$ steps. | Uses **`vafter2`** to calculate the **instantaneous velocity jump** due to the stress step at the start of each step. $\tau$ is explicitly updated in the ICs before each integration. |
| **`CreepManyJumpsTauZLP.m`**| `output = CreepManyJumpsTauZLP(...)` | **Shear Stress Stepping (ZLP Steptype):** Same as above, but uses the ZLP-specific ODE from `define_function`. | The Initial Condition (IC) order is mapped to the ZLP ODE: $\text{[} \tau, v, \theta, u, \phi \text{]}$. |

***

## III. Rate-and-State Core Functions and Helpers

These functions define the core physics and instantaneous jump calculations.

| File | Function | Description | Equation / Logic |
| :--- | :--- | :--- | :--- |
| **`define_function.m`**| `odefun = define_function(...)` | **Defines the vector field** for the ODE solver using symbolic math. | Implements the coupled differential equations for the state variables based on `modtype` (`simple`/`complex`) and `steptype` (`zlp`/`creep`, etc.). |
| **`mu.m`** | `output = mu(v,theta,parameters)` | Calculates the instantaneous **coefficient of friction** ($\mu$). | $\mu = \mu_0 + a \ln(v) + b \ln(\theta)$ (normalized units). |
| **`statenew.m`** | `output = statenew(...)` | Calculates the **instantaneous state variable jump** ($\Delta \theta$) due to a sudden change in effective normal stress ($\Delta \sigma$). | $\theta_{new} = \theta_{old} (\sigma_{old} / \sigma_{new})^{\alpha/b}$. |
| **`vafter2.m`** | `output = vafter2(...)` | Calculates the **instantaneous velocity jump** ($v_{after}$) due to a change in shear stress ($\Delta \tau$). | $v_{after} = v_{before} \exp((\tau_{after}-\tau_{before})/a)$. |
| **`velnew.m`** | `output = velnew(...)` | Calculates the **instantaneous velocity jump** ($v_{new}$) due to a change in effective normal stress ($\Delta \sigma$). | Derived from the condition $\Delta \mu = 0$ over the instant, with terms for $\alpha$ (direct effect) and $\mu$. |
| **`pressure.m`** | `output = pressure(t,parameters)` | Calculates the expected **normalized pressure** (Pf reservoir/fault) as a function of time ($t$), based on a piecewise step function defined by the injection parameters. |

***

## IV. Parameter Management and Unit Conversion

| File | Function | Description |
| :--- | :--- | :--- |
| **`get_parameters.m`** | `parameters=get_parameters(expname)` | Reads dimensional parameters for an experiment from **`inputparameters.xlsx`** and calculates all required **normalized (dimensionless) parameters** ($k, \Delta t, \hat{\beta}, \hat{c}$, etc.). |
| **`dim2adim.m`** | `output=dim2adim(input,parameters)` | Converts dimensional (real-unit) data into **normalized (dimensionless) units** for use in the model. |
| **`dimplotter.m`** | `output=dimplotter(input,parameters)` | Converts normalized model output back into **dimensional (real) units** and plots the result in a standard **Figure 2** (8-subplot figure in real units). |

***

## V. Analysis, Plotting, and Benchmarking

### 1. Plotting and Comparison Utilities

| File | Function | Description |
| :--- | :--- | :--- |
| **`plotter.m`** | `output=plotter(input,parameters)` | The **base plotting function** that creates **Figure 1** (a standard 8-subplot figure) using the raw **normalized (dimensionless) model output**. |
| **`comparison_plotter.m`** | `output=comparison_plotter(...)` | Generates specialized comparison plots (e.g., "R23" figures). **Figure 3** is the main comparison plot: dual y-axis of $\ln(v/v_R)$ vs. Time and $\Delta p / \sigma_{0}$ vs. Time. |
| **`dataoverlayer.m`** | `dataoverlayer(...)` | Imports experimental data, applies **smoothing** (window 201 for $\text{vel}$, 101 for $\text{P}$), converts it to normalized units, and **overlays** it onto the model comparison plot (Figure 3). |
| **`plot_script.m`** | Script | A standalone script for quick loading and plotting of a **single** model run (MATLAB and Julia), calling both `comparison_plotter` and `dimplotter`. |

### 2. Benchmarking and Data Import

| File | Function/Script | Description |
| :--- | :--- | :--- |
| **`comparison_script.m`**| Script | The main analysis script for comparing multiple models based on a list or **`query_table_dynamically`**. It plots them on **Figure 3** and can optionally include experimental data via `dataoverlayer`. |
| **`benchmark_script.m`** | Script | Compares the current model against external **benchmark data** ("JR23" models) defined in **`benchmark.list`**. It plots up to four data sets (JR benchmark, MATLAB model, two Julia model formats) and sets $\mathbf{log}$ **y-scales** for Sliprate and Slip subplots. |
| **`query_table_dynamically.m`**| `comparison_list = query_table_dynamically(...)` | Utility function to filter the main parameter spreadsheet (`inputparameters.xlsx`) using multiple, dynamic, column-value conditions. |
| **`JRcarb2mat.m`** | Function | Imports tab-delimited data from **Carbonate** benchmark files and maps it to the standard 8-column model output format, padding unused columns with zeros. |
| **`JRshale2mat.m`** | Function | Imports tab-delimited data from **Shale** benchmark files and maps its 8 available columns directly to the standard 8-column model output format. |

### 3. Configuration Files

| File | Format | Purpose | Key Fields |
| :--- | :--- | :--- | :--- |
| **`model.list`** | CSV | Lists models and groups them for **execution** by `model_script.m`. | `model`, `group` |
| **`comparison.list`** | CSV | Lists models and groups them for **comparison and plotting** by `comparison_script.m`. | `model`, `group`, `comment` |
| **`benchmark.list`** | CSV | Maps JR benchmark model names to local files and controls which comparisons are **executed**. | `JR_model`, `our_model`, `compare` |