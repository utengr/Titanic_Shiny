library(shiny)
library(ggplot2)
library(rpart)
library(party)


shinyUI(pageWithSidebar(
  headerPanel(""),
  sidebarPanel(
    helpText("Titanic Surviver Data Set"),
    helpText("VARIABLE DESCRIPTIONS:"),
    helpText("pclass = Passenger Class(1 = 1st; 2 = 2nd; 3 = 3rd)"),
    helpText("survival = Survival (0 = No; 1 = Yes) "),
    helpText("name = Name "),
    helpText("sex = Sex "),
    helpText("age = Age "),
    helpText("sibsp = Number of Siblings/Spouses Aboard "),
    helpText("parch = Number of Parents/Children Aboard "),
    helpText("ticket = Ticket Number "),
    helpText("fare = Passenger Fare "),
    helpText("cabin = Cabin "),
    helpText("embarked = Port of Embarkation(C = Cherbourg; Q = Queenstown; S = Southampton) "),
    helpText("boat = Lifeboat "),
    helpText("body = Body Identification Number "),
    helpText("home.dest = Home/Destination "),
    uiOutput("choose_Xcol"),
    uiOutput("choose_Ycol"),
    uiOutput("choose_Group"),
    helpText("Jittering the points will add noise to the data so you can visualize overlapping points."),
    uiOutput("choose_Jitter"),
    helpText(""),
    helpText("The Decision Tree Shows the % Survival Rate at the Bottom"),
    helpText("n is the number of passengers that followed that 'path'"),
    helpText("The dark portion is the % that survived")
  ),

  mainPanel(
    h3(textOutput('caption')),
    tabsetPanel(
      #tableOutput("data_table")
      tabPanel("Data", dataTableOutput("filetable")),
	  tabPanel("Stats", tableOutput("stattable")),
      tabPanel("Exploration", plotOutput("plot", height = 600)),
      tabPanel("Decision Tree", plotOutput("tree", height = 1000))
    )
   )
  )
)