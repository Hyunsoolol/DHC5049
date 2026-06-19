#######################################################################
# 헬스케어데이터분석개론 9강: Data handling with R #
# 실습자료 #
#######################################################################


###### 강의자료 ----


  ### 준비: 패키지와 라이브러리 설정하기 -----

  # 1-1. 패키지 설치하기
  install.packages("dplyr")
  # install.packages(): 패키지를 처음 사용할 때 한 번만 실행하면 됩니다.
  # dplyr: 데이터 조작에 특화된 패키지입니다. (필터링, 변수 추가, 요약, 결합 등)

  # 1-2. 패키지 설정하기
  library(dplyr)   # dplyr 패키지를 현재 세션에서 사용할 수 있도록 활성화합니다.
  library(MASS)    # MASS 패키지를 활성화합니다. (다양한 통계 함수와 데이터셋 제공)

  # 1-3. 작업 디렉토리 설정하기
  setwd("C:/Users/sangahchi/Desktop/")
  # setwd("경로"): 작업 디렉토리(working directory)를 지정합니다.
  # 이후 read.csv() 등에서 파일 경로를 전체 경로 대신 파일명만으로 지정할 수 있습니다.


  ### 0. 자료 가져오기 -----

  # Ex1_Data 자료 가져오기
  Ex1_Data <- read.csv("Ex1_Data.csv", header = T, stringsAsFactors = F)
  # read.csv(): CSV 파일을 읽어 데이터프레임으로 불러옵니다.
  # header=T: 첫 행을 변수명으로 사용합니다.
  # stringsAsFactors=F: 문자형 변수를 팩터로 자동 변환하지 않고 문자형으로 유지합니다.

  # 자료의 첫 6줄 확인하기
  head(Ex1_Data)
  # head(데이터프레임): 데이터의 첫 6행을 출력합니다.
  # 데이터를 불러온 후 값이 올바르게 입력됐는지 빠르게 확인할 때 사용합니다.

  # 자료의 구조 확인하기
  str(Ex1_Data)
  # str(): 데이터프레임의 구조를 요약합니다.
  # 변수명, 타입(chr/int/num 등), 값 일부를 한눈에 파악할 수 있습니다.


  ### 1. 변수 및 케이스 삽입/지우기 -----

  # 새로운 변수(New) 추가하기 (1)
  tmp <- dplyr::mutate(Ex1_Data, New = 1)
  # dplyr::mutate(데이터프레임, 새변수명 = 값): 데이터프레임에 새로운 열을 추가합니다.
  # New = 1: 모든 행에 값이 1인 New 변수를 추가합니다.
  # dplyr::: 패키지명을 명시하여 다른 패키지의 동명 함수와 충돌을 방지합니다.

  # 새로운 데이터 구조 확인하기
  str(tmp)
  # str(): New 변수가 추가되었는지 구조를 확인합니다.


  # 새로운 변수(New2) 추가하기 (2)
  tmp <- Ex1_Data %>%
    dplyr::mutate(New2 = rep(c("A", "B", "C"), 63))
  # %>% (파이프 연산자): 왼쪽 객체를 오른쪽 함수의 첫 번째 인수로 전달합니다.
  #   Ex1_Data %>% mutate(...): Ex1_Data를 mutate()에 넣는 것과 동일합니다.
  #   여러 단계의 작업을 순서대로 연결할 때 코드를 읽기 쉽게 만들어줍니다.
  # rep(c("A","B","C"), 63): "A","B","C"를 63번 반복하여 189개짜리 벡터를 만듭니다.
  #   (Ex1_Data의 행 수 189 = 3 × 63)

  # 새로운 데이터 구조 확인하기
  str(tmp)
  # str(): New2 변수가 추가되었는지 구조를 확인합니다.


  # id 변수 지우기
  tmp <- tmp %>%
    dplyr::select(-id)
  # dplyr::select(-변수명): 지정한 변수를 제외하고 나머지 변수만 선택합니다.
  # -id: id 변수를 제거합니다. (선택이 아닌 제거이므로 '-' 부호를 사용합니다.)
  # select(변수명)처럼 '-' 없이 쓰면 해당 변수만 선택합니다.

  # 새로운 데이터 구조 확인하기
  str(tmp)
  # str(): id 변수가 제거되었는지 확인합니다.


  # 새로운 케이스 삽입하기 (1)
  tmp <- Ex1_Data %>%
    dplyr::rows_insert(data.frame(id = 190, age = 40, race = 1, smoke = "No", lwt = 100, ptl = 1, ht = 0, ui = 0, ftv = 0), by = "id")
  # dplyr::rows_insert(데이터프레임, 삽입할행, by=기준변수): 새로운 행을 삽입합니다.
  # data.frame(...): 삽입할 1개의 새 행을 데이터프레임 형태로 만듭니다.
  # by="id": id 변수를 기준으로 중복 여부를 확인합니다. (이미 존재하는 id이면 오류 발생)

  # 자료의 마지막 6줄 확인하기
  tail(tmp)
  # tail(데이터프레임): 데이터의 마지막 6행을 출력합니다. (head()의 반대)
  # 새 행이 마지막에 올바르게 추가되었는지 확인합니다.


  # 새로운 케이스 삽입하기 (2)
  New <- data.frame(id = 190:192, age = c(40, NA, 60), race = c(1, 1, 1), smoke = rep("No", 3))
  # data.frame(): 여러 벡터를 열로 묶어 새로운 데이터프레임을 만듭니다.
  # id=190:192: 190, 191, 192 세 행을 만듭니다.
  # age=c(40,NA,60): 두 번째 행의 나이는 NA(결측값)로 입력합니다.
  # rep("No",3): "No"를 3번 반복하여 smoke 열을 채웁니다.

  tmp <- Ex1_Data %>% dplyr::rows_insert(New)
  # rows_insert(): Ex1_Data에 New 데이터프레임의 3개 행을 삽입합니다.

  # 자료의 마지막 6줄 확인하기
  tail(tmp)
  # tail(): 새 행 3개가 마지막에 올바르게 추가되었는지 확인합니다.


  # 케이스 지우기 (1)
  tmp <- Ex1_Data %>%
    dplyr::rows_delete(data.frame(id = c(1, 3, 10)))
  # dplyr::rows_delete(데이터프레임, 삭제할행): 지정한 행을 삭제합니다.
  # data.frame(id=c(1,3,10)): id가 1, 3, 10인 행을 삭제 대상으로 지정합니다.

  # 자료의 첫 8줄 확인하기
  head(tmp, 8)
  # head(데이터프레임, n): 데이터의 첫 n행을 출력합니다.
  # id 1, 3, 10번 행이 제거되고 2, 4, 5, ...번 행이 남아있는지 확인합니다.


  # 케이스 지우기 (2)
  tmp <- tmp %>%
    dplyr::filter(age >= 18)
  # dplyr::filter(조건): 조건을 만족하는 행만 남기고 나머지를 제거합니다.
  # age>=18: 나이가 18세 이상인 행만 선택합니다. (미성년자 행 제거)

  # 변수의 요약통계량 확인하기
  summary(tmp$age)
  # summary(): age 변수의 요약 통계량을 출력합니다.
  # 최솟값이 18 이상인지 확인하여 필터링이 올바르게 적용되었는지 검증합니다.


  ### 2. 자료 변환하기: 문자형 입력 -> 숫자형 입력 -----
  # 범주형 변수(smoke)의 문자형 값 No, Yes를 0, 1로 변환하고 싶다면?

  # smoke1 변수 삽입하기 (1)
  tmp <- Ex1_Data %>%
    dplyr::mutate(smoke1 = ifelse(smoke == "No", 0, 1))
  # dplyr::mutate(): 새로운 변수 smoke1을 추가합니다.
  # ifelse(조건, 참일 때 값, 거짓일 때 값): 조건에 따라 다른 값을 할당합니다.
  # smoke=="No"이면 0, 아니면(Yes이면) 1을 부여합니다.

  # smoke1 변수 삽입하기 (2)
  tmp <- Ex1_Data %>%
    dplyr::mutate(smoke1 = ifelse(smoke == "Yes", 1, 0))
  # ifelse(): smoke=="Yes"이면 1, 아니면(No이면) 0을 부여합니다.
  # (1)과 동일한 결과를 반환합니다. 조건의 기준을 바꿔도 결과는 같습니다.

  # smoke 변수와 smoke1 변수의 교차빈도표 확인하기
  table(tmp$smoke, tmp$smoke1)
  # table(변수1, 변수2): 두 변수의 교차표를 만듭니다.
  # smoke(No/Yes)와 smoke1(0/1)이 올바르게 대응되는지 확인합니다.

  with(tmp, table(smoke, smoke1))
  # with(tmp, ...): tmp 데이터 안에서 변수명을 직접 씁니다.
  # table(smoke, smoke1): 위와 동일한 교차표를 만듭니다. (결과 동일)


  ### 3. 파생변수 만들기: 연속형 변수 -> 범주형 변수 (그룹변수) -----

  ### 연속형 변수 -> 이분형 변수 -----
  # 연속형 변수인 체중(bwt)을 저체중여부(lowbwt)로 변환하고 싶다면?

  # lowbwt 변수 삽입하기 (1)
  tmp <- Ex1_Data %>%
    dplyr::mutate(lowbwt = ifelse(bwt <= 2500, 1, 0))
  # dplyr::mutate(): 새로운 변수 lowbwt를 추가합니다.
  # ifelse(bwt<=2500, 1, 0): 출생체중이 2500g 이하이면 1(저체중), 초과이면 0을 부여합니다.

  # lowbwt 변수 삽입하기 (2)
  tmp <- Ex1_Data %>%
    dplyr::mutate(lowbwt = ifelse(bwt > 2500, 0, 1))
  # ifelse(bwt>2500, 0, 1): 출생체중이 2500g 초과이면 0, 이하이면 1을 부여합니다.
  # (1)과 조건 방향만 다를 뿐 동일한 결과를 반환합니다.

  # lowbwt 변수에 따른 bwt 변수의 분포 확인하기
  with(tmp, tapply(bwt, lowbwt, summary))
  # tapply(변수, 그룹변수, 함수): 그룹별로 함수를 적용합니다.
  # bwt를 lowbwt(0/1) 그룹별로 summary를 적용하여 분류가 올바른지 확인합니다.


  ### 연속형 변수 -> 다범주 변수 -----
  # 연속형 변수인 연령(age)을 연령군(age1)으로 변환하고 싶다면?

  # age1 변수 삽입하기
  tmp <- Ex1_Data %>%
    dplyr::mutate(age1 = ifelse(age <= 30, 1,
                                ifelse(age <= 40, 2, 3)))
  # dplyr::mutate(): 새로운 변수 age1을 추가합니다.
  # 중첩 ifelse(): 조건을 순서대로 적용하여 세 범주를 만듭니다.
  #   age <= 30이면 1 (30세 이하)
  #   age <= 30이 아니고 age <= 40이면 2 (31~40세)
  #   나머지(age > 40)이면 3 (41세 이상)

  # age1 변수에 따른 age 변수의 분포 확인하기
  with(tmp, tapply(age, age1, summary))
  # tapply(): age를 age1(1/2/3) 그룹별로 summary를 적용합니다.
  # 각 연령군의 age 범위가 올바르게 구분되었는지 확인합니다.


  ### 4. 파생변수 만들기: 합성변수 만들기 -----

  # Ex2_Data 자료 가져오기
  Ex2_Data <- read.csv("Ex2_Data.csv", header = T, stringsAsFactors = F)
  # read.csv(): Ex2_Data.csv 파일을 읽어 데이터프레임으로 불러옵니다.

  head(Ex2_Data)   # 데이터의 첫 6행을 출력하여 값을 확인합니다.
  str(Ex2_Data)    # 데이터의 구조(변수명, 타입)를 확인합니다.


  ### 연속형-범주형 -----
  # Serum Creatinine과 Age, Sex로 eGFR (estimated GFR)을 계산하고 싶다면?

  # eGFR 변수 삽입하기 (1)
  tmp <- Ex2_Data %>%
    dplyr::mutate(eGFR = ifelse(sex == 1,
                                175 * serumcr^(-1.154) * age^(-0.203),
                                175 * serumcr^(-1.154) * age^(-0.203) * 0.742))
  # dplyr::mutate(): 새로운 변수 eGFR을 추가합니다.
  # ifelse(sex==1, 남성 공식, 여성 공식): 성별에 따라 다른 eGFR 공식을 적용합니다.
  #   남성(sex==1): 175 × Cr^(-1.154) × Age^(-0.203)
  #   여성(sex==2): 남성 공식 × 0.742 (여성 보정 계수)
  # ^: 거듭제곱 연산자입니다. (serumcr^(-1.154): 혈청 크레아티닌의 -1.154 제곱)

  # eGFR 변수의 분포 확인하기
  with(tmp, summary(eGFR))
  # summary(): eGFR 변수의 요약 통계량(최솟값, Q1, 중앙값, 평균, Q3, 최댓값)을 출력합니다.

  # eGFR 변수 삽입하기 (2)
  tmp <- Ex2_Data %>%
    dplyr::mutate(eGFR = 175 * serumcr^(-1.154) * age^(-0.203) * ifelse(sex == 2, 0.742, 1))
  # 공식을 하나로 통합하여 더 간결하게 작성한 방법입니다.
  # ifelse(sex==2, 0.742, 1): 여성(sex==2)이면 0.742, 남성이면 1을 곱합니다.
  # (1)과 동일한 결과를 반환합니다.

  # eGFR 변수의 분포 확인하기
  with(tmp, summary(eGFR))
  # summary(): eGFR 분포를 확인합니다. (1)번과 동일한 결과인지 비교합니다.


  ### 범주형-범주형 -----
  # 호흡곤란, 감염, 절개부위 열림, 구토, 체온 상승 중 1개 이상인 경우로 composite endpoint를 만들고 싶다면?

  # comp 변수 삽입하기
  tmp <- Ex2_Data %>%
    dplyr::mutate(comp = ifelse((dyspnea == 1) | (infection == 1) | (incision_failure == 1) | (vomit == 1) | (hightemp == "Yes"), 1, 0))
  # dplyr::mutate(): 새로운 변수 comp(composite endpoint)를 추가합니다.
  # |: OR 연산자입니다. 여러 조건 중 하나라도 TRUE이면 TRUE를 반환합니다.
  #   dyspnea==1: 호흡곤란 / infection==1: 감염 / incision_failure==1: 절개부위 열림
  #   vomit==1: 구토 / hightemp=="Yes": 체온 상승
  # 다섯 가지 중 하나 이상 해당하면 1(발생), 모두 해당 없으면 0(미발생)

  # comp 변수의 분포 확인하기
  with(tmp, table(comp))
  # table(): comp 변수의 빈도(0: 미발생, 1: 발생)를 확인합니다.


  ### 연속형-연속형 -----
  # 키와 몸무게로 BMI (Body mass index)를 계산하고 싶다면?

  # BMI 변수 삽입하기
  tmp <- Ex2_Data %>%
    dplyr::mutate(BMI = wt_entry / ((ht / 100)^2))
  # dplyr::mutate(): 새로운 변수 BMI를 추가합니다.
  # BMI 공식: 체중(kg) / 키(m)^2
  #   ht/100: 키를 cm에서 m 단위로 변환합니다.
  #   (ht/100)^2: 키(m)의 제곱을 계산합니다.

  # BMI 변수의 분포 확인하기
  with(tmp, summary(BMI))
  # summary(): BMI 변수의 요약 통계량을 출력합니다.


  ### 5. 파생변수 만들기: 절대 변화량 및 상대 변화량 계산하기 -----
  # 폐암 진단 전에 비해 진단 후의 몸무게 수치가 얼마나 변했는지 알고 싶다면?

  # 절대변화량 wt_loss1 변수 삽입하기
  tmp <- Ex2_Data %>%
    dplyr::mutate(wt_loss1 = ifelse(is.na(wt_6month), NA, wt_entry - wt_6month))
  # dplyr::mutate(): 새로운 변수 wt_loss1(체중 절대 변화량)을 추가합니다.
  # is.na(wt_6month): wt_6month(6개월 후 체중)가 NA(결측값)인지 확인합니다.
  # ifelse(is.na(wt_6month), NA, wt_entry-wt_6month):
  #   wt_6month가 NA이면 결과도 NA로 처리합니다.
  #   wt_6month가 있으면 진단 시 체중 - 6개월 후 체중(절대 변화량)을 계산합니다.

  # wt_loss1 변수의 분포 확인하기
  with(tmp, summary(wt_loss1))
  # summary(): wt_loss1(절대 변화량)의 분포를 확인합니다. NA's 항목도 함께 출력됩니다.

  # 상대변화량 wt_loss2 변수 삽입하기
  tmp <- Ex2_Data %>%
    dplyr::mutate(wt_loss2 = ifelse(!is.na(wt_6month), (wt_entry - wt_6month) / wt_entry, NA))
  # dplyr::mutate(): 새로운 변수 wt_loss2(체중 상대 변화량)를 추가합니다.
  # !is.na(wt_6month): wt_6month가 NA가 아닌 경우(값이 있는 경우)
  #   '!': NOT 연산자입니다. is.na()의 결과를 반대로 뒤집습니다.
  # (wt_entry-wt_6month)/wt_entry: (진단 시 체중 - 6개월 후 체중) / 진단 시 체중 = 상대 변화율

  # wt_loss2 변수의 분포 확인하기
  with(tmp, summary(wt_loss2))
  # summary(): wt_loss2(상대 변화량)의 분포를 확인합니다.


  ### 6. 파생변수 만들기: 추적관찰기간 계산하기 -----
  # 연구 시작일부터 사망 또는 마지막 추적관찰일까지의 기간을 계산하고 싶다면?

  # survival_time 변수 삽입하기 (1)
  tmp <- Ex2_Data %>%
    dplyr::mutate(entry_date1  = as.Date(entry_date),
                  death_date1  = as.Date(death_date),
                  lastfu_date1 = as.Date(lastfu_date)) %>%
    dplyr::mutate(survival_time = ifelse(status == 1,
                                         as.numeric(lastfu_date1 - entry_date1),
                                         as.numeric(death_date1  - entry_date1)))
  # 첫 번째 mutate(): 문자형 날짜를 날짜 객체로 변환합니다.
  #   as.Date(문자열): "YYYY-MM-DD" 형식의 문자열을 날짜 객체로 변환합니다.
  #   날짜 객체끼리 빼면 두 날짜 사이의 일수(difftime)를 반환합니다.
  # 두 번째 mutate(): 생존 기간(일수)을 계산합니다.
  #   status==1: 생존(추적관찰 종료) → lastfu_date1 - entry_date1 (마지막 추적일까지 기간)
  #   status!=1: 사망 → death_date1 - entry_date1 (사망일까지 기간)
  #   as.numeric(): difftime 객체를 순수한 숫자(일수)로 변환합니다.

  # survival_time 변수의 분포 확인하기
  with(tmp, summary(survival_time))
  # summary(): survival_time(추적관찰기간, 일수)의 분포를 확인합니다.

  # survival_time 변수 삽입하기 (2)
  tmp <- Ex2_Data %>%
    dplyr::mutate(survival_time = ifelse(status == 1,
                                         as.numeric(as.Date(lastfu_date) - as.Date(entry_date)),
                                         as.numeric(as.Date(death_date)  - as.Date(entry_date))))
  # (1)과 동일하지만 날짜 변환과 기간 계산을 한 줄에 처리한 더 간결한 방법입니다.
  # as.Date()를 mutate() 안에서 직접 사용하여 중간 변수(entry_date1 등)를 만들지 않습니다.

  # survival_time 변수의 분포 확인하기
  with(tmp, summary(survival_time))
  # summary(): (1)번과 동일한 결과인지 확인합니다.


  ### 7. 다양한 자료 결합하기: Row bind vs Column bind -----

  ### Row Bind (행 결합, 환자 통합) -----
  # Registry에서의 암환자 자료와 CDW에서의 정상환자 자료를 결합하고 싶다면?

  # Ex3_Case 자료 가져오기
  Ex3_Case <- read.csv("Ex3_Case.csv", header = T, stringsAsFactors = F)
  # read.csv(): Ex3_Case.csv 파일을 읽어 데이터프레임으로 불러옵니다.

  head(Ex3_Case); str(Ex3_Case)
  # head(): 첫 6행을 출력합니다. / str(): 데이터 구조를 확인합니다.
  # ';': 두 명령어를 한 줄에 순서대로 실행합니다.

  # Ex3_Control 자료 가져오기
  Ex3_Control <- read.csv("Ex3_Control.csv", header = T, stringsAsFactors = F)
  # read.csv(): Ex3_Control.csv 파일을 읽어 데이터프레임으로 불러옵니다.

  head(Ex3_Control); str(Ex3_Control)
  # head(): 첫 6행을 출력합니다. / str(): 데이터 구조를 확인합니다.


  # Ex3_Case와 Ex3_Control의 행 결합하기 (1)
  tmp <- dplyr::rows_insert(Ex3_Case, Ex3_Control, by = "id")
  # dplyr::rows_insert(기준데이터, 삽입할데이터, by=기준변수):
  #   Ex3_Control의 행들을 Ex3_Case에 추가합니다.
  #   by="id": id 변수를 기준으로 중복 행 여부를 확인합니다.

  # Ex3_Case와 Ex3_Control의 행 결합하기 (2)
  tmp <- Ex3_Case %>%
    dplyr::rows_insert(Ex3_Control, by = "id")
  # %>%: Ex3_Case를 rows_insert()의 첫 번째 인수로 전달합니다.
  # (1)과 동일한 결과를 반환합니다. 파이프 방식이 더 읽기 쉽습니다.

  # 새로운 자료 구조 확인하기
  str(tmp)
  # str(): 결합 후 전체 행 수와 변수 구조를 확인합니다.

  # 케이스 및 변수의 개수, group의 분포 확인하기
  nrow(tmp); ncol(tmp)
  # nrow(): 데이터프레임의 행(관측값) 수를 반환합니다.
  # ncol(): 데이터프레임의 열(변수) 수를 반환합니다.

  with(tmp, table(group))
  # table(): group 변수의 범주별 빈도를 확인합니다. (case/control 각각 몇 명인지 확인)


  ### Column Bind (열 결합, 변수 통합) -----
  # 동일한 대상자 집단에 대한 인구학적 자료와 Lab 자료를 결합하고 싶다면?

  ### 단일측정자료와의 결합 -----

  # Ex4_Demo 자료 가져오기
  Ex4_Demo <- read.csv("Ex4_Demo.csv", header = T, stringsAsFactors = F)
  # read.csv(): Ex4_Demo.csv 파일을 읽어 데이터프레임으로 불러옵니다.

  head(Ex4_Demo); str(Ex4_Demo)
  # head(): 첫 6행을 출력합니다. / str(): 데이터 구조를 확인합니다.

  # Ex4_Lab_First 자료 가져오기
  Ex4_Lab_First <- read.csv("Ex4_Lab_First.csv", header = T, stringsAsFactors = F)
  # read.csv(): Ex4_Lab_First.csv 파일을 읽어 데이터프레임으로 불러옵니다.

  head(Ex4_Lab_First); str(Ex4_Lab_First)
  # head(): 첫 6행을 출력합니다. / str(): 데이터 구조를 확인합니다.

  # Ex4_Demo와 Ex4_Lab_First의 열 결합하기 (1)
  tmp <- dplyr::left_join(Ex4_Demo, Ex4_Lab_First, by = "id")
  # dplyr::left_join(기준데이터, 결합할데이터, by=기준변수): 두 데이터를 열 방향으로 결합합니다.
  #   기준데이터(Ex4_Demo)의 모든 행을 유지하면서, id가 일치하는 Ex4_Lab_First의 열을 붙입니다.
  #   id가 일치하지 않는 행은 NA로 채워집니다.
  #   by="id": 두 데이터를 연결하는 기준 변수(key)를 지정합니다.

  # Ex4_Demo와 Ex4_Lab_First의 열 결합하기 (2)
  tmp <- Ex4_Demo %>%
    dplyr::left_join(Ex4_Lab_First, by = "id")
  # %>%: Ex4_Demo를 left_join()의 첫 번째 인수로 전달합니다.
  # (1)과 동일한 결과를 반환합니다. 파이프 방식이 더 읽기 쉽습니다.

  # 새로운 자료 구조 확인하기
  head(tmp); str(tmp)
  # head(): 결합 후 첫 6행을 확인합니다. / str(): 열이 올바르게 추가되었는지 확인합니다.


  ### 반복측정자료와의 결합 -----

  # Ex5_Demo 자료 가져오기
  Ex5_Demo <- read.csv("Ex5_Demo.csv", header = T, stringsAsFactors = F)
  # read.csv(): Ex5_Demo.csv 파일을 읽어 데이터프레임으로 불러옵니다.

  head(Ex5_Demo); str(Ex5_Demo)
  # head(): 첫 6행을 출력합니다. / str(): 데이터 구조를 확인합니다.

  # Ex5_Lab_Rep 자료 가져오기
  Ex5_Lab_Rep <- read.csv("Ex5_Lab_Rep.csv", header = T, stringsAsFactors = F)
  # read.csv(): Ex5_Lab_Rep.csv 파일을 읽어 데이터프레임으로 불러옵니다.
  # 반복측정 자료: 한 환자에 대해 여러 시점의 측정값이 있는 long-format 데이터입니다.

  head(Ex5_Lab_Rep); str(Ex5_Lab_Rep)
  # head(): 첫 6행을 출력합니다. / str(): 데이터 구조를 확인합니다.

  # Ex5_Demo와 Ex5_Lab_Rep의 열 결합하기
  tmp <- Ex5_Lab_Rep %>%
    dplyr::left_join(Ex5_Demo, by = "id")
  # Ex5_Lab_Rep(반복측정 자료)를 기준으로 Ex5_Demo(인구학적 자료)를 결합합니다.
  # 반복측정 자료가 기준이 되므로, 한 환자의 인구학적 정보가 측정 시점별로 반복 결합됩니다.
  # left_join(): id가 일치하는 Ex5_Demo의 열을 Ex5_Lab_Rep의 각 행에 붙입니다.

  # 새로운 자료 구조 확인하기
  head(tmp); str(tmp)
  # head(): 결합 후 첫 6행을 확인합니다. / str(): 구조를 확인합니다.


  ### 8. 자료 저장하기 -----

  # csv 자료로 저장하기
  write.csv(tmp, "output.csv", row.names = F)
  # write.csv(데이터프레임, 파일명, row.names): 데이터프레임을 CSV 파일로 저장합니다.
  # "output.csv": 저장할 파일 이름입니다. (작업 디렉토리에 저장됩니다.)
  # row.names=F: 행 번호(1, 2, 3...)를 별도 열로 저장하지 않습니다.

  # xlsx 자료로 저장하기
  install.packages("openxlsx")
  library(openxlsx)   # xlsx 파일 생성 및 읽기 기능을 제공하는 패키지를 활성화합니다.

  write.xlsx(tmp, "output.xlsx")
  # write.xlsx(데이터프레임, 파일명): 데이터프레임을 Excel(.xlsx) 파일로 저장합니다.


  ### 9. 자료 점검하기 -----

  # allocation의 분포 확인하기
  with(tmp, table(allo))
  # with(tmp, ...): tmp 데이터 안에서 변수명을 직접 씁니다.
  # table(allo): allo(무작위배정 그룹) 변수의 범주별 빈도를 확인합니다.

  # allocation에 따른 남녀 비율 확인하기
  with(tmp, table(allo, sex))
  # table(allo, sex): allo(배정 그룹)와 sex(성별)의 교차표를 만듭니다.
  # 무작위배정 그룹별로 성별 분포가 균형 잡혀 있는지 확인합니다.

  # allocation에 따른 a1c 분포 확인하기
  with(tmp, tapply(a1c, allo, summary))
  # tapply(): allo 그룹별로 a1c(당화혈색소)의 summary를 적용합니다.
  # 배정 그룹 간 a1c 기저값이 유사한지 확인합니다.

  # allocation에 따른 a1c의 평균 및 표준편차 확인하기
  tmp %>%
    dplyr::group_by(allo) %>%
    dplyr::summarise(mean = mean(a1c, na.rm = T), sd = sd(a1c, na.rm = T))
  # dplyr::group_by(변수): 지정한 변수의 수준별로 데이터를 그룹화합니다.
  # dplyr::summarise(...): 그룹별로 요약 통계량을 계산합니다.
  #   mean=mean(a1c, na.rm=T): a1c의 평균을 계산합니다. na.rm=T: NA를 제외하고 계산합니다.
  #   sd=sd(a1c, na.rm=T): a1c의 표준편차를 계산합니다.
  # tapply()와 유사하지만, 결과를 데이터프레임으로 반환하여 활용하기 편합니다.


