#Risky Bank Loans analysis
#Data Importation
#Data Exploration

loans <- credit_data1
str(loans)
table(loans$`Saving accounts`)
table(loans$`Checking account`)
summary(loans$Duration)
summary(loans$`Credit amount`)

#the risk variable indicates whether the applicant was able to meet up with the payment
table(loans$Risk)

#creating training and test data sets
#using the order function to rearrange the list into descending or ascending order
#using the run-if function to generate a randomly ordered list
#set.seed function generates random numbers in a predefined sequence.The set.seed() function ensures that if the
#analysis is repeated, an identical result is obtained

set.seed(12345)
loan_rand <- loans[order(runif(1000)), ]

summary(loans$`Credit amount`)
summary(loan_rand$`Credit amount`)
head(loans$`Credit amount`)
head(loan_rand$`Credit amount`)

loans_train <- loan_rand[1:900, ]
loans_test <- loan_rand[901:1000, ]

prop.table(table(loans_train$Risk))
prop.table(table(loans_test$Risk))

#training a model on the data
install.packages("C50")
library(C50)

loans_train$Risk <- as.factor(loans_train$Risk)
str(loans_train$Risk)

loan_model <- C5.0(loans_train[-11],loans_train$Risk)
loan_model

#decisions
summary(loan_model)

#evaluating model performance
loan_pred <- predict(loan_model,loans_test)

#evaluating model performance
library(gmodels)
CrossTable(loans_test$Risk,loan_pred,prop.chisq = FALSE,prop.c = FALSE,dnn = c('actual risk','predicted risk'))

#improving model performance
loan_boost10 <- C5.0(loans_train[-11],loans_train$Risk,trials = 10)
loan_boost10
summary(loan_boost10)

loan_boost10_pred <- predict(loan_boost10,loans_test)
CrossTable(loans_test$Risk,loan_boost10_pred,prop.chisq = FALSE,prop.c = FALSE,prop.r = FALSE,dnn = c('actual risk','predicted risk'))





