
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(markdown)

shinyUI(
    navbarPage(
        "Peer Review Project for devdataprod-011",
        tabPanel(
            "Rubric",
            includeMarkdown("Rubric.md")
        ), # End tabPanel 
        tabPanel(
            "Problem Selection",
            includeMarkdown("Description.md")
        ), # End tabPanel
        tabPanel(
            "Exploration",
            sidebarLayout(
                sidebarPanel(
                    radioButtons(
                        "Country",
                        "Survey Country:",
                        c("Jordan", "Palestine", "Algeria", "Morroco",
                          "Lebanon", "Yemen")
                    ),
                    selectInput('param1',
                                "Chart 1 Parameter",
                                c("Age" = "age",
                                  "Education" = "education",
                                  "Married" = "married",
                                  "Religion" = "religion",
                                  "Employed" = "employed",
                                  "Sex" = "sex",
                                  "Internet" = "internet"),
                                selected="age"
                    ),
                    selectInput('param2',
                                "Chart 2 Parameter",
                                c("Age" = "age",
                                  "Education" = "education",
                                  "Married" = "married",
                                  "Religion" = "religion",
                                  "Employed" = "employed",
                                  "Sex" = "sex",
                                  "Internet" = "internet"),
                                selected="education"
                    ),                    
                    hr(),
                    helpText("Data from Arab Barometer (2006-2007)")
                ),
                mainPanel(
                    plotOutput('bar'),
                    textOutput('param1'),
                    hr(),
                    plotOutput('bar2')
                )
            ) # End sidebarLayout
        ), # End tabPanel
        tabPanel(
            "Application",
            verticalLayout(
                sidebarLayout(
                    sidebarPanel(
                        sliderInput(
                            "trainFraction",
                            "Fraction for Training Set",
                            min=0,
                            max=1,
                            value=.6
                        ),
                        actionButton("doIt", "Redo Training"),
                        hr(),
                        helpText("Change the proportion of data you
                             would like to use for training and submit.
                             to re-calculate the decision tree.")
                        
                    ),
                    
                    mainPanel(
                        plotOutput('classificationTree')
                    )
                ), # End sidebarLayout
                hr(),
                sidebarLayout(
                    sidebarPanel(
                        actionButton('testPrediction', 'Test Prediction'),
                        hr(),
                        helpText("Press the Test Prediction button
                                to see how accurate the model is.")                        
                    ),
                    mainPanel(
                        tableOutput("predictResults"),
                        splitLayout(
                            tableOutput("predictOverall"),
                            tableOutput("predictClass")
                        )
                    )
                ) # End sidebarLayout
            ) # End of verticalLayout
        ) # End tabPanel
    ) # End navbarPage
) # End shinyUI