###### R 실습 ----

### 1. 실습자료인 Ex1_Data 자료를 불러오고, 연속형 변수인 체중(bwt)을 저체중여부(lowbwt)로 변환하라.

# Ex1_Data 자료 가져오기
Ex1_Data <- read.csv("Ex1_Data.csv", header = T, stringsAsFactors = F)
# read.csv(): Ex1_Data.csv 파일을 읽어 데이터프레임으로 불러옵니다.

library(dplyr)   # 데이터 조작 패키지를 활성화합니다.
library(MASS)    # MASS 패키지를 활성화합니다.

# lowbwt 변수 삽입하기 (1)
tmp <- Ex1_Data %>%
  dplyr::mutate(lowbwt = ifelse(bwt <= 2500, 1, 0))
# %>%: Ex1_Data를 mutate()에 전달합니다.
# dplyr::mutate(): 새로운 변수 lowbwt를 추가합니다.
# ifelse(bwt<=2500, 1, 0): 출생체중이 2500g 이하이면 1(저체중), 초과이면 0을 부여합니다.

# lowbwt 변수 삽입하기 (2)
tmp <- Ex1_Data %>%
  dplyr::mutate(lowbwt = ifelse(bwt > 2500, 0, 1))
# ifelse(bwt>2500, 0, 1): 출생체중이 2500g 초과이면 0, 이하이면 1을 부여합니다.
# (1)과 조건 방향만 다를 뿐 동일한 결과를 반환합니다.

