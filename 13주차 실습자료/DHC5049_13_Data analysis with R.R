#######################################################################
# 헬스케어데이터분석개론 13강: Data analaysis with R #
# 실습자료 #
#######################################################################
 
library(dplyr)

### Flow Chart for the study population ----

# install.packages("riskCommunicator")
library(riskCommunicator)
data(framingham)
framingham <- as.data.frame(framingham)

data <- dplyr::filter(framingham, PERIOD == 1)
nrow(data); length(unique(data$RANDID))
summary(data)

length(unique(data[with(data, is.na(TOTCHOL)),]$RANDID))
data <- data %>% dplyr::filter(!is.na(TOTCHOL))

length(unique(data[with(data, is.na(CIGPDAY)),]$RANDID))
data <- data %>% dplyr::filter(!is.na(CIGPDAY))

length(unique(data[with(data, is.na(BMI)),]$RANDID))
data <- data %>% dplyr::filter(!is.na(BMI))

length(unique(data[with(data, is.na(BPMEDS)),]$RANDID))
data <- data %>% dplyr::filter(!is.na(BPMEDS))

length(unique(data[with(data, is.na(HEARTRTE)),]$RANDID))
data <- data %>% dplyr::filter(!is.na(HEARTRTE))

length(unique(data[with(data, is.na(GLUCOSE)),]$RANDID))
data <- data %>% dplyr::filter(!is.na(GLUCOSE))

length(unique(data[with(data, is.na(educ)),]$RANDID))
data <- data %>% dplyr::filter(!is.na(educ))

# data <- data %>%
#   dplyr::filter(!is.na(TOTCHOL) & !is.na(CIGPDAY) & !is.na(BMI) & !is.na(BPMEDS) & !is.na(HEARTRTE) & !is.na(GLUCOSE) & !is.na(educ))

nrow(data)

with(data, table(PREVCHD))
with(data, table(PREVAP))
with(data, table(PREVMI))
with(data, table(PREVSTRK))


length(unique(data[with(data, PREVCHD == 1),]$RANDID))
data <- data %>% dplyr::filter(!(PREVCHD == 1))

length(unique(data[with(data, PREVAP == 1),]$RANDID))
data <- data %>% dplyr::filter(!(PREVAP == 1))

length(unique(data[with(data, PREVMI == 1),]$RANDID))
data <- data %>% dplyr::filter(!(PREVMI == 1))

length(unique(data[with(data, PREVSTRK == 1),]$RANDID))
data <- data %>% dplyr::filter(!(PREVSTRK == 1))

# data <- data %>%
#   dplyr::filter(PREVCHD == 0) %>%
#   dplyr::filter(PREVAP == 0) %>%
#   dplyr::filter(PREVMI == 0) %>%
#   dplyr::filter(PREVSTRK == 0) 

nrow(data)




### Table 1: Baseline characteristics for the study population ----

nrow(data)

with(data, table(SEX))
with(data, table(DIABETES))
with(data, table(CURSMOKE))
with(data, table(PREVHYP))
with(data, table(BPMEDS))

with(data, shapiro.test(AGE))
with(data, shapiro.test(BMI))
with(data, shapiro.test(SYSBP))
with(data, shapiro.test(DIABP))
with(data, shapiro.test(HEARTRTE))
with(data, shapiro.test(TOTCHOL))

with(data, c(summary(AGE),sd=sd(AGE)))
with(data, c(summary(BMI),sd=sd(BMI)))
with(data, c(summary(SYSBP),sd=sd(SYSBP)))
with(data, c(summary(HEARTRTE),sd=sd(HEARTRTE)))
with(data, c(summary(TOTCHOL),sd=sd(TOTCHOL)))




### Table 2: Comparison between those with CVD  and those without CVD ----

nrow(data)
with(data, table(CVD))

with(data, table(SEX, CVD))
with(data, table(DIABETES, CVD))
with(data, table(CURSMOKE, CVD))
with(data, table(PREVHYP, CVD))
with(data, table(BPMEDS, CVD))

with(data, tapply(AGE, CVD, function(x) c(summary(x),sd=sd(x))))
with(data, tapply(BMI, CVD, function(x) c(summary(x),sd=sd(x))))
with(data, tapply(SYSBP, CVD, function(x) c(summary(x),sd=sd(x))))
with(data, tapply(HEARTRTE, CVD, function(x) c(summary(x),sd=sd(x))))
with(data, tapply(TOTCHOL, CVD, function(x) c(summary(x),sd=sd(x))))




