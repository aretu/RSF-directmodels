# RSF-directmodels
Aretusini S. refactoring of [Rudnicki, (2023)](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2022JB026313) direct models into a series of Matlab functions. In doing so, I tried to keep the naming of variables and functions from the original author.

## Usage
I will proceed with a very brief description hoping to structure the code folder in a better way later on.

- model_script.m: requires a .xlsx file with parameters to run the model. One sample with all models to benchmark to Rudnicki, (2023) is provided: inputparameters.xls. Please change the extension to .xlsx to make it work. Each model is saved as .mat into the /results folder. To add a new model, add a new line to the .xlsx file and call it from the script.
- plot_script.m: Generates plots without saving them.
- benchmark_script.m: Comparing generated models in /results folder later moved to /benchmark folder with benchmark data. Data for benchmarking has to be downloaded from [this zenodo repository](https://zenodo.org/records/7793232) and placed into the /benchmark folder. Generates plots saved as .fig, .png and .svg into the /benchmark/plots folder. 
- comparison_script.m: Comparing generated models in /results folder. Generates plots saved as .fig, .png and .svg into the /comparisons/plots folder.