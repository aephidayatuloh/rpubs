ui <- fixedPage(
  fluidRow(
    wellPanel(style="background-color:skyblue;", width = "100%", height = "5%",
              div(style="display:flex;align-content:center;width:100%;",
                  actionButton("prv", NULL, icon = icon("angle-left")),
                  uiOutput("currlist"),
                  actionButton("nxt", NULL, icon = icon("angle-right")),
                  HTML("<div style='display:flex;font-style: italic;font-family: adelle;font-size:150%;margin-left:20px;margin-right:2px;text-align:left;width:80%;'>
                    <span style='font-weight:700;color:#ffa500;'>R</span>Pubs Recently Published
                   </div>"),
                  HTML("<div style='display:flex;font-style: italic;font-family: adelle;margin-top:auto;margin-bottom:auto;margin-left:auto;margin-right:2px;text-align:right;width:18%;'>
                    aephidayatuloh
                   </div>")
              )
    )
  ),
  titlePanel(title = NULL,  #div(style = "text-align:center;",
             #   HTML("<div style='font-style: italic;font-family: adelle;'><span style='font-weight:700;color:#ffa500;'>R</span>Pubs Recently Published</div>")
             # ),
             windowTitle = "RPubs Recently Published"),

  uiOutput("page")
)
server <- function(input, output, session){
  home <- read_html("https://rpubs.com")
  articles <- html_nodes(home, "div.pubinfo")
  links <- html_attr(html_nodes(html_nodes(articles, "h5"), "a"), "href")
  titles <- html_text(html_nodes(html_nodes(articles, "h5"), "a"))
  authors <- gsub("By ", "", html_text(html_nodes(articles, "div.byline")))
  descr <- html_text(html_nodes(articles, "div.desc"))
  uploaded_at <- gsub("\\+00:00", "", gsub("T", " ", html_attr(html_nodes(articles, "time"), "datetime")))
  recently <- list(titles = titles, links = links, authors = authors, descriptions = descr, uploaded_at = uploaded_at)
  images <- paste0("https:", html_attr(html_nodes(html_nodes(home, "div.pubtile"), "img.pubthumb"), "src"))

  rvlist <- reactiveVal(1)
  n <- ceiling(length(titles)/2)
  observeEvent(input$prv, {
    newValue <- rvlist() - 1
    if(newValue < 1){
      rvlist(n)
    } else {
      rvlist(newValue)
    }

  })

  observeEvent(input$nxt, {
    newValue <- rvlist() + 1
    if(newValue > n){
      rvlist(1)
    } else {
      rvlist(newValue)
    }
  })

  output$currlist <- renderUI({
    HTML(sprintf("<button id='currlist' type='button' class='btn btn-default action-button' disabled>%s</button>", rvlist()))
  })

  output$page <- renderUI({
    tagList(
      br(),
      fixedRow(
        div(style="display:inline-block;width:47%;margin-left:20px;padding-left: 40;padding-right: 40;",
            img(src = images[rvlist()*2 - 1]),
            br(),
            HTML(sprintf("<a href='%s' target='_self'><strong>%s</strong></a>", links[rvlist()*2 - 1], titles[rvlist()*2 - 1])),
            br(),
            HTML(sprintf("By <a href='https://rpubs.com/%s' target='_self'><strong>%s</strong></a>", authors[rvlist()*2 - 1], authors[rvlist()*2 - 1])),
            br(),
            HTML(sprintf("Uploaded %s UTC", as.POSIXlt(uploaded_at[rvlist()*2 - 1], tz = "UTC"))),
            br()
        ),
        div(style="display:inline-block;width:49%;padding-left: auto;padding-right: auto;",
            img(src = images[rvlist()*2]),
            br(),
            HTML(sprintf("<a href='%s'><strong>%s</strong></a>", links[rvlist()*2], titles[rvlist()*2])),
            br(),
            HTML(sprintf("By <a href='https://rpubs.com/%s'><strong>%s</strong></a>", authors[rvlist()*2], authors[rvlist()*2])),
            br(),
            HTML(sprintf("Uploaded %s UTC", as.POSIXlt(uploaded_at[rvlist()*2], tz = "UTC"))),
            br()
        )
      )
    )
  })

}
shinyApp(ui, server, options = list("launch.browser" = interactive()))
