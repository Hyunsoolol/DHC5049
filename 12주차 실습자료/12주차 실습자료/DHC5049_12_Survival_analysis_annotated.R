#######################################################################
# 헬스케어데이터분석개론 12강: Survival analysis #
# 실습자료 #
#######################################################################


# 강의자료 -----------

#### 생존자료에 대한 양측 이표본 검정

# 데이터 가져오기
# install.packages("riskCommunicator")
library(riskCommunicator)
# riskCommunicator 패키지: framingham 데이터셋을 제공합니다.

data(framingham)
# data(): framingham 데이터셋을 작업 환경으로 불러옵니다.
# framingham: 프레이밍햄 심장 연구 자료로, 심뇌혈관질환(CVD) 발생과 관련된 위험요인을 포함합니다.
# 주요 변수:
#   PERIOD: 추적관찰 시기 (1/2/3) / CVD: 심뇌혈관질환 발생 여부 (0/1)
#   TIMECVD: CVD 발생까지의 시간 (일) / DIABETES: 당뇨 여부 (0/1)

# Period=1에 해당하는 군 선별 (Subgroup)
tmp <- framingham %>% dplyr::filter(PERIOD == 1)
# %>%: framingham 데이터를 filter()에 전달합니다.
# dplyr::filter(PERIOD==1): PERIOD가 1인 행만 선택합니다.
# → Period 1에 해당하는 대상군만 분석에 포함합니다.

# CVD 발생 비율 및 time-to-event 확인
with(tmp, table(DIABETES, CVD))
# with(tmp, ...): tmp 데이터 안에서 변수명을 직접 씁니다.
# table(DIABETES, CVD): 당뇨 여부별 CVD 발생 교차표를 확인합니다.

with(tmp, tapply(TIMECVD, DIABETES, summary))
# tapply(): DIABETES 그룹별로 TIMECVD(CVD 발생까지의 시간)의 summary를 적용합니다.
# TIMECVD=0인 값이 있는지 확인합니다. (time-to-event는 항상 양의 값이어야 합니다.)

# time-to-event=0인 환자군 삭제 (time-to-event는 항상 양의 값)
tmp <- tmp %>% dplyr::filter(TIMECVD > 0)
# %>%: tmp 데이터를 filter()에 전달합니다.
# dplyr::filter(TIMECVD>0): TIMECVD가 0보다 큰 행만 선택합니다.
# TIMECVD=0인 행은 관찰 시작과 동시에 사건이 발생한 것으로, 생존분석에서 제외합니다.

# CVD 발생 비율 및 time-to-event 확인
with(tmp, table(DIABETES, CVD))
# table(): 필터링 후 DIABETES × CVD 교차표를 다시 확인합니다.

with(tmp, tapply(TIMECVD, DIABETES, summary))
# tapply(): 필터링 후 DIABETES 그룹별 TIMECVD 분포를 다시 확인합니다.
# TIMECVD=0인 행이 제거되었는지 검증합니다.


# Package for survival analysis
library(survival)
# survival 패키지: 생존분석의 핵심 함수들을 제공합니다.
# Surv(), survfit(), survdiff(), coxph() 등의 함수가 포함되어 있습니다.

# ggplot Package for survival analysis
# install.packages("survminer")
library(survminer)
# survminer 패키지: ggplot2 기반의 생존곡선 시각화 함수(ggsurvplot())를 제공합니다.


# Survival curve for total population
surv_fit <- survfit(Surv(TIMECVD / 365, CVD) ~ 1, data = tmp)
# survfit(생존객체 ~ 그룹변수, data=데이터): Kaplan-Meier 생존곡선을 추정합니다.
# Surv(time, event): 생존 객체를 만듭니다.
#   TIMECVD/365: 생존 시간을 일(day) 단위에서 년(year) 단위로 변환합니다.
#   CVD: 사건 발생 여부 (1=발생, 0=중도절단)
# ~ 1: 그룹 구분 없이 전체 집단의 생존곡선을 추정합니다.

