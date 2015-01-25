
library(combinat)
library(data.table)

load("preds.RData", .GlobalEnv) # my saved collection of predictive n-grams

maxPL <- 10 ## Maximum Phrase Length
maxPL <- 10 ## Maximum Phrase Length
maxN <- 5 ## Maximum number of grams
dfAnswers <- data.table(word = character(0), weight = numeric(0), freq = numeric(0))
vWeight <- c(0.2,0.4,0.6,0.8,1,0,0,0,0,0)
nextWord <- NULL

##-------------------------------------------

lookBigWord <- function(vPhrase){
  
  vTemp <- data.table(vPhrase[1:(maxPL-1)])
  setnames(vTemp, c("word"))
  vTemp <- vTemp[order(nchar(vTemp$word), decreasing=TRUE)]
  nextWord <- NULL
  
  print("BIG WORDS")
  
  ## Delimiting HERE  
  temp <- c(vTemp[1],vTemp[2])
  x <- permn(temp)
  
  z <- data.frame(gram1 = character(0), gram2 = character(0))
  z <- rbind(z, unlist(x[1]))
  z <- rbind(z, unlist(x[2]))    
  z$gram3 <- vPhrase[10]
  
  setnames(z, c("gram1","gram2", "gram3"))
  
  r1 <- tn4[J(z$gram1, z$gram2, unique(gram3)), nomatch = 0]
  r1$weight <- vWeight[as.numeric(4)]
  
  r2 <- tn5[J(z$gram1, z$gram2, z$gram3, unique(gram4)), nomatch = 0]
  r2$weight <- vWeight[as.numeric(5)]
  
  ## With 5
  temp <- c(vTemp[1],vTemp[2], vTemp[3])
  x <- permn(temp)
  
  z <- data.frame(gram1 = character(0), gram2 = character(0), gram3 = character(0))
  z <- rbind(z, unlist(x[1]))
  z <- rbind(z, unlist(x[2]))  
  z <- rbind(z, unlist(x[3]))  
  
  z$gram4 <- vPhrase[10]
  setnames(z, c("gram1","gram2","gram3", "gram4") )
  
  r3 <- tn5[J(z$gram1, z$gram2, z$gram3, unique(gram4)), nomatch = 0]
  r3$weight <- vWeight[as.numeric(5)]
  
  w1 <- 0
  w2 <- 0
  w3 <- 0
  vAnswer <- data.table(nextWord = character(0), weight = numeric(0), freq = numeric(0))
  
  
  if (nrow(r1) > 0) 
  {
    vAnswer <- rbind(vAnswer, list(r1$gram4, r1$weight, r1$freq))    
  }
  if (nrow(r2) > 0) 
  {
    vAnswer <- rbind(vAnswer, list(r2$gram5, r2$weight, r2$freq))    
  }
  if (nrow(r3) > 0) 
  {
    vAnswer <- rbind(vAnswer, list(r3$gram5, r3$weight, r3$freq))       
  }
  setnames(vAnswer, c("word","weight", "freq"))
  
  return(vAnswer)  
}

#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
lookBackward <- function(vPhrase, numGrams){
  vTemp <- replicate(10, "")
  vTemp <- vPhrase
  for (i in numGrams:1)
  {
    ngram <- as.character(i)
    switch(ngram, "2"  = vAnswer <- lookNgram(tn2, "2", vTemp),
           "3"  = vAnswer <- lookNgram(tn3, "3", vTemp),
           "4"  = vAnswer <- lookNgram(tn4, "4", vTemp),
           "5"  = vAnswer <- lookNgram(tn5, "5", vTemp)
    )  
    colnames <- names(dfAnswers)
    dfAnswers <- rbind(dfAnswers, vAnswer)
    setnames(dfAnswers, colnames)
  }
  
  if (nrow(dfAnswers) == 0)
  {
    nextWord = NULL
    return(nextWord)
  }else
  {
    nextWord <- dfAnswers
    return(nextWord)
  }
}

#-----------------------------------------------------------------------
#-----------------------------------------------------------------------

