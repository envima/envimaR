#' Define and create a project environment
#'
#' @description Defines folder structures and creates them if necessary, loads
#' libraries, and sets other project relevant parameters.
#'
#' @param root_folder root directory of the project.
#' @param folders list of subfolders within the project directory.
#' @param folder_names names of the variables that point to subfolders. If not
#' provided, the base paths of the folders is used.
#' @param path_prefix a prefix for the folder names.
#' @param global export path strings as global variables.
#' @param alt_env_id alternative system environment attribute used to
#' check for setting an alternative \code{root_folder}.
#' @param alt_env_value value of the attribute for which the alternative
#' root directory of the project should be set.
#' @param alt_env_root_folder alternative root directory.
#'
#' @return A list containing the project settings.
#'
#' @name createEnvi
#' @export createEnvi
#'
#' @author Christoph Reudenbach, Thomas Nauss
#'
#' @seealso [alternativeEnvi()]
#'
#' @examples
#' \dontrun{
#' createEnvi(root_folder = "~/edu", folders = c("data/", "data/tmp/"),
#' alt_env_id = "COMPUTERNAME", alt_env_value = "PCRZP",
#' alt_env_root_folder = "D:\\BEN\\edu")
#'}

createEnvi = function(root_folder = tempdir(), folders = c("data", "data/tmp"),
                      folder_names = NULL, path_prefix = "path_", global = FALSE,
                      alt_env_id = NULL,
                      alt_env_value = NULL,
                      alt_env_root_folder = NULL){

  # Set root folder or alternative root folder
  root_folder = alternativeEnvi(root_folder = root_folder,
                                alt_env_id = alt_env_id,
                                alt_env_value = alt_env_value,
                                alt_env_root_folder = alt_env_root_folder)

  if(!is.null(alt_env_id)){
    if(Sys.getenv()[alt_env_id] == alt_env_value){
      root_folder = alt_env_root_folder
    }
  }

  # Create folder list and set variable names pointing to the path values
  folders = lapply(folders, function(f){
    file.path(root_folder, f)
  })

  if(is.null(folder_names)){
    names(folders) = basename(unlist(folders))

    while(any(duplicated(names(folders)))){
      names(folders)[duplicated(names(folders))] =
        paste(basename(dirname(unlist(folders)))[duplicated(names(folders))],
              names(folders[duplicated(names(folders))]), sep = "_")
    }
  } else {
    names(folders) = folder_names
  }

  if(!is.null(path_prefix)) names(folders) = paste(path_prefix, names(folders))

  # Check paths for existance and create if necessary
  for(f in folders){
    if(!file.exists(f)) dir.create(f, recursive = TRUE)
  }

  if(global) makeGlobalVariable(names = names(folders), values = folders)

  return(folders)
}
