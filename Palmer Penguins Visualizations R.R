#PALMER PENGUINS EXPLORATION PROJECT

install.packages("palmerpenguins")
library(palmerpenguins)
library(dplyr)
library(ggplot2)

data(package = 'palmerpenguins')
View(penguins)
View(penguins_raw)
data()
head(pen)

#Checking for missing values

complete.cases(penguins_raw)
summary(penguins_raw)

#Removing NAs

penguins_raw$`Culmen Depth (mm)`[is.na(penguins_raw$`Culmen Depth (mm)`)] <- 0
penguins_raw$`Delta 15 N (o/oo)`[is.na(penguins_raw$`Delta 15 N (o/oo)`)] <-0
penguins_raw$`Delta 13 C (o/oo)`[is.na(penguins_raw$`Delta 13 C (o/oo)`)] <-0
penguins_raw$`Flipper Length (mm)`[is.na(penguins_raw$`Flipper Length (mm)`)] <-0
penguins_raw$`Body Mass (g)`[is.na(penguins_raw$`Body Mass (g)`)] <-0
penguins_raw$`Culmen Length (mm)`[is.na(penguins_raw$`Culmen Length (mm)`)] <-0

penguins_raw$Sex[is.na(penguins_raw$Sex)] <- "Unkown"
penguins_raw$Comments[is.na(penguins_raw$Comments)] <- "Not Given"


A1 <- filter(penguins_raw,Region == "Anvers")
A2 <- filter(penguins_raw,Region =="Anvers",Island == "Biscoe") 


penguins_raw%>%
  group_by(Species)

penguins_raw%>%
  count(Species)

#Remove unnecessary columns

penguins_raw$Comments <- NULL
penguins_raw$studyName <- NULL
penguins_raw$`Sample Number`<- NULL

View(penguins_raw)

#Visualization
#1
ggplot(penguins,aes(penguins$flipper_length_mm,penguins$bill_length_mm))+
  geom_point(size = 3)+
  geom_line(color = "red")

#2

penguins%>%
  ggplot(aes(body_mass_g,bill_length_mm,
             color = species,
             shape = species))+
  geom_point(size = 3)+
  geom_smooth(method = lm,se=F)

#3

penguins%>%
  ggplot(aes(flipper_length_mm,body_mass_g))+
  geom_boxplot()+
  geom_point(
             aes(color = penguins$species,
                 shape = penguins$species,
                 size = 3))

















