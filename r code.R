library(tidyverse)
library(gbm)
library(randomForest)
library(pdp)
library(vip)
library(tree)
library(rpart)
library(rpart.plot)

# HTRU2 Data Set
# Pursar, 0 or 1, 0 for negative, 1 for positive
data <- read.csv(file="/Users/eunbinko/downloads/HTRU2/HTRU_2.csv", header=TRUE, sep=",")
head(data)
dataset <- data %>% 
  rename(
    X1 = X140.5625,
    X2 = X55.68378214,
    X3 = X.0.234571412,
    X4 = X.0.699648398,
    X5 = X3.199832776,
    X6 = X19.11042633,
    X7 = X7.975531794,
    X8 = X74.24222492,
  )
# sum(is.na(data$Occupancy)) # check if there have unknown rows
Y <- dataset[,9]
X <- dataset[,1:8]
df <- data.frame(Y,X)
train_rows = sample(nrow(df), nrow(df)/2)
train = df[train_rows, ]
test = df[-train_rows, ]
head(test)

# Classification tree
tree = tree(Y~., data = train)
summary(tree)
plot(tree)
text(tree, pretty=0)
# test error
pred = predict(tree, test)
mean((test$Y - pred)^2)


# Comparison between Logistic regression, Boosting, and Random Forest.
# logistic regression
logistic_fit = glm(Y ~ ., data = train, family = "binomial")
logistic_pred = predict(logistic_fit, newdata = test, type = "response")
logistic_class = ifelse(logistic_pred > 0.5, 1,0)
table(test$Y, logistic_class)
mean(logistic_class != test$Y)

# boosting
boost = gbm(Y ~ ., data = train, distribution = "bernoulli", n.trees = 500)
boosting_pred = predict(boost, newdata = test, n.trees = 500)
boosting_class = ifelse(boosting_pred > 0.5, 1,0)
table(boosting_class, test$Y)
mean(boosting_class != test$Y)

# bagging
bagging = randomForest(Y ~ ., data = train, mtry = 5, ntree = 500, importance = T)
bagging_pred = predict(bagging, test)
bagging_class = ifelse(bagging_pred > 0.5, 1,0)
table(bagging_class, test$Y)
mean(bagging_class != test$Y)

# random forest
rf = randomForest(Y ~ ., data = train, mtry = 2, ntree = 500, importance = T)
rf_pred = predict(rf, test)
rf_class = ifelse(rf_pred > 0.5, 1,0)
table(rf_class, test$Y)
mean(rf_class != test$Y)

## Find the most important variables
## Variable Importance Plot using Boosting
model_gbm = gbm(Y ~., data = df, n.trees = 300,
                distribution = 'bernoulli')
vip(model_gbm, bar = FALSE, horizontal = FALSE, size = 1.5)
## partical dependence plot
partial(model_gbm, pred.var = 'X3', n.trees = 300, plot = TRUE)
partial(model_gbm, pred.var = 'X6', n.trees = 300, plot = TRUE)

## Variable Importance Plot using Random Forest
model_rf = randomForest(Y ~., data = df, distribution = 'bernoulli',
                        n_tree = 300, importance = TRUE)
vip(model_rf, bar = FALSE, horizontal = FALSE, size = 1.5)

## partial dependence plot
partial(model_rf, pred.var = 'X3', plot = TRUE)
partial(model_rf, pred.var = 'X4', plot = TRUE)

