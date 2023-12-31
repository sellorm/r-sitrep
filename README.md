# R sitrep - reporting for R based environments

The file `sitrep.r` is a command line utility that should be copied to the target system and run.

It will produce markdown format output in the terminal with details of the environment checks performed.


## Usage

run the following for more information:

```
sitrep.r --help
```

Checks include:

* repos          Tests that the configured repo is set and accessible
* library        Checks configured library paths and whether they're writable
* packages       Lists all installed packages
* bioc           Checks that bioconductor.org is accessible
* rstudio        Reports the installed RStudio version

The output can be captured by redirecting to a file, like so:

```
sitrep.r > report.md
```


## License

(c) 2023 Mark Sellors
Release under the MIT License.

See LICENSE.md for more.

