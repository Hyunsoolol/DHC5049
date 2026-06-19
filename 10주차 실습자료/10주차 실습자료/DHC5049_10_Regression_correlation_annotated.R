#######################################################################
# 헬스케어데이터분석개론 10강: Regression & correlation #
# 실습자료 #
#######################################################################


###### R 실습 ----


### 실습1 ----

# 1. 실습자료인 birthweight 자료를 불러오고, 산모의 마지막 생리때의 체중(lwt)과 아기의 출생시 체중(bwt)의 분포를 확인하라.

data <- read.csv("birthweight.csv", header = T, stringsAsFactors = F)
# read.csv(): birthweight.csv 파일을 읽어 데이터프레임으로 불러옵니다.
# header=T: 첫 행을 변수명으로 사용합니다.
# stringsAsFactors=F: 문자형 변수를 팩터로 자동 변환하지 않고 문자형으로 유지합니다.

with(data, summary(lwt))
# with(data, ...): data 안에서 변수명을 직접 씁니다.
# summary(lwt): lwt(산모의 마지막 생리 시 체중, 단위: lbs)의 요약 통계량을 출력합니다.

with(data, summary(bwt))
# summary(bwt): bwt(아기 출생 시 체중, 단위: g)의 요약 통계량을 출력합니다.


# 2. 산모의 마지막 생리때의 체중 (lwt)과 아기의 출생시 체중 (bwt)간의 연관성을 확인하기 위해 산점도를 그려라. (단, ggplot 함수 사용)

library(ggplot2)  # 데이터 시각화 패키지를 불러옵니다.

ggplot(aes(x = lwt, y = bwt), data = data) +
# ggplot(): 그래프 캔버스를 만듭니다.
# aes(x=lwt, y=bwt): x축에 lwt(산모 체중), y축에 bwt(출생 체중)를 배치합니다.
# data=data: 사용할 데이터프레임을 지정합니다.
  geom_point() +
# geom_point(): 각 관측값을 점으로 표시하는 산점도 레이어를 추가합니다.
  theme_bw()
# theme_bw(): 흰 배경에 검은 격자선의 깔끔한 테마를 적용합니다. (black & white)


# 3. 2번의 산점도에 선형 회귀직선을 그려라. (단, ggplot 함수의 geom_smooth 함수 사용)

library(ggplot2)  # 데이터 시각화 패키지를 불러옵니다.

ggplot(aes(x = lwt, y = bwt), data = data) +
# ggplot(): x축: lwt(산모 체중), y축: bwt(출생 체중)로 캔버스를 만듭니다.
  geom_point() +
# geom_point(): 각 관측값을 점으로 표시합니다.
  geom_smooth(method = lm) +
# geom_smooth(method=lm): 점들에 선형 회귀직선(linear model)을 추가합니다.
# method=lm: lm(linear model) 함수를 사용하여 최소제곱법으로 회귀직선을 적합합니다.
# 회귀직선과 함께 95% 신뢰구간(음영)도 자동으로 표시됩니다.
  theme_bw()
# theme_bw(): 흰 배경에 검은 격자선 테마를 적용합니다.


# 4. 산모의 마지막 생리때의 체중 (lwt)과 아기의 출생시 체중 (bwt)간의 상관계수를 추정하고 유의성을 확인하라.

with(data, cor.test(lwt, bwt))
# with(data, ...): data 안에서 변수명을 직접 씁니다.
# cor.test(x, y): 두 연속형 변수 간의 피어슨 상관계수를 계산하고 유의성을 검정합니다.
#   H0: 두 변수 간 상관관계가 없다 (ρ = 0)
#   H1: 두 변수 간 상관관계가 있다 (ρ ≠ 0)
# 출력 결과:
#   cor: 상관계수 (−1 ~ +1, 절댓값이 클수록 강한 상관관계)
#   p-value: 상관계수의 유의성 (p < 0.05이면 통계적으로 유의한 상관관계)
#   95% CI: 상관계수의 95% 신뢰구간



### 실습2 ----

# 1. birthweight 자료에서 산모의 나이(age)로 아기의 출생시 체중(bwt)를 예측할 수 있는 회귀식을 추정하고 추정된 회귀계수를 해석하라.

model <- glm(bwt ~ age, data = data)
# glm(종속변수 ~ 독립변수, data=데이터): 일반화 선형 모델(Generalized Linear Model)을 적합합니다.
# bwt ~ age: bwt(결과변수)를 age(예측변수)로 설명하는 단순 선형 회귀 모델입니다.
# '~': 왼쪽은 결과변수, 오른쪽은 예측변수입니다.
# 기본값(family 미지정)으로 연속형 결과변수에 대한 선형 회귀를 수행합니다.

summary(model)
# summary(model): 회귀 모델의 결과를 출력합니다.
# 출력 항목:
#   Estimate: 회귀계수 (intercept: 절편, age: 기울기)
#   Std. Error: 표준오차 / t value: t-통계량 / Pr(>|t|): p-value
#   age의 Estimate: age가 1세 증가할 때 bwt의 평균 변화량(g)을 의미합니다.

