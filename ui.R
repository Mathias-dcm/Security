#install.packages("tidyverse")
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(tidyverse)


ui <- fluidPage(
  titlePanel("Projet"),
  
  
  sidebarLayout(
    #loading message
    sidebarPanel(
      tags$head(tags$style(type="text/css", "
             #loadmessage {
               position: fixed;
               top: 0px;
               left: 0px;
               width: 100%;
               padding: 5px 0px 5px 0px;
               text-align: center;
               font-weight: bold;
               font-size: 100%;
               color: #000000;
               background-color: #CCFF66;
               z-index: 105;
             }
          ")),
      conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                       tags$div("Loading...",id="loadmessage")),
      #side panel 1
      conditionalPanel(condition="input.tabselected==1",
                       helpText("Analyse des ports UDP et TCP"),
                       hr(),
                      checkboxGroupInput("port", label = h3("Port"), 
                         choices = list("UDP" = 1, "TCP" = 2),
                         selected = 1))),
      
      mainPanel(
        tabsetPanel(
          tabPanel("Analyse des ports", plotOutput("freqPlot"), value = 1,  
                   conditionalPanel(condition="input.tabselected==1")),
          id = "tabselected")
      )
    )
  
)