ggsurvplot(surv_fit,
           data = tmp,
           conf.int = TRUE,      # 95% 신뢰구간(음영)을 표시합니다.
           risk.table = TRUE,    # 시간대별 위험군(at-risk) 수를 표 형태로 표시합니다.
           palette = "black",    # 곡선 색상을 검정으로 지정합니다.
           ylim = c(0.6, 1),     # y축 범위를 0.6~1.0으로 설정합니다.
           xlab = "Time (years)",         # x축 레이블: 시간(년)
           ylab = "Survival Probability", # y축 레이블: 생존 확률
           title = "Overall Survival Curve")  # 그래프 제목
# ggsurvplot(): survminer 패키지의 함수로 Kaplan-Meier 생존곡선을 시각화합니다.

# Survival probability at specific time
summary(surv_fit, times = c(5, 10, 15, 20, 25))
# summary(surv_fit, times=c(...)): 지정한 시점(5, 10, 15, 20, 25년)에서의 생존 확률을 출력합니다.
# 각 시점의 생존율(survival), 표준오차, 95% CI, 위험군 수(n.risk), 사건 수(n.event)를 확인합니다.


# Survival curve according to DIABETES
surv_fit <- survfit(Surv(TIMECVD / 365, CVD) ~ DIABETES, data = tmp)
# survfit(): DIABETES 그룹별(0: 비당뇨, 1: 당뇨) Kaplan-Meier 생존곡선을 추정합니다.
# ~ DIABETES: DIABETES 변수의 수준별로 생존곡선을 각각 추정합니다.

surv_fit
# surv_fit 객체를 출력하면 각 그룹의 관측수(n), 사건 수, 중도절단 수를 확인합니다.

ggsurvplot(surv_fit,
           data = tmp,
           conf.int = TRUE,      # 95% 신뢰구간을 표시합니다.
           risk.table = TRUE,    # 시간대별 위험군 수를 표 형태로 표시합니다.
           pval = TRUE,          # 두 그룹 간 log-rank test의 p-value를 그래프에 표시합니다.
           xlab = "Time (years)",
           ylab = "Survival Probability",
           title = "Overall Survival Curve according to DM")
# ggsurvplot(): DIABETES 그룹별 생존곡선을 시각화합니다.
# pval=TRUE: log-rank test p-value가 그래프 내에 자동으로 표시됩니다.

# Survival probability at specific time
summary(surv_fit, times = c(5, 10, 15, 20, 25))
# summary(): DIABETES 그룹별로 지정한 시점(5, 10, 15, 20, 25년)의 생존 확률을 출력합니다.
# 두 그룹의 생존율을 시점별로 비교할 수 있습니다.

# Log-rank test
survdiff(Surv(TIMECVD / 365, CVD) ~ DIABETES, data = tmp)
# survdiff(생존객체 ~ 그룹변수, data=데이터): Log-rank test를 수행합니다.
# 두 그룹(비당뇨 vs 당뇨)의 생존곡선이 통계적으로 유의하게 다른지 검정합니다.
# H0: 두 그룹의 생존곡선이 같다
# H1: 두 그룹의 생존곡선이 다르다
# 출력 결과의 p-value로 유의성을 판단합니다.


#### Cox's PH Model
library(survival)  # 생존분석 패키지를 활성화합니다.

# 당뇨병과 CVD 발생위험간의 연관성 분석 - Univariable analysis
surv_fit <- coxph(Surv(TIMECVD / 365, CVD) ~ DIABETES, data = tmp)
# coxph(생존객체 ~ 예측변수, data=데이터): Cox 비례위험 모델(Cox's PH model)을 적합합니다.
# Surv(TIMECVD/365, CVD): 생존 시간(년)과 사건 발생 여부로 생존 객체를 만듭니다.
# ~ DIABETES: DIABETES를 예측변수로 사용하는 단변량 분석입니다.
# Cox 모델은 시간에 따른 위험비(HR, Hazard Ratio)를 추정합니다.

summary(surv_fit)
# summary(): Cox 모델의 결과를 출력합니다.
# 출력 항목:
#   coef: 로그 위험비(log HR) / exp(coef): 위험비(HR)
#   se(coef): 표준오차 / z: z-통계량 / p: p-value
#   HR > 1: 해당 변수가 있을 때 사건 발생 위험이 더 높음
#   HR < 1: 해당 변수가 있을 때 사건 발생 위험이 더 낮음