cbind(coef(model), confint(model))
# coef(model): 모델의 회귀계수(절편, 기울기)를 벡터로 반환합니다.
# confint(model): 각 회귀계수의 95% 신뢰구간을 계산합니다.
# cbind(): 두 결과를 열 방향으로 합쳐 회귀계수와 95% CI를 한 표에 출력합니다.


# 2. 1번의 추정된 회귀식에 대한 유의성과 설명력을 확인하라.

# 회귀식의 유의성
summary(aov(bwt ~ age, data = data))
# aov(bwt ~ age, data=data): 분산분석(ANOVA) 모델을 적합합니다.
# summary(): ANOVA 결과표를 출력합니다.
#   F value: F-통계량 (회귀에 의한 분산 / 잔차 분산)
#   Pr(>F): p-value → p < 0.05이면 회귀식이 통계적으로 유의함을 의미합니다.

# 회귀식의 설명력
fit <- summary(aov(bwt ~ age, data = data))
# ANOVA 결과를 fit 객체에 저장합니다. 아래에서 제곱합(Sum Sq)을 추출하기 위해 사용합니다.

fit[[1]]$`Sum Sq`[1] / sum(fit[[1]]$`Sum Sq`)
# fit[[1]]: ANOVA 결과표 데이터프레임을 추출합니다.
# $`Sum Sq`: 제곱합(Sum of Squares) 열을 가져옵니다.
# [1]: 첫 번째 값, 즉 회귀(age)에 의한 제곱합(SSR)을 선택합니다.
# sum(fit[[1]]$`Sum Sq`): 전체 제곱합(SST = SSR + SSE)을 계산합니다.
# SSR / SST = R² (결정계수): 회귀식이 종속변수의 분산을 설명하는 비율입니다.
# R²가 1에 가까울수록 모델의 설명력이 높습니다.


# 3. 산모의 나이(age), 인종(race) 및 흡연여부(smoke)로 아기의 출생시 체중(bwt)를 예측할 수 있는 회귀식을 추정하고 추정된 회귀계수를 해석하라.

data$race  <- factor(data$race)
# factor(): race 변수를 팩터로 변환합니다.
# 팩터로 변환해야 R이 race를 연속형이 아닌 범주형으로 인식하여 더미변수로 처리합니다.
# 첫 번째 수준(race=1, white)이 기준범주(reference category)가 됩니다.

data$smoke <- factor(data$smoke, levels = c("No", "Yes"))
# factor(): smoke 변수를 팩터로 변환하면서 levels 순서를 지정합니다.
# levels=c("No","Yes"): "No"(비흡연)를 첫 번째 수준으로 지정하여 기준범주로 사용합니다.

model <- glm(bwt ~ age + race + smoke, data = data)
# glm(): 다중 선형 회귀 모델을 적합합니다.
# bwt ~ age + race + smoke: bwt를 age, race, smoke 세 변수로 동시에 설명합니다.
# '+': 독립변수를 추가할 때 사용합니다.
# race는 팩터이므로 자동으로 더미변수(race2, race3)로 변환됩니다. (기준: race1)

summary(model)
# summary(model): 다중 회귀 모델의 결과를 출력합니다.
# 각 변수의 회귀계수, 표준오차, p-value를 확인합니다.
# race2, race3: race=1(white) 대비 각 인종의 bwt 차이를 나타냅니다.
# smokeYes: 비흡연(No) 대비 흡연(Yes)군의 bwt 차이를 나타냅니다.

cbind(coef(model), confint(model))
# coef(): 모든 회귀계수를 반환합니다.
# confint(): 각 회귀계수의 95% 신뢰구간을 계산합니다.
# cbind(): 회귀계수와 95% CI를 열 방향으로 합쳐 한 표에 출력합니다.

library(aod)  # wald.test() 함수를 제공하는 패키지를 불러옵니다.

wald.test(b = coef(model), Sigma = vcov(model), Terms = 3:4)
# wald.test(): Wald 검정으로 여러 계수를 동시에 검정합니다.
# b=coef(model): 모델의 회귀계수 벡터를 지정합니다.
# Sigma=vcov(model): 회귀계수의 분산-공분산 행렬을 지정합니다.
# Terms=3:4: 3번째와 4번째 계수(race2, race3)를 동시에 검정합니다.
# → race 전체(race2=0 AND race3=0)에 대한 동시 유의성을 확인합니다.
#   개별 더미변수 p-value와 달리, 범주형 변수 전체의 유의성을 하나의 p-value로 평가합니다.


# 4. 3번의 추정된 회귀식의 다중공선성을 확인하고 해석하라.

library(car)  # vif() 함수를 제공하는 패키지를 불러옵니다.

vif(model)
# vif(model): 분산팽창인수(VIF, Variance Inflation Factor)를 계산합니다.
# 다중공선성(multicollinearity): 독립변수들 간의 강한 상관관계로 인해
#   회귀계수 추정이 불안정해지는 문제입니다.
# VIF 해석 기준:
#   VIF = 1: 다중공선성 없음
#   1 < VIF < 5: 낮은 수준의 다중공선성 (일반적으로 허용)
#   VIF ≥ 10: 심각한 다중공선성 → 변수 제거 또는 변환 고려
