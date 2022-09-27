
library(tidyverse)
library(tseries)

Integrated = read_csv("dfTrans.csv")

for (i in 1:nrow(Integrated)) {
  if (is.na(Integrated$`Tax Rate - Actual`[i])) {
    if (!is.na(Integrated$`Effective Tax Rate, (%)`[i])) {
      Integrated$`Tax Rate - Actual`[i] = Integrated$`Effective Tax Rate, (%)`[i]
    }else{
      Integrated$`Tax Rate - Actual`[i] = Integrated$`Tax Rate - Mean`[i]
      
    }
  }
}

Integrated$NDtoE = Integrated$`Net Debt to Total Equity`
Integrated$Size = log(Integrated$`Total Assets`)
Integrated$Tangibility = Integrated$`PPE - Net Percentage of Total Assets`
Integrated$GrowthO = Integrated$`Market Capitalization`/Integrated$`Total Assets`
Integrated$TaxRate = Integrated$`Tax Rate - Actual`
Integrated$DtoE = Integrated$`Total Debt Percentage of Total Equity`/100
#Integrated$Capex = Integrated$`Capital Expenditures - Total`/Integrated$`Total Revenue`

OilPrice = read_excel("Oil_Price.xlsx")


OilPrice$Year = as.numeric(OilPrice$Year)
Integrated$OilPrice = 0

#This needs to be changed after which columns number the columns have.
for(j in 1:nrow(OilPrice)) {
  for(i in 1:nrow(Integrated)){
    if (identical(OilPrice$Year[j],Integrated$Year[i])) {
      Integrated$OilPrice[i] = OilPrice$Price[j]
      #Integrated[i,23] = OilPrice[j,2]
    }
  }
}
Integrated$Profitability = Integrated$`Return on Capital Employed - %`



Before = Integrated %>% filter(Integrated$Year<2015)
After = Integrated %>% filter(Integrated$Year>=2015)


regBef = lm(NDtoE ~
               Size+
               Profitability+
               Tangibility+
               GrowthO+
               TaxRate+
               OilPrice
               #Capex
             #CreditRating
             ,
             data = Before
)


regAft = lm(NDtoE ~
              Size+
              Profitability+
              Tangibility+
              GrowthO+
              TaxRate+
              OilPrice
            #Capex
            #CreditRating
            ,
            data = After
)


