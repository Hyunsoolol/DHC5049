# DHC5049 오픈북 시험 대비 가이드

근거 자료: 현재 폴더의 DHC5049 PDF 강의자료 7개, 압축 해제된 R 실습자료 8개, `birthweight.csv`

## 빠른 검색용 요약표

| 검색어 | 언제 쓰나 | 핵심 결론 | 대표 R 코드 |
|---|---|---|---|
| 데이터 불러오기, read.csv | CSV 자료를 R로 읽을 때 | `header=T`, `stringsAsFactors=F` 확인 | `read.csv("file.csv", header=T, stringsAsFactors=F)` |
| 전처리, mutate | 새 변수 생성, 재코딩 | `ifelse()`, `factor()`, `as.Date()` 자주 사용 | `data %>% mutate(new = ifelse(x==1, 1, 0))` |
| group_by, summarise | 그룹별 평균/표준편차 | `na.rm=T` 누락값 제외 | `data %>% group_by(g) %>% summarise(mean=mean(x, na.rm=T))` |
| 상관분석, correlation | 연속형 X와 연속형 Y의 관련성 | Pearson: 선형/정규성, Spearman: 순위/비정규 | `cor.test(x, y, method="spearman")` |
| 선형회귀, linear regression | 연속형 outcome 예측/설명 | 회귀계수는 Y의 평균 변화량 | `glm(y ~ x1 + x2, data=data)` |
| 다중공선성, VIF | 설명변수끼리 너무 강하게 관련될 때 | VIF 10 이상이면 심각하게 의심 | `car::vif(model)` |
| 로지스틱 회귀, logistic | 이분형 outcome 예측/설명 | 계수 `β`는 log OR, `exp(β)`는 OR | `glm(y ~ x, family="binomial")` |
| 오즈비, OR | 질병 있음/없음 같은 이분형 결과 | OR>1 위험 증가, OR<1 위험 감소 | `moonBook::extractOR(fit)` |
| 생존분석, survival | event 발생 여부와 시간 모두 있을 때 | censoring을 함께 처리 | `Surv(time, event)` |
| Kaplan-Meier | 그룹별 생존곡선 추정 | 생존확률, at-risk, log-rank p 확인 | `survfit(Surv(t,e) ~ group)` |
| Cox PH, hazard ratio | 생존자료의 위험요인 분석 | 계수 `β`는 log HR, `exp(β)`는 HR | `coxph(Surv(t,e) ~ x)` |
| PH assumption | Cox 비례위험 가정 확인 | `cox.zph()` p>0.05면 가정 위반 근거 약함 | `cox.zph(fit)` |
| Table 1 | 전체 대상자 기초특성 | 범주형 n(%), 연속형 mean±SD 또는 median(IQR) | `table()`, `summary()`, `shapiro.test()` |
| Table 2 | outcome 그룹별 비교 | 연속형 t-test/Wilcoxon, 범주형 chi-square/Fisher | `wilcox.test()`, `chisq.test()` |
| 연구설계, epidemiology | 자료 수집 방향과 목적 구분 | cohort, case-control, cross-sectional, RCT | 설계별 RR/OR/시점 구분 |
| 머신러닝, ML | 지도/비지도/생성형 AI 개념 | supervised vs unsupervised, bias/privacy 중요 | 개념 비교 중심 |

## 전체 자료 목록

| 구분 | 파일 | 시험 활용 |
|---|---|---|
| PDF | `DHC5049_09_Data handling with R.pdf` | R 데이터 불러오기, 전처리, 변수 생성, 자료 결합 |
| PDF | `DHC5049_10_Regression_correlation_updated.pdf` | 상관분석, 단순/다중 선형회귀 |
| PDF | `DHC5049_11_Logistic regression.pdf` | RR, OR, 로지스틱 회귀, adjusted OR |
| PDF | `DHC5049_12_Survival analysis.pdf` | 생존자료, censoring, KM, log-rank, Cox PH |
| PDF | `DHC5049_13_Data analysis with R.pdf` | Framingham 분석 흐름, Table/Figure 구성 |
| PDF | `DHC5049_13_Data analysis with R_ver2.pdf` | 13주차 완성 표와 수치가 보강된 버전 |
| PDF | `DHC5049_15_Introduction to epidemiology & machine learning.pdf` | 역학 연구설계, PICO, ML/AI 개요 |
| R | `9주차 실습코드 (주석 포함 코드)/DHC5049_09_Data_handling_with_R_annotated.R` | 전처리 코드 주석본 |
| R | `10주차 실습자료/10주차 실습자료/DHC5049_10_Regression_correlation_updated.R` | 상관/회귀 실습 원본 |
| R | `10주차 실습자료/10주차 실습자료/DHC5049_10_Regression_correlation_annotated.R` | 상관/회귀 실습 주석본 |
| R | `11주차 실습자료/11주차 실습자료/DHC5049_11_Logistic regression.R` | 로지스틱 실습 원본 |
| R | `11주차 실습자료/11주차 실습자료/DHC5049_11_Logistic_regression_annotated.R` | 로지스틱 실습 주석본 |
| R | `12주차 실습자료/12주차 실습자료/DHC5049_12_Survival analysis.R` | 생존분석 실습 원본 |
| R | `12주차 실습자료/12주차 실습자료/DHC5049_12_Survival_analysis_annotated.R` | 생존분석 실습 주석본 |
| R | `13주차 실습자료/DHC5049_13_Data analysis with R.R` | 논문식 분석 전체 파이프라인 |
| CSV | `10주차 실습자료/10주차 실습자료/birthweight.csv` | birthweight 실습 데이터 |