lookNgram <- function(ntable, ngram, vPhrase){
  r <- NULL
  switch(ngram, 
         "2"  = r <- ntable[J(vPhrase[10])],
         
         "3"  = {
           if (vPhrase[9] == '')
           {
             r <- ntable[J(unique(gram1), vPhrase[10]), nomatch = 0]
           }else
           {
             r <- ntable[J(vPhrase[9],vPhrase[10]), nomatch = 0]
           }
         },
         
         "4"  = {
           if ((vPhrase[8] == '') && (vPhrase[9] == ''))
           {
             r <- ntable[J(unique(gram1),unique(gram2), vPhrase[10]), nomatch = 0]
           }else
           {
             if (vPhrase[8] == '')
             {
               r <- ntable[J(unique(gram1),vPhrase[9], vPhrase[10]), nomatch = 0]
             }else
             {
               r <- ntable[J(vPhrase[8],vPhrase[9],vPhrase[10]), nomatch = 0]
             }
           }
         },
         
         "5"  = {
           if ((vPhrase[7] == '') && (vPhrase[8] == '') && (vPhrase[9] == ''))
           {
             r <- ntable[J(unique(gram1),unique(gram2),unique(gram3), vPhrase[10]), nomatch = 0]         
           } else
           {
             if ((vPhrase[7] == '') && (vPhrase[8] == ''))
             {
               r <- ntable[J(unique(gram1),unique(gram2),vPhrase[9], vPhrase[10]), nomatch = 0]
             }else
             {
               if (vPhrase[8] == '')
               {
                 r <- ntable[J(unique(gram1),vPhrase[8],vPhrase[9], vPhrase[10]), nomatch = 0]
               }else
               {
                 r <- ntable[J(vPhrase[7],vPhrase[8],vPhrase[9],vPhrase[10]), nomatch = 0]         
               }
             }
           }
         }
  )
  
  
  vAnswer <- data.table(word = character(0), weight = numeric(0), freq = numeric(0))
  
  if ( is.na(r$freq[1]) || (nrow(r)==0))
  {
    return(NULL)
  }  else
  {
    r <- r[order(r$freq, decreasing = TRUE)]
    r$weight <- vWeight[as.numeric(ngram)]    
    nextWord <- ''
    switch(ngram, 
           "2"  = {
             #nextWord <- r$gram2[1],
             vAnswer <- rbind(vAnswer, list(r$gram2, r$freq, r$weight))
           },
           "3"  = {
             #nextWord <- r$gram3[1]
             vAnswer <- rbind(vAnswer, list(r$gram3, r$freq, r$weight) )
           },
           "4"  = {
             #nextWord <- r$gram4[1]
             vAnswer <- rbind(vAnswer, list(r$gram4, r$freq, r$weight))             
           },
           "5"  = {
             #nextWord <- r$gram5[1]
             vAnswer <- rbind(vAnswer, list(r$gram5, r$freq, r$weight))
           }
    )
    return(as.data.table(vAnswer))
  }
}

#-----------------------------------------------------------------------
#-----------------------------------------------------------------------

predictor <- function(sentence)
{
  v <- unlist(strsplit(sentence, " "))
  l <- length(v)
  
  vSentence <- replicate(10, "")
  vPhrase <- replicate(10, "")
  
  if (l == maxPL)
  {
    for (i in 1:l)
    {
      vSentence[i] <- v[i]
    }
  }else if (l < maxPL)
  {
    dif <- maxPL - l
    for (i in l:1)
    {
      vSentence[i+dif] <- v[i]
    }
  } else
  {
    dif <- l - maxPL
    for (i in maxPL:1)
    {
      vSentence[i] <- v[i+dif]
    }    
  }
  
  nextWord <- NULL
  vPhrase <- vSentence[(length(vSentence) - maxPL + 1): (length(vSentence))]
  
  if (l < maxN)  ngram <- as.character(l + 1)
  else ngram <- "5"
  
  switch(ngram,  "2"  = nextWord <- lookNgram(tn2, "2", vPhrase),
         "3"  = nextWord <- lookNgram(tn3, "3", vPhrase),
         "4"  = nextWord <- lookNgram(tn4, "4", vPhrase),
         "5"  = nextWord <- lookNgram(tn5, "5", vPhrase))
  
  if (is.null(nextWord) && (l > 2))
  {
    dfAnswers <- data.table(word = character(0), weight = numeric(0), freq = numeric(0))      
    vTemp <- replicate(10, "")
    vTemp <- vPhrase      
    
    if ((l-1) < maxN)  ngram <- as.character(l - 1)
    else ngram <- "5"
    
    nextWord <- lookBackward(vTemp, ngram)
    if (is.null(nextWord) || (nextWord == "the"))
    { 
      nextWord <- lookBigWord(vPhrase)
    }
  }
  
  if (is.null(nextWord) || nrow(nextWord) == 0) 
  {
    nextWord <- data.table(word = "the", weight = 1, freq = 1)      
  } else
  {
    nextWord$value <- as.numeric(nextWord$weight) * as.numeric(nextWord$freq)    
    nextWord <- nextWord[order(nextWord$freq, decreasing = TRUE)]
    nextWord <- unique(nextWord[,list(word,weight, freq,value)])  
    nextWord <- nextWord[,list(value=sum(value)), by=word]
  }
  
  return(nextWord)
}


##-----------------------------------------------------------------

shinyServer(function(input, output, session) {
  
  output$uiOutputPanel <- renderUI({
    
    # Just the act of reading input$sentence will cause this block to re-execute
    sentenceToParse <- tolower(input$sentence)
    if (sentenceToParse != "")
    {
        answers <- predictor(sentenceToParse)
        word1 <- "The"
        word2 <- "next"
        word3 <- "word"
        
        word1 <- answers$word[1]
        if (nrow(answers) > 1) word2 <- answers$word[2]
        if (nrow(answers) > 2) word3 <- answers$word[3]
        
        ##print(word1)
        
        button1Click <- paste("$('#sentence').val($('#sentence').val() + ' ", word1, "').trigger('change')", sep='')
        button2Click <- paste("$('#sentence').val($('#sentence').val() + ' ", word2, "').trigger('change')", sep='')
        button3Click <- paste("$('#sentence').val($('#sentence').val() + ' ", word3, "').trigger('change')", sep='')
        
        tags$div(
          tags$button(type="button", id="word1", word1, class="btn action-button shiny-bound-input", onclick=button1Click),
          tags$button(type="button", id="word2", word2, class="btn action-button shiny-bound-input", onclick=button2Click),
          tags$button(type="button", id="word3", word3, class="btn action-button shiny-bound-input", onclick=button3Click)
        )
    }
  })
  
  output$sentenceEntered <- renderText({input$sentence})
})
