#######################################################################
# 헬스케어데이터분석개론 11강: Logistic regression #
# 실습자료 #
#######################################################################


# 강의자료 -----------

# 데이터 가져오기
# install.packages("moonBook")
library(moonBook)
# moonBook 패키지: acs 데이터셋과 mytable(), extractOR() 함수를 제공합니다.
# library(): 패키지를 현재 세션에서 사용할 수 있도록 활성화합니다.

# 데이터 로드 및 구조 파악
data(acs)   # moonBook 패키지에 내장된 acs 데이터셋을 불러옵니다.
            # acs: 급성관상동맥증후군(Acute Coronary Syndrome) 환자 857명의 임상 자료입니다.
str(acs)    # 데이터 구조 확인: 변수명, 타입, 값 일부를 한눈에 파악합니다.

# 심장성 쇼크 여부에 대한 기초통계분석 및 차이검정
mytable(cardiogenicShock ~ ., data = acs)
# mytable(그룹변수 ~ ., data=데이터): 그룹별 모든 변수의 기초통계분석을 수행합니다.
# cardiogenicShock: 그룹을 나누는 기준 변수 (심장성 쇼크 여부)
# '.': 나머지 모든 변수를 요약 대상으로 포함합니다.
# 연속형 변수는 평균±SD, 범주형 변수는 빈도(%)로 요약하고 p-value를 자동 계산합니다.

# 비만과 심장성 쇼크 간의 연관성 분석 - Univariable analysis
library(dplyr)  # 데이터 조작 패키지를 활성화합니다.

data <- acs %>%
  dplyr::mutate(cardiogenicShock = ifelse(is.na(cardiogenicShock), NA,
                                          ifelse(cardiogenicShock == "Yes", 1, 0)))
# %>%: acs 데이터를 mutate()에 전달합니다.
# dplyr::mutate(): cardiogenicShock 변수를 문자형에서 숫자형(0/1)으로 변환합니다.
# 중첩 ifelse():
#   is.na(cardiogenicShock): 결측값이면 NA로 유지합니다.
#   cardiogenicShock=="Yes"이면 1, 아니면(No) 0을 부여합니다.
# 로지스틱 회귀에서 결과변수는 숫자형 0/1이어야 합니다.

lm_fit <- glm(cardiogenicShock ~ factor(obesity), data = data, family = "binomial")
# glm(결과변수 ~ 예측변수, data=데이터, family="binomial"): 로지스틱 회귀 모델을 적합합니다.
# cardiogenicShock ~ factor(obesity): 비만(obesity)으로 심장성 쇼크를 예측합니다.
# factor(obesity): obesity를 팩터로 변환하여 범주형으로 처리합니다.
#   첫 번째 수준(obesity=0, 비비만)이 기준범주(reference category)가 됩니다.
# family="binomial": 이항분포를 사용하는 로지스틱 회귀임을 지정합니다.
#   결과변수가 0/1인 이분형 변수일 때 사용합니다.

summary(lm_fit)
# summary(): 로지스틱 회귀 결과를 출력합니다.
# 출력 항목:
#   Estimate: 로그 오즈비(log OR) / Std. Error: 표준오차
#   z value: z-통계량 / Pr(>|z|): p-value
# ※ 로지스틱 회귀의 계수는 로그 오즈비이므로, exp()로 변환해야 오즈비(OR)가 됩니다.

extractOR(lm_fit)
# extractOR(모델): 로지스틱 회귀 모델에서 오즈비(OR)와 95% CI를 추출합니다. (moonBook 패키지)
# exp(Estimate): 로그 오즈비를 오즈비로 변환합니다.
# OR > 1: 해당 변수가 있을 때 결과 발생 위험이 더 높음을 의미합니다.
# OR < 1: 해당 변수가 있을 때 결과 발생 위험이 더 낮음을 의미합니다.


# 비만과 심장성 쇼크 간의 연관성 분석 - Multivariable analysis
library(dplyr)  # 데이터 조작 패키지를 활성화합니다.

data <- acs %>%
  dplyr::mutate(cardiogenicShock = ifelse(is.na(cardiogenicShock), NA,
                                          ifelse(cardiogenicShock == "Yes", 1, 0)))
# %>%: acs 데이터를 mutate()에 전달합니다.
# dplyr::mutate(): cardiogenicShock 변수를 숫자형(0/1)으로 변환합니다.
# 중첩 ifelse(): 결측값은 NA로 유지하고, "Yes"는 1, "No"는 0으로 변환합니다.


# R 실습 ----

# 1. "framingham" 자료 가져오기
# install.packages("riskCommunicator")
library(riskCommunicator)
# riskCommunicator 패키지: framingham 데이터셋을 제공합니다.

