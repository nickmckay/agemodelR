# CLAUDE.md: agemodelR

agemodelR is the age-modeling core of the geoChronR package family, split out of the monolithic
geoChronR in June 2026 and renamed from `geoChronR-chronOnly`. It holds only age modeling and LiPD
model infrastructure. `library(geoChronR)` still provides the full interface: GeoChronR 2.0 is a
thin wrapper over agemodelR, ens and lipdViz.

## Package family (dependency order: ens <- lipdViz <- agemodelR <- geoChronR; actR and compositeR on ens + lipdViz)

| Repo (`~/GitHub/...`) | GitHub | Branch | Role |
|---|---|---|---|
| lipdR | nickmckay/lipdR | main | Read and write LiPD |
| ens | nickmckay/ens | main | Ensemble methods + UQ engine |
| lipdViz | nickmckay/lipdViz | main | Plotting + mapping |
| **agemodelR** (this repo) | nickmckay/agemodelR | main | Age modeling |
| GeoChronR | nickmckay/GeoChronR | master | Wrapper re-exporting agemodelR, ens and lipdViz |
| actR | LinkedEarth/actR | main | Abrupt-change detection |
| compositeR | nickmckay/compositeR | master | Record compositing |

## What lives here

- Age models: `R/bacon.lipd.R`, `R/run.bchron.LiPD.R`, `R/oxcal.R`, `R/BAM.lipd.R` (the
  LiPD-level `runBam()` wrapper; the computational `simulateBam`/`bamCorrect` moved to ens).
- LiPD model infra: `R/createModel.R`, `R/chronBuilding.R`, `R/flux.R`.
- Only the ens and lipdViz functions this code calls are imported (`R/agemodelR-package.R`). After a
  new export here, regenerate the wrapper with `tools/gen_reexports.R` in the GeoChronR repo.

## Gotchas

- `@inheritParams ens::selectData` style for params defined in ens (the function moved there).
- Depends on heavy age-model software (rbacon, Bchron, oxcAAR) — this is the ONLY repo in the
  family that does; downstream actR/compositeR deliberately do not.
- CI: R CMD check on Windows, macOS and Linux. Linux skips vignettes until lipdverse.org's
  certificate chain is fixed.

## Dev

`devtools::load_all()` · `devtools::document()` · `devtools::test()` · `devtools::check()`.
Needs `ens` and `lipdViz` installed from source first; push order for CI Remotes resolution is
ens, then lipdViz, then agemodelR, then GeoChronR. Commit work when complete.
