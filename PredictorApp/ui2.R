
shinyUI(fluidPage(
  titlePanel("Next Word Predictor"),
  tags$style(type="text/css", "textarea { width: 800px; }"),
  tags$h4("Type a sentence"),
  tags$textarea(id="sentence", rows=4, cols=120, ""),
  uiOutput("uiOutputPanel"),
  tags$style(type = "text/css", ".navbar {background-color: blue;}"),
  tags$div(HTML("<font color='blue'; size = 3 > Press a button to select a word </font>"))
  #h6(textOutput("sentenceEntered", container=span))
))
