
shinyUI(fluidPage(
  titlePanel("Next Word Predictor"),
  tags$style(type="text/css", "textarea { width: 600px; }"),
  tags$h6("* This application provides predictions based on n-gram frequency tables",
           "and predictions extracted from raw text files."),
  tags$h6("* The left panel shows the word list returned by the search for the next word."),
  tags$h6("* Please, be aware that you must press the <space> key after each word in order to trigger the next prediction."),  
  
  
  absolutePanel(
  tags$h3("Using n-gram frequency tables"),  
  tags$h4("Type a sentence"),
  tags$style(type = "text/css", ".navbar {background-color: blue;}"),
  tags$div(HTML("<font color='blue'; size = 2 > Press &lt;space&gt; to get the predicted next word. Press a button to select a word. </font>")),
  tags$textarea(id="sentence", rows=4, cols=120, ""),
  #h6(textOutput("sentenceEntered", container=span)),  
  uiOutput("uiOutputPanel"),
  top = 170, left = 50, right = 10, bottom = 500, width = 600, height = 300, draggable = FALSE, 
  fixed = FALSE, cursor = c("auto", "move", "default", "inherit")),
  
  #h6(textOutput("sentenceEntered", container=span)),
  absolutePanel(
  tags$h3("Reading files stream"),  
  tags$h4("Type a sentence"),
  tags$style(type = "text/css", ".navbar {background-color: blue;}"),
  tags$div(HTML("<font color='blue'; size = 2 > Press &lt;space&gt; to get the predicted next word. Press a button to select a word. </font>")),  
  tags$textarea(id="sentence2", rows=4, cols=120, ""),
  uiOutput("uiOutputPanel2"),
  top = 430, left = 50, right = 10, bottom = 100, width = 600, height = 300, draggable = FALSE, 
  fixed = FALSE, cursor = c("auto", "move", "default", "inherit") ),
  tags$style(HTML("
                  body {
                  font-size: 16px;
                  background-color: #CEE3F6;
                  }
                  .span8 .well { 
                  background-color: #00FFFF; 
                  }
                ")
  ),
  
  absolutePanel(
    tags$h5("Words returned by the algorithm"),      
    wellPanel(
    #tags$textarea(id="sentenceEntered", rows=4, cols=120, ""),
    textOutput("sentenceEntered")),
    top = 100, left = 750, right = 100, bottom = 100, width = 250, height = 50, draggable = FALSE, 
    fixed = TRUE, cursor = c("auto", "move", "default", "inherit"))
  
))
