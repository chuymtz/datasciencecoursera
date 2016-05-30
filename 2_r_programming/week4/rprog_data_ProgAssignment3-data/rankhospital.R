rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
    df <- read.csv("outcome-of-care-measures.csv", 
                   colClasses = "character", nrows = 4710L)
    
    ## Check that state and outcome are valid
    if (outcome == 'heart attack'){
        id <- 11
    } else if (outcome == 'heart failure'){
        id <- 17
    } else if (outcome == 'pneumonia'){
        id <- 23
    } else {
        stop('invalid outcome')
    }
    
    if (sum(df$State == state) == 0) {
        stop('invalid state')
    }
    
    df_state <- df[df$State == state, ]
    new_df <- data.frame(as.character(df_state$Hospital.Name), as.numeric(df_state[[id]]))
    names(new_df) <- c('h name', 'rate')
    new_df <- new_df[complete.cases(new_df), ]
    sorted_df <- new_df[ order(new_df$rate, new_df$`h name`), ]
    
    output <- sorted_df[num, 1][[1]]
    
    if (num == 'best') {
        output <- as.vector(sorted_df$`h name`)[[1]]
    } else if (num == 'worst') {
        output <- as.vector(sorted_df$`h name`)[[length(sorted_df$`h name`)]]
    } else if (num <= length(sorted_df$`h name`)) {
        output <- as.vector(sorted_df$`h name`)[[num]]
    } else {
        output <- NA
    }
    
    output
    
}