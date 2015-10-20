#' import Excel template
#' 
#' This function imports two sheets from the provided Excel template: 
#' "survey" and "choices" and returns a list. 
#'  
#' @param XLSpath path to your "path/template.xls" file
#' @export
importTemplate <- function(XLSpath) {
  survey <- read.xlsx(XLSpath, "survey")
  survey <- subset(survey, !is.na(survey$questiontext)) # drop if blank
  choices <- read.xlsx(XLSpath, "choices")
  list(survey, choices)
}

#' create an advanced format .txt survey file to import into Qualtrics 
#'
#' This function creates a .txt file formatted for direct import into 
#' Qualtrics \url{http://www.qualtrics.com/university/researchsuite/advanced-building/advanced-options-drop-down/import-and-export-surveys/}.
#' 
#' @param Qlist the object created by \code{\link{importTemplate}}
#' @param f the path and name of the .txt file you want to generate; default is "qualtrics.txt"
#' @export
writeQtxt <- function(Qlist, f="qualtrics.txt") {
  # create vector to hold results
  output <- "[[AdvancedFormat]]"
  # loop through every question
  for (i in 1:nrow(Qlist[[1]])) {
    # insert start block if one exists
    bs <- ifelse(is.na(Qlist[[1]]$blockname[i]), "", 
                 paste0("[[Block:", 
                        as.character(Qlist[[1]]$blockname[i]), "]]"))
    # insert end block if one exists
    be <- ifelse(is.na(Qlist[[1]]$endblock[i]), "", 
                 as.character(Qlist[[1]]$endblock[i]))
    # insert item ID if one exists
    qid <- ifelse(is.na(Qlist[[1]]$questionid[i]), "", 
                  paste0("[[ID:", 
                         as.character(Qlist[[1]]$questionid[i]), 
                         "]]"))
    # subset choice sheet to selected choice
    choices.sub <- subset(Qlist[[2]], 
                          Qlist[[2]]$listname==Qlist[[1]]$choicelist[i])
    responses <- ""
    # create vector of choices
    for (ch in 1:nrow(Qlist[[2]])) {
      responses <- paste(responses, 
                         choices.sub$label[ch], sep="\n")
    }
    remove(choices.sub)
    # insert page break if one exists
    pb <- ifelse(is.na(Qlist[[1]]$pagebreak[i]) | i==nrow(Qlist[[1]]), 
                 "", 
                 as.character(Qlist[[1]]$pagebreak[i]))
    # add to output vector
    output <- paste(output, 
                    bs,
                    Qlist[[1]]$questiontype[i],
                    qid,
                    Qlist[[1]]$questiontext[i],
                    Qlist[[1]]$choicetype[i],
                    responses,
                    pb,
                    be,
                    sep="\n")
    
  }
  # write to txt file
  cat(output, file = (con <- file(f, "w", encoding = "UTF-8"))); close(con) 
}