#' authenticate
#' 
#' This function creates a list with authentication details to access the
#' Qualtrics API
#' 
auth <- function(url="https://survey.qualtrics.com/WRAPI/ControlPanel/api.php",
                 useremail, brand="", token) {
  a <- list(url, useremail, brand, token)
  a[[2]][1] <- gsub("@", "%40", a[[2]][1])
  a
}