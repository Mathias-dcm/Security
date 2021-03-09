#install.packages("tidyverse")
#install.packages("DT")
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(tidyverse)
library(DT)
library(scales)


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
                       helpText("Analyse des protocoles UDP et TCP"),
                       hr(),
                      checkboxGroupInput("proto", label = h3("Protocole"), 
                         choices = c("UDP", "TCP"), selected=c("TCP","UDP")),
                      checkboxGroupInput("action", label = h3("Action"), 
                                         choices = c("PERMIT", "DENY"), selected=c("PERMIT","DENY")),
                      radioButtons("port", label = h3("RFC 6056"), 
                                         choices = list("Tout"=1,"The Well-Known Ports" =2,"The Registered Ports" = 3, "The Dynamic and/or Private Ports" =4), 
                                         selected=1)),
      
      conditionalPanel(condition="input.tabselected==2",
                       helpText("Analyse des données"),
                       hr(),
                       checkboxGroupInput("proto2", label = h3("Protocole"), 
                                          choices = c("UDP", "TCP"), selected=c("TCP","UDP")),
                       checkboxGroupInput("action2", label = h3("Action"), 
                                          choices = c("PERMIT", "DENY"), selected=c("PERMIT","DENY"))),
                       
      conditionalPanel(condition="input.tabselected==3",
                       helpText("Visualisation intéractive des données"),
                       hr(),
                       #   checkboxGroupInput("proto3", label = h3("Protocole"), 
                       #                      choices = c("UDP", "TCP"), selected=c("TCP","UDP")),
                       #   checkboxGroupInput("action3", label = h3("Action"), 
                       #                      choices = c("PERMIT", "DENY"), selected=c("PERMIT","DENY"))
                       sliderInput("k1", "choisir l'indice ", 
                                   min=1, max= 250, value=1, step = 1),),
      
      conditionalPanel(condition="input.tabselected==4",
                       helpText("statistiques relatives au TOP 5 des IP sources les plus émettrices, TOP 10 des ports inférieurs à 1024 avec un accès autorisé"),
                       hr(),
                      checkboxGroupInput("proto4", label = h3("Protocole"), 
                                         choices = c("UDP", "TCP"), selected=c("TCP","UDP")),
                      checkboxGroupInput("action4", label = h3("Action"), 
                                         choices = c("PERMIT", "DENY"), selected=c("PERMIT","DENY")))
              ), #sidebar panel,
      
      mainPanel(
        tabsetPanel(
          tabPanel("Analyse des ports", plotOutput("freqProto"), 
                   fluidRow(
                     column(6,plotOutput("pieProto")),
                     column(6,DT::dataTableOutput("tabProto"))),
                   value = 1,  
                   conditionalPanel(condition="input.tabselected==1")),
          tabPanel("Analyse des données",
                   DT::dataTableOutput("tabData"),
                   value = 2,  
                   conditionalPanel(condition="input.tabselected==2")),
          tabPanel("Visualisation intéractive",
                   fluidRow(column(6, plotOutput("visa")), column(6,DT::dataTableOutput("tabvisa"))),
                   value = 3,  
                   conditionalPanel(condition="input.tabselected==3")),
          tabPanel("TOP IP/PORT",
                   fluidRow(
                     column(6,plotOutput("plotTop")),
                     column(6,plotOutput("plotTop10"))),
                   tableOutput("tabport"),
                   value = 4,  
                   conditionalPanel(condition="input.tabselected==4")),
          id = "tabselected")
      ) #Main panel
  ) #Sidebar layout
  
) #fluidpage

