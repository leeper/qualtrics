#' Returns the results of a given survey.
#'
#' @param reqAuth list object returned from \code{\link{auth}}
#' @param surveyid the Qualtrics survey id.
#' @export
getSurveyResults <- function(reqAuth, surveyid) {
  # import
    url <- paste0(reqAuth[[1]], "?", 
                  "API_SELECT=ControlPanel",
                  "&Version=2.3",
                  "&Request=getLegacyResponseData",
                  "&User=", reqAuth[[2]],
                  ifelse(reqAuth[[3]]=="", "&Token=",
                         paste0("%23", reqAuth[[3]], "&Token=")),
                  reqAuth[[4]],
                  "&Format=CSV",
                  "&SurveyID=", surveyid)
    x <- getURL(url)
    df <- read.csv(text=x, stringsAsFactors=FALSE)
  # get question id
    url2 <- paste0(reqAuth[[1]], "?", 
                  "API_SELECT=ControlPanel",
                  "&Version=2.3",
                  "&Request=getSurvey",
                  "&User=", reqAuth[[2]],
                  ifelse(reqAuth[[3]]=="", "&Token=",
                         paste0("%23", reqAuth[[3]], "&Token=")),
                  reqAuth[[4]],
                  "&Format=XML",
                  "&SurveyID=", surveyid)
    temp <- getURL(url2)
    doc <- xmlRoot(xmlTreeParse(temp))
    q <- parseXMLResponse(doc[["Questions"]])
    itemnames <- q$QuestionText
    itemid <- q$ExportTag
  # replace item names with id
    for (i in 1:length(as.character(as.vector(df[1,])))) {
      for (f in 1:length(itemnames)) {
        df[1,i] <- ifelse(df[1,i]==itemnames[f], itemid[f], df[1,i])
      }
    }
  # set column names
    colnames(df) <- as.character(as.vector(df[1,]))
    df <- df[-1,]
    return(df)
}

#' Returns a list of surveys available for the given user.
#'
#' @param reqAuth list object returned from \code{\link{auth}}
#' @export
getSurveys <- function(reqAuth) {
  url <- paste0(reqAuth[[1]], "?", 
                "API_SELECT=ControlPanel",
                "&Version=2.3",
                "&Request=getSurveys",
                "&User=", reqAuth[[2]],
                ifelse(reqAuth[[3]]=="", "&Token=",
                       paste0("%23", reqAuth[[3]], "&Token=")),
                reqAuth[[4]],
                "&Format=XML")
  temp <- getURL(url)
  doc <- xmlRoot(xmlTreeParse(temp))
  df2 <- parseXMLResponse(doc[["Questions"]][[1]])
  return(df)
}


#' Returns the given survey.
#'
#' @param reqAuth list object returned from \code{\link{auth}}
#' @param surveyid the Qualtrics survey id.
#' @export
getSurvey <- function(reqAuth, surveyid) {
  url <- paste0(reqAuth[[1]], "?", 
                "API_SELECT=ControlPanel",
                "&Version=2.3",
                "&Request=getSurvey",
                "&User=", reqAuth[[2]],
                ifelse(reqAuth[[3]]=="", "&Token=",
                       paste0("%23", reqAuth[[3]], "&Token=")),
                reqAuth[[4]],
                "&Format=XML",
                "&SurveyID=", surveyid)
  temp <- getURL(url)
  xmlRoot(xmlTreeParse(temp))
}