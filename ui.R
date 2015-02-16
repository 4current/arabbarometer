
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
                                  "Sex" = "sex"),
                                selected="age"
                    ),
                    selectInput('param2',
                                "Chart 2 Parameter",
                                c("Age" = "age",
                                  "Education" = "education",
                                  "Married" = "married",
                                  "Religion" = "religion",
                                  "Employed" = "employed",
                                  "Sex" = "sex"),
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
            sidebarLayout(
                sidebarPanel(
                    sliderInput(
                        "trainFraction",
                        "Fraction for Training Set",
                        min=0,
                        max=1,
                        value=.6
                        ),
                    actionButton("doIt", "Run")
                    ),
                mainPanel(
                    tableOutput('trainingStats')
                     )
            ) # End sidebarLayout
        ) # End tabPanel
    ) # End navbarPage
) # End shinyUI
