# Documentation: `JRmodel_reltime sensitivity plots.ipynb`

This Jupyter Notebook is the final step in the Global Sensitivity Analysis (GSA) pipeline, dedicated to loading, processing, and visualizing the aggregated results from the Julia simulation runs.

## 1. Environment and Dependencies

This notebook uses a **Python** environment, requiring the following libraries to function:

| Library | Alias | Purpose |
| :--- | :--- | :--- |
| `pandas` | `pd` | Data reading and manipulation of the GSA output file. |
| `plotly.graph_objects` | `go` | Primary tool for creating advanced 3D scatter plots. |
| `plotly.subplots` | (Imported) | Used to create the multi-panel figure layout. |
| `numpy` | `np` | Used for mathematical operations, primarily calculating $\log_{10}$ of the final metric. |

***
### Installation 
```python
conda env create -f environment.yml
conda activate plotly
cd C:\Users\<user>\.conda\envs\plotly\Scripts
python choreo_get_chrome
```

## 2. Workflow and Data Preparation

The notebook assumes the preceding Julia aggregation script (`JRmodel_reltime sensitivity plots.jl`) has successfully created a single summary CSV file.

### A. Path Configuration

The paths are configured using relative addressing, anchored from the notebook's location:

```python
analysis_name = "gsa-shiva-bg-lf"
root_path = "../.."
folder_path = root_path + "/results/" + analysis_name + "/"

# Data Loading (Reads the summary file created by the Julia script)
results_df = pd.read_csv(folder_path + analysis_name + "_analysis.csv")

# Metric Calculation for Visualization
# The final slip rate (Vfinal) is converted to a log scale for better color representation.
results_df['logVfinal'] = np.log10(results_df['Vfinal'])
```