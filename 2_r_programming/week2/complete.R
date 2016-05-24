complete <- function(directory, id=1:332) {
    
    ## Set working directory
    old_path <- getwd()
    new_path <- paste(old_path, directory, sep="/")
    setwd(new_path)
    
    ## define vector with files in current directory
    files <- dir()
    
    ## init matrix
    matrix <- c()

    ## 
    for(i in id){
        df <- read.csv(files[i], header = TRUE)
        n_complete <- complete.cases(df)
        s <- sum(n_complete)
        matrix <- rbind(matrix, c(i, s))
    }
    
    ## Return to project directory
    setwd(old_path)
    
    ## return 
    output_df <- as.data.frame(matrix)
    
    names(output_df) <- c('id', 'nobs')
    
    output_df
}