# 1 ----
# install.packages("riskCommunicator")
library(riskCommunicator)
library(tidyverse)
library(moonBook)

setwd("/Users/hyunsooshin/desktop")
dir()
dt <- read_csv("framingham.csv")

# 2 ----
## 2-1 ----
dt %>% 
  filter(PERIOD == 2)

## 2-2 ----
dt %>% 
  filter(PERIOD == 2) %>% 
  filter(is.na(TOTCHOL))

## 2-3 ----
dt %>% 
  filter(PERIOD == 2) %>% 
  filter(PREVCHD == 1)

## 2-4 ----
dt_study <- dt %>% 
  filter(PERIOD == 2) %>% 
  filter(!is.na(TOTCHOL)) %>% 
  filter(!(PREVCHD == 1 & PREVAP == 1 & PREVMI == 1 & PREVSTRK == 1))

dt_study %>% dim()

# 3 ----
dt_study
## 3-1 ----
# (1) 설명변수들 간 독립이 아닌, 즉 상관관계가 강한 경우 생기는 이슈
# 다중공선성

# (2) VIF


## 3-2 ----
colnames(dt_study)
dt$BPMEDS
lm_fit <- glm(CVD ~ DIABETES + factor(SEX) + AGE + BMI + SYSBP + HEARTRTE + TOTCHOL +
                CURSMOKE + HYPERTEN + BPMEDS, data = dt_study, family = "binomial")
summary(lm_fit)

exp(1.25)
extractOR(lm_fit)

