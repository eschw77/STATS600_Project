# STATS600_Project

## General Plan 

- Data Cleaning: 
- Initial Model fits: 
- Feature Engineering: 

## Environment Setup

The R environment is managed with renv. Package versions are pinned in `renv.lock`, and the packages the project needs are listed in
`DESCRIPTION`.

One-time setup (run from the project root):

```sh
Rscript setup.R
```

This installs the pinned packages into the project library (`renv/library`, which git
ignores) and registers the **R (STATS600 renv)** Jupyter kernel. Select that kernel
when you open the notebooks in `Notebooks/`.

To add a package:

1. Add it to the `Imports:` list in `DESCRIPTION`.
2. Run `renv::install("pkg")` and then `renv::snapshot()` from an R session in the project root.
3. Commit the updated `DESCRIPTION` and `renv.lock`.
