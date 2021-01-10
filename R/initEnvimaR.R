#' Set up a project environment
#'
#' @description Set up the project environment with a defined folder structure, an RStudio project, initial script and
#' settings templates and git and dvc repository, if necessary.
#'
#' @param root_folder root directory of the project.
#' @param folders list of subfolders within the project directory that will be created.
#' @param folder_names names of the variable values that point to subfolders. If not
#' provided, the base paths of the folders is used.
#' @param path_prefix a prefix for the variable values that point to the created folders.
#' @param init_git logical: init git repository in the project directory.
#' @param code_subfolders subfolders for scripts and functions within the project directory that will be created. The
#' folders src and src/functions are mandatory.
#' @param init_dvc logical: init dvc repository in the project't git repository.
#' @param dvc_subfolders subfolders for data that should be added to dvc.
#' @param dvc_cache dvc cache directory. If NULL, the default will be used (i.e. local cache) within the dvc repository.
#' @param global logical: export path strings as global variables?
#' @param libs  vector with the  names of libraries that are required for the initial project.
#' @param alt_env_id alternative system environment attribute used to
#' check for setting an alternative \code{root_folder}.
#' @param alt_env_value value of the attribute for which the alternative
#' root directory of the project should be set.
#' @param alt_env_root_folder alternative root directory.
#' @param standard_setup use predefined settings. In this case, only the name of the root folder is required. See
#' names(envimaR::lutInfo()) for available standards.
#'
#' @details The function uses [createEnvi] for setting up the folders. Once the project is creaeted, manage the overall
#' configuration of the project by the src/functions/000_settings.R script. It is sourced at the begining of the
#' template scripts that are created by default. Define additional constans, required libraries etc. in the
#' 000_settings.R at any time. If additonal folders are required later, just add them manually. They will be parsed as
#' part of the 000_settings.R and added to a variable called envrmt that allows easy acces to any of the folders. Use
#' this variable to load/save data to avoid any hard coded links in the scripts except the top-level root folder which
#' is defined once in the main control script located at src/control.R.
#'
#' @return envrmt, i.e. a list containing the project settings.
#'
#' @name initEnvimaR
#' @export initEnvimaR
#'
#' @seealso [createEnvi()]
#'
#' @examples
#' \dontrun{
#' root_folder <- tempdir() # Mandatory, variable must be in the R environment.
#' envrmt <- initEnvimaR(root_folder = root_folder, standard_setup = "envimar")
#' }
#'
initEnvimaR <- function(root_folder = ".", folders = NULL, folder_names = NULL, path_prefix = NULL,
                        init_git = TRUE, code_subfolders = c("src", "src/functions"),
                        init_dvc = TRUE, dvc_subfolders = "data", dvc_cache = NULL,
                        global = FALSE, libs = NULL,
                        alt_env_id = NULL, alt_env_value = NULL, alt_env_root_folder = NULL,
                        standard_setup = c("envimar", "envimar_no_dvc", "envimar_no_git_dvc")) {

  # Setup project directory structure
  if (is.null(folders)) {
    use_standard_setup <- TRUE
    envrmt <- createEnvi(root_folder = root_folder, standard_setup = standard_setup[1])
  } else {
    use_standard_setup <- FALSE
    envrmt <- createEnvi(
      root_folder = root_folder, folders = folders, folder_names = folder_names, path_prefix = path_prefix,
      code_subfolders = code_subfolders, dvc_subfolders = dvc_subfolders,
      global = global, libs = libs,
      alt_env_id = alt_env_id, alt_env_value = alt_env_value, alt_env_root_folder = alt_env_root_folder,
      standard_setup = NULL
    )
  }

  # Init R project and scripts
  template_path <- system.file(sprintf("templates/%s.brew", "rstudio_proj"), package = "envimaR")
  brew::brew(template_path, file.path(root_folder, paste0(basename(root_folder), ".Rproj")))
  createScript(new_file = file.path(envrmt$src, "main.R"), template = "script_control", notes = TRUE)
  createScript(new_file = file.path(envrmt$functions, "000_setup.R"), template = "script_setup", notes = TRUE)


  # Init git
  if (use_standard_setup) init_git <- setup_dflt[[standard_setup[1]]]$init_git
  if (init_git) {
    if (!file.exists(file.path(root_folder, ".git"))) {
      system(paste("git init", root_folder))
    }
    template_path <- system.file(sprintf("templates/%s.brew", "gitignore"), package = "envimaR")
    brew::brew(template_path, file.path(root_folder, ".gitignore"))
  }


  # Init dvc
  if (use_standard_setup) init_dvc <- setup_dflt[[standard_setup[1]]]$init_dvc
  if (init_dvc) {
    act_path <- getwd()
    setwd(root_folder)
    if (!file.exists(file.path(root_folder, ".dvc"))) {
      system("dvc init")
    }

    if (!is.null(dvc_cache)) {
      system(paste("dvc cache dir", dvc_cache))
      system("dvc config cache.shared group")
      system("git add .dvc/config")
      system("git commit -m 'Central dvc cache configured.'")
    }

    if (!is.null(dvc_subfolders) || use_standard_setup) {
      if (use_standard_setup) dvc_subfolders <- setup_dflt[[standard_setup[1]]]$dvc_subfolders

      for (p in dvc_subfolders) {
        setwd(file.path(root_folder, dirname(p)))
        template_path <- system.file(sprintf("templates/%s.brew", "dataset_description_md"), package = "envimaR")
        brew::brew(template_path, file.path(root_folder, p, "README.md"))
        system(paste("dvc add", basename(p)))
        system(paste("git add .gitignore", paste0(basename(p), ".dvc")))
        system(paste0('git commit -m "', paste("Added dvc data path", p, "to .gitignore."), '"'))
      }
    }
  }
  return(envrmt)
}
