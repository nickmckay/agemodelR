# agemodelR

Age-uncertain chronology development for paleogeoscientific data, with LiPD model
infrastructure: `runBacon()`, `runBchron()`, `runOxcal()`, `runBam()`, `createModel()`,
`createChronMeasInputDf()` and `calculateFlux()`.

agemodelR is part of the [geoChronR](https://github.com/nickmckay/GeoChronR) package family:

| Package | Role |
|---|---|
| **agemodelR** (this repo) | Age modeling and LiPD model infrastructure |
| [ens](https://github.com/nickmckay/ens) | Ensemble methods: `corEns()`, `regressEns()`, `pcaEns()`, `computeSpectraEns()`, binning, `selectData()` |
| [lipdViz](https://github.com/nickmckay/lipdViz) | Visualization: `plotChronEns()`, `plotTimeseriesEnsRibbons()`, `plotCorEns()`, maps and more |
| [geoChronR](https://github.com/nickmckay/GeoChronR) | Wrapper: `library(geoChronR)` provides the complete interface of the three packages above |

## Installation

```r
remotes::install_github("nickmckay/agemodelR")
```

## Getting started

See the [Introduction vignette](vignettes/Introduction.Rmd) for the full workflow: load LiPD
data, build age models, map age ensembles to paleo measurements, and analyze with ensemble
methods.
