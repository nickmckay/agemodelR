.onAttach <- function(...){
  if(!interactive()){
    packageStartupMessage(glue::glue("Welcome to agemodelR version {utils::packageVersion('agemodelR')}!"))
    
  }
}