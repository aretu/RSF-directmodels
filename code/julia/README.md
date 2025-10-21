# RSF-directmodels (Julia Refactoring)

This repository contains a Julia refactoring of the Rate-and-State Friction (RSF) direct models originally developed by Rudnicki (2023) in Mathcad. The core functionality focuses on simulating multi-stage fault behavior, specifically the coupled effects of fluid injection and frictional slip, using Ordinary Differential Equations (ODEs).

## Project Structure

The project is divided into four main Julia scripts and relies on external data:

| File Name | Role | Description |
| :--- | :--- | :--- |
| `myfunctions_reltime.jl` | **Core Library** | Contains all mathematical model functions, ODE system definitions, and the core utility function for importing and normalizing parameters (`import_and_process_model_data`). |
| `JRmodel_reltime.jl` | **Main Runner** | Orchestrates the three-stage ODE simulation (ZLP, Creep, Injection) for a single model run. Handles path setup, logging, solving, and saving output data (`.csv`) and plots (`.png`). |
| `JRmodel_reltime sensitivity.jl` | **Sensitivity Driver** | Automates the **Global Sensitivity Analysis (GSA)** by looping through a grid of specified parameters (e.g., `alpha`, `beta`, `difftime`) and running a unique simulation for each combination. |
| `JRmodel_reltime sensitivity plots.jl` | **Data Aggregator** | Processes the output from the GSA runs. Extracts parameters from filenames using regex and calculates a key metric (e.g., final slip rate $V$) for aggregation into a single summary CSV file. |
| `output.log` | Log File | Persistent record of all model runs, warnings, errors, and solution steps. |

## Core Modeling Framework

The simulation models fault behavior through the time evolution of a 7-element state vector $u$, solved using stiff ODE solvers (e.g., `Rodas5`) from the `DifferentialEquations.jl` package.

### State Variables

The state vector is $u = [\mathrm{T}, \Theta, V, U, \Phi, P, \text{Prev}]$:

| Variable | Description |
| :--- | :--- |
| $\mathrm{T}$ | Normalized Shear Stress |
| $\Theta$ | State Variable (related to characteristic slip distance $d_c$) |
| $V$ | Normalized Slip Rate |
| $U$ | Normalized Cumulative Slip |
| $\Phi$ | Normalized Pore Pressure State Variable |
| $P$ | Normalized Pore Pressure (Fault) |
| $\text{Prev}$ | Normalized Pore Pressure (Reservoir/Previous Step) |

### Simulation Stages

Each full simulation consists of three sequential stages, defined by specific ODE system functions (e.g., `zlp!`, `creep!`, `creepinjshale!`) and separated by instantaneous stress steps:

1.  **Stage 1: Zero Load Point (ZLP)**
    * **Goal:** Simulates the initial evolution of slip rate and state under constant stress until a steady-state condition is reached.
2.  **Instantaneous Stress Step**
    * Functions like `calculate_VplusZLP`, `calculate_ThetaPlus`, and `calculate_Vplus` are used to update the state vector based on the applied stress change $\Delta\sigma$ before moving to the next stage.
3.  **Stage 2: Creep**
    * **Goal:** Simulates continued constant-stress evolution.
4.  **Stage 3: Fluid Injection**
    * **Goal:** Simulates the effect of fluid injection over $M$ discrete time steps. The ODE solver runs for a duration $\Delta t$, and then the initial conditions are updated by a discrete pressure step before the next iteration, simulating progressive injection.

## Running the Code

### 1. Single Model Execution

To run a predefined model (or a list of models) using parameters from `inputparameters.xlsx`:

1.  Ensure `inputparameters.xlsx` is accessible.
2.  Open and run `JRmodel_reltime.jl`.
3.  Modify the model lists (e.g., `brava_gouge`, `shiva_barerock`) within this script to select which models to execute.

### 2. Sensitivity Analysis

To perform a sensitivity study on specific parameters:

1.  Open and run `JRmodel_reltime sensitivity.jl`.
2.  Define the parameter ranges (`alpha_list`, `epsilon_list`, `beta_list`, `difftime_list`) within the script. The script generates a unique simulation for every combination.

### 3. Aggregating Results

After running the sensitivity driver, aggregate the results for analysis:

1.  Ensure the `analysis_name` in `JRmodel_reltime sensitivity plots.jl` matches the folder created by the sensitivity run.
2.  Open and run `JRmodel_reltime sensitivity plots.jl`.
3.  This generates a final summary CSV file used for plotting and analysis.