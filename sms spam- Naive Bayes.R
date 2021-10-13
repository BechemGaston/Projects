str(spam)
spam$...5 <- NULL
spam$...4 <- NULL
spam$...3 <- NULL
colnames(spam)[colnames(spam)=="v1"] <- "type"
colnames(spam)[colnames(spam)=="v2"] <- "text"
str(spam)
#converting to a factor variable
spam$type <- factor(spam$type)
str(spam$type)
table(spam$type)
#data preparation
install.packages("tm")
library(tm)
#creating a corpus
spam_corpus <- Corpus(VectorSource(spam$text))
print(spam_corpus)
inspect(spam_corpus)
#converting and removing numbers
corpus_clean <- tm_map(spam_corpus,tolower)
corpus_clean <- tm_map(corpus_clean,removeNumbers)
#remove filler words
corpus_clean <- tm_map(corpus_clean,removeWords,stopwords())
#remove punctuation
corpus_clean <- tm_map(corpus_clean,removePunctuation)
#removing additional spaces
corpus_clean <- tm_map(corpus_clean,stripWhitespace)
inspect(corpus_clean[1:3])

#tokenization
sms_dtm <- DocumentTermMatrix(corpus_clean)
#creating training and test data sets
spam_train <- spam[1:4179, ]
spam_test <- spam[4180:5572, ]

#dtm
sms_dtm_train <- sms_dtm[1:4179, ]
sms_dtm_test <- sms_dtm[4180:5572, ]

#corpus
sms_corpus_train <- corpus_clean[1:4179]
sms_corpus_test <- corpus_clean[4180:5572]

#confirmation of the above sets
prop.table(table(spam_train$type))
prop.table(table(spam_test$type))

#visualizing text data- word clouds
install.packages("wordcloud")
library(wordcloud)

wordcloud(sms_corpus_train,min.freq = 40,random.order = FALSE)

#some comparison
#creating a subset of the spam_train data by sms type,where type equal to ham and spam

sms_spam <- subset(spam_train,type=="spam")
sms_ham <- subset(spam_train,type=="ham")

wordcloud(sms_spam$text,max.words = 40,scale = c(3,0.5))
wordcloud(sms_ham$text,max.words = 40,scale = c(3,0.5))

#creating indicator features for frequent words

findFreqTerms(sms_dtm_train,5)

#saving the frequent terms for future

sms_dict <- findFreqTerms(sms_dtm_train, 5)

new_train <- DocumentTermMatrix(sms_corpus_train,list(sms_dict))
new_test <- DocumentTermMatrix(sms_corpus_test,list(sms_dict))

#converting counts to factors
convert_counts <- function(x) {
  x <- ifelse(x > 0,1,0)
  x <- factor(x,levels = c(0,1),labels = c("No","Yes"))
  return(x)
}

new_train <- apply(new_train,MARGIN = 2,convert_counts)
new_test <- apply(new_test,MARGIN = 2,convert_counts)

#training a model on the data
install.packages("e1071")
library(e1071)
sms_classifier <- naiveBayes(new_train,spam_train$type)

#predictions
test_pred <- predict(sms_classifier,new_test)

#comparing the actual versus predicted results

install.packages("gmodels")
library(gmodels)

CrossTable(test_pred,spam_test$type,prop.chisq = FALSE,prop.t = FALSE,dnn = c("predicted","actual"))

#improving the model

sms_classifier2 <- naiveBayes(new_train,spam_train$type,laplace = 1)
test_pred2 <- predict(sms_classifier2,new_test)
CrossTable(test_pred2,spam_test$type,prop.chisq = FALSE,prop.t = FALSE,prop.r = FALSE,dnn = c("predicted","actual"))
