chisq.test(with(data, table(SEX, CVD)))
chisq.test(with(data, table(DIABETES, CVD)))
chisq.test(with(data, table(CURSMOKE, CVD)))
chisq.test(with(data, table(PREVHYP, CVD)))
chisq.test(with(data, table(BPMEDS, CVD)))

wilcox.test(AGE ~ CVD, data=data)
wilcox.test(BMI ~ CVD, data=data)
wilcox.test(SYSBP ~ CVD, data=data)
wilcox.test(HEARTRTE ~ CVD, data=data)
wilcox.test(TOTCHOL ~ CVD, data=data)




### Figure 1: Kaplan-meier curve for CVD ----

library(survival)
library(survminer)
with(data, table(CVD))
with(data, summary(TIMECVD))


# 600,600
surv_fit <- survfit(Surv(TIMECVD/365, CVD) ~ DIABETES, data=data)
ggsurvplot(surv_fit,
           data=data,
           conf.int = TRUE,
           risk.table = TRUE,
           pval = TRUE,
           # ylim = c(0.6, 1),
           xlab = "Time (years)",
           ylab = "Survival Probability",
           title = "CVD-free Survival Curve according to Diabetes")

# Survival probability at specific time
summary(surv_fit, times=c(5, 10, 15, 20, 25))

# Log-rank test
#options(scipen = 999)
survdiff(Surv(TIMECVD/365, CVD) ~ DIABETES, data=data)



### Table 3: Risk factor analysis for CVD ----
data <- data %>%
  dplyr::mutate(SEX = factor(SEX),
                DIABETES = factor(DIABETES),
                CURSMOKE = factor(CURSMOKE),
                PREVHYP = factor(PREVHYP),
                BPMEDS = factor(BPMEDS))

# univariable models
fit <- coxph(Surv(TIMECVD/365, CVD) ~ SEX, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)
fit <- coxph(Surv(TIMECVD/365, CVD) ~ AGE, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)
fit <- coxph(Surv(TIMECVD/365, CVD) ~ BMI, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)
fit <- coxph(Surv(TIMECVD/365, CVD) ~ SYSBP, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)
fit <- coxph(Surv(TIMECVD/365, CVD) ~ HEARTRTE, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)
fit <- coxph(Surv(TIMECVD/365, CVD) ~ TOTCHOL, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10) 
fit <- coxph(Surv(TIMECVD/365, CVD) ~ DIABETES, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)
fit <- coxph(Surv(TIMECVD/365, CVD) ~ CURSMOKE, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)
fit <- coxph(Surv(TIMECVD/365, CVD) ~ PREVHYP, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)
fit <- coxph(Surv(TIMECVD/365, CVD) ~ BPMEDS, data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)

with(data, summary(TOTCHOL))
fit <- coxph(Surv(TIMECVD/365, CVD) ~ factor(ifelse(TOTCHOL <200, 0, 1)), data=data); print(cox.zph(fit), digits=10); print(summary(fit), digits=10)

# multivariable model
fit <- coxph(Surv(TIMECVD/365, CVD) ~ SEX + AGE + BMI + SYSBP + factor(ifelse(TOTCHOL <200, 0, 1)) + DIABETES + CURSMOKE + PREVHYP + BPMEDS, data=data)

library(car)
vif(fit)
cox.zph(fit)
summary(fit)




### Supple Table 1: Risk factor analysis for CVD (Yes or No) ----
library(moonBook)

# univariable models
fit <- glm(CVD ~ SEX, data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ AGE, data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ BMI, data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ SYSBP, data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ HEARTRTE, data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ factor(ifelse(TOTCHOL <200, 0, 1)), data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ DIABETES, data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ CURSMOKE, data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ PREVHYP, data=data, family="binomial"); extractOR(fit, digits=4)
fit <- glm(CVD ~ BPMEDS, data=data, family="binomial"); extractOR(fit, digits=4)

# multivariable model
fit <- glm(CVD ~ SEX + AGE + BMI + SYSBP + factor(ifelse(TOTCHOL <200, 0, 1)) + DIABETES + CURSMOKE + PREVHYP + BPMEDS, data=data, family="binomial"); extractOR(fit, digits=4)

vif(fit)
extractOR(fit, digits=4)