extractHR(surv_fit)
# extractHR(모델): Cox 모델에서 위험비(HR)와 95% CI를 추출합니다. (moonBook 패키지)
# HR 해석: DIABETES=1(당뇨) 군은 DIABETES=0(비당뇨) 군 대비 CVD 발생 위험이 HR배입니다.

# PH 가정 확인
cox.zph(surv_fit)
# cox.zph(모델): Cox 비례위험(PH, Proportional Hazards) 가정을 검정합니다.
# PH 가정: 두 그룹의 위험비(HR)가 시간에 따라 일정해야 합니다.
# H0: PH 가정을 만족한다 (위험비가 시간에 따라 일정하다)
# H1: PH 가정을 만족하지 않는다
# p-value > 0.05 → PH 가정 만족 / p-value ≤ 0.05 → PH 가정 위반

ggcoxzph(cox.zph(surv_fit))
# ggcoxzph(): cox.zph() 결과를 시각화합니다. (survminer 패키지)
# Schoenfeld 잔차를 시간에 따라 그려 PH 가정 만족 여부를 시각적으로 확인합니다.
# 잔차가 시간에 따라 수평(0 근방)에 가까우면 PH 가정을 만족합니다.


# 당뇨병과 CVD 발생위험간의 연관성 분석 - Multivariable analysis
surv_fit <- coxph(Surv(TIMECVD / 365, CVD) ~ DIABETES + factor(SEX) + AGE, data = tmp)
# coxph(): 다변량 Cox 비례위험 모델을 적합합니다.
# ~ DIABETES + factor(SEX) + AGE: DIABETES를 주요 변수로, SEX와 AGE를 보정 변수로 포함합니다.
# factor(SEX): SEX를 팩터로 변환하여 범주형으로 처리합니다.
# '+': 보정 변수(공변량)를 추가합니다.
# 다변량 분석에서 DIABETES의 HR은 SEX와 AGE를 보정한 후의 독립적인 효과입니다.

summary(surv_fit)
# summary(): 다변량 Cox 모델의 결과를 출력합니다.
# 각 변수의 HR(exp(coef))과 p-value를 확인합니다.

extractHR(surv_fit)
# extractHR(): 모든 변수의 위험비(HR)와 95% CI를 추출하여 출력합니다.
# 주요 관심 변수인 DIABETES의 보정 위험비(adjusted HR)를 확인합니다.

# PH 가정 확인
cox.zph(surv_fit)
# cox.zph(): 다변량 Cox 모델의 각 변수에 대한 PH 가정을 검정합니다.
# 각 변수별 p-value와 GLOBAL(전체 모델) p-value를 확인합니다.

ggcoxzph(cox.zph(surv_fit))
# ggcoxzph(): 다변량 모델의 각 변수별 Schoenfeld 잔차를 시각화합니다.
# 각 변수의 잔차가 시간에 따라 수평인지 확인합니다.


# R 실습 ----

# 1. "framingham" 자료 가져오기
# install.packages("riskCommunicator")
library(riskCommunicator)  # framingham 데이터셋을 제공하는 패키지를 활성화합니다.

data(framingham)
# data(): framingham 데이터셋을 작업 환경으로 불러옵니다.


# 2. Period 1에 해당하는 대상군 (PERIOD=1)에 한하여,
# 당뇨여부(DIABETES)로 심뇌혈관질환(CVD) 발생 위험을 예측할 수 있는 회귀식을 추정하고 추정된 위험비를 해석하라.

tmp <- framingham %>% dplyr::filter(PERIOD == 1)
# %>%: framingham 데이터를 filter()에 전달합니다.
# dplyr::filter(PERIOD==1): PERIOD가 1인 행만 선택합니다.

surv_fit <- coxph(Surv(TIMECVD / 365, CVD) ~ factor(DIABETES), data = tmp)
# coxph(): 단변량 Cox 비례위험 모델을 적합합니다.
# Surv(TIMECVD/365, CVD): 생존 시간(년)과 CVD 발생 여부로 생존 객체를 만듭니다.
# ~ factor(DIABETES): DIABETES를 팩터로 변환하여 범주형 예측변수로 사용합니다.
#   DIABETES=0(비당뇨)이 기준범주가 됩니다.

