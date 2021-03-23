library(devtools)
library(rems)
library(tidyverse)
library(ggplot2)

dataTable <- read_csv("lw_1.csv", col_names = FALSE)
view(dataTable)

acceptedWeightSum <- 0
sumOfWeights <- 0
numRows = nrow(dataTable[2])
x <- 1:numRows
y <- 1:numRows

# for each value in the first column X1
for(rowNum in 1:numRows){
  
  if(dataTable[rowNum, 1] == 1){
    acceptedWeightSum <- acceptedWeightSum + dataTable[rowNum, 2];
    sumOfWeights <- sumOfWeights + dataTable[rowNum, 2];
  } else if (dataTable[rowNum, 1] == 2){
    sumOfWeights <- sumOfWeights + dataTable[rowNum, 2];
  }
  
  y[rowNum] <- acceptedWeightSum/sumOfWeights
  
}

# print(rainIsTrue)
# print(acceptedSamplesSoFar)
# print(y)


newGraph <- plot(x, y,xlab="Used Samples", ylab="P (r | s, w)", type = "lines", log ="x")
view(newGraph)
