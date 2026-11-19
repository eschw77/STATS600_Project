# Set up the project's R environment and register its Jupyter kernel.
#
# Run from the project root:
#   Rscript setup.R
#
# 1. Restores the packages pinned in renv.lock into the project library (renv/library).
# 2. Installs the "R (STATS600 renv)" kernel from jupyter/kernels/stats600-r into
#    your user Jupyter kernels directory, filling in this machine's R binary and
#    project path.

if (!file.exists("renv.lock")) {
  stop("Run this script from the project root (the folder containing renv.lock).")
}

project_dir <- normalizePath(getwd(), winslash = "/")
Sys.setenv(RENV_PROJECT = project_dir)

if (!requireNamespace("renv", quietly = TRUE)) {
  source(file.path("renv", "activate.R"))  # bootstraps renv if it is missing
}
renv::restore(project = project_dir, prompt = FALSE)

kernel_name <- "stats600-r"
template_dir <- file.path("jupyter", "kernels", kernel_name)

user_kernels_dir <- switch(
  Sys.info()[["sysname"]],
  Darwin = file.path(Sys.getenv("HOME"), "Library", "Jupyter", "kernels"),
  Windows = file.path(Sys.getenv("APPDATA"), "jupyter", "kernels"),
  {
    data_home <- Sys.getenv("XDG_DATA_HOME", file.path(Sys.getenv("HOME"), ".local", "share"))
    file.path(data_home, "jupyter", "kernels")
  }
)

dest <- file.path(user_kernels_dir, kernel_name)
dir.create(dest, recursive = TRUE, showWarnings = FALSE)

for (f in list.files(template_dir, full.names = TRUE)) {
  file.copy(f, dest, overwrite = TRUE)
}

r_bin <- normalizePath(file.path(R.home("bin"), "R"), winslash = "/")
spec <- readLines(file.path(template_dir, "kernel.json"))
spec <- gsub("{R_BIN}", r_bin, spec, fixed = TRUE)
spec <- gsub("{PROJECT_DIR}", project_dir, spec, fixed = TRUE)
writeLines(spec, file.path(dest, "kernel.json"))

message("Installed Jupyter kernel '", kernel_name, "' to ", dest)
