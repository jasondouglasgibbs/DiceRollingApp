##Shiny App to execute dice rolls.##
##Author: Jason Gibbs##

##Libraries##
library(shiny)
library(shinydashboard)
library(kableExtra)
library(plotly)
library(ggplot2)
library(tidyverse)

##Defines the UI.##
ui <- dashboardPage(skin="green",
                    
                    ##Application title.##
                    dashboardHeader(titleWidth=350, title = "Dice Rolling App"),
                    
                    ##Sidebar with inputs.##
                    dashboardSidebar(width=350,
                                     sidebarMenu(
                                       numericInput("number_of_rolls", "Number of Dice Rolls", value=1, min=1),
                                       numericInput("number_of_sides", "Number of Dice Sides", value=6, min=1),
                                       actionButton("button", "Roll the dice!")
                                     )
                                     
                    ),
                    
                    ##Body outputs.##
                    dashboardBody(tableOutput("SummaryDiceTable"), plotlyOutput("DicePlot"),tableOutput("DiceTable"))
)


##Server Logic##
server <- function(input, output) {
  
  ##Observes input to the action button and then executes dice rolling calculations##
  ##and output creations##.
  observeEvent(input$button,{
    
    ##Dice Rolling Script##
    
    ##Inputs.##
    number_of_sides<-input$number_of_sides
    number_of_rolls<-input$number_of_rolls
    
    
    ##Calculations and Result Output.##
    
    ##Creates a list of the possible outcomes, from 1 to the number of sides of the dice.##
    Result_Possibilities<-1:number_of_sides
    
    ##Creates a list of the probabilities of getting each result, each side has an equal probability##
    Dice_Probs<-rep(1/number_of_sides, number_of_sides)
    ##"Rolls the dice", creating a list of the dice rolls.##
    Results<-sample(x=Result_Possibilities, size=number_of_rolls, prob=Dice_Probs, replace=TRUE)
    ##Creates lists of various information to be added to the output.##
    Roll<-1:number_of_rolls
    Sides<-rep(number_of_sides, number_of_rolls)
    
    ##Creates the full output dataframe.##
    RollOutput<-data.frame(Roll, Sides, Results)
    
    ##Creates a summary output that shows the number of instances of each dice value.##
    Summary<-RollOutput %>% count(Results)
    Summary<-rename(Summary, Count = n)
    
    ##Summary Table Output##
    output$SummaryDiceTable<- renderText({
      kable(Summary, align = "c", caption="<span style='color: black;'><center><strong>Summary of Dice Rolls</strong></center></span>") %>%
        kable_styling(
          font_size = 15
        ) 
    }
    )
    
    ##Full Table Output##
    output$DiceTable<- renderText({
      kable(RollOutput, align = "c", caption="<span style='color: black;'><center><strong>Dice Rolls</strong></center></span>") %>%
        kable_styling(
          font_size = 15
        ) 
    }
    )
    
    ##Creates a plot of the count of each dice value. Adds a line showing the expected##
    ##count for each dice value.##
    RollOutput$Results<-as.factor(RollOutput$Results)
    DicePlot<-ggplot(RollOutput, aes(Results)) + geom_bar(fill="green") +
      geom_hline(aes(yintercept = number_of_rolls/number_of_sides), color="red")+
      annotate(geom="text", label="Expected Rolls", x=3, y=number_of_rolls/number_of_sides, vjust=-1)+
      ylab("Number of Rolls")+
      xlab("Dice Value")+
      ggtitle("Plot of Roll Results")+
      theme(plot.title = element_text(hjust = 0.5))
    
    DicePlot<-ggplotly(DicePlot)
    output$DicePlot<-renderPlotly(DicePlot)
    
    
  }
  
  )
  
}

## Runs the Shiny App.##
shinyApp(ui = ui, server = server)