summary(surv_fit)
# summary(): 단변량 Cox 모델의 결과를 출력합니다.
# DIABETES의 HR(exp(coef))과 p-value를 확인합니다.

extractHR(surv_fit)
# extractHR(): 위험비(HR)와 95% CI를 추출하여 출력합니다. (moonBook 패키지)
# HR 해석: DIABETES=1(당뇨) 군은 DIABETES=0(비당뇨) 군 대비 CVD 발생 위험이 HR배입니다.


# 3. Period 1에 해당하는 대상군 (PERIOD=1)에 한하여,
# 성별(SEX), 나이(AGE), BMI, 수축기혈압(SYSBP), 심박수(HEARTRTE), 총콜레스테롤(TOTCHOL), 흡연 여부(CURSMOKE),
# 과거 고혈압 진단 여부(PREVHYP) 및 항고혈압 약 복용 여부 (BPMEDS)를 보정한 후,
# 당뇨여부(DIABETES)로 심뇌혈관질환(CVD) 발생 위험을 예측할 수 있는 회귀식을 추정하고 추정된 오즈비를 해석하라.

tmp <- framingham %>% dplyr::filter(PERIOD == 1)
# %>%: framingham 데이터를 filter()에 전달합니다.
# dplyr::filter(PERIOD==1): PERIOD가 1인 행만 선택합니다.

surv_fit <- coxph(Surv(TIMECVD / 365, CVD) ~ factor(DIABETES) + factor(SEX) + AGE + BMI + SYSBP + HEARTRTE + TOTCHOL + factor(CURSMOKE) + factor(PREVHYP) + factor(BPMEDS), data = tmp)
# coxph(): 다변량 Cox 비례위험 모델을 적합합니다.
# Surv(TIMECVD/365, CVD): 생존 객체를 만듭니다.
# ~ factor(DIABETES) + ...: DIABETES를 주요 변수로, 나머지를 보정 변수로 포함합니다.
# factor(변수명): 이분형 범주형 변수들을 팩터로 변환합니다.
#   SEX, CURSMOKE, PREVHYP, BPMEDS: 범주형 변수 → 더미변수로 처리
#   AGE, BMI, SYSBP, HEARTRTE, TOTCHOL: 연속형 변수 → 그대로 사용
# 다변량 분석에서 DIABETES의 HR은 나머지 변수들을 보정한 후의 독립적인 효과입니다.

summary(surv_fit)
# summary(): 다변량 Cox 모델의 결과를 출력합니다.
# 각 변수의 HR(exp(coef))과 p-value를 확인합니다.

extractHR(surv_fit)
# extractHR(): 모든 변수의 위험비(HR)와 95% CI를 추출하여 출력합니다.
# 주요 관심 변수인 DIABETES의 보정 위험비(adjusted HR)를 확인합니다.


# 4. 3번의 추정된 회귀식의 다중공선성을 확인하고 해석하라.

# 다중공선성 확인
library(car)  # vif() 함수를 제공하는 패키지를 불러옵니다.

vif(surv_fit)
# vif(모델): 분산팽창인수(VIF)를 계산하여 다중공선성을 확인합니다.
# VIF 해석 기준:
#   VIF = 1: 다중공선성 없음
#   1 < VIF < 5: 낮은 수준 (일반적으로 허용)
#   VIF ≥ 10: 심각한 다중공선성 → 변수 제거 또는 변환 고려

# PH 가정 확인
cox.zph(surv_fit)
# cox.zph(): 다변량 Cox 모델의 각 변수에 대한 PH 가정을 검정합니다.
# 각 변수별 p-value와 GLOBAL(전체 모델) p-value를 확인합니다.
# p-value > 0.05 → PH 가정 만족 / p-value ≤ 0.05 → PH 가정 위반

ggcoxzph(cox.zph(surv_fit))
# ggcoxzph(): 다변량 모델의 각 변수별 Schoenfeld 잔차를 시각화합니다. (survminer 패키지)
# 잔차가 시간에 따라 수평(0 근방)에 가까우면 PH 가정을 만족합니다.
