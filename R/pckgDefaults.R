#' Create look-up table data for defining environment defaults
#'
#' @details After changing something, run [lutUpdate()] to update the LUT.
#'
#' @return A list containing the default project settings.
#'
#' @keywords internal
#'  # Standard setup for envimaR
#'
#' @author Christoph Reudenbach, Thomas Nauss
#'
#' @examples
#' \dontrun{
#' pckgDefaults()
#' }
#'

pckgDefaults <- function() { envimar <- list(
    folders = c("doc", "doc/figures"),
    folder_names = NULL,
    init_git = TRUE,
    code_subfolders = c("src", "src/functions"),
    init_dvc = TRUE,
    dvc_subfolders = c("data/source", "data/results", "data/tmp"),
    path_prefix = NULL,
    global = FALSE,
    libs = NULL,
    fcts_folder = "functions",
    alt_env_id = "COMPUTERNAME",
    alt_env_value = "PCRZP",
    alt_env_root_folder = "D:\\BEN\\plygrnd",
    lut_mode = FALSE,
    create_folders = TRUE,
    git_repository = "." # Historic reasons, remove once var git_repository in createEnvi is depricated.
  )

  envimar_no_dvc <- envimar
  envimar_no_dvc[["init_dvc"]] <- FALSE
  envimar_no_git_dvc <- envimar_no_dvc
  envimar_no_git_dvc[["init_git"]] <- FALSE

  # First version of EnvimaR
  dflt_createEnvi <- list(
    folders = c("data", "data/tmp", "doc"),
    code_subfolders = c("src", "doc", "fcts"),
    path_prefix = "path_",
    global = FALSE,
    libs = NULL,
    fcts_folder = "fcts",
    alt_env_id = "COMPUTERNAME",
    alt_env_value = "PCRZP",
    alt_env_root_folder = "D:\\BEN\\plygrnd"
  )

  setup_dflt <- list(
    envimar = envimar, envimar_no_dvc = envimar_no_dvc, envimar_no_git_dvc = envimar_no_git_dvc,
    dflt_createEnvi = dflt_createEnvi
  )
  usethis::use_data(setup_dflt, overwrite = TRUE, internal = TRUE)
}