# lowbwt 변수에 따른 bwt 변수의 분포 확인하기
with(tmp, tapply(bwt, lowbwt, summary))
# tapply(): lowbwt 그룹(0/1)별로 bwt의 summary를 적용합니다.
# lowbwt=0인 그룹의 최솟값이 2500 초과, lowbwt=1인 그룹의 최댓값이 2500 이하인지 확인합니다.



### 2. 실습자료인 Ex2_Data 자료를 불러오고, 호흡곤란, 감염, 절개부위 열림, 구토, 체온 상승 중 1개 이상인 경우로 composite endpoint를 만들어라.

# Ex2_Data 자료 가져오기
Ex2_Data <- read.csv("Ex2_Data.csv", header = T, stringsAsFactors = F)
# read.csv(): Ex2_Data.csv 파일을 읽어 데이터프레임으로 불러옵니다.

# comp 변수 삽입하기
tmp <- Ex2_Data %>%
  dplyr::mutate(comp = ifelse((dyspnea == 1) | (infection == 1) | (incision_failure == 1) | (vomit == 1) | (hightemp == "Yes"), 1, 0))
# %>%: Ex2_Data를 mutate()에 전달합니다.
# dplyr::mutate(): 새로운 변수 comp를 추가합니다.
# |: OR 연산자입니다. 다섯 가지 조건 중 하나라도 TRUE이면 TRUE를 반환합니다.
# ifelse(조건, 1, 0): 조건을 만족하면 1(발생), 아니면 0(미발생)을 부여합니다.