## 분석방법 선택표

| 질문 | X | Y | 대표 방법 | 귀무가설 | 결과 해석 |
|---|---|---|---|---|---|
| 두 범주형 변수의 관련성 | 범주형 | 범주형 | Chi-square, Fisher exact | X와 Y는 독립이다 | p<0.05면 관련성 있음 |
| 두 연속형 변수의 관련성 | 연속형 | 연속형 | Pearson, Spearman correlation | 상관계수 ρ=0 | r 부호는 방향, 절댓값은 강도 |
| 연속형 결과 예측 | 연속/범주형 | 연속형 | Linear regression | β=0 | X 1단위 증가 시 Y 평균 β 변화 |
| 이분형 결과 예측 | 연속/범주형 | 0/1 outcome | Logistic regression | OR=1 | OR>1 odds 증가 |
| 사건 수 자료 예측 | 연속/범주형 | count | Poisson regression | rate ratio=1 | 사건 발생률 비 |
| 시간-사건 자료 예측 | 연속/범주형 | time + event | Cox PH regression | HR=1 | HR>1 event hazard 증가 |

## 9주차: Data Handling With R

근거 파일:
`DHC5049_09_Data handling with R.pdf`,
`9주차 실습코드 (주석 포함 코드)/DHC5049_09_Data_handling_with_R_annotated.R`

### 목차

| 항목 | 핵심 |
|---|---|
| 자료 가져오기 | `read.csv()`, `head()`, `str()` |
| 변수/케이스 삽입과 삭제 | `mutate()`, `select()`, `rows_insert()`, `rows_delete()`, `filter()` |
| 변수 변환 | 문자형 -> 숫자형, 연속형 -> 범주형 |
| 파생변수 생성 | low birth weight, age group, eGFR, composite endpoint, BMI |
| 변화량 계산 | 절대 변화량, 상대 변화량 |
| 추적기간 계산 | `as.Date()`, 날짜 차이, event/censor 기준 |
| 자료 결합 | row bind, column bind, `left_join()` |
| 자료 저장/탐색 | `write.csv()`, `write.xlsx()`, `table()`, `tapply()`, `group_by()` |

### 핵심 개념

| 개념 | 영어 | 시험 포인트 |
|---|---|---|
| 자료형 | data type | 숫자형, 문자형, 범주형을 구분해야 분석방법이 맞는다 |
| 결측값 | missing value, NA | `is.na()`, `!is.na()`, `na.rm=T`를 사용한다 |
| 파생변수 | derived variable | 원자료 변수로 BMI, eGFR, composite endpoint 등을 만든다 |
| 범주화 | categorization | 연속형 변수를 cut point 기준으로 0/1 또는 여러 그룹으로 변환한다 |
| 기준변수 | key variable | 자료 결합 시 `id` 같은 공통 키가 필요하다 |
| 반복측정자료 | repeated measures data | 한 대상자에 여러 행이 있을 수 있어 join 기준을 신중히 둔다 |

### 주요 공식과 코드

| 목적 | 공식/코드 | 해석 |
|---|---|---|
| 저체중아 | `lowbwt = ifelse(bwt <= 2500, 1, 0)` | 출생체중 2500g 이하이면 1 |
| BMI | `BMI = wt_entry / ((ht / 100)^2)` | kg/m², 키는 cm에서 m로 변환 |
| eGFR | `175 * serumcr^(-1.154) * age^(-0.203) * ifelse(sex==2, 0.742, 1)` | 여성 보정계수 0.742 적용 |
| composite endpoint | `ifelse(cond1 | cond2 | cond3, 1, 0)` | 여러 사건 중 하나라도 발생하면 1 |
| 절대 변화량 | `wt_entry - wt_6month` | 기준값과 추적값의 차이 |
| 상대 변화량 | `(wt_entry - wt_6month) / wt_entry` | 기준값 대비 변화율 |
| 추적기간 | `as.numeric(as.Date(end) - as.Date(entry))` | 날짜 차이를 일수로 계산 |

```r
library(dplyr)

data <- read.csv("Ex1_Data.csv", header = TRUE, stringsAsFactors = FALSE)

data2 <- data %>%
  mutate(
    lowbwt = ifelse(bwt <= 2500, 1, 0),
    smoke1 = ifelse(smoke == "Yes", 1, 0),
    age_group = ifelse(age <= 30, 1, ifelse(age <= 40, 2, 3))
  ) %>%
  select(-id)

with(data2, table(smoke, smoke1))
with(data2, tapply(bwt, lowbwt, summary))
```

### 답안 작성 포인트

| 문제 유형 | 답안 포인트 |
|---|---|
| 새 변수 생성 코드 쓰기 | `mutate()` 안에 `ifelse()` 또는 계산식을 넣는다 |
| 결측값 처리 | `is.na()`로 확인하고 계산 시 `NA`를 유지하거나 `na.rm=T` 사용 |
| 자료 결합 | 행 추가는 `rows_insert()`/row bind, 열 추가는 `left_join(..., by="id")` |
| 전처리 검증 | `head()`, `str()`, `table()`, `summary()`, `tapply()`로 확인 |

## 10주차: Regression And Correlation

