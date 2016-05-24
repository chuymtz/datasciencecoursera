pollutantmean <- function(directory, pollutant, id=1:332) {
    
    ## Set working directory
    old_path <- getwd()
    new_path <- paste(old_path, directory, sep="/")
    setwd(new_path)
    
    ## define vector with files in current directory
    files <- dir()
    
    ## Define file column based on pollutatnt
    if (pollutant == 'nitrate') {
        p <- 3
    } else if (pollutant == 'sulfate') {
        p <- 2
    } else {
        print('Not a pollutant')
    }
    
    ## initiate vector to calculate mean
    mean_vec <- c()
    
    ## loop through director
    ## extract pollutat vector 
    ## concat all these into mean_vec vector
    for(i in id){
        vec <- read.csv(files[i], header = TRUE)[,p]
        mean_vec <- c(mean_vec, vec)
    }
    
    ## Return to project directory
    setwd(old_path)
    
    ## Compute and return mean of mean_vec and remove NAs
    mean(mean_vec, na.rm = TRUE)
}