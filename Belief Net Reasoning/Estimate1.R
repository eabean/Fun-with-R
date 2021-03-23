library(devtools)
library(rems)
library(tidyverse)
library(ggplot2)

dataTable <- read_csv("rs_1.csv", skip = 1, col_names = FALSE)
view(dataTable)

rainIsTrue <- 0
acceptedSamplesSoFar <- 0
numRows = nrow(dataTable[1])
x <- 1:numRows
y <- 1:numRows


for(rowNum in 1:numRows){
  
  if(dataTable[rowNum, 1] == 1){
    rainIsTrue <- rainIsTrue + 1;
    acceptedSamplesSoFar <- acceptedSamplesSoFar+ 1
  } else if (dataTable[rowNum, 1] == 2){
    acceptedSamplesSoFar <- acceptedSamplesSoFar+ 1
  }
  
  y[rowNum] <- rainIsTrue/acceptedSamplesSoFar
  
}

# print(rainIsTrue)
# print(acceptedSamplesSoFar)
# print(y)

 
newGraph <- plot(x, y,xlab="Used Samples", ylab="P (r | s, w)", type = "lines", log ="x")
#view(newGraph)