근거 파일:
`DHC5049_10_Regression_correlation_updated.pdf`,
`10주차 실습자료/10주차 실습자료/DHC5049_10_Regression_correlation_updated.R`,
`10주차 실습자료/10주차 실습자료/DHC5049_10_Regression_correlation_annotated.R`

### 목차

| 항목 | 핵심 |
|---|---|
| Correlation methods | Pearson vs Spearman |
| Regression model | simple linear regression, multiple linear regression |
| Birthweight 실습 | `birthweight.csv`, `lwt`, `bwt`, `age`, `race`, `smoke` |
| 모델 진단 | 정규성, 선형성, 등분산성, 독립성, VIF |

### 상관분석

| 구분 | Pearson correlation | Spearman rank correlation |
|---|---|---|
| 한국어 | 피어슨 상관계수 | 스피어만 순위상관계수 |
| 자료 | 연속형, 선형관계 | 연속/순위형, 단조관계 |
| 가정 | 정규성에 더 민감 | 비정규/이상치에 상대적으로 강함 |
| 해석 | r이 +면 양의 상관, -면 음의 상관 | 순위가 함께 증가/감소하는지 |
| R | `cor.test(x, y, method="pearson")` | `cor.test(x, y, method="spearman", exact=FALSE)` |

상관계수:

```text
r = cov(X, Y) / (SD(X) * SD(Y))
-1 <= r <= 1
```

해석 템플릿:
`p<0.05이므로 두 변수 사이에 통계적으로 유의한 상관관계가 있다. r=0.19이면 약한 양의 상관관계로 해석한다. 단, 상관분석만으로 인과관계를 말할 수 없다.`

### 선형회귀

| 개념 | 영어 | 핵심 |
|---|---|---|
| 단순 선형회귀 | simple linear regression | 설명변수 1개 |
| 다중 선형회귀 | multiple linear regression | 설명변수 여러 개 |
| 회귀계수 | regression coefficient, beta | X 1단위 증가 시 Y 평균 변화량 |
| 절편 | intercept | X=0일 때 예측 Y |
| 결정계수 | R-squared | Y 변동 중 모델이 설명하는 비율 |
| 다중공선성 | multicollinearity | 설명변수끼리 강하게 관련되어 계수 불안정 |

공식:

```text
Simple:   Y_i = β0 + β1 X_i + ε_i
Multiple: Y_i = β0 + β1 X1_i + β2 X2_i + ... + βp Xp_i + ε_i
R² = SSR / SST = 1 - SSE / SST
```

가정:

| 가정 | 영어 | 확인/의미 |
|---|---|---|
| 선형성 | linearity | X와 Y의 평균관계가 선형 |
| 독립성 | independence | 관측치/잔차가 서로 독립 |
| 정규성 | normality | 잔차가 정규분포 |
| 등분산성 | equal variance, homoscedasticity | 잔차 분산이 일정 |
| 평균 0 | zero mean error | 잔차 평균이 0 |

대표 코드:

```r
data <- read.csv("birthweight.csv", header = TRUE, stringsAsFactors = FALSE)

with(data, shapiro.test(lwt))
with(data, shapiro.test(bwt))
with(data, cor.test(lwt, bwt, method = "spearman", exact = FALSE))

library(ggplot2)
ggplot(aes(x = lwt, y = bwt), data = data) +
  geom_point() +
  geom_smooth(method = lm) +
  theme_bw()

model <- glm(bwt ~ age, data = data)
summary(model)
cbind(coef(model), confint(model))

data$race <- factor(data$race)
data$smoke <- factor(data$smoke, levels = c("No", "Yes"))
model <- glm(bwt ~ age + race + smoke, data = data)

library(aod)
wald.test(b = coef(model), Sigma = vcov(model), Terms = 3:4)

library(car)
vif(model)
```

### 답안 작성 포인트

| 출력 | 봐야 할 것 | 해석 |
|---|---|---|
| `summary(model)` | Estimate, p-value | 계수 방향/크기/유의성 |
| `confint(model)` | 95% CI | 선형회귀 계수 CI가 0을 포함하지 않으면 유의 |
| `aov()` | F test p-value | 모델 전체의 유의성 |
| `R²` | 설명력 | 1에 가까울수록 설명력 큼 |
| `vif()` | VIF | 10 이상이면 심각한 다중공선성 의심 |

## 11주차: Logistic Regression

근거 파일:
`DHC5049_11_Logistic regression.pdf`,
`11주차 실습자료/11주차 실습자료/DHC5049_11_Logistic regression.R`,
`11주차 실습자료/11주차 실습자료/DHC5049_11_Logistic_regression_annotated.R`

### 목차

| 항목 | 핵심 |
|---|---|
| 범주형 자료의 관련성 | RR, OR |
| Logistic regression model | 이분형 outcome, logit link |
| R 실습 | `acs`, `framingham`, `glm(..., family="binomial")` |

### RR vs OR

2x2 표:

|  | Disease 발생 | Disease 미발생 | 전체 |
|---|---:|---:|---:|
| Exposure 있음 | A | B | A+B |
| Exposure 없음 | C | D | C+D |

공식:

```text
Relative Risk (RR) = [A / (A+B)] / [C / (C+D)]
Odds Ratio (OR) = (A/B) / (C/D) = AD / BC
```

| 구분 | RR | OR |
|---|---|---|
| 한국어 | 상대위험도 | 오즈비 |
| 주로 쓰는 설계 | cohort study | case-control study, logistic regression |
| 의미 | 위험 확률의 비 | odds의 비 |
| null value | 1 | 1 |
| 해석 | RR=1.08이면 위험이 1.08배 | OR=1.11이면 odds가 1.11배 |

