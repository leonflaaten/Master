
library(tidyverse)
library(tseries)

Integrated = read_csv("dfInt.csv")

Integrated = Integrated %>% filter(!is.na(`Shareholders' Equity - Attributable to Parent ShHold - Total`))

#Test
#Integrated = Integrated %>% filter(Instrument == "EQNR.OL")

for (i in 1:nrow(Integrated)) {
  if (is.na(Integrated$`Tax Rate - Actual`[i])) {
    if (!is.na(Integrated$`Effective Tax Rate, (%)`[i])) {
      Integrated$`Tax Rate - Actual`[i] = Integrated$`Effective Tax Rate, (%)`[i]
    }else{
      Integrated$`Tax Rate - Actual`[i] = Integrated$`Tax Rate - Mean`[i]
      
    }
  }
}
Integrated = Integrated %>%
  group_by(Integrated$`Company Common Name`) %>%
  filter(n() >= 3)


Integrated$NDtoE = Integrated$`Net Debt to Total Equity`
Integrated$Size = log(Integrated$`Total Assets`)
Integrated$Tangibility = Integrated$`PPE - Net Percentage of Total Assets`
Integrated$GrowthO = Integrated$`Market Capitalization`/Integrated$`Total Assets`
Integrated$TaxRate = Integrated$`Tax Rate - Actual`
Integrated$DtoE = Integrated$`Total Debt Percentage of Total Equity`/100
Integrated$RnDInt = Integrated$`Research And Development`/Integrated$`Total Revenue`


Integrated = Integrated %>% filter(Instrument != "PEA.TO")
Integrated = Integrated %>% filter(Instrument != "PETR4.SA")

# just to check, cant just remove all N/a and replace with 0.
#Integrated[is.na(Integrated)] = 0

mean(Integrated$DtoE,na.rm = TRUE)

library(car)

vif(reg_int)
adf.test(Integrated$NDtoE)
adf.test(Integrated$Size)
adf.test(Integrated$Tangibility)
adf.test(Integrated$GrowthO)
adf.test(Integrated$TaxRate)


plot(Integrated$NDtoE)

library(readxl)
Int = Integrated %>% group_by(Year) %>%
  mutate(
    mDtoE = mean(DtoE,na.rm=TRUE),
    mNDtoE = mean(NDtoE,na.rm=TRUE),
    mMCap = mean(`Market Capitalization`,na.rm=TRUE),
  )

#Integrated$OilPrice = OilPrice[1,2]

Integrated$OilPrice = as.numeric(Integrated$OilPrice)

OilPrice = read_excel("Oil_Price.xlsx")


OilPrice$Year = as.numeric(OilPrice$Year)




#This needs to be changed after which columns number the columns have.
Integrated$OilPrice = 0
for(j in 1:nrow(OilPrice)) {
  for(i in 1:nrow(Integrated)){
    if (identical(OilPrice$Year[j],Integrated$Year[i])) {
      Integrated$OilPrice[i] = OilPrice$Price[j]
    }
  }
}

tickers = unique(Integrated$`Ticker Symbol`)

length(tickers)

write(tickers,file = "Ticker.txt")

#credit rating
Integrated$CreditRating = 0

for (i in 1:nrow(Integrated)) {
  if (Integrated$`Credit Combined Implied Rating`[i]=="AAA") {
    Integrated$CreditRating[i] = 100
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="AA+") {
    Integrated$CreditRating[i] = 95
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="AA") {
    Integrated$CreditRating[i] = 90
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="AA-") {
    Integrated$CreditRating[i] = 85
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="A+") {
    Integrated$CreditRating[i] = 80
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="A") {
    Integrated$CreditRating[i] = 75
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="A-") {
    Integrated$CreditRating[i] = 70
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="BBB+") {
    Integrated$CreditRating[i] = 65
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="BBB") {
    Integrated$CreditRating[i] = 60
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="BBB-") {
    Integrated$CreditRating[i] = 55
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="BB+") {
    Integrated$CreditRating[i] = 50
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="BB") {
    Integrated$CreditRating[i] = 45
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="BB-") {
    Integrated$CreditRating[i] = 40
    
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="B+") {
    Integrated$CreditRating[i] = 35
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="B") {
    Integrated$CreditRating[i] = 30
    
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="B-") {
    Integrated$CreditRating[i] = 25
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="CCC+") {
    Integrated$CreditRating[i] = 20
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="CCC") {
    Integrated$CreditRating[i] = 20
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="CCC-") {
    Integrated$CreditRating[i] = 20
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="CC") {
    Integrated$CreditRating[i] = 15
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="C") {
    Integrated$CreditRating[i] = 10
  }
  else if(Integrated$`Credit Combined Implied Rating`[i]=="D") {
    Integrated$CreditRating[i] = 5
    
  }else{
    Integrated$CreditRating[i] = 50
    
  }
}
Integrated$Profitability = Integrated$`Return on Capital Employed - %`

Integrated[Integrated=="-Inf"] = 0
Integrated[Integrated=="Inf"] = 0


reg_int = lm(NDtoE ~
               Size+
               Tangibility+
               GrowthO+
               TaxRate+
               OilPrice+
               CreditRating+
               Profitability+
               RnDInt
             ,
             data = Integrated
)

summary(reg_int)

mean(Integrated$CreditRating)
mean(Integrated$TaxRate,na.rm=TRUE)

mean(Integrated$TaxRate[Integrated$TaxRate>0],na.rm=TRUE)
mean(Integrated$`PPE - Net Percentage of Total Assets`,na.rm = TRUE)
