library(shiny)

shinyUI(fluidPage(
    # title
    fluidRow(
        column(10, h1("Storm Data across the USA 1950-2011"))
    ),
    
    # first paragraph
    fluidRow(
        column(10,
               h3("Top 10 Harm"),
               p("This app shows the top 10 harm done by severe weather events in the USA. Data ranges from 1950 to 2011."),
               p("The data comes from the Coursera module Reproducible Research or can be obtained from ",
                a("NOAA", href="https://www.ncdc.noaa.gov/stormevents/details.jsp"),".", br(), 
                "Choose year or event and a category to show the top 10."),
               p("Amount of damage is given in billions.")
               )
    ),
    
    # plotting section
    fluidRow(
        column(10,
               plotOutput("vPlot", height = "300px"))
    ),
    
    # selections input
    fluidRow(
        column(10, style="background-color:#f5f5f5; margin:0 15px",
               p("Selections", style="text-align:center;font-size:1.3em"),
               fluidRow(
        column(3,
               p("Year or Event", style="text-align:center"),
               selectInput("vGroup", NULL, c("Eventtype", "Year"))
               ),
        column(3, 
               p("Category:", style="text-align:center"),
               selectInput("vColumn", NULL, c("Total damage",
                                                   "Crop damage",
                                                   "Property damage",
                                                   "Injuries",
                                                   "Fatalities"))
               ),
        column(2, 
               p(HTML("&nbsp;"), style="text-align:center"),
               actionButton("vActie", "Submit")
               )
    ))),
    
    # table section
    fluidRow(
        column(10,
               tableOutput("Type"),
               p(em("Published on 2 Feb 2018"), style="font-size:0.75em;text-align:center")
               )
    )
))