### 로지스틱 회귀

공식:

```text
p = P(Y=1 | X)
logit(p) = log[p / (1-p)] = β0 + β1X1 + ... + βpXp
OR_j = exp(β_j)
β_j = log(OR_j)
```

| 개념 | 영어 | 시험 포인트 |
|---|---|---|
| 이분형 결과 | binary outcome | 0/1, No/Yes, Control/Case |
| 로짓 링크 | logit link | 확률을 log odds로 변환 |
| 회귀계수 | beta coefficient | log OR |
| 오즈비 | odds ratio | `exp(coef)` |
| 보정 오즈비 | adjusted OR | 다른 공변량을 통제한 OR |

대표 코드:

```r
library(moonBook)
library(dplyr)

data(acs)
mytable(cardiogenicShock ~ ., data = acs)

data <- acs %>%
  mutate(cardiogenicShock = ifelse(is.na(cardiogenicShock), NA,
                                   ifelse(cardiogenicShock == "Yes", 1, 0)))

fit <- glm(cardiogenicShock ~ factor(obesity),
           data = data, family = "binomial")
summary(fit)
extractOR(fit)

library(riskCommunicator)
data(framingham)
tmp <- framingham %>% filter(PERIOD == 1)

fit <- glm(CVD ~ factor(DIABETES) + factor(SEX) + AGE + BMI +
             SYSBP + HEARTRTE + TOTCHOL + factor(CURSMOKE) +
             factor(PREVHYP) + factor(BPMEDS),
           data = tmp, family = "binomial")
extractOR(fit)
car::vif(fit)
```

### 해석 템플릿

| 결과 | 답안 문장 |
|---|---|
| OR>1, p<0.05 | `다른 변수들을 보정했을 때, X가 있는 군은 기준군보다 outcome 발생 odds가 OR배 높고 통계적으로 유의하다.` |
| OR<1, p<0.05 | `X가 있는 군은 기준군보다 outcome 발생 odds가 낮다. 보호요인 가능성이 있다.` |
| 95% CI가 1 포함 | `OR의 95% CI가 1을 포함하므로 통계적으로 유의하다고 보기 어렵다.` |
| `factor()` 사용 | `범주형 변수를 연속형 숫자로 잘못 해석하지 않도록 factor로 지정한다.` |

## 12주차: Survival Analysis

근거 파일:
`DHC5049_12_Survival analysis.pdf`,
`12주차 실습자료/12주차 실습자료/DHC5049_12_Survival analysis.R`,
`12주차 실습자료/12주차 실습자료/DHC5049_12_Survival_analysis_annotated.R`

### 목차

| 항목 | 핵심 |
|---|---|
| Survival analysis introduction | time-to-event, censoring |
| Descriptive statistics | Kaplan-Meier survival curve |
| Difference test | log-rank test |
| Cox PH model | HR, PH assumption |
| R 실습 | `Surv()`, `survfit()`, `survdiff()`, `coxph()` |

### 핵심 개념

| 한국어 | 영어 | 핵심 |
|---|---|---|
| 생존자료 | survival data, time-to-event data | 사건 발생 여부와 사건까지 시간을 함께 가진 자료 |
| 사건 | event | 사망, CVD 발생, 재발 등 관심 결과 |
| 중도절단 | censoring | 사건이 관찰되지 않았지만 추적시간은 있는 상태 |
| 추적기간 | follow-up time | baseline부터 event 또는 censoring까지 시간 |
| 생존함수 | survival function | 시간 t 이후까지 event 없이 남을 확률 |
| 위험함수 | hazard function | t까지 생존했을 때 직후 event 발생 순간위험 |
| 비례위험 | proportional hazards | HR이 시간에 따라 일정하다는 Cox 가정 |

공식:

```text
S(t) = P(T > t)
h(t) = lim[dt -> 0] P(t <= T < t+dt | T >= t) / dt
Cox: h(t | X) = h0(t) * exp(βX)
HR = exp(β)
```

### Kaplan-Meier와 Log-rank

| 방법 | 목적 | R 코드 | 해석 |
|---|---|---|---|
| Kaplan-Meier | 그룹별 생존확률 추정 | `survfit(Surv(time,event) ~ group)` | 생존곡선이 낮을수록 event가 더 빨리/많이 발생 |
| 특정 시점 생존확률 | 5, 10, 15년 생존확률 | `summary(fit, times=c(5,10,15))` | `survival`, `n.risk`, `n.event`, CI 확인 |
| Log-rank test | 생존곡선 차이 검정 | `survdiff(Surv(time,event) ~ group)` | p<0.05이면 곡선 차이 |

### Cox PH 모델

| 출력 | 의미 | 해석 |
|---|---|---|
| `coef` | log HR | 양수면 hazard 증가 |
| `exp(coef)` | HR | HR>1 위험 증가, HR<1 위험 감소 |
| `p` | 유의성 | p<0.05이면 통계적으로 유의 |
| `cox.zph()` | PH 가정 검정 | p>0.05이면 가정 위반 근거 약함 |
| `GLOBAL` | 전체 모델 PH 검정 | 전체 모형의 비례위험 가정 |

대표 코드:

