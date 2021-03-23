library(devtools)
library(rems)
library(tidyverse)


dataTable <- read_csv("rs_1.csv", skip = 1, col_names = FALSE)
view(dataTable)

rainIsTrue <- 0
acceptedSamplesSoFar <- 0
numRows = nrow(dataTable[1])
x <- 1:numRows
y <- 1:numRows
lowerError <- rep(0, numRows)
upperError <- rep(1, numRows)


# for each value in the first column X1
for(rowNum in 1:numRows){
  
  if(dataTable[rowNum, 1] == 1){
    rainIsTrue <- rainIsTrue + 1;
    acceptedSamplesSoFar <- acceptedSamplesSoFar+ 1
  } else if (dataTable[rowNum, 1] == 2){
    acceptedSamplesSoFar <- acceptedSamplesSoFar+ 1
  }
  
  y[rowNum] <- rainIsTrue/acceptedSamplesSoFar
  error <- sqrt(log(2/0.05)/(2*acceptedSamplesSoFar))
  lowerError[rowNum] <- y[rowNum] - error
  upperError[rowNum] <- y[rowNum] + error
  
}

# print(rainIsTrue)
# print(acceptedSamplesSoFar)
# print(y)


plot(x, y, ylim=c(0,1), xlab="Used Samples", ylab="P (r | s, w)", type = "lines", log = "x")
lines(x, lowerError, type = "lines", col = "blue", log = "x")
lines(x, upperError, type = "lines", col = "red", log = "x")

view(newGraph)
