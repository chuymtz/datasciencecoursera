best <- function(state, outcome) {
    
    ## Read outcome dat
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
    min_index <- new_df$rate == min(new_df$rate)

    ## Return hospital name in that state with lowest 30-day death
    ## rate
    output <- sort(as.vector(new_df$`h name`[min_index]))[[1]]
    output
}