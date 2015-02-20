
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(caret)
library(rattle)
library(rpart)
library(rpart.plot)
library(data.table)
library(e1071)
source("getData.R")

graph1 <- function(param, country) {
    subSet <- cleanData[cleanData$country==country,]
    subSet$tmp_var <- subSet[[param]]
    
    p <- ggplot(data=subSet, aes(x=tmp_var, y=(..count..)/sum(..count..),
                                 fill=internet)) +
        geom_bar(position=position_dodge()) + 
        xlab(param) +
        ylab("fraction") +
        labs(title=paste('Fraction by', param, 'for', country))
    print(p)
}

shinyServer(
    function(input, output) {
        
        output$bar <- renderPlot({
            
            # draw the histogram with the specified number of bins
            graph1(input$param1, input$Country)
        })
        
        output$bar2 <- renderPlot({
            
            # draw the histogram with the specified number of bins
            graph1(input$param2, input$Country)
        })
        
        
        
        output$classificationTree <- renderPlot ({
            
            input$doIt
            set.seed(3319)
            inTrain <- createDataPartition(cleanData$internet,
                                           p=isolate(input$trainFraction),
                                           list=FALSE)
            training <<- cleanData[inTrain,]
            testing <<- cleanData[-inTrain,]
            modFit <<- train(internet ~ ., method='rpart', data=training)
            
            fancyRpartPlot(modFit$finalModel,
                           main="Internet User Class Tree",
                           sub=NULL)
        })
        
        
        confusion <- reactive({
            input$testPrediction
            pred <- predict(isolate(modFit), newdata=isolate(testing))        
            confusionMatrix(pred, isolate(testing$internet))
        })
        
        output$predictResults <- renderTable({
            confusion()$table
        })
        
        output$predictOverall <- renderTable({
            as.matrix(confusion()$overall)
        })
        
        output$predictClass <- renderTable({
            as.matrix(confusion()$byClass)
        })
        
    })
