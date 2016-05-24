quiz <- read.csv("hw1_data.csv")

head(quiz, n=2L)

summary(quiz)

str(quiz)

tail(quiz, n=2L)

quiz$Ozone[47]

summary(quiz$Ozone)

good_oz <- quiz$Ozone[!is.na(quiz$Ozone)]
summary(good_oz)

no_na_oz <- quiz$Ozone[complete.cases(quiz$Ozone)]
summary(no_na_oz)


quiz <- quiz[complete.cases(quiz),]
quiz
cond_oz <- quiz$Ozone >31
cond_temp<- quiz$Temp >90
cond_oz * cond_temp
summary(quiz$Solar.R[as.logical(cond_oz * cond_temp)])


rm(quiz)
quiz <- read.csv("hw1_data.csv")
summary(quiz)
quiz$Month==6
summary(quiz$Temp[quiz$Month==6])

max(quiz$Ozone[quiz$Month==5])
new <- quiz$Ozone[quiz$Month==5]
max(new[!is.na(new)])
