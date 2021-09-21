## Data Manipulation in R

##Loading libraries

library(readxl)
library(dplyr)
library(data.table)
library(tidyr)

## Asigning better column names

colnames(surveydata)[colnames(surveydata)=="Respondent_ID"]<-"Employee_ID"
colnames(surveydata)[colnames(surveydata)=="Employment"]<-"Employment_Type"

##Removing missing values (N/A)

summary(surveydata)
complete.cases(surveydata)

##Record N/A before removing them

records <- subset(surveydata,is.na(surveydata$Generation))
records2 <- subset(surveydata,is.na(surveydata$Gender))
records3 <- subset(surveydata,is.na(surveydata$Question1_Response))

##Replacements

surveydata$Generation[is.na(surveydata$Generation)]<-"Unspecified"
surveydata$Gender[is.na(surveydata$Gender)]<-"Questionable"
surveydata$Question1_Response[is.na(surveydata$Question1_Response)]<-"Not Given"
surveydata$Gender[surveydata$Gender=="Non-Binary"]<-"Not Given"

##Aggregations

sum(surveydata$Employee_ID)
mean(surveydata$Employee_ID)
aggregate(Employee_ID~Question1_Response+Gender,surveydata,sum)

view(surveydata$Gender)

ggplot(data = surveydata,
       mapping = aes(x=Employee_ID,
                     y=Question1_Response))+
  geom_point(size=5,alpha=0.5)+
  geom_line(colour="red")+
  geom_smooth(method = lm,se=F)

##some filters
select(surveydata,3:6)
select(surveydata,1:5,1)
