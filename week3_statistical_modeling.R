# ============================================================
# WEEK 3 - STATISTICAL ANALYSIS AND PREDICTIVE MODELING USING R
# Hotel Booking Cancellation Prediction
# ============================================================


# ============================================================
# 1. LOAD DATA
# ============================================================

hotel_data <- read.csv("hotel_bookings_cleaned.csv")

dim(hotel_data)
head(hotel_data)
str(hotel_data)

# Check missing values
sum(is.na(hotel_data))


# ============================================================
# 2. BASIC STATISTICAL SUMMARY
# ============================================================

summary(hotel_data)

# Important numerical variables
summary(hotel_data$lead_time)
summary(hotel_data$adr)
summary(hotel_data$adults)
summary(hotel_data$children)
summary(hotel_data$booking_changes)
summary(hotel_data$total_of_special_requests)

# Cancellation distribution
table(hotel_data$is_canceled)

# Cancellation percentage
prop.table(table(hotel_data$is_canceled)) * 100


# ============================================================
# 3. DATA DISTRIBUTION ANALYSIS
# ============================================================

# Lead Time Histogram
hist(
  hotel_data$lead_time,
  breaks = 30,
  main = "Distribution of Lead Time",
  xlab = "Lead Time (Days)"
)

# ADR Histogram
hist(
  hotel_data$adr,
  breaks = 30,
  main = "Distribution of Average Daily Rate",
  xlab = "Average Daily Rate (ADR)"
)

# Boxplot of ADR
boxplot(
  hotel_data$adr,
  main = "Boxplot of Average Daily Rate",
  ylab = "ADR"
)


# ============================================================
# 4. NORMALITY TEST
# ============================================================

# Shapiro-Wilk test only supports a limited sample size.
# A random sample is therefore used for diagnostic testing.

set.seed(123)

lead_sample <- sample(
  hotel_data$lead_time,
  5000
)

shapiro.test(lead_sample)


# ADR normality test

set.seed(123)

adr_sample <- sample(
  hotel_data$adr,
  5000
)

shapiro.test(adr_sample)


# ============================================================
# 5. CORRELATION ANALYSIS
# ============================================================

cor(
  hotel_data$lead_time,
  hotel_data$adr,
  use = "complete.obs"
)

# Correlation test

cor.test(
  hotel_data$lead_time,
  hotel_data$adr,
  method = "pearson"
)


# ============================================================
# 6. HYPOTHESIS TEST 1
# Cancellation Rate vs Hotel Type
# ============================================================

# H0:
# Hotel type and booking cancellation are independent.

# H1:
# Hotel type and booking cancellation are associated.

hotel_cancel_table <- table(
  hotel_data$hotel,
  hotel_data$is_canceled
)

hotel_cancel_table

chisq.test(hotel_cancel_table)


# ============================================================
# 7. HYPOTHESIS TEST 2
# ADR Difference Between Hotel Types
# ============================================================

# H0:
# Mean ADR is equal for City Hotel and Resort Hotel.

# H1:
# Mean ADR differs between the two hotel types.

t.test(
  adr ~ hotel,
  data = hotel_data
)


# ============================================================
# 8. HYPOTHESIS TEST 3
# Lead Time: Cancelled vs Not Cancelled
# ============================================================

# H0:
# Mean lead time is equal for cancelled and non-cancelled bookings.

# H1:
# Mean lead time differs between cancelled and non-cancelled bookings.

t.test(
  lead_time ~ is_canceled,
  data = hotel_data
)


# ============================================================
# 9. PREPARE DATA FOR PREDICTIVE MODEL
# ============================================================

# Target variable:
# is_canceled
#
# 0 = Not Cancelled
# 1 = Cancelled

# Variables selected for prediction

model_data <- hotel_data[
  ,
  c(
    "is_canceled",
    "lead_time",
    "adr",
    "adults",
    "children",
    "babies",
    "previous_cancellations",
    "previous_bookings_not_canceled",
    "booking_changes",
    "days_in_waiting_list",
    "required_car_parking_spaces",
    "total_of_special_requests",
    "hotel",
    "deposit_type",
    "customer_type",
    "market_segment"
  )
]

# Check model dataset

str(model_data)
summary(model_data)

