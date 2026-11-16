# Setup

Requires R and RStudio (or R with pandoc). The project file is
[covid19.Rproj](../covid19.Rproj) and is configured as an R Markdown website
using [_site.yml](../_site.yml).

## Packages

```r
install.packages(c("rmarkdown", "flexdashboard", "plotly", "magrittr",
                   "dplyr", "tidyr", "ggplot2", "readr"))
install.packages("devtools")
devtools::install_github("RamiKrispin/coronavirus")
```

The animated chart script in `scripts/learning/gganimate.R` also uses
`gganimate`, `gifski`, `av` and `reshape2`.

## Knit

Open `covid19.Rproj` so the working directory is the repository root, then:

```r
rmarkdown::render("covid19stats.Rmd")        # global analysis, needs internet
rmarkdown::render("covid19Dashboard.Rmd")    # Belgium flexdashboard
rmarkdown::render_site()                     # all pages, writes to the repo root
```

`covid19stats.Rmd` downloads three JHU CSV files from GitHub each time it is
knitted, so the output changes as the source repository is updated or archived.
The dashboard uses the data bundled in the installed `coronavirus` package, so
its totals depend on the package version.

## Scripts

Run these from the repository root so the relative data path resolves:

```r
source("scripts/covid.R")
```

`scripts/covid-draft.R` is an older autosaved draft that still contains unresolved
merge-conflict markers; it is kept for history and will not run as is.
`scripts/learning/` holds tutorial exercises.

## Layout

```
covid19/
  README.md                the case study
  Index.Rmd                site home page
  covid19stats.Rmd         global analysis
  covid19Dashboard.Rmd     flexdashboard
  Data/                    Australian tracking table
  Figures/                 animated chart outputs
  scripts/                 working scripts
  scripts/learning/        tutorial exercises
  docs/SETUP.md
  site_libs/               assets used by the knitted HTML pages
  covid19stats_files/      figures used by covid19stats.html
```
