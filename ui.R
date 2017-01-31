library(shiny)
library(shinydashboard)
library(plotly)

axisOptions <- list("Worldwide Gross ($m)" = 4, "Domestic Gross ($m)" = 5,
                    "Metascore" = 10, "IMDb rating" = 11,
                    "Rotten Tomatoes critic meter" = 13,
                    "Rotten Tomatoes user meter" = 18)

sizeOptions <- list("Worldwide Gross ($m)" = 4, "Domestic Gross ($m)" = 5,
                    "IMDb number of votes" = 12, "Rotten Tomatoes number of critic ratings" = 14,
                    "Rotten Tomatoes number of user ratings" = 20)

colourOptions <- list("Golden Globes Nominees / Winners" = 21,
                      "Action" = 22, "Adventure" = 23, "Animation" = 25,
                      "Biography" = 34,"Comedy" = 26, "Crime" = 35, "Documentary" = 43,
                      "Drama" = 27, "Family" = 28, "Fantasy" = 29, "History" = 37,
                      "Horror" = 31, "Music" = 42, "Musical" = 39, "Mystery" = 32,
                      "Sci-Fi" = 24, "Sport" = 40, "Thriller" = 30,
                      "Romance" = 33, "War" = 38, "Western" = 36)
shinyUI(dashboardPage(
  dashboardHeader(title = "seestats"),
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "imdbapp.css")
    ),
    
    fluidRow(
      column(width = 4,
             box(width = 12, status = "warning",
                 selectInput("xaxis", label = "X-axis",
                             choices = axisOptions, selected = 11),
                 selectInput("yaxis", label = "Y-axis",
                             choices = axisOptions, selected = 13),
                 selectInput("size", label = "Size",
                             choices = sizeOptions, selected = 4),
                 selectInput("colour", label = "Highlight",
                             choices = colourOptions, selected = 21))
      ),
      column(width = 8,
             box(width = 12,
                 plotlyOutput("Plotly", height = "500px")))
    )
  )
)
)