# Convert categorical predictors to factors

model_data$hotel <- as.factor(model_data$hotel)

model_data$deposit_type <- as.factor(
  model_data$deposit_type
)

model_data$customer_type <- as.factor(
  model_data$customer_type
)

model_data$market_segment <- as.factor(
  model_data$market_segment
)

# Target kept numeric for logistic regression

model_data$is_canceled <- as.numeric(
  model_data$is_canceled
)

# Missing value check

sum(is.na(model_data))


# ============================================================
# 10. TRAIN-TEST SPLIT
# ============================================================

set.seed(123)

train_index <- sample(
  1:nrow(model_data),
  size = 0.80 * nrow(model_data)
)

train_data <- model_data[train_index, ]

test_data <- model_data[-train_index, ]

dim(train_data)
dim(test_data)


# Check target distribution

prop.table(
  table(train_data$is_canceled)
)

prop.table(
  table(test_data$is_canceled)
)


# ============================================================
# 11. BUILD LOGISTIC REGRESSION MODEL
# ============================================================

logistic_model <- glm(
  is_canceled ~ .,
  data = train_data,
  family = binomial(link = "logit")
)

# Model summary

summary(logistic_model)


# ============================================================
# 12. MODEL PREDICTIONS
# ============================================================

predicted_probability <- predict(
  logistic_model,
  newdata = test_data,
  type = "response"
)

# Convert probabilities to classes

predicted_class <- ifelse(
  predicted_probability >= 0.5,
  1,
  0
)

# View predictions

head(predicted_probability)
head(predicted_class)


# ============================================================
# 13. CONFUSION MATRIX
# ============================================================

confusion_matrix <- table(
  Actual = test_data$is_canceled,
  Predicted = predicted_class
)

confusion_matrix


# ============================================================
# 14. MODEL PERFORMANCE METRICS
# ============================================================

TN <- confusion_matrix["0", "0"]

FP <- confusion_matrix["0", "1"]

FN <- confusion_matrix["1", "0"]

TP <- confusion_matrix["1", "1"]


# Accuracy

accuracy <- (
  TP + TN
) / sum(confusion_matrix)

accuracy


# Precision

precision <- TP / (
  TP + FP
)

precision


# Recall / Sensitivity

recall <- TP / (
  TP + FN
)

recall


# Specificity

specificity <- TN / (
  TN + FP
)

specificity


# F1 Score

f1_score <- 2 * (
  precision * recall
) / (
  precision + recall
)

f1_score


# Display metrics together

performance_metrics <- data.frame(
  Metric = c(
    "Accuracy",
    "Precision",
    "Recall",
    "Specificity",
    "F1 Score"
  ),
  Value = c(
    accuracy,
    precision,
    recall,
    specificity,
    f1_score
  )
)

performance_metrics


# ============================================================
# 15. INSTALL AND LOAD pROC PACKAGE
# ============================================================

# Run install.packages only the first time.
# After successful installation, it can be commented out.

if (!requireNamespace("pROC", quietly = TRUE)) {
  install.packages("pROC")
}

library(pROC)


# ============================================================
# 16. ROC CURVE AND AUC
# ============================================================

roc_object <- roc(
  test_data$is_canceled,
  predicted_probability
)

auc_value <- auc(roc_object)

auc_value

plot(
  roc_object,
  main = "ROC Curve - Hotel Booking Cancellation Model"
)


# ============================================================
# 17. LOGISTIC REGRESSION DIAGNOSTICS
# ============================================================

# Diagnostic plots

par(mfrow = c(2, 2))

plot(logistic_model)

par(mfrow = c(1, 1))


# ============================================================
# 18. PREDICTED PROBABILITY DISTRIBUTION
# ============================================================

hist(
  predicted_probability[
    test_data$is_canceled == 0
  ],
  breaks = 30,
  main = "Predicted Probability for Non-Cancelled Bookings",
  xlab = "Predicted Probability"
)

hist(
  predicted_probability[
    test_data$is_canceled == 1
  ],
  breaks = 30,
  main = "Predicted Probability for Cancelled Bookings",
  xlab = "Predicted Probability"
)


# ============================================================
# 19. 5-FOLD CROSS-VALIDATION
# ============================================================

set.seed(123)

