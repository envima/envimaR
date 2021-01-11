<img src="https://avatars0.githubusercontent.com/u/44788932?s=200&v=4" align="right" title="Logo">
Environmental Informatics Lab @ Marburg University

# envimaR
Helpers to set up and manage analysis environments and enable reproducible research.

# Use case for setting up a project

To set up an RStudio project, folder structures for data analysis and initialize a [Git](https://git-scm.com/) and [dvc](https://dvc.org/) repository, you can use the template "envimar". Other templates for initialization without dvc (envimar_no_dvc) and no Git/dvc (envimar_no_git_dvc) are also available. For other options, define the input manualy or create another template using [pckgDefaults.R](https://github.com/envima/envimaR/blob/master/R/pckgDefaults.R).

```R
# Install envimaR
devtools::install_github("envima/envimaR")


library(envimaR)
root_folder <- tempdir()
initEnvimaR(root_folder = root_folder, standard_setup = "envimar")

```

# Use 000_settings.R for mastering the project environment

Once a project environment is initialized, two scripts are created:

* The `src/main.R` script is the basis of the project. It loads the project settings in the beginning. Use this script to control the programme flow. Use sub-control scripts and functions for your tasks to keep the control script clean and understandable and put all functions inside the `src/functions` folder (you can use subfolders, if you like).
* The `src/functions/000_setup.R` script defines the environment. It is source at the beginning of the main.R script and provides two variables: `envrmt` and `meta`. `envrmt` is a list of all folders available in the project. The folders can be accessed by their baselevel name, e.g. `/src/functions` is accessible by `envrmt$functions`. `meta` is a list which can be used to collect the metadata of the project. If you want to save it, use `yaml::write_yaml(meta, filepath)`. It is a good idea to save some metadata along with each critical output file (e.g. `my_output.rd`s and `my_output.yaml`). If you want, you can use the functions `enviSave()` and `enviLoad()` for this.

This is what the 000_setup.R script looks like:

```R
#' ...
require(envimaR)

# Define libraries (by adding libraries to the libs vector)
libs <- c()

# Load libraries and create environment object to be used in other scripts for path navigation
project_folders <- list.dirs(path = root_folder, full.names = FALSE, recursive = TRUE)
project_folders <- project_folders[!grepl("\\..", project_folders)]
envrmt <- createEnvi(
  root_folder = root_folder, fcts_folder = file.path(root_folder, "src/functions/"),  folders = project_folders,
  libs = libs, create_folders = FALSE)
meta <- createMeta(root_folder)

# Define more variables

# Load more data

```

