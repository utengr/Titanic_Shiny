library(shiny)
library(ggplot2)
library(rpart)
library(party)

rawdata <- read.csv("titanic.csv", header=T, stringsAsFactors = F)
rawdata[,1] <- as.factor(rawdata[,1])
rawdata[,2] <- as.factor(rawdata[,2])
rawdata[,4] <- as.factor(rawdata[,4])
rawdata[,6] <- as.factor(rawdata[,6])
rawdata[,7] <- as.factor(rawdata[,7])
rawdata[,11] <- as.factor(rawdata[,11])

tree.titanic <- ctree(survived ~ pclass + sex + age + sibsp + parch + fare, data = rawdata)


shinyServer(function(input, output) {
   #Upload Data
     Data <- reactive({
       colnames <- names(rawdata)
       info <- list(rawdata=rawdata, colnames=colnames)
       return(info)
       })

   #Create summary of data showing Head and Tail
     output$filetable <- renderDataTable({
         tmp <- Data()$rawdata
     })

   #Create Summary Statistics of Data
     output$stattable <- renderTable({
     summary(Data()$rawdata)
     })

  # Pick X Value Dropdown
      output$choose_Xcol <- renderUI(function() {
        # Populate X Variable Dropdown with Column Name
        selectInput("columns", "Choose X Value",
            choices = Data()$colnames, selected = Data()$colnames[4],
            multiple = FALSE)
        })
    
  # Pick Y Value Dropdown
      output$choose_Ycol <- renderUI(function() {
        # Populate Y Variable Dropdown with Column Names
        selectInput("ycolumns", "Choose Y Values",
            choices = Data()$colnames, selected = Data()$colnames[1],
            multiple = FALSE)
        })
        
  # Pick Group Dropdown
      output$choose_Group <- renderUI(function() {
        #Populate Group VAriable Dropdown with Column Names
        selectInput("groups", "Choose Group Value",
            choices = Data()$colnames, selected = Data()$colnames[2],
            multiple = FALSE)
        })

  # Choose Jitter or Not
      output$choose_Jitter <- renderUI(function() {
        #Create the Checkbox for Jittering the Points and set to False
        checkboxInput("jitter", "Jitter the Points", FALSE)
         })


  # Take all the inputs and generate the appropriate plot
      output$plot <- renderPlot(function() {
        xval <- Data()$rawdata[,input$columns]
        yval <- Data()$rawdata[,input$ycolumns]
        groupval <- Data()$rawdata[,input$groups]
        if (input$jitter == TRUE) (
          p <-(qplot(xval, yval, data = Data()$rawdata, color = factor(groupval), geom = "jitter", size = 10) + labs( x = input$columns, y = input$ycolumns, color = input$groups, title = "Titanic.csv"))
          )
        else (
          p <-(qplot(xval, yval, data = Data()$rawdata, color = factor(groupval), size = 10) + labs( x = input$columns, y = input$ycolumns, color = input$groups, title = "Titanic.csv"))
          )
        print(p + scale_size(guide = 'none'))
        })
        
  # Decision Tree on Select Parameters for Survival
      output$tree <- renderPlot(function() {
        plot(tree.titanic)
        })
})