k <- 5

folds <- sample(
  rep(
    1:k,
    length.out = nrow(model_data)
  )
)

cv_accuracy <- numeric(k)

for (i in 1:k) {
  
  cv_train <- model_data[
    folds != i,
  ]
  
  cv_test <- model_data[
    folds == i,
  ]
  
  cv_model <- glm(
    is_canceled ~ .,
    data = cv_train,
    family = binomial
  )
  
  cv_probability <- predict(
    cv_model,
    newdata = cv_test,
    type = "response"
  )
  
  cv_prediction <- ifelse(
    cv_probability >= 0.5,
    1,
    0
  )
  
  cv_accuracy[i] <- mean(
    cv_prediction ==
      cv_test$is_canceled
  )
}

# Accuracy of each fold

cv_accuracy

# Mean cross-validation accuracy

mean_cv_accuracy <- mean(
  cv_accuracy
)

mean_cv_accuracy


# ============================================================
# 20. MODEL COEFFICIENTS / ODDS RATIOS
# ============================================================

# Logistic regression coefficients

coef(logistic_model)

# Odds ratios

odds_ratios <- exp(
  coef(logistic_model)
)

odds_ratios


# ============================================================
# 21. SAVE IMPORTANT OUTPUTS
# ============================================================

write.csv(
  performance_metrics,
  "week3_model_performance.csv",
  row.names = FALSE
)

capture.output(
  summary(logistic_model),
  file = "week3_model_summary.txt"
)

capture.output(
  confusion_matrix,
  file = "week3_confusion_matrix.txt"
)

capture.output(
  hotel_cancel_table,
  chisq.test(hotel_cancel_table),
  file = "week3_hypothesis_test.txt"
)


# ============================================================
# 22. FINAL RESULTS
# ============================================================

cat(
  "\n===== WEEK 3 MODEL PERFORMANCE =====\n"
)

cat(
  "Accuracy:",
  round(accuracy, 4),
  "\n"
)

cat(
  "Precision:",
  round(precision, 4),
  "\n"
)

cat(
  "Recall:",
  round(recall, 4),
  "\n"
)

cat(
  "Specificity:",
  round(specificity, 4),
  "\n"
)

cat(
  "F1 Score:",
  round(f1_score, 4),
  "\n"
)

cat(
  "AUC:",
  round(
    as.numeric(auc_value),
    4
  ),
  "\n"
)

cat(
  "Mean 5-Fold CV Accuracy:",
  round(mean_cv_accuracy, 4),
  "\n"
)

cat(
  "====================================\n"
)

print(
  "Week 3 Statistical Analysis and Predictive Modeling completed successfully!"
)
# ============================================================
# WEEK 3 - SAVE REPORT VISUALIZATIONS AS PNG
# ============================================================


# ------------------------------------------------------------
# 01. Lead Time Distribution
# ------------------------------------------------------------

png(
  "01_lead_time_distribution.png",
  width = 2400,
  height = 1500,
  res = 300
)

hist(
  hotel_data$lead_time,
  breaks = 30,
  main = "Distribution of Booking Lead Time",
  xlab = "Lead Time (Days)"
)

dev.off()


# ------------------------------------------------------------
# 02. ADR Distribution
# ------------------------------------------------------------

png(
  "02_adr_distribution.png",
  width = 2400,
  height = 1500,
  res = 300
)

hist(
  hotel_data$adr,
  breaks = 30,
  main = "Distribution of Average Daily Rate",
  xlab = "Average Daily Rate (ADR)"
)

dev.off()


# ------------------------------------------------------------
# 03. ADR by Hotel Type
# ------------------------------------------------------------

png(
  "03_adr_by_hotel_type.png",
  width = 2400,
  height = 1500,
  res = 300
)

boxplot(
  adr ~ hotel,
  data = hotel_data,
  main = "ADR Distribution by Hotel Type",
  xlab = "Hotel Type",
  ylab = "Average Daily Rate (ADR)"
)

dev.off()


# ------------------------------------------------------------
# 04. ROC Curve
# ------------------------------------------------------------

png(
  "04_roc_curve.png",
  width = 2400,
  height = 1500,
  res = 300
)

