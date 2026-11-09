# Age model outputs get time scales right away (lipdR >= 0.8.0)

test_that("createModel gives the new ensemble and summary columns time scales", {
  L <- list(dataSetName = "t", chronData = list(list(measurementTable = list(list(
    depth = list(variableName = "depth", units = "cm", values = c(1, 2, 3)))))))
  ens <- matrix(rep(c(100, 200, 300), 10) + rep(1:10, each = 3), nrow = 3)
  L <- suppressMessages(suppressWarnings(createModel(L, depth.or.age.vector = c(1, 2, 3), ensemble.data = ens)))
  mod <- L$chronData[[1]]$model[[1]]
  ae <- mod$ensembleTable[[1]]$ageEnsemble
  expect_equal(ae$timeDatum, 1950)
  expect_equal(ae$timeDirection, "retrograde")
  expect_equal(ae$timeSource, "units")
  expect_null(mod$ensembleTable[[1]]$depth$timeSource)
  expect_equal(mod$summaryTable[[1]]$ageMedian$timeUnits, "yr BP")
})

test_that("an ensemble in year CE gets a prograde scale", {
  L <- list(dataSetName = "t", chronData = list(list(measurementTable = list(list(
    depth = list(variableName = "depth", units = "cm", values = c(1, 2, 3)))))))
  ens <- matrix(rep(c(1900, 1800, 1700), 10) + rep(1:10, each = 3), nrow = 3)
  L <- suppressMessages(suppressWarnings(createModel(L, depth.or.age.vector = c(1, 2, 3), ensemble.data = ens,
                                                     ens.var = "yearEnsemble", ens.units = "CE",
                                                     create.summary.table = FALSE)))
  ye <- L$chronData[[1]]$model[[1]]$ensembleTable[[1]]$yearEnsemble
  expect_equal(ye$timeDirection, "prograde")
  expect_equal(ye$timeUnits, "yr AD")
})