```r
library(dplyr)
library(riskCommunicator)
library(survival)
library(survminer)

data(framingham)
tmp <- framingham %>%
  filter(PERIOD == 1) %>%
  filter(TIMECVD > 0)

surv_fit <- survfit(Surv(TIMECVD / 365, CVD) ~ DIABETES, data = tmp)
ggsurvplot(surv_fit, data = tmp, conf.int = TRUE,
           risk.table = TRUE, pval = TRUE,
           xlab = "Time (years)", ylab = "Survival Probability")

summary(surv_fit, times = c(5, 10, 15, 20, 25))
survdiff(Surv(TIMECVD / 365, CVD) ~ DIABETES, data = tmp)

fit <- coxph(Surv(TIMECVD / 365, CVD) ~ factor(DIABETES) + factor(SEX) +
               AGE + BMI + SYSBP + HEARTRTE + TOTCHOL +
               factor(CURSMOKE) + factor(PREVHYP) + factor(BPMEDS),
             data = tmp)
summary(fit)
moonBook::extractHR(fit)
car::vif(fit)
cox.zph(fit)
ggcoxzph(cox.zph(fit))
```

### PH 가정 위반 시 대처

| 대처 | 설명 |
|---|---|
| outlier 제거/확인 | 극단값이 PH 위반을 유도하는지 확인 |
| 변수 변환 | log transformation, Box-Cox 등 |
| 범주화 | 연속형 변수를 임상 cut point로 분류 |
| time-dependent covariate | 시간과 상호작용하는 공변량 추가 |
| stratified Cox | 범주형 변수에서 PH 위반 시 층화 |
| 변수 제거 | 이론적으로 덜 중요한 위반 변수 제거 |

## 13주차: Data Analysis With R

근거 파일:
`DHC5049_13_Data analysis with R.pdf`,
`DHC5049_13_Data analysis with R_ver2.pdf`,
`13주차 실습자료/DHC5049_13_Data analysis with R.R`

### 목차

| 항목 | 핵심 |
|---|---|
| 논문 제출 흐름 | 문제 확인 -> 문헌고찰 -> 연구목적 -> 가설 -> 설계/방법 -> 수집 -> 분석/해석 -> 보고 |
| 연구목적 | CVD 발생에 영향을 미치는 인자 확인 |
| 분석 산출물 | Flow chart, Table 1, Table 2, Kaplan-Meier Figure, Cox Table |
| Framingham 자료 | Period 1, CVD, TIMECVD, 위험요인 변수 |

### Framingham 분석 계획

| 산출물 | 목적 | 주요 방법 |
|---|---|---|
| Flow chart | 최종 분석대상 선정 과정 | Period 1 선택, 결측 제거, 과거 CVD 관련 병력 제외 |
| Table 1 | 전체 연구대상자의 기초특성 | 범주형 n(%), 연속형 mean±SD 또는 median(IQR) |
| Table 2 | CVD 발생군 vs 비발생군 비교 | 연속형 Wilcoxon/t-test, 범주형 chi-square/Fisher |
| Figure 1 | DIABETES별 CVD-free survival curve | Kaplan-Meier, log-rank p-value |
| Table 3 | CVD 위험요인 분석 | Cox PH, univariable/multivariable HR |
| Supplementary Table | CVD yes/no 분석 | Logistic regression OR |

### 주요 변수

| 변수 | 의미 |
|---|---|
| `RANDID` | 개인 식별번호 |
| `SEX` | 성별 |
| `AGE` | 조사 시 나이 |
| `BMI` | 체질량지수 |
| `SYSBP`, `DIABP` | 수축기/이완기 혈압 |
| `TOTCHOL` | 총 콜레스테롤 |
| `DIABETES` | 당뇨 여부 |
| `CURSMOKE` | 현재 흡연 여부 |
| `PREVHYP` | 과거 고혈압 진단 |
| `BPMEDS` | 항고혈압제 복용 |
| `CVD` | 추적 후 심혈관질환 발생 |
| `TIMECVD` | CVD 발생 또는 censoring까지 시간 |

### Table 작성 규칙

| 변수형 | Table 1 요약 | Table 2 검정 |
|---|---|---|
| 범주형 | n (%) | Chi-square 또는 Fisher exact |
| 연속형, 정규성 만족 | mean ± SD | Two-sample t-test |
| 연속형, 정규성 위반 | median (Q1, Q3) | Wilcoxon rank-sum test |

대표 코드:

```r
library(dplyr)
library(riskCommunicator)
data(framingham)

data <- framingham %>%
  filter(PERIOD == 1) %>%
  filter(!is.na(TOTCHOL), !is.na(CIGPDAY), !is.na(BMI),
         !is.na(BPMEDS), !is.na(HEARTRTE), !is.na(GLUCOSE), !is.na(educ)) %>%
  filter(PREVCHD == 0, PREVAP == 0, PREVMI == 0, PREVSTRK == 0)

with(data, table(SEX))
with(data, shapiro.test(AGE))
with(data, c(summary(AGE), sd = sd(AGE)))

with(data, table(SEX, CVD))
chisq.test(with(data, table(SEX, CVD)))
wilcox.test(AGE ~ CVD, data = data)

library(survival)
library(survminer)
surv_fit <- survfit(Surv(TIMECVD / 365, CVD) ~ DIABETES, data = data)
ggsurvplot(surv_fit, data = data, conf.int = TRUE,
           risk.table = TRUE, pval = TRUE)

fit <- coxph(Surv(TIMECVD / 365, CVD) ~ SEX + AGE + BMI + SYSBP +
               factor(ifelse(TOTCHOL < 200, 0, 1)) + DIABETES +
               CURSMOKE + PREVHYP + BPMEDS,
             data = data)
summary(fit)
cox.zph(fit)
```

