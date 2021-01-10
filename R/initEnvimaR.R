#' Set up a project environment
#'
#' @description Set up the project environment, a folder structure and git and dvc, if necessary.
#'
#' @param root_folder root directory of the project.
#' @param folders list of subfolders within the project directory.
#' @param folder_names names of the variables that point to subfolders. If not
#' provided, the base paths of the folders is used.
#' @param git_repository name of the project's git repository. Will be
#' added to the folders and subfolders defined in default "lut" or supplied by
#' user will be created.
#' @param git_subfolders subdirectories within git repository that should be
#' created.
#' @param path_prefix a prefix for the folder names.
#' @param global logical: export path strings as global variables?
#' @param libs  vector with the  names of libraries
#' @param fcts_folder  path of the folder holding the functions. All files in
#' this folder will be sourced.
#' @param source_functions logical: should functions be sourced?
#' @param alt_env_id alternative system environment attribute used to
#' check for setting an alternative \code{root_folder}.
#' @param alt_env_value value of the attribute for which the alternative
#' root directory of the project should be set.
#' @param alt_env_root_folder alternative root directory.
#' @param lut_mode use predefined environmental settings. In this case, only the
#' name of the git repository must be supplied to the function.
#' @param create_folders create folders if not existing already.
#'
#' @return A list containing the project settings.
#'
#' @name initEnvimaR
#' @export initEnvimaR
#'
#' @import brew
#'
#' @author Christoph Reudenbach, Thomas Nauss
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
initEnvimaR <- function(root_folder = ".", folders = NULL, folder_names = NULL,
                        init_git = TRUE, code_subfolders = c("src", "functions"),
                        init_dvc = TRUE, dvc_subfolders = "data", dvc_cache = NULL,
                        path_prefix = NULL, global = FALSE,
                        libs = NULL, fcts_folder = NULL, source_functions = !is.null(fcts_folder),
                        alt_env_id = NULL, alt_env_value = NULL, alt_env_root_folder = NULL,
                        standard_setup = c("envimar", "envimar_no_dvc", "envimar_no_git_dvc"),
                        overwrite = FALSE) {

  # Setup project directory structure
  if (is.null(folders)) {
    use_standard_setup <- TRUE
    envrmt <- createEnvi(root_folder = root_folder, lut_mode = standard_setup[1])
  } else {
    envrmt <- createEnvi(
      root_folder = root_folder, folders = folders, folder_names = folder_names,
      git_repository = git_repository, code_subfolders = code_subfolders,
      path_prefix = path_prefix, global = global,
      libs = libs, fcts_folder = fcts_folder, source_functions = source_functions,
      alt_env_id = alt_env_id, alt_env_value = alt_env_value, alt_env_root_folder = alt_env_root_folder,
      lut_mode = lut_mode, create_folders = create_folders
    )
  }


  # Init R project and scripts
  template_path <- system.file(sprintf("templates/%s.brew", "rstudio_proj"), package = "envimaR")
  brew::brew(template_path, file.path(root_folder, paste0(basename(root_folder), ".Rproj")))
  envimaR:::createScript(new_file = file.path(envrmt$src, "main.R"), template = "script_control", notes = TRUE)
  envimaR:::createScript(new_file = file.path(envrmt$functions, "000_setup.R"), template = "script_setup", notes = TRUE)


  # Init git
  if(use_standard_setup) init_git <- setup_dflt[[standard_setup[1]]]$init_git
  if (init_git) {
    if (!file.exists(file.path(root_folder, ".git"))) {
      system(paste("git init", root_folder))
    }
    template_path <- system.file(sprintf("templates/%s.brew", "gitignore"), package = "envimaR")
    brew::brew(template_path, file.path(root_folder, ".gitignore"))
  }


  # Init dvc
  if(use_standard_setup) init_dvc <- setup_dflt[[standard_setup[1]]]$init_dvc
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

  #
  #
  # envrmt<-createEnvi(root_folder = dir,
  #                        folders = folders,
  #                        folder_names = folder_names,
  #                        path_prefix = path_prefix,
  #                        global = global,
  #                        alt_env_id = alt_env_id,
  #                        alt_env_value = alt_env_value,
  #                        alt_env_root_folder = alt_env_root_folder,
  #                        create_folders = create_folders)
  #   templatePath = system.file(sprintf("scriptTemplates/%s.brew", "projfile"),
  #                              package = "tpEnvima")
  #   brew::brew(templatePath, file.path(dir,paste0(basename(dir),".Rproj")))
  #   templatePath = system.file(sprintf("scriptTemplates/%s.brew", "gitignore"),
  #                              package = "tpEnvima")
  #   brew::brew(templatePath, file.path(dir,".gitignore"))
  #   templatePath = system.file(sprintf("scriptTemplates/%s.brew", "HowTo"),
  #                              package = "tpEnvima")
  #   brew::brew(templatePath, file.path(dir,"docs/HowTo.md"))
  #
  #   #if (dir != ".") dirCreate("")
  #
  #   # dirCreate ("data")
  #   # dirCreate ("output")
  #   # dirCreate ("scripts")
  #
  #   if (!is.null(packageDescription("tpEnvima")$Date)) {
  #     pkgDate = as.Date(packageDescription("tpEnvima")$Date) + 1
  #   } else {
  #     pkgDate = as.character(Sys.Date())
  #   }
  #
  #   brew::brew(system.file("Rprofile.brew", package = "tpEnvima"),
  #              file.path(dir,"./.Rprofile"))
  #
  #   options(projectRoot = normalizePath(dir))
  #
  #   tpEnvima::prScript("setup_data", template = "setup_data", instructions = instructions)
  #   tpEnvima::prScript("control", template = "control", instructions = instructions)
  #   tpEnvima::prScript("setup_project", template = "setup_project", instructions = instructions)
  #
  #   prSave(proj_env,replace=TRUE)
  #
  #   if (git){
  #     repo<- git2r::init(path = dir)
  #     git2r::add(repo = repo, paste0(basename(dir),"*.Rproj"))
  #     git2r::add(repo = repo, "scripts/control.r")
  #     git2r::add(repo = repo, "scripts/setup_project.r")
  #     git2r::add(repo = repo, "scripts/setup_data.r")
  #     git2r::commit(repo = repo,message = "initial commit")
  #
  #   }
}
