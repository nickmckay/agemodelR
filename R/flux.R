
#' Calculate a flux ensemble
#'
#' @param L A LiPD object
#' @param sed.rate.ens sedimentation rate ensemble (potentially from createSedRateEnsemble()), either as a variable selected with selectData() or as the name of a variable in L. The same goes for the other variable arguments.
#' @param sed.rate.age age ensemble that corresponds to sed.rate.ens
#' @param sed.rate.table.num table number for sed rate ensemble (for an ensemble or summary table, the model number). Used only when a variable is given by name; the same goes for the other table arguments.
#' @param sed.rate.table.type table type for sed rate ensemble
#' @param density.var name of the density variable
#' @param density.var.age age variable that corresponds to density
#' @param density.table.num table number for density
#' @param density.table.type table type for density
#' @param concentration.var name of the concentration variable
#' @param concentration.var.age age variable that corresponds to concentration
#' @param concentration.table.num table number for concentration
#' @param concentration.table.type name of the concentration variable
#' @param out.age.var What is the output age variable (e.g., age or ageEnsemble)
#' @param ens.units What are the output units (default is "mass/cm2/yr")
#' @param ens.var.name What is the output variable name (default = "flux")
#' @param bin.step What timestep are you calculating flux over?
#' @param bin.vec Optionall specify a vector to calculate flux over
#' @family LiPD manipulation
#'
#' @returns A LiPD object
#' @export
calculateFlux <- function(L, 
                          sed.rate.ens = "sedimentationRate", 
                          sed.rate.age = "ageEnsemble",
                          sed.rate.table.num = 1,
                          sed.rate.table.type = "ensemble",
                          density.var = "WBD",
                          density.var.age = "ageEnsemble",
                          density.table.num = 1, 
                          density.table.type = "measurement",
                          concentration.var = "RABD",
                          concentration.var.age = "ageEnsemble",
                          concentration.table.num = 1, 
                          concentration.table.type = "measurement",
                          out.age.var = "age",
                          ens.units = "mass/cm2/yr",
                          ens.var.name = "flux",
                          bin.step = 100,
                          bin.vec = NA){
  
  #get each variable, either as given or by selecting it from L
  srEns <- fluxVariable(L, sed.rate.ens, sed.rate.table.type, sed.rate.table.num)
  srAgeEns <- fluxVariable(L, sed.rate.age, sed.rate.table.type, sed.rate.table.num)
  concEns <- fluxVariable(L, concentration.var, concentration.table.type, concentration.table.num)
  concAgeEns <- fluxVariable(L, concentration.var.age, concentration.table.type, concentration.table.num)
  if(!all(is.na(density.var))){
    densEns <- fluxVariable(L, density.var, density.table.type, density.table.num)
    densAgeEns <- fluxVariable(L, density.var.age, density.table.type, density.table.num)
  }

  #create age binning vector
  if(all(is.na(bin.vec))){
    vec.min <- min(apply(srAgeEns$values,1,median),apply(concAgeEns$values,1,median))
    vec.max <- max(apply(srAgeEns$values,1,median),apply(concAgeEns$values,1,median))
    bin.vec <- seq(vec.min,vec.max,by = bin.step)
  }
  
  #calculate binned matrixes
  sb <- binEns(srAgeEns$values,srEns$values,bin.vec = bin.vec)
  
  if(!all(is.na(density.var))){
    db <- binEns(densAgeEns$values,densEns$values,bin.vec = bin.vec)
  }else{
    db <- sb
    db$matrix <- matrix(1,nrow = nrow(sb$matrix),ncol = ncol(sb$matrix))  
  }
  
  cb <- binEns(concAgeEns$values,concEns$values,bin.vec = bin.vec)
  
  #calculate flux
  fluxMat <- sb$matrix * db$matrix * cb$matrix
  
  L <- createModel(L, paleo.or.chron = "paleoData",
                   depth.or.age.vector = sb$time,
                   depth.or.age.var = out.age.var,
                   ensemble.data = fluxMat,
                   depth.or.age.units = srAgeEns$units,
                   make.new = TRUE,
                   ens.units = ens.units,
                   ens.var = ens.var.name,
                   methods = list(methods = "agemodelR::calculateFlux"))
  
  return(L)
}

#' Get a variable for calculateFlux()
#'
#' @param L A LiPD object
#' @param x Either a LiPD variable list (for example from selectData()), or the name of a variable to select from L
#' @param table.type "measurement", "ensemble" or "summary"
#' @param table.num For a measurement table, its number; for an ensemble or summary table, the model number
#' @returns A LiPD variable list
#' @noRd
fluxVariable <- function(L, x, table.type, table.num){
  if(is.list(x) && !is.null(x$values)){
    return(x)
  }
  if(!is.character(x) || length(x) != 1){
    stop("Expected a variable name or a variable selected with selectData(), but got ", class(x)[1])
  }
  if(grepl("^meas", table.type)){
    selectData(L, var.name = x, table.type = table.type, meas.table.num = table.num)
  }else{
    selectData(L, var.name = x, table.type = table.type, model.num = table.num)
  }
}
