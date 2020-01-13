# This is function to extract code from RPubs
#
#' @title Extract Code From RPubs Article
#' @description Extract code from an RPubs article.
#' @param url Character. URL of RPubs article, e.g. url = "http://rpubs.com/aephidayatuloh/sendgmail".
#' @param files Character. File name for the extracted code as R script, e.g. \code{code.R}.
#' @param output Logical. Should extraction include output of the code? Default to \code{FALSE}, means only R script will be extracted.
#' @import rvest
#' @importFrom xml2 read_html
#' @return vector
#' @details If \code{files = NULL} then the extracted script will be print on console or as vector if you assign to an object. One code block is one element of vector.
#' @examples \dontrun{
#' rpubs_code(url = "http://rpubs.com/aephidayatuloh/sendgmail", file = "sendmail.R", output = FALSE)
#' }
#'
#'
#' @export
rpubs_code <- function(url, files = NULL, output = FALSE){
  if(substr(url, 8, 16) != "rpubs.com"){
    stop("Only support article from http://rpubs.com")
  }

  pg <- read_html(url)

  iframe_link <- paste0("http:",
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

  if(output){
    node <- "pre"
  } else {
    node <- "pre.r"
  }

  code <- html_text(
    html_nodes(
      read_html(iframe_link),
      node)
  )

  if(is.null(files)){
    paste0(sprintf("# %s\n\n", url), paste(gsub("\n", "", code), collapse = "\n\n"))
  } else {
    writeLines(text = paste0(sprintf("# %s\n\n", url), paste(gsub("\n", "", code), collapse = "\n\n")), con = files)
  }
}
