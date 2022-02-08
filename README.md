# Dice Rolling App and Script

This repository contains a Shiny App and R script that simulates rolling dice.

## Shiny App

The app is hosted on Shinyapps.io [here](https://jasondouglasgibbs.shinyapps.io/DiceRollingApp/). The app allows the user to input the desired number of sides for the dice, as well as the number of rolls they want to make. The app provides a summary table, telling the user how many of each dice value they rolled, as well as a plot showing the expected number of rolls. The final output is a roll by roll table showing each individual roll.

## Script

The script follows the same methodology as the Shiny App. The user inputs dice side number to the variable "number_of_sides" and the number of rolls to the variable "number_of_rolls". Running the entire script will provide a plotly graph in the viewer, showing the number of rolls for each dice value, as well as a table outputted to the console.