# comp 변수의 분포 확인하기
with(tmp, table(comp))
# table(): comp 변수의 빈도(0: 미발생, 1: 발생)를 확인합니다.



### 3. 실습자료인 Ex2_Data 자료에서 키와 몸무게로 BMI (Body mass index)를 만들어라.

# BMI 변수 삽입하기
tmp <- Ex2_Data %>%
  dplyr::mutate(BMI = wt_entry / ((ht / 100)^2))
# %>%: Ex2_Data를 mutate()에 전달합니다.
# dplyr::mutate(): 새로운 변수 BMI를 추가합니다.
# ht/100: 키를 cm에서 m 단위로 변환합니다.
# (ht/100)^2: 키(m)의 제곱을 계산합니다.
# wt_entry/(ht/100)^2: 체중(kg) / 키(m)^2 = BMI 공식

# BMI 변수의 분포 확인하기
with(tmp, summary(BMI))
# summary(): BMI 변수의 요약 통계량을 출력합니다.



### 4. 실습자료인 Ex4_Demo와 Ex4_Lab_First 자료를 불러오고, "id"라는 변수를 기준으로 열결합하라.

# Ex4_Demo 자료 가져오기
Ex4_Demo <- read.csv("Ex4_Demo.csv", header = T, stringsAsFactors = F)
# read.csv(): Ex4_Demo.csv 파일을 읽어 데이터프레임으로 불러옵니다.

