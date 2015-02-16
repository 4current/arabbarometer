
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(caret)
source("getData.R")

training <- data.frame()

graph1 <- function(param, country) {
    subSet <- cleanData[cleanData$country==country,]
    subSet$tmp_var <- subSet[[param]]
    
    p <- ggplot(data=subSet, aes(x=tmp_var, y=(..count..)/sum(..count..))) +
        geom_bar(aes(fill=tmp_var)) + 
        xlab(param) +
        ylab("fraction") +
        labs(title=paste('Fraction by', param, 'for', country)) +
        guides(fill=guide_legend(title=param))
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
    
    output$trainingStats <- renderTable ({

        # model calculations go here
        pool <- cleanData[complete.cases(cleanData),]
        inTrain <- createDataPartition(pool$internet,
                                       p=input$trainFraction,
                                       list=FALSE)
        training <<- pool[inTrain,]
        testing <<- pool[-inTrain,]
        
        summary(training)
    })
    
    }
)