### 13주차 수치 기억 포인트

`DHC5049_13_Data analysis with R_ver2.pdf` 기준:

| 항목 | 값/패턴 |
|---|---|
| 전체 Framingham 등록 | n=11,627 |
| Period 1 | n=4,434 |
| 최종 분석대상 | n=3,637 |
| CVD 발생군 | n=874 |
| No CVD | n=2,763 |
| Diabetes별 KM log-rank | p<.0001 |
| DIABETES=0 20년 survival | 약 0.798 |
| DIABETES=1 20년 survival | 약 0.372 |
| 다변량 Cox 주요 예 | AGE HR 약 1.055, BMI HR 약 1.029, SYSBP HR 약 1.013, CURSMOKE HR 약 1.411 |

해석 예:
`다변량 Cox 모델에서 흡연의 HR이 1.411이고 95% CI가 1을 포함하지 않으면, 다른 공변량을 보정한 뒤에도 현재 흡연자는 비흡연자보다 CVD 발생 hazard가 약 1.41배 높다.`

## 15주차: Epidemiological Studies And Machine Learning

근거 파일:
`DHC5049_15_Introduction to epidemiology & machine learning.pdf`

### 목차

| 항목 | 핵심 |
|---|---|
| Epidemiology | PICO, 연구설계, 근거수준 |
| Cohort study | 노출에서 질병 발생을 추적 |
| Case-control study | 질병군/대조군에서 과거 노출 비교 |
| Cross-sectional study | 한 시점에서 유병률/특성 평가 |
| Case report/series | 드문 사례 기술 |
| Experimental studies | RCT, non-randomized trial, crossover |
| Machine learning | AI/ML/DL, supervised/unsupervised, LLM, ethical AI |

### 연구설계 비교

| 설계 | 한국어 | 시작점 | 방향 | 주로 계산 | 장점 | 주의점 |
|---|---|---|---|---|---|---|
| Cohort | 코호트 연구 | 노출 여부 | 노출 -> 결과 | incidence, RR, HR | 시간 순서 명확 | 시간/비용 큼 |
| Case-control | 환자-대조군 연구 | 질병 여부 | 결과 -> 과거 노출 | OR | 드문 질병에 효율적 | recall/selection bias |
| Cross-sectional | 단면 연구 | 한 시점의 모집단 | 동시 측정 | prevalence | 빠르고 저렴 | 인과 시간성 약함 |
| Case report/series | 증례보고/증례군 | 특정 사례 | 기술 | 없음 또는 단순 빈도 | 새 현상 발견 | 일반화 어려움 |
| RCT | 무작위대조시험 | 중재 배정 | 중재 -> 결과 | risk difference, RR | 근거수준 높음 | 현실 적용성/윤리 고려 |

### PICO

| 요소 | 의미 | 예 |
|---|---|---|
| P | Patient/Population | 연구대상자 |
| I | Intervention/Exposure | 중재 또는 노출 |
| C | Comparison | 대조군 |
| O | Outcome | 결과변수 |

### 머신러닝 개념

| 개념 | 영어 | 핵심 |
|---|---|---|
| 인공지능 | Artificial Intelligence, AI | 인간 지능 모사 전체 |
| 머신러닝 | Machine Learning, ML | 데이터로부터 규칙/패턴 학습 |
| 딥러닝 | Deep Learning, DL | 신경망 기반 ML |
| 지도학습 | supervised learning | 정답 label이 있음, 분류/회귀 |
| 비지도학습 | unsupervised learning | 정답 label 없이 군집/차원축소 |
| zero-shot learning | zero-shot learning | 별도 학습 예시 없이 새 과제 수행 |
| 생성형 AI | generative AI | 텍스트/이미지 등 새 콘텐츠 생성 |
| LLM | large language model | 대규모 언어모델 |
| multimodal model | multimodal model | 텍스트, 이미지 등 여러 modality 활용 |

Ethical AI 답안 포인트:

| 이슈 | 설명 |
|---|---|
| bias | 대표성 낮은 자료로 학습하면 소수집단에 불리할 수 있음 |
| privacy | 환자/사용자 정보 수집과 활용에 대한 동의와 보호 필요 |
| mistakes | 의료 AI 오류는 환자 안전 문제로 이어질 수 있어 검증 필요 |
| environmental impact | 대형 모델 학습은 많은 에너지 사용 |

## 핵심 공식 모음

| 주제 | 공식 | null value | 해석 |
|---|---|---|---|
| Pearson r | `cov(X,Y)/(SD(X)SD(Y))` | 0 | 0이면 선형 상관 없음 |
| 선형회귀 | `Y=β0+β1X+ε` | β=0 | X 1단위 증가 시 Y 평균 β 변화 |
| R² | `SSR/SST` 또는 `1-SSE/SST` | 없음 | Y 변동 중 설명 비율 |
| RR | `[A/(A+B)]/[C/(C+D)]` | 1 | 위험 확률의 비 |
| OR | `(A/B)/(C/D)=AD/BC` | 1 | odds의 비 |
| Logit | `log[p/(1-p)]` | 없음 | 확률을 log odds로 변환 |
| Logistic OR | `exp(β)` | 1 | X 1단위 증가 또는 노출군의 odds 배수 |
| Survival | `S(t)=P(T>t)` | 없음 | t 이후까지 event 없을 확률 |
| Hazard | `h(t)` | 없음 | t 직후 event 순간위험 |
| Cox HR | `exp(β)` | 1 | X에 따른 hazard 배수 |
| BMI | `weight(kg)/height(m)^2` | 없음 | 체질량지수 |
| eGFR | `175*Cr^-1.154*Age^-0.203*(0.742 if female)` | 없음 | 신기능 추정 |

