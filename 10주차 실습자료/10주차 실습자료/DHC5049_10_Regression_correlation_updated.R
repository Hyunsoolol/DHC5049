#######################################################################
# 헬스케어데이터분석개론 10강: Regression & correlation #
# 실습자료 #
#######################################################################

###### R 실습 ----

setwd("C:/Users/sangahchi/Desktop/Ongoing/SAIHST/DHC5049_41/2026/강의자료/10")

### 실습1 ----

# 1. 실습자료인 birthweight 자료를 불러오고, 산모의 마지막 생리때의 체중(lwt)과 아기의 출생시 체중(bwt)의 분포를 확인하라.

data <- read.csv("birthweight.csv", header=T, stringsAsFactors=F)

with(data, summary(lwt))
with(data, summary(bwt))

# 2. 산모의 마지막 생리때의 체중 (lwt)과 아기의 출생시 체중 (bwt)간의 연관성을 확인하기 위해 산점도를 그려라. (단, ggplot 함수 사용)

library(ggplot2)
ggplot(aes(x=lwt, y=bwt), data=data) +
  geom_point() +
  theme_bw()

# 3. 2번의 산점도에 선형 회귀직선을 그려라. (단, ggplot 함수의 geom_smooth 함수 사용)

library(ggplot2)
ggplot(aes(x=lwt, y=bwt), data=data) +
  geom_point() +
  geom_smooth(method=lm) +
  theme_bw()

# 4. 산모의 마지막 생리때의 체중 (lwt)과 아기의 출생시 체중 (bwt)간의 상관계수를 추정하고 유의성을 확인하라.

with(data, shapiro.test(lwt))
with(data, shapiro.test(bwt))
with(data, cor.test(lwt, bwt, method = "spearman", exact=F))



### 실습2 ----

# 1. birthweight 자료에서 산모의 나이(age)로 아기의 출생시 체중(bwt)를 예측할 수 있는 회귀식을 추정하고 추정된 회귀계수를 해석하라.

model <- glm(bwt ~ age, data=data)
summary(model)
cbind(coef(model),confint(model))


# 2. 1번의 추정된 회귀식에 대한 유의성과 설명력을 확인하라. 

# 회귀식의 유의성
summary(aov(bwt ~ age, data=data))

# 회귀식의 설명력
fit <- summary(aov(bwt ~ age, data=data))
fit[[1]]$`Sum Sq`[1]/sum(fit[[1]]$`Sum Sq`)



# 3. 산모의 나이(age), 인종(race) 및 흡연여부(smoke)로 아기의 출생시 체중(bwt)를 예측할 수 있는 회귀식을 추정하고 추정된 회귀계수를 해석하라.

data$race <- factor(data$race)
data$smoke <- factor(data$smoke, levels=c("No","Yes"))

model <- glm(bwt ~ age + race + smoke, data=data)
summary(model)
cbind(coef(model),confint(model))

library(aod)
wald.test(b = coef(model), Sigma = vcov(model), Terms = 3:4)


# 4. 3번의 추정된 회귀식의 다중공선성을 확인하고 해석하라.

library(car)
vif(model)

