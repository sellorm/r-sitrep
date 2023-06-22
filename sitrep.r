#!/usr/bin/env Rscript

################################################################################
#
# Simple inspection and reporting utility for R based environments
#
# Author: Mark Sellors
#
################################################################################

args <- commandArgs(trailingOnly = TRUE)

script_version <- "0.1.0"

# Print version if requested
if (!is.na(args[1])) {
  if (args[1] == "version" | args[1] == "-v" | args[1] == "--version") {
    cat(script_version, "\n")
    quit("no", 0)
  }
}

# The '\033[F' resets the cursor position up one line, which allows us to format
# it more neatly here.
help_text <- "\033[F
sitrep.r - A simple inspection and reporting utility for R environments

This utility performs a number of tests in order to ensure R-based
environments work in the desired manner. Output uses the markdown format and
so can be captured to file and further processed into other formats as required.

Tests performed as as follows:
 * repos          Tests that the configured repo is set and accessible
 * library        Checks configured library paths and whether they're writable
 * packages       Lists all installed packages
 * bioc           Checks that bioconductor.org is accessible
 * rstudio        Reports the installed RStudio version

To skip a test, supply that test name as a command line parameter.
For example, to skip the 'bioc' and 'rstudio' tests, run:
$ sitrep.r rstudio bioc

For more info see: https://github.com/sellorm/r-sitrep
"


# Print help if requested
if (!is.na(args[1])) {
  if (args[1] == "help" | args[1] == "-h" | args[1] == "--help") {
    cat(help_text)
    quit("no", 0)
  }
}


# header
cat(paste0("# R sitrep - ", Sys.time(), "\n\n"))

# R Version
cat(paste0("R Version: ", R.version$major, ".", R.version$minor, "\n"))


# Repository configuration
cat("\n\n## repo configuration\n\n")
if ("repos" %in% args) {
  cat("- Skipping repos\n")
} else {
  cat(paste0("Repos    : ", options("repos"), "\n"))

  repo_url <- paste0(options("repos")[1], "/src/contrib/PACKAGES.gz")

  cat("\n```\n")
  download.file(url = repo_url, dest = "/dev/null")
  cat("\n```\n")

  if (!grepl("__linux__", options("repos")[1])) {
    cat("\n**WARNING** Configured repo does not contain Linux binaries\n")
  }
}


# Library configuration
cat("\n\n## library configuration\n\n")
if ("library" %in% args) {
  cat("- Skipping library\n")
} else {
  cat("library paths:\n")
  cat("\n```\n")
  cat(.libPaths())
  cat("\n```\n\n")
  for (path in .libPaths()) {
    libpath_file <- tempfile(tmpdir = path)
    if (file_test("-w", path)) {
      cat(paste0("- Writable: ", path, "\n"))
    } else {
      cat(paste0("- Not writable: ", path, "\n"))
    }
  }
}


# Installed packages
cat("\n\n## Installed packages\n\n")
if ("packages" %in% args) {
  cat("- Skipping packages\n")
} else {
  # note \x60 is `
  cat("\n```\n")
  print(installed.packages()[, c("Package", "Version")])
  cat("\n```\n")
}


# BioConductor
cat("\n\n## BioConductor access\n\n")
if ("bioc" %in% args) {
  cat("- Skipping bioc\n")
} else {
  cat("\n```\n")  
  download.file(
    url = "https://bioconductor.org/config.yaml",
    destfile = "/dev/null"
  )
  cat("\n```\n")
}


# RStudio version
cat("\n\n## RStudio version\n\n")
if ("rstudio" %in% args) {
  cat("- Skipping rstudio\n")
} else {
  output <- tryCatch(
    {
      system2("rstudio-server",
        args = "version",
        stdout = TRUE, stderr = TRUE
      )
    },
    error = function(e) "rstudio-server not found"
  )
  cat(paste0(output, "\n"))
}

cat("\n\n--\n\nReport ends\n\n")
