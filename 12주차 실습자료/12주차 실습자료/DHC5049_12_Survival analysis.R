#######################################################################
# 헬스케어데이터분석개론 12강: Survival analysis #
# 실습자료 #
#######################################################################

# 강의자료 -----------
library(dplyr)
#### 생존자료에 대한 양측 이표본 검정

# 데이터 가져오기
# install.packages("riskCommunicator")
library(riskCommunicator)
data(framingham)

# Period=1에 해당하는 군 선별 (Subgroup)
tmp <- framingham %>% dplyr::filter(PERIOD == 1)

# CVD 발생 비율 및 time-to-event 확인
with(tmp, table(DIABETES, CVD))
with(tmp, tapply(TIMECVD, DIABETES, summary))

# time-to-event=0인 환자군 삭제 (time-to-event는 항상 양의 값)
tmp <- tmp %>% dplyr::filter(TIMECVD >0)

# CVD 발생 비율 및 time-to-event 확인
with(tmp, table(DIABETES, CVD))
with(tmp, tapply(TIMECVD, DIABETES, summary))


# Package for survival analysis
library(survival)

# ggplot Package for survival analysis
# install.packages("survminer") 
library(survminer)
 
# Survival curve for total population
surv_fit <- survfit(Surv(TIMECVD/365, CVD) ~ 1, data=tmp)
ggsurvplot(surv_fit,
           data=tmp,
           conf.int = TRUE,
           risk.table = TRUE,
           palette = "black",
           ylim = c(0.6, 1),
           xlab = "Time (years)",
           ylab = "Survival Probability",
           title = "Overall Survival Curve")

# Survival probability at specific time
summary(surv_fit, times=c(5, 10, 15, 20, 25))


# Survival curve according to DIABETES
surv_fit <- survfit(Surv(TIMECVD/365, CVD) ~ DIABETES, data=tmp)
surv_fit

ggsurvplot(surv_fit,
           data=tmp,
           conf.int = TRUE,
           risk.table = TRUE,
           pval=TRUE,
           xlab = "Time (years)",
           ylab = "Survival Probability",
           title = "Overall Survival Curve according to DM")

# Survival probability at specific time
summary(surv_fit, times=c(5, 10, 15, 20, 25))

# Log-rank test
survdiff(Surv(TIMECVD/365, CVD) ~ DIABETES, data=tmp)



#### Cox's PH Model
library(survival)

# 당뇨병과 CVD 발생위험간의 연관성 분석 - Univariable analysis
surv_fit <- coxph(Surv(TIMECVD/365, CVD) ~ DIABETES, data=tmp)
summary(surv_fit)
extractHR(surv_fit)

# PH 가정 확인
cox.zph(surv_fit)
ggcoxzph(cox.zph(surv_fit))


# 당뇨병과 CVD 발생위험간의 연관성 분석 - Multivariable analysis
surv_fit <- coxph(Surv(TIMECVD/365, CVD) ~ DIABETES + factor(SEX) + AGE, data=tmp)
summary(surv_fit)
extractHR(surv_fit)

# PH 가정 확인
cox.zph(surv_fit)
ggcoxzph(cox.zph(surv_fit))




# R 실습 ----

# 1. “framingham” 자료 가져오기
# install.packages("riskCommunicator")
library(riskCommunicator)
data(framingham)



# 2. Period 1에 해당하는 대상군 (PERIOD=1)에 한하여,
# 당뇨여부(DIABETES)로 심뇌혈관질환(CVD) 발생 위험을 예측할 수 있는 회귀식을 추정하고 추정된 위험비를 해석하라. 

tmp <- framingham %>% dplyr::filter(PERIOD == 1)
surv_fit <- coxph(Surv(TIMECVD/365, CVD) ~ factor(DIABETES), data=tmp)
summary(surv_fit)
extractHR(surv_fit)


# 3. Period 1에 해당하는 대상군 (PERIOD=1)에 한하여,
# 성별(SEX), 나이(AGE), BMI, 수축기혈압(SYSBP), 심박수(HEARTRTE), 총콜레스테롤(TOTCHOL), 흡연 여부(CURSMOKE), 
# 과거 고혈압 진단 여부(PREVHYP) 및 항고혈압 약 복용 여부 (BPMEDS)를 보정한 후,
# 당뇨여부(DIABETES)로 심뇌혈관질환(CVD) 발생 위험을 예측할 수 있는 회귀식을 추정하고 추정된 오즈비를 해석하라.

tmp <- framingham %>% dplyr::filter(PERIOD == 1)
tmp <- tmp %>% dplyr::filter(TIMECVD > 0)
surv_fit <- coxph(Surv(TIMECVD/365, CVD) ~ factor(DIABETES) + factor(SEX) + AGE + BMI + SYSBP + HEARTRTE + TOTCHOL + factor(CURSMOKE) + factor(PREVHYP) + factor(BPMEDS), data=tmp)
summary(surv_fit)
extractHR(surv_fit)



# 4. 3번의 추정된 회귀식의 다중공선성을 확인하고 해석하라.

# 다중공선성 확인
library(car)
vif(surv_fit)

# PH 가정 확인
cox.zph(surv_fit)
ggcoxzph(cox.zph(surv_fit))

tmp <- tmp %>% dplyr::mutate(TOTCHOL_g = factor(ifelse(is.na(TOTCHOL), NA,
                                                       ifelse(TOTCHOL < 230, 0, 1))))

surv_fit <- coxph(Surv(TIMECVD/365, CVD) ~ factor(DIABETES) + factor(SEX) + AGE + BMI + SYSBP + HEARTRTE + TOTCHOL_g + factor(CURSMOKE) + factor(PREVHYP) + factor(BPMEDS), data=tmp)
summary(surv_fit)
extractHR(surv_fit)

cox.zph(surv_fit)
ggcoxzph(cox.zph(surv_fit))