plot(
  roc_object,
  main = paste(
    "ROC Curve - Logistic Regression Model\nAUC =",
    round(as.numeric(auc_value), 4)
  )
)

dev.off()


# ------------------------------------------------------------
# 05. Confusion Matrix
# ------------------------------------------------------------

png(
  "05_confusion_matrix.png",
  width = 2400,
  height = 1500,
  res = 300
)

cm <- confusion_matrix

image(
  1:2,
  1:2,
  t(cm[nrow(cm):1, ]),
  axes = FALSE,
  xlab = "Predicted Class",
  ylab = "Actual Class",
  main = "Confusion Matrix"
)

axis(
  1,
  at = 1:2,
  labels = c("Not Cancelled", "Cancelled")
)

axis(
  2,
  at = 1:2,
  labels = c("Cancelled", "Not Cancelled")
)

text(
  rep(1:2, each = 2),
  rep(2:1, times = 2),
  labels = as.vector(cm),
  cex = 1.5
)

dev.off()


# ------------------------------------------------------------
# 06. Model Performance Metrics
# ------------------------------------------------------------

png(
  "06_model_performance_metrics.png",
  width = 2400,
  height = 1500,
  res = 300
)

metric_values <- c(
  accuracy,
  precision,
  recall,
  specificity,
  f1_score,
  as.numeric(auc_value)
)

metric_names <- c(
  "Accuracy",
  "Precision",
  "Recall",
  "Specificity",
  "F1 Score",
  "AUC"
)

bp <- barplot(
  metric_values,
  names.arg = metric_names,
  ylim = c(0, 1),
  main = "Logistic Regression Model Performance",
  ylab = "Score",
  las = 2
)

text(
  bp,
  metric_values,
  labels = paste0(
    round(metric_values * 100, 1),
    "%"
  ),
  pos = 3,
  cex = 0.9
)

dev.off()


# ------------------------------------------------------------
# 07. 5-Fold Cross-Validation Accuracy
# ------------------------------------------------------------

png(
  "07_cross_validation_accuracy.png",
  width = 2400,
  height = 1500,
  res = 300
)

plot(
  1:5,
  cv_accuracy,
  type = "b",
  pch = 19,
  ylim = c(
    min(cv_accuracy) - 0.02,
    max(cv_accuracy) + 0.02
  ),
  main = "5-Fold Cross-Validation Accuracy",
  xlab = "Cross-Validation Fold",
  ylab = "Accuracy",
  xaxt = "n"
)

axis(
  1,
  at = 1:5,
  labels = paste("Fold", 1:5)
)

abline(
  h = mean_cv_accuracy,
  lty = 2
)

legend(
  "bottomright",
  legend = paste(
    "Mean Accuracy =",
    round(mean_cv_accuracy * 100, 2),
    "%"
  ),
  lty = 2,
  bty = "n"
)

dev.off()


# ------------------------------------------------------------
# 08. Logistic Regression Diagnostic Plots
# ------------------------------------------------------------

png(
  "08_logistic_regression_diagnostics.png",
  width = 2400,
  height = 2400,
  res = 300
)

par(
  mfrow = c(2, 2)
)

plot(logistic_model)

par(
  mfrow = c(1, 1)
)

dev.off()


# ------------------------------------------------------------
# 09. Predicted Probability by Actual Booking Status
# ------------------------------------------------------------

png(
  "09_predicted_probability_distribution.png",
  width = 2400,
  height = 1500,
  res = 300
)

boxplot(
  predicted_probability ~ test_data$is_canceled,
  names = c(
    "Not Cancelled",
    "Cancelled"
  ),
  main = "Predicted Cancellation Probability by Actual Status",
  xlab = "Actual Booking Status",
  ylab = "Predicted Cancellation Probability"
)

dev.off()


# ------------------------------------------------------------
# FINISHED
# ------------------------------------------------------------

print(
  "All Week 3 report visualizations saved successfully!"
)
# Save Logistic Regression Diagnostics again

png(
  filename = "08_logistic_regression_diagnostics.png",
  width = 1600,
  height = 1600,
  res = 150,
  type = "windows"
)

par(mfrow = c(2, 2))

plot(logistic_model)

par(mfrow = c(1, 1))

dev.off()

print("Diagnostic PNG saved successfully!")