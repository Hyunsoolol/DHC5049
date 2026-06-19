#######################################################################
# 헬스케어데이터분석개론 11강: Logistic regression #
# 실습자료 #
#######################################################################
 
# 강의자료 -----------

# 데이터 가져오기
# install.packages("moonBook")
library(moonBook)

# 데이터 로드 및 구조 파악
data(acs)
str(acs)

# 심장성 쇼크 여부에 대한 기초통계분석 및 차이검정
mytable(cardiogenicShock ~., data=acs)

# 비만과 심장성 쇼크 간의 연관성 분석 - Univariable analysis
library(dplyr)
data <- acs %>%
  dplyr::mutate(cardiogenicShock = ifelse(is.na(cardiogenicShock), NA,
                                          ifelse(cardiogenicShock == "Yes", 1, 0)))

lm_fit <- glm(cardiogenicShock ~ factor(obesity), data=data, family="binomial")
summary(lm_fit)
extractOR(lm_fit)


# 비만과 심장성 쇼크 간의 연관성 분석 - Multivariable analysis
library(dplyr)
data <- acs %>%
  dplyr::mutate(cardiogenicShock = ifelse(is.na(cardiogenicShock), NA,
                                          ifelse(cardiogenicShock == "Yes", 1, 0)))


# R 실습 ----

library(dplyr)
library(moonBook)

# 1. “framingham” 자료 가져오기
# install.packages("riskCommunicator")
library(riskCommunicator)
data(framingham)



# 2. Period 1에 해당하는 대상군 (PERIOD=1)에 한하여,
#    당뇨여부(DIABETES)로 심뇌혈관질환(CVD) 발생 위험을 예측할 수 있는 회귀식을 추정하고 추정된 오즈비를 해석하라. 

tmp <- framingham %>% dplyr::filter(PERIOD == 1)
lm_fit <- glm(CVD ~ factor(DIABETES), data=tmp, family="binomial")
summary(lm_fit)
extractOR(lm_fit)


# 3. Period 1에 해당하는 대상군 (PERIOD=1)에 한하여,
# 성별(SEX), 나이(AGE), BMI, 수축기혈압(SYSBP), 심박수(HEARTRTE), 총콜레스테롤(TOTCHOL), 흡연 여부(CURSMOKE), 
# 과거 고혈압 진단 여부(PREVHYP) 및 항고혈압 약 복용 여부 (BPMEDS)를 보정한 후,
# 당뇨여부(DIABETES)로 심뇌혈관질환(CVD) 발생 위험을 예측할 수 있는 회귀식을 추정하고 추정된 오즈비를 해석하라.

tmp <- framingham %>% dplyr::filter(PERIOD == 1)
lm_fit <- glm(CVD ~ factor(DIABETES) + factor(SEX) + AGE + BMI + SYSBP + HEARTRTE + TOTCHOL + factor(CURSMOKE) + factor(PREVHYP) + factor(BPMEDS), data=tmp, family="binomial")
summary(lm_fit)
extractOR(lm_fit)



# 4. 3번의 추정된 회귀식의 다중공선성을 확인하고 해석하라.
library(car)
vif(lm_fit)