data(framingham)
# data(): framingham 데이터셋을 작업 환경으로 불러옵니다.
# framingham: 프레이밍햄 심장 연구(Framingham Heart Study) 자료입니다.
#   심뇌혈관질환(CVD) 발생과 관련된 위험요인을 분석한 대규모 코호트 자료입니다.


# 2. Period 1에 해당하는 대상군 (PERIOD=1)에 한하여,
#    당뇨여부(DIABETES)로 심뇌혈관질환(CVD) 발생 위험을 예측할 수 있는 회귀식을 추정하고 추정된 오즈비를 해석하라.

tmp <- framingham %>% dplyr::filter(PERIOD == 1)
# %>%: framingham 데이터를 filter()에 전달합니다.
# dplyr::filter(PERIOD==1): PERIOD가 1인 행만 선택합니다.
# → Period 1에 해당하는 대상군만 분석에 포함합니다.

lm_fit <- glm(CVD ~ factor(DIABETES), data = tmp, family = "binomial")
# glm(): 로지스틱 회귀 모델을 적합합니다.
# CVD ~ factor(DIABETES): CVD(심뇌혈관질환 발생 여부)를 DIABETES(당뇨 여부)로 예측합니다.
# factor(DIABETES): DIABETES를 팩터로 변환하여 범주형으로 처리합니다.
#   DIABETES=0(비당뇨)이 기준범주가 됩니다.
# family="binomial": 결과변수가 이분형(0/1)이므로 로지스틱 회귀를 지정합니다.

summary(lm_fit)
# summary(): 로지스틱 회귀 결과를 출력합니다.
# DIABETES 계수의 Estimate(로그 OR)와 p-value를 확인합니다.

extractOR(lm_fit)
# extractOR(): 오즈비(OR)와 95% CI를 추출하여 출력합니다. (moonBook 패키지)
# OR 해석: DIABETES=1(당뇨) 군은 DIABETES=0(비당뇨) 군 대비 CVD 발생 오즈가 OR배입니다.


# 3. Period 1에 해당하는 대상군 (PERIOD=1)에 한하여,
# 성별(SEX), 나이(AGE), BMI, 수축기혈압(SYSBP), 심박수(HEARTRTE), 총콜레스테롤(TOTCHOL), 흡연 여부(CURSMOKE),
# 과거 고혈압 진단 여부(PREVHYP) 및 항고혈압 약 복용 여부 (BPMEDS)를 보정한 후,
# 당뇨여부(DIABETES)로 심뇌혈관질환(CVD) 발생 위험을 예측할 수 있는 회귀식을 추정하고 추정된 오즈비를 해석하라.

tmp <- framingham %>% dplyr::filter(PERIOD == 1)
# %>%: framingham 데이터를 filter()에 전달합니다.
# dplyr::filter(PERIOD==1): PERIOD가 1인 행만 선택합니다.

lm_fit <- glm(CVD ~ factor(DIABETES) + factor(SEX) + AGE + BMI + SYSBP + HEARTRTE + TOTCHOL + factor(CURSMOKE) + factor(PREVHYP) + factor(BPMEDS), data = tmp, family = "binomial")
# glm(): 다변량 로지스틱 회귀 모델을 적합합니다.
# CVD ~ factor(DIABETES) + ...: CVD를 여러 변수로 동시에 예측합니다.
# '+': 보정 변수(공변량)를 추가합니다.
# factor(변수명): 이분형 범주형 변수들을 팩터로 변환합니다.
#   SEX, CURSMOKE, PREVHYP, BPMEDS: 이분형 범주형 변수 → 더미변수로 처리
#   AGE, BMI, SYSBP, HEARTRTE, TOTCHOL: 연속형 변수 → 그대로 사용
# family="binomial": 로지스틱 회귀를 지정합니다.
# 다변량 분석에서 DIABETES의 OR은 나머지 변수들을 보정한 후의 독립적인 효과를 의미합니다.

summary(lm_fit)
# summary(): 다변량 로지스틱 회귀 결과를 출력합니다.
# 각 변수의 로그 오즈비(Estimate)와 p-value를 확인합니다.

extractOR(lm_fit)
# extractOR(): 모든 변수의 오즈비(OR)와 95% CI를 추출하여 출력합니다.
# 주요 관심 변수인 DIABETES의 보정 오즈비(adjusted OR)를 확인합니다.


# 4. 3번의 추정된 회귀식의 다중공선성을 확인하고 해석하라.

library(car)  # vif() 함수를 제공하는 패키지를 불러옵니다.

vif(lm_fit)
# vif(모델): 분산팽창인수(VIF, Variance Inflation Factor)를 계산합니다.
# 독립변수들 간의 강한 상관관계(다중공선성)가 있는지 확인합니다.
# VIF 해석 기준:
#   VIF = 1: 다중공선성 없음
#   1 < VIF < 5: 낮은 수준 (일반적으로 허용)
#   VIF ≥ 10: 심각한 다중공선성 → 변수 제거 또는 변환 고려
