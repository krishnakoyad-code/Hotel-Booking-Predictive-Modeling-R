# Hotel Booking Predictive Modeling Using R

## 📌 Project Overview

This project was completed as part of **Week 3 – Statistical Analysis and Predictive Modeling Using R**.

The project extends the Hotel Booking Demand analysis performed in previous weeks by applying statistical hypothesis testing and predictive modeling techniques. The primary objective is to analyze factors associated with hotel booking cancellations and build a classification model capable of predicting whether a booking will be cancelled.

A **Logistic Regression model** was developed in R using booking, customer, pricing, and behavioral variables. The model was evaluated using a train-test split, confusion matrix, classification metrics, ROC-AUC analysis, model diagnostics, and 5-fold cross-validation.

---

## 🎯 Objectives

- Perform exploratory statistical analysis
- Examine data distributions and summary statistics
- Test normality of important numerical variables
- Analyze correlation between numerical variables
- Conduct statistical hypothesis testing
- Build a hotel booking cancellation prediction model
- Evaluate the model using multiple classification metrics
- Perform 5-fold cross-validation
- Analyze ROC curve and AUC
- Examine model diagnostics
- Identify model strengths, limitations, and possible improvements

---

## 📊 Dataset

The project uses the cleaned **Hotel Booking Demand Dataset** prepared during the previous stages of the analysis.

After data cleaning, the dataset contains approximately:

- **87,221 observations**
- **33 variables**
- City Hotel and Resort Hotel bookings
- Booking, customer, pricing, and behavioral information

### Target Variable

`is_canceled`

- `0` = Booking Not Cancelled
- `1` = Booking Cancelled

---

## 🔬 Statistical Analysis

The project includes:

### Distribution Analysis

- Lead Time Distribution
- Average Daily Rate (ADR) Distribution
- ADR comparison between hotel types

### Normality Testing

Shapiro-Wilk tests were performed using reproducible samples of 5,000 observations for:

- Lead Time
- ADR

### Correlation Analysis

Pearson correlation was used to examine the relationship between:

- Lead Time
- Average Daily Rate (ADR)

The relationship was found to be very weak.

---

## 🧪 Hypothesis Testing

### Hypothesis 1 – Hotel Type vs Booking Cancellation

**H0:** Hotel type and booking cancellation are independent.

**H1:** Hotel type and booking cancellation are associated.

Pearson's Chi-Squared Test result:

- Chi-Squared = **454.01**
- Degrees of Freedom = **1**
- p-value **< 2.2e-16**

The null hypothesis was rejected, indicating a statistically significant association between hotel type and booking cancellation.

### Hypothesis 2 – ADR by Hotel Type

A two-sample t-test was used to examine whether the mean Average Daily Rate differs between City Hotel and Resort Hotel.

### Hypothesis 3 – Lead Time and Cancellation Status

A two-sample t-test was used to examine whether mean lead time differs between cancelled and non-cancelled bookings.

---

## 🤖 Predictive Model

A **Logistic Regression Classification Model** was developed to predict booking cancellations.

Selected predictors included:

- Lead Time
- ADR
- Adults
- Children
- Babies
- Previous Cancellations
- Previous Non-Cancelled Bookings
- Booking Changes
- Days in Waiting List
- Required Car Parking Spaces
- Total Special Requests
- Hotel Type
- Deposit Type
- Customer Type
- Market Segment

The dataset was divided into:

- **80% Training Data**
- **20% Testing Data**

A probability threshold of **0.50** was used for classification.

---

## 📈 Model Performance

| Metric | Score |
|---|---:|
| Accuracy | **78.60%** |
| Precision | **69.60%** |
| Recall | **38.14%** |
| Specificity | **93.76%** |
| F1 Score | **49.27%** |
| AUC | **0.7949** |
| Mean 5-Fold CV Accuracy | **78.50%** |

---

## 🔢 Confusion Matrix

| Actual / Predicted | Not Cancelled | Cancelled |
|---|---:|---:|
| Not Cancelled | 11,899 | 792 |
| Cancelled | 2,941 | 1,813 |

The model performs particularly well at identifying non-cancelled bookings, as shown by the **93.76% specificity**.

However, the recall of **38.14%** indicates that a considerable number of actual cancellations are missed.

---

## 📉 ROC-AUC Analysis

The model achieved:

**AUC = 0.7949**

This indicates useful discrimination between cancelled and non-cancelled bookings.

---

## 🔄 Cross-Validation

A **5-Fold Cross-Validation** procedure was performed to evaluate model stability.

**Mean Cross-Validation Accuracy = 78.50%**

The cross-validation result is very close to the test accuracy of 78.60%, indicating consistent model performance across different data partitions.

---

## 🔍 Model Diagnostics

Logistic regression diagnostic plots were generated to examine:

- Residuals vs Fitted Values
- Q-Q Residuals
- Scale-Location
- Residuals vs Leverage

The diagnostic analysis identified some observations with large residuals and leverage, which could be investigated further in future model development.

---

## 💡 Key Findings

- Hotel type is significantly associated with booking cancellation.
- The model achieves an overall accuracy of 78.60%.
- AUC of 0.7949 indicates useful predictive discrimination.
- Specificity is high at 93.76%.
- Cancellation recall is relatively low at 38.14%.
- Cross-validation accuracy remains stable at approximately 78.50%.
- Lead time, ADR, previous cancellations, deposit type, and special requests contribute useful information to the model.

---

## 🚀 Potential Improvements

Future improvements could include:

- Optimizing the classification probability threshold
- Handling class imbalance
- Using stratified cross-validation
- Creating additional predictive features
- Comparing Logistic Regression with Random Forest
- Testing Gradient Boosting models
- Using Precision-Recall curves
- Applying regularized Logistic Regression
- Investigating influential observations
- Using time-based validation for future booking prediction

---

## 🛠️ Technologies Used

- R
- RStudio
- Logistic Regression
- pROC
- Statistical Hypothesis Testing
- Cross-Validation
- Predictive Modeling
- Data Visualization

---

## 📁 Project Files

- `week3_statistical_modeling.R`
- `hotel_bookings_cleaned.csv`
- `week3_model_performance.csv`
- `week3_model_summary.txt`
- `week3_confusion_matrix.txt`
- `week3_hypothesis_test.txt`
- Statistical analysis visualizations
- ROC Curve
- Confusion Matrix
- Model Performance Chart
- Cross-Validation Chart
- Logistic Regression Diagnostic Plots
- Week 3 Final Report

---

## 👨‍🎓 Author

**Krishna**

MCA  
PK University, Shivpuri

---

## 📌 Project Status

**Week 3 – Statistical Analysis and Predictive Modeling Using R: Completed ✅**