head(Ex4_Demo); str(Ex4_Demo)
# head(): 첫 6행을 출력합니다. / str(): 데이터 구조를 확인합니다.

# Ex4_Lab_First 자료 가져오기
Ex4_Lab_First <- read.csv("Ex4_Lab_First.csv", header = T, stringsAsFactors = F)
# read.csv(): Ex4_Lab_First.csv 파일을 읽어 데이터프레임으로 불러옵니다.

head(Ex4_Lab_First); str(Ex4_Lab_First)
# head(): 첫 6행을 출력합니다. / str(): 데이터 구조를 확인합니다.

# Ex4_Demo와 Ex4_Lab_First의 열 결합하기 (1)
tmp <- dplyr::left_join(Ex4_Demo, Ex4_Lab_First, by = "id")
# dplyr::left_join(): Ex4_Demo를 기준으로 id가 일치하는 Ex4_Lab_First의 열을 결합합니다.
# by="id": 두 데이터를 연결하는 기준 변수를 지정합니다.

# Ex4_Demo와 Ex4_Lab_First의 열 결합하기 (2)
tmp <- Ex4_Demo %>%
  dplyr::left_join(Ex4_Lab_First, by = "id")
# %>%: Ex4_Demo를 left_join()의 첫 번째 인수로 전달합니다.
# (1)과 동일한 결과를 반환합니다. 파이프 방식이 더 읽기 쉽습니다.

