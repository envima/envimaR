#' Setup project folder structure
#'
#' @description Defines folder structures and creates them if necessary, loads
#' libraries, and sets other project relevant parameters.
#'
#' @param root_folder root directory of the project.
#' @param folders list of subfolders within the project directory.
#' @param folder_names names of the variables that point to subfolders. If not
#' provided, the base paths of the folders is used.
#' @param code_subfolders define subdirectories for code should be created.
#' @param dvc_subfolders subfolders for data that should be added to dvc.
#' @param path_prefix a prefix for the folder names.
#' @param global logical: export path strings as global variables?
#' @param libs  vector with the  names of libraries
#' @param setup_script name of the setup script. This file will not be sourced from the functions folder even if
#' fcts_folder is provided.
#' @param fcts_folder  path of the folder holding the functions. All files in
#' this folder will be sourced.
#' @param source_functions logical: should functions be sourced?
#' @param alt_env_id alternative system environment attribute used to
#' check for setting an alternative \code{root_folder}.
#' @param alt_env_value value of the attribute for which the alternative
#' root directory of the project should be set.
#' @param alt_env_root_folder alternative root directory.
#' @param standard_setup use predefined settings. In this case, only the name of the root folder is required. See
#' names(envimaR::lutInfo()) for available standards.
#' name of the git repository must be supplied to the function.
#' @param create_folders create folders if not existing already.
#' @param git_repository deprecated, use code_subfolders instead.
#' @param git_subfolders deprecated, use code_subfolders instead.
#' @param lut_mode deprecated, use standard_setup instead.
#'
#' @return A list containing the project settings.
#'
#' @name createEnvi
#' @export createEnvi
#'
#' @seealso [alternativeEnvi()]
#'
#' @examples
#' \dontrun{
#' createEnvi(
#'   root_folder = "~/edu", folders = c("data/", "data/tmp/"),
#'   libs = c("link2GI"),
#'   alt_env_id = "COMPUTERNAME", alt_env_value = "PCRZP",
#'   alt_env_root_folder = "D:\\BEN\\edu"
#' )
#' }
#'
createEnvi <- function(root_folder = tempdir(), folders = c("data", "data/tmp"), folder_names = NULL,
                       path_prefix = NULL, code_subfolders = NULL, dvc_subfolders = NULL,
                       global = FALSE, libs = NULL, setup_script = "000_setup.R", fcts_folder = NULL,
                       source_functions = !is.null(fcts_folder),
                       alt_env_id = NULL, alt_env_value = NULL, alt_env_root_folder = NULL,
                       standard_setup = NULL, lut_mode = NULL, create_folders = TRUE,
                       git_repository = NULL, git_subfolders = NULL) {

  # Deprecated warnings
  if (!is.null(git_subfolders)) {
    warning("git_subfolders is deprecated, use code_subfolders instead.")
    code_subfolders <- git_subfolders
  }

  if (!is.null(git_repository)) {
    warning("git_repository is deprecated, use code_subfolders instead.")
    code_subfolders <- c(code_subfolders, git_repository)
  }

  if (!is.null(lut_mode)) warning("lut_mode is deprecated, use standard_setup instead.")

  if (isTRUE(lut_mode)) {
    dflt <- setup_dflt[["dflt_createEnvi"]]
    for (i in seq(length(dflt))) {
      assign(names(dflt[i]), dflt[[i]])
    }
  } else if (!is.null(standard_setup)) {
    dflt <- setup_dflt[[standard_setup]]
    for (i in seq(length(dflt))) {
      assign(names(dflt[i]), dflt[[i]])
    }
  }

  # Set root folder or alternative root folder
  root_folder <- alternativeEnvi(
    root_folder = root_folder,
    alt_env_id = alt_env_id,
    alt_env_value = alt_env_value,
    alt_env_root_folder = alt_env_root_folder
  )

  # Add code folders to folders
  if (!is.null(code_subfolders)) {
    folders <- c(folders, code_subfolders)
  }

  # Add dvc folders to folders
  if (!is.null(dvc_subfolders)) {
    folders <- c(folders, dvc_subfolders)
  }

  # Create folders
  folders <- createFolders(root_folder, folders,
    folder_names = folder_names, path_prefix = path_prefix,
    create_folders = create_folders
  )

  # Set global environment if necessary
  if (global) makeGlobalVariable(names = names(folders), values = folders)

  # Load and install libraries
  loadLibraries(libs)

  # Source functions
  if (source_functions) sourceFunctions(fcts_folder, setup_script)

  return(folders)
}
