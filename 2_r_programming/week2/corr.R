corr <- function(directory, threshold = 0) {
    
    v_nobs <- complete(directory)$nobs  > threshold
    
    old_path <- getwd()
    new_path <- paste(old_path, directory, sep="/")
    setwd(new_path)
    
    files <- dir()[v_nobs]
    
    output <- c()
    
    if(length(files)>0) {
      for(i in 1:length(files)){
        df <- read.csv(files[i], header = TRUE)
        df <- df[complete.cases(df), ]
        
        output <- c(output, cor(df$sulfate, df$nitrate))
      }
      
      setwd(old_path)
      
      output
    } else {
      
      setwd(old_path)
      
      output
    }
}