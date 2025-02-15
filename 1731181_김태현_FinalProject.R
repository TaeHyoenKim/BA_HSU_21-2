rm(list=ls())
bike = read.csv('C:/dataset/SeoulBikeData.csv') #데이터를 불러옵니다
View(bike)

### 데이터 구조 확인 ###
str(bike) # 8769개 행, 14개 열
summary(bike)

# 자전거를 가장 많이 대여한 날은?
bike$Date[which.max(bike$Rented.Bike.Count)]


### 데이터 전처리 ###
# 변수 이름 변경
names(bike)[4] = 'Temperature'
names(bike)[5] = 'Humidity'
names(bike)[6] = 'Wind.speed'
names(bike)[7] = 'Visibility'
names(bike)[8] = 'Dew.point.temperature' 
names(bike)[9] = 'Solar.Radiation'
names(bike)[10] = 'Rainfall'
names(bike)[11] = 'Snowfall' 
# names(bike)

# 변수 삭제
bike = bike[bike$Functioning.Day == 'Yes', ]
bike$Functioning.Day = NULL #필요없는 변수 삭제

### RentedBikeCount - Temperature 관계 파악 ###
windows()
plot(bike$Temperature, bike$Rented.Bike.Count) #일반적으로 온도가 높아질수록 대여량이 늘어나는 형태 


### Modeling _ 단순 선형 회귀분석 ###
# y = ax + b
# y:(RentedBikeCount), x:(Temperature), (a,b): parameter
bike.temp.reg = lm(Rented.Bike.Count ~ Temperature, data = bike)
bike.temp.reg # a = 329.95, b = 29.08
abline(bike.temp.reg, col='red')

# 회귀분석 결과 확인 / 해석
summary(bike.temp.reg)

# 자전거 대여수와 온도 사이의 관계가 있는가? Y
# 온도가 변하면 자전거 대여수가 변화하는가? Y
# 온도는 자전거 대여수에 영향을 미치는가?  Y

# 구체적인 관계
# 대여량 = 329.95 + 29.08*temperature

# 정도
# 온도가 자전거 대여량에 29%를 설명

# 온도가 1도 올라가면?
# 온도가 1도 올라갈 때마다 대여량은 29대 증가


### Modeling _ 다중 선형 회귀분석 ###
names(bike)
bike.all.reg = lm(Rented.Bike.Count ~ Temperature + Humidity + Wind.speed + Visibility + Dew.point.temperature + Solar.Radiation, data = bike)
# bike.all.reg = lm(Rented.Bike.Count ~ Temperature + Humidity + Wind.speed + Visibility, data = bike)

summary(bike.all.reg)
# p-value 값 유의
# Visibility, Dew.point.temperature 유의하지 않음
bike.all.reg2 = lm(Rented.Bike.Count ~ Temperature + Humidity + Wind.speed + Solar.Radiation, data = bike)
summary(bike.all.reg2)
# Rented.Bike.Count = 905.097 + 36.243*Temperature -11.333*Humidity + 50.743*Wind.speed -118.666*Solar.Radiation
# 습도, 풍속, 일사량의 변화가 42.4%를 설명
# 일사량이 낮을 수록 자전거 대여 갯수가 가장 크게 줄어든다