## R 함수 색인

| 함수 | 패키지 | 용도 | 시험 중 검색어 |
|---|---|---|---|
| `install.packages()` | base/utils | 패키지 설치 | install |
| `library()` | base | 패키지 로드 | library |
| `setwd()` | base | 작업 폴더 지정 | working directory |
| `read.csv()` | utils | CSV 읽기 | read csv |
| `head()`, `tail()` | utils | 앞/뒤 행 확인 | head tail |
| `str()` | utils | 자료 구조 확인 | structure |
| `summary()` | base | 요약통계/모델 요약 | summary |
| `with()` | base | 데이터 안 변수 직접 사용 | with |
| `table()` | base | 빈도표/교차표 | frequency |
| `tapply()` | base | 그룹별 함수 적용 | by group |
| `%>%` | magrittr/dplyr | 파이프 | pipe |
| `mutate()` | dplyr | 변수 생성/변환 | mutate |
| `select()` | dplyr | 변수 선택/삭제 | select |
| `filter()` | dplyr | 행 필터링 | filter |
| `rows_insert()` | dplyr | 행 삽입 | rows insert |
| `rows_delete()` | dplyr | 행 삭제 | rows delete |
| `left_join()` | dplyr | 키 기준 열 결합 | join |
| `group_by()` | dplyr | 그룹 지정 | group |
| `summarise()` | dplyr | 그룹별 요약 | summarise |
| `ifelse()` | base | 조건부 값 생성 | ifelse |
| `is.na()` | base | 결측 확인 | missing |
| `factor()` | base | 범주형 지정 | factor |
| `as.Date()` | base | 날짜 변환 | date |
| `write.csv()` | utils | CSV 저장 | export csv |
| `write.xlsx()` | openxlsx | Excel 저장 | xlsx |
| `ggplot()` | ggplot2 | 그래프 시작 | ggplot |
| `geom_point()` | ggplot2 | 산점도 | scatter |
| `geom_smooth(method=lm)` | ggplot2 | 회귀선 | regression line |
| `theme_bw()` | ggplot2 | 그래프 테마 | theme |
| `shapiro.test()` | stats | 정규성 검정 | normality |
| `cor.test()` | stats | 상관분석 | correlation |
| `glm()` | stats | GLM, 선형/로지스틱 | regression |
| `aov()` | stats | ANOVA | model significance |
| `coef()` | stats | 계수 추출 | coefficient |
| `confint()` | stats | 신뢰구간 | confidence interval |
| `vcov()` | stats | 분산-공분산 행렬 | covariance |
| `wald.test()` | aod | 여러 계수 동시 검정 | Wald |
| `vif()` | car | 다중공선성 | VIF |
| `mytable()` | moonBook | 기초특성표 | Table 1 |
| `extractOR()` | moonBook | OR와 CI 추출 | odds ratio |
| `extractHR()` | moonBook | HR와 CI 추출 | hazard ratio |
| `Surv()` | survival | 생존객체 생성 | survival object |
| `survfit()` | survival | KM 생존곡선 | Kaplan-Meier |
| `survdiff()` | survival | log-rank test | log-rank |
| `coxph()` | survival | Cox PH 모델 | Cox |
| `cox.zph()` | survival | PH 가정 검정 | Schoenfeld |
| `ggsurvplot()` | survminer | 생존곡선 그림 | KM plot |
| `ggcoxzph()` | survminer | Schoenfeld residual plot | PH plot |

## 헷갈리기 쉬운 개념 비교표

| 비교 | A | B | 구분 포인트 |
|---|---|---|---|
| correlation vs regression | 상관분석 | 회귀분석 | 상관은 관련성 강도/방향, 회귀는 Y를 X로 설명/예측 |
| Pearson vs Spearman | 선형 상관 | 순위/단조 상관 | 정규성/이상치 우려 시 Spearman |
| association vs causation | 관련성 | 인과성 | 관찰연구 통계분석만으로 인과 단정 금지 |
| RR vs OR | 위험비 | 오즈비 | cohort는 RR 가능, case-control/logistic은 OR |
| OR vs HR | odds의 비 | hazard의 비 | HR은 time-to-event와 censoring을 반영 |
| logistic vs Cox | 이분형 발생 여부 | 발생 여부 + 시간 | Cox는 `Surv(time,event)` 필요 |
| censoring vs no event | 중도절단 | 사건 미발생 | censoring은 관찰 종료 시점까지 event 없음, 이후는 모름 |
| Table 1 vs Table 2 | 전체 기초특성 | outcome 그룹 비교 | Table 2에는 p-value가 들어감 |
| univariable vs multivariable | 변수 하나씩 | 여러 변수 동시 보정 | adjusted OR/HR은 다변량 모델 결과 |
| confounder vs predictor | 교란변수 | 예측변수 | 교란변수는 노출-결과 관계를 왜곡할 수 있어 보정 |
| cross-sectional vs longitudinal | 한 시점 | 여러 시점/추적 | 생존분석은 longitudinal/time-to-event |
| supervised vs unsupervised | label 있음 | label 없음 | 분류/회귀 vs 군집/차원축소 |

