# This is function to extract code from RPubs
#
#' @title Extract Code From Rpubs Article
#' @description (Deprecated) Extract code from an Rpubs <https://rpubs.com/> article. These functions still work but will be removed (defunct) in the next version.
#'
#'
#' \itemize{
#'  \item \code{\link{extractCode}}: This function is deprecated, and will
#'  be removed in the next version of this package. Use \code{rpubs_code()} instead.
#' }
#'
#' @name extractCode-defunct
#' @param url Character. URL of RPubs article, e.g. url = "http://rpubs.com/aephidayatuloh/sendgmail".
#' @param path Character. File name for the extracted code as R script, e.g. \code{code.R}.
#' @param output Logical. Should extraction include output of the code? Default to \code{FALSE}, means only R script will be extracted.
#' @param ... Other parameter for defunct.
#' @import rvest
#' @importFrom xml2 read_html
#' @return vector
#' @details If \code{path = NULL} then the extracted script will be print on console or as vector if you assign to an object. One code block is one element of vector.
#' @examples \donttest{
#' extractCode(url = "http://rpubs.com/aephidayatuloh/sendgmail", path = NULL, output = FALSE)
#' }
#'
#'
#' @export
extractCode <- function(url, path = NULL, output = FALSE, ...){
  # if (as.character(match.call()[[1]]) == "extractCode") {
  #   warning("please use rpubs_code() instead of extractCode()", call. = FALSE)
  # }
  .Defunct(msg = "'extractCode()' has been removed from this package\nUse 'rpubs_code()' instead.")
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

  if(is.null(path)){
    paste0(sprintf("# %s\n\n", url), paste(gsub("\n", "", code), collapse = "\n\n"))
  } else {
    writeLines(text = paste0(sprintf("# %s\n\n", url), paste(gsub("\n", "", code), collapse = "\n\n")), con = path)
  }
}
