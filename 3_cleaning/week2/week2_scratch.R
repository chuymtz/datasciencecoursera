# week2 SCRATCH R file

# http://biostat.mc.vanderbilt.edu/wiki/Main/RMySQL

install.packages('RMySQL', type = "source")
install.packages('RMySQL')
library(RMySQL)

ucscDb <- dbConnect(MySQL(), user='genome',
                    host='genome-mysql.cse.ucsc.edu')

result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb)

head(result)

hg19 <- dbConnect(MySQL(),
                  user='genome',
                  db='hg19',
                  host='genome-mysql.cse.ucsc.edu')
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

dbListFields(hg19,'affyU133Plus2')

dbGetQuery(hg19, 'select count(*) from affyU133Plus2')

affyData <- dbReadTable(hg19, 'affyU133Plus2')
head(affyData)

query <- dbSendQuery(
    hg19, 
    "select * from affyU133Plus2 where 
    misMatches between 1 and 3"
    )

affyMis <- fetch(query)
quantile(affyMis$misMatches)

affyMisSmall <- fetch(query, n=10)
dbClearResult(query)
dim(affyMisSmall)

dbDisconnect(hg19)


#######--------#######--------#######--------#######--------#######--------
#######--------#######--------  HDF5 --------#######--------#######--------
#######--------#######--------#######--------#######--------#######--------

link <- 'http://bioconductor.org/biocLite.R'
source(link)
biocLite('rhdf5')
library(rhdf5)

created <- h5createFile('example.h5')
created <- h5createGroup('example.h5', 'foo')
created <- h5createGroup('example.h5', 'baa')
created <- h5createGroup('example.h5', 'foo/foobaa')
h5ls('example.h5')

#######--------#######--------#######--------#######--------#######--------
#######--------#######--------  HDF5 --------#######--------#######--------
#######--------#######--------#######--------#######--------#######--------




















