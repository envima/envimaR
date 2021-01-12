#' Define working environment default settings
#'
#'@details After adding new project settings run [pckgDefaults()] to update and savew the default settings. For compatibility reasons you may also run [lutUpdate()].
#'
#'@return  A list containing the default project settings
#'@param  new_envrmt_list containing a list of arbitrary folders to be generated
#'@param  new_envrmt_list_name name of this list
#'
#'
#' @examples
#' \dontrun{
#' # Standard setup for envimaR
#' pckgDefaults()
#' }
#' @name pckgDefaults
#' @export pckgDefaults

pckgDefaults <- function(new_envrmt_list=NULL,new_envrmt_list_name=NULL) {
  envimar <- list(
    folders = c("doc", "doc/figures","tmp"),
    folder_names = NULL,
    init_git = TRUE,
    code_subfolders = c("src", "src/functions"),
    init_dvc = TRUE,
    dvc_subfolders = c("data/source", "data/results", "data/tmp","data/level0","data/level1"),
    path_prefix = NULL,
    global = FALSE,
    libs = NULL,
    alt_env_id = "COMPUTERNAME",
    alt_env_value = "PCRZP",
    alt_env_root_folder = "D:\\BEN\\plygrnd",
    lut_mode = FALSE,
    create_folders = TRUE,
    git_repository = "." # Historic reasons, remove once var git_repository in createEnvi is deprecated.
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


  if (is.null(new_envrmt_list)){
  setup_dflt <- list(
    envimar = envimar, envimar_no_dvc = envimar_no_dvc, envimar_no_git_dvc = envimar_no_git_dvc,
    dflt_createEnvi = dflt_createEnvi
  )} else {
    setup_dflt <- list(envimar = envimar, envimar_no_dvc = envimar_no_dvc, envimar_no_git_dvc = envimar_no_git_dvc)
    setup_dflt[[new_envrmt_list_name]] = new_envrmt_list
  }

  usethis::use_data(setup_dflt, overwrite = TRUE, internal = TRUE)
  return(setup_dflt)
}
