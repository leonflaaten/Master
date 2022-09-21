
library(tidyverse)
library(tseries)

Integrated = read_csv("dfRen.csv")

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
  group_by(`Company Common Name`) %>%
  filter(n() >= 3)


Integrated$NDtoE = Integrated$`Net Debt to Total Equity`
Integrated$Size = log(Integrated$`Total Assets`)
Integrated$Tangibility = Integrated$`PPE - Net Percentage of Total Assets`
Integrated$GrowthO = Integrated$`Market Capitalization`/Integrated$`Total Assets`
Integrated$TaxRate = Integrated$`Tax Rate - Actual`
Integrated$DtoE = Integrated$`Total Debt Percentage of Total Equity`/100

#Integrated = Integrated %>% filter(Instrument != "PETR4.SA")

# just to check, cant just remove all N/a and replace with 0.
Integrated[is.na(Integrated)] = 0
Integrated[Integrated=="Inf"] = 0
Integrated[Integrated=="-Inf"] = 0


#Majors = Integrated %>% filter(`Company Common Name`==c("Eni SPA","Equinor ASA","Shell PLC","BP PLC","Chevron Corp","Exxon Mobil Corp","TotalEnergies SE"))


mean(Integrated$DtoE,na.rm=TRUE)

library(car)

vif(reg_int)
adf.test(Integrated$NDtoE)
adf.test(Integrated$Size)
adf.test(Integrated$Tangibility)
adf.test(Integrated$GrowthO)
adf.test(Integrated$TaxRate)


plot(Integrated$NDtoE)

Ren = Integrated %>% group_by(Year) %>%
  mutate(
    mDtoE = mean(DtoE,na.rm=TRUE),
    mNDtoE = mean(NDtoE,na.rm=TRUE),
    mMCap = mean(`Market Capitalization`,na.rm=TRUE)
  )



OilPrice = read_excel("Oil_Price.xlsx")


OilPrice$Year = as.numeric(OilPrice$Year)
Integrated$OilPrice = 0

#This needs to be changed after which columns number the columns have.
for(j in 1:nrow(OilPrice)) {
  for(i in 1:nrow(Integrated)){
    if (identical(OilPrice[j,1],Integrated[i,16])) {
      Integrated[i,23] = OilPrice[j,2]
    }
  }
}

tickers = unique(Integrated$`Ticker Symbol`)

length(tickers)

write(tickers,file = "Ticker.txt")

#credit rating
Integrated$CreditRating = 0
class(Integrated$`Credit Combined Implied Rating`)
Integrated$`Credit Combined Implied Rating`[is.na(Integrated$`Credit Combined Implied Rating`)] = "N"


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

Renewables = Integrated
reg_Ren = lm(NDtoE ~
               Size+
               Profitability+
               Tangibility+
               GrowthO+
               TaxRate+
               OilPrice+
               CreditRating
             ,
             data = Renewables
)

mean(Renewables$CreditRating)
mean(Renewables$TaxRate,na.rm = TRUE)
vif(reg_Ren)
summary(reg_Ren)

mean(Renewables$TaxRate[Renewables$TaxRate>0],na.rm=TRUE)
mean(Renewables$`PPE - Net Percentage of Total Assets`,na.rm = TRUE)


# Hei eirik! Får du dette?
