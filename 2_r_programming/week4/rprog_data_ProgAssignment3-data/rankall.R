rankall <- function(outcome, num = "best") {
  ## Read outcome data
  df <- read.csv("outcome-of-care-measures.csv", 
                 colClasses = "character", nrows = 4710L)
  
  states <- unique(df$State)
  
  matrix <- c()
  
  for (state in states){
    output <- rankhospital(state, outcome, num)
    matrix <- rbind(matrix, c(output, state))
  }
  
  output_df <- as.data.frame(matrix)
  names(output_df) <- c('hospital', 'state')
  sorted_df <- output_df[ order(output_df$state, output_df$hospital), ]
  sorted_df
}