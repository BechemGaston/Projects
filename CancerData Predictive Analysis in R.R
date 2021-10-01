#PREDICTIVE ANALYSIS in R, Using the Cancer Diagnosis dataset

#Importing the dataset from Excel

#Display structure of the dataset

str(cancerdata)

#Data Preparation(removing redundant/unnecessary variables)

cancerdata <- NULL

#Identify rows without missing data

cancerdata <- Cancer[complete.cases(Cancer),]

#Transform the diagnosis of M and B into Benign and Malignant

cancerdata$diagnosis <- factor(ifelse(cancerdata$diagnosis=="M",1, 2))

#Building the Model

trainingset <- cancerdata[1:369,2:31]
testset <- cancerdata[370:569,2:31]

#Splitting the diagnosis into training and test outcome

trainingoutcomes <- cancerdata[1:369,1]
testoutcome <- cancerdata[370:569,1]

#Applying KNN algorithm to training set and outcome

library(class)

prediction <- knn(trainingset,cl=trainingoutcomes,k=20,test = testset)


#Display Predictions
prediction

#Model evaluation

table(testoutcome,prediction)

#Checking for accuracy

actual_prediction <- data.frame(cbind(actuals=testoutcome,predicted=prediction))

correlation_accuracy <- cor(actual_prediction)
head(actual_prediction)