# 새로운 자료 구조 확인하기
head(tmp); str(tmp)
# head(): 결합 후 첫 6행을 확인합니다. / str(): 열이 올바르게 추가되었는지 확인합니다.



### 5. 4번에서 만든 자료의 allocation에 따른 남녀 비율 및 a1c 분포를 확인하라.

# allocation의 분포 확인하기
with(tmp, table(allo))
# with(tmp, ...): tmp 데이터 안에서 변수명을 직접 씁니다.
# table(allo): allo(무작위배정 그룹) 변수의 범주별 빈도를 확인합니다.

# allocation에 따른 남녀 비율 확인하기
with(tmp, table(allo, sex))
# table(allo, sex): allo(배정 그룹)와 sex(성별)의 교차표를 만듭니다.
# 배정 그룹 간 성별 분포를 확인합니다.

# allocation에 따른 a1c 분포 확인하기
with(tmp, tapply(a1c, allo, summary))
# tapply(): allo 그룹별로 a1c(당화혈색소)의 summary를 적용합니다.
# 배정 그룹 간 a1c 분포를 비교합니다.

# allocation에 따른 a1c의 평균 및 표준편차 확인하기
tmp %>%
  dplyr::group_by(allo) %>%
  dplyr::summarise(mean = mean(a1c, na.rm = T), sd = sd(a1c, na.rm = T))
# %>%: tmp를 group_by()에 전달하고, 결과를 summarise()에 전달합니다.
# dplyr::group_by(allo): allo 그룹별로 데이터를 묶습니다.
# dplyr::summarise(): 그룹별 평균과 표준편차를 계산하여 데이터프레임으로 반환합니다.
#   mean=mean(a1c, na.rm=T): NA를 제외한 a1c 평균을 계산합니다.
#   sd=sd(a1c, na.rm=T): NA를 제외한 a1c 표준편차를 계산합니다.
