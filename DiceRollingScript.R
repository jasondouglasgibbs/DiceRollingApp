##Dice Rolling Script##
library(tidyverse)
library(ggplot2)
library(plotly)
##Inputs##
number_of_sides<-6
number_of_rolls<-18


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
RollOutput<-rename(RollOutput, `Dice Value` = Results)

##Creates a summary output that shows the number of instances of each dice value.##
Summary<-RollOutput %>% count(`Dice Value`)
Summary<-rename(Summary, Count = n)

##Creates a data frame to preserve dice values that aren't rolled.##
SummaryDF_DV<-1:number_of_sides
SummaryDF_Count<-rep(0, number_of_sides)
SummaryDF<-data.frame(SummaryDF_DV, SummaryDF_Count)

##For loop that fills in the new data frame based on the rolls.##
for(i in 1:nrow(Summary)){
  for(j in 1:nrow(SummaryDF)){
    if(Summary[i,1]==SummaryDF[j,1]){
      SummaryDF[j,2]<-Summary[i, 2]
    }else{
      next
    }
  }
}


SummaryDF<-rename(SummaryDF, `Dice Value` = SummaryDF_DV)
SummaryDF<-rename(SummaryDF, Count = SummaryDF_Count)



##Creates a plot of the count of each dice value. Adds a line showing the expected##
##count for each dice value.##
DicePlotDF_DV<-1:number_of_sides
DicePlotDF_Count<-rep(0, number_of_sides)
DicePlotDF<-data.frame(DicePlotDF_DV, DicePlotDF_Count)
for(i in 1:nrow(Summary)){
  for(j in 1:nrow(DicePlotDF)){
    if(Summary[i,1]==DicePlotDF[j,1]){
      DicePlotDF[j,2]<-Summary[i, 2]
    }else{
      next
    }
  }
}

DicePlotDF<-rename(DicePlotDF, `Dice Value` = DicePlotDF_DV)
DicePlotDF<-rename(DicePlotDF, Count = DicePlotDF_Count)
DicePlot<-ggplot(DicePlotDF, aes(x=`Dice Value`, y=Count)) + geom_bar(fill="green", color="green", stat="identity") +
  geom_hline(aes(yintercept = number_of_rolls/number_of_sides, linetype="Expected Rolls"), color="red")+
  ylab("Number of Rolls")+
  xlab("Dice Value")+
  scale_x_continuous(breaks = seq(1, number_of_sides, by = 1))+
  scale_y_continuous(breaks = seq(0, max(RollOutput$Roll), by = 1))+
  ggtitle("Plot of Roll Results")+
  labs(linetype='')+
  theme(plot.title = element_text(hjust = 0.5))

DicePlot<-ggplotly(DicePlot)

##Displays the final plot and prints the summary dataframe to the console.##
DicePlot
SummaryDF