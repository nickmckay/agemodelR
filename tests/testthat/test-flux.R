fakeLipd <- function(){
  ens <- function(name, m) list(variableName = name, values = m, units = "yr BP")
  meas <- function(name, v) list(variableName = name, values = v, units = "unitless")
  set.seed(1)
  n <- 20
  ages <- matrix(rep(seq(0, 1900, length.out = n), 10), nrow = n) + rnorm(n * 10, sd = 5)
  L <- list(paleoData = list(list(
    measurementTable = list(list(
      depth = meas("depth", 1:n),
      RABD = meas("RABD", runif(n, 1, 2)),
      ageEnsemble = ens("ageEnsemble", ages)
    )),
    model = list(list(ensembleTable = list(list(
      sedimentationRate = ens("sedimentationRate", matrix(runif(n * 10, 0.05, 0.1), nrow = n)),
      ageEnsemble = ens("ageEnsemble", ages)
    ))))
  )))
  L
}

test_that("fluxVariable passes a selected variable through unchanged", {
  v <- list(variableName = "x", values = 1:3)
  expect_identical(agemodelR:::fluxVariable(list(), v, "measurement", 1), v)
})

test_that("fluxVariable rejects something that is neither a name nor a variable", {
  expect_error(agemodelR:::fluxVariable(list(), 1:3, "measurement", 1), "variable name")
})

test_that("fluxVariable selects a named variable from the right table", {
  L <- fakeLipd()
  sr <- agemodelR:::fluxVariable(L, "sedimentationRate", "ensemble", 1)
  expect_identical(sr$values, L$paleoData[[1]]$model[[1]]$ensembleTable[[1]]$sedimentationRate$values)
  conc <- agemodelR:::fluxVariable(L, "RABD", "measurement", 1)
  expect_identical(conc$values, L$paleoData[[1]]$measurementTable[[1]]$RABD$values)
})

test_that("calculateFlux works from variable names alone, outside the global environment", {
  L <- fakeLipd()
  f <- function(L){
    calculateFlux(L,
                  sed.rate.ens = "sedimentationRate",
                  sed.rate.age = "ageEnsemble",
                  density.var = NA,
                  concentration.var = "RABD",
                  concentration.var.age = "ageEnsemble",
                  bin.step = 200)
  }
  out <- f(L)
  expect_length(out$paleoData[[1]]$model, 2)
  expect_true("flux" %in% names(out$paleoData[[1]]$model[[2]]$ensembleTable[[1]]))
})
