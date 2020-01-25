# This is function to extract code from RPubs
#
#' @title Extract Code From RPubs Article
#' @description Extract code from an RPubs article.
#' @param url Character. URL of RPubs article, e.g. url = "https://rpubs.com/aephidayatuloh/sendgmail".
#' @param path Character. File name for the extracted code as R script, e.g. \code{code.R}.
#' @param output Logical. Should extraction include output of the code? Default to \code{FALSE}, means only R script will be extracted.
#' @import rvest
#' @importFrom xml2 read_html
#' @return vector
#' @details If \code{path = NULL} then the extracted script will be print on console or as vector if you assign to an object. One code block is one element of vector.
#' @examples
#' rpubs_code(url = "https://rpubs.com/aephidayatuloh/sendgmail", path = NULL, output = FALSE)
#'
#'
#'
#' @export
rpubs_code <- function(url, path = NULL, output = FALSE){
  url <- sub("http://", "https://", url)
  url <- sub("https://www.", "https://", url)

  if(substr(sub("https?://(www\\.)?", "", url), 1, 9) != "rpubs.com"){
    stop("Only support article from https://rpubs.com")
  }

  message("Please wait...\nThis depends on your internet connection.\n")
  pg <- read_html(url)

  iframe_link <- paste0("https:",
                        html_attr(
                          html_nodes(
                            html_nodes(
                              html_nodes(
                                html_nodes(pg, "body"),
                                "div#pagebody"),
                              "div#payload"),
                            "iframe"),
                          "src")
  )

  node <- ifelse(output, "pre", "pre.r")

  code <- html_text(
    html_nodes(
      read_html(iframe_link),
      node)
  )

  script <- paste0(sprintf("# %s\n\n", url), paste(gsub("\n", "", code), collapse = "\n\n"))

  if(is.null(path)){
    return(script)
  } else {
    writeLines(text = script, con = path)
  }
}
