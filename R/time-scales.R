#' Give the time columns of a LiPD object their time scales
#'
#' @description Age models create ensemble, summary and distribution
#'   columns in memory. lipdR (>= 0.8.0) gives every time column a time scale
#'   (`timeUnits`, `timeDatum`, `timeDirection`, `timeExponent`, `timeSource`)
#'   when a file is read; this does the same for the new columns, so the
#'   result can be used and converted right away, without writing and
#'   re-reading it.
#' @keywords internal
#' @param L a LiPD object
#' @return L, with time scales on its time columns
addAgeModelTimeScales <- function(L){
  f <- tryCatch(getExportedValue("lipdR", "addTimeScales"), error = function(e) NULL)
  if(is.null(f)){
    f <- tryCatch(utils::getFromNamespace("add_time_scales", "lipdR"), error = function(e) NULL)
  }
  if(is.null(f)){
    return(L)
  }
  f(L)
}
