
library(tidyverse)
library(tseries)

Integrated = read_csv("df.csv")

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

Integrated = Integrated %>% filter(Instrument != "PETR4.SA")

# just to check, cant just remove all N/a and replace with 0.
Integrated[is.na(Integrated)] = 0
reg_int = lm(DtoE ~
               lag(DtoE)+
               Size+
               Tangibility+
               GrowthO+
               TaxRate
               ,
             data = Integrated
)

reg_int

library(car)

vif(reg_int)
adf.test(Integrated$NDtoE)
adf.test(Integrated$Size)
adf.test(Integrated$Tangibility)
adf.test(Integrated$GrowthO)
adf.test(Integrated$TaxRate)


plot(Integrated$NDtoE)