## 회귀분석, 상관분석, 로지스틱, 생존분석, 역학, ML 비교

| 영역 | 주 질문 | outcome | 대표 결과값 | 대표 가정/주의 | 대표 코드 |
|---|---|---|---|---|---|
| 상관분석 | X와 Y가 함께 변하나 | 연속형 | r, p-value | 인과 아님, Pearson은 선형/정규성 | `cor.test()` |
| 선형회귀 | X가 Y 평균을 얼마나 바꾸나 | 연속형 | β, 95% CI, R² | 잔차 가정, 다중공선성 | `glm(y~x)` |
| 로지스틱 회귀 | X가 사건 odds를 바꾸나 | 이분형 | OR, 95% CI | OR를 risk로 오해하지 않기 | `glm(..., family="binomial")` |
| 생존분석 | X가 event hazard를 바꾸나 | time + event | HR, KM, log-rank | censoring, PH assumption | `coxph(Surv(t,e)~x)` |
| 역학 | 어떤 설계가 질문에 맞나 | 설계별 다름 | RR, OR, HR, prevalence | bias/confounding/time order | PICO, study design |
| 머신러닝 | 데이터로 예측/분류 가능한가 | label 유무별 | accuracy 등 성능지표 | bias/privacy/검증 | supervised/unsupervised |

## 예상 문제 유형과 답안 작성 포인트

| 예상 문제 | 바로 쓸 답안 구조 |
|---|---|
| 분석방법 선택 | `Y가 무엇인가 -> X가 무엇인가 -> 자료형에 맞는 방법 선택 -> 귀무가설 제시` |
| 상관계수 해석 | `방향(+/-), 강도, p-value, 인과 아님` 순서로 쓴다 |
| 선형회귀 계수 해석 | `다른 변수 고정 시 X 1단위 증가에 따른 Y 평균 변화량`으로 쓴다 |
| 로지스틱 OR 해석 | `기준군 대비 노출군의 outcome odds가 OR배`라고 쓴다 |
| Cox HR 해석 | `기준군 대비 노출군의 event hazard가 HR배`라고 쓴다 |
| CI 해석 | 선형 β는 0 포함 여부, OR/HR은 1 포함 여부를 본다 |
| Table 1 작성 | 범주형 n(%), 연속형 정규성에 따라 mean±SD 또는 median(IQR) |
| Table 2 검정 선택 | 연속형 t/Wilcoxon, 범주형 chi-square/Fisher |
| KM 그래프 해석 | 곡선 위치, 특정 시점 생존확률, log-rank p-value |
| PH 가정 질문 | `cox.zph()`와 Schoenfeld residual, p>0.05면 위반 근거 약함 |
| VIF 질문 | VIF가 크면 다중공선성, 계수 불안정, 변수 제거/통합 고려 |
| 역학 설계 구분 | cohort는 노출에서 결과로 추적, case-control은 결과에서 과거 노출로 역추적 |
| ML 개념 구분 | supervised는 label 있음, unsupervised는 label 없음, generative AI는 새 콘텐츠 생성 |

## 오픈북 키워드 색인

| 키워드 | 찾아볼 섹션 |
|---|---|
| `read.csv`, `head`, `str` | 9주차, R 함수 색인 |
| `mutate`, `ifelse`, `factor` | 9주차, R 함수 색인 |
| `BMI`, `eGFR`, `composite endpoint` | 9주차 |
| `left_join`, `rows_insert`, `rows_delete` | 9주차 |
| `cor.test`, `Pearson`, `Spearman` | 10주차 |
| `linear regression`, `glm`, `aov`, `R²` | 10주차 |
| `wald.test`, `VIF`, `multicollinearity` | 10주차, 11주차, 13주차 |
| `RR`, `OR`, `odds ratio`, `logit` | 11주차 |
| `family="binomial"`, `extractOR` | 11주차 |
| `Surv`, `Kaplan-Meier`, `log-rank` | 12주차 |
| `coxph`, `HR`, `PH assumption`, `cox.zph` | 12주차 |
| `Table 1`, `Table 2`, `Flow chart` | 13주차 |
| `Framingham`, `CVD`, `TIMECVD`, `DIABETES` | 11~13주차 |
| `PICO`, `cohort`, `case-control`, `cross-sectional` | 15주차 |
| `supervised`, `unsupervised`, `LLM`, `ethical AI` | 15주차 |

## 시험 직전 10분 체크리스트

| 체크 | 내용 |
|---|---|
| 1 | outcome 자료형부터 확인: 연속형/이분형/time-to-event |
| 2 | 범주형 변수는 `factor()` 처리 여부 확인 |
| 3 | OR/HR 해석 시 null value는 1, β 해석 시 null value는 0 |
| 4 | p-value만 보지 말고 95% CI가 null을 포함하는지 확인 |
| 5 | Cox 모델이면 PH assumption과 censoring을 언급 |
| 6 | 다변량 모델이면 `adjusted`라는 표현을 사용 |
| 7 | 상관분석 결과를 인과관계로 쓰지 않기 |
| 8 | Table 1/2에서는 변수형에 맞는 요약과 검정 선택 |
| 9 | VIF가 크면 다중공선성으로 계수 해석 불안정 |
| 10 | 연구설계 문제는 시간 방향과 시작점으로 구분 |
