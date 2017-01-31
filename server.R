library(shiny)
library(shinydashboard)
library(plotly)

data <- read.delim("export.txt", sep = "\t")

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

colours <- c("#FE7C00", "#FFD832", "#00B4AB", "#FE7C00", "#FF5E97",
             "#0269A4", "#852CBA", "#CC2C04", "#1BAADD", "#80CB17",
             "#FE7C00", "#00B4AB", "#FFD832", "#FE7C00", "#FF5E97",
             "#0269A4", "#852CBA", "#CC2C04", "#1BAADD", "#80CB17",
             "#FE7C00", "#00B4AB")

shinyServer(function(input, output) {
  
  output$Plotly <- renderPlotly({
    p <- plot_ly(data, x = data[,as.numeric(input$xaxis)],
                 y = data[,as.numeric(input$yaxis)],
                 size = data[,as.numeric(input$size)],
                 color = as.factor(data[,as.numeric(input$colour)]),
                 colors = c("#C8C8C8", colours[which(colourOptions == as.numeric(input$colour))]),
                 type = "scatter", mode = "markers",
                 marker = list(opacity = 0.8, sizemode = "area", sizeref = 0.5),
                 hoverinfo = "text",
                 text = ~Title)
    p <- layout(p,
                font = list(family = "Segoe UI, Arial, Sans-serif"),
                title = "Top 200 movies from the 2016 box office",
                xaxis = list(title = paste(names(axisOptions[axisOptions == as.numeric(input$xaxis)])), fixedrange = TRUE,
                             showgrid = FALSE, showline = FALSE, zeroline = FALSE),
                yaxis = list(title = paste(names(axisOptions[axisOptions == as.numeric(input$yaxis)])), fixedrange = TRUE,
                             showgrid = FALSE, showline = FALSE, zeroline = FALSE),
                showlegend = FALSE) %>%
      config(displayModeBar = FALSE) 
    p
  })
  
}
)
