# agemodelR 0.1.0

* First release under this name. agemodelR holds the age modeling code from geoChronR (`runBacon()`, `runBchron()`, `runOxcal()`, `runBam()` and the LiPD model infrastructure). It was developed as `geoChronR-chronOnly`. Ensemble methods live in ens and plotting in lipdViz; `library(geoChronR)` still provides the complete interface of all three.
* Fixed `runBacon()` failing with `undefined columns selected` under rbacon 4.0.0, which renamed the columns in Bacon's `_ages.txt` output (`depths`, `qmin`, `qmax`). `loadBaconOutput()` now matches the column names used by any rbacon version.
* Fixed OxCal ensemble parsing when dates flagged with a bare `Outlier();` are dropped from OxCal's posterior output, and added a clear error when OxCal writes zero posterior samples.
* Fixed the `distributionTable` depth field being silently dropped after OxCal runs.
