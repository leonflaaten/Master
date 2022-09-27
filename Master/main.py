import eikon as ek
import openpyxl as openpyxl
from pandas import read_csv

ek.set_app_key('fe0e84e4878d49a7ad8535cf66e84f45b631f704')

syntax = "SCREEN(U(IN(Equity(active,public,primary))/*UNV:Public*/)," \
         " IN(TR.GICSSubIndustryCode,""10102010""), CURN=USD)"


fields = ["TR.CommonName", "TR.F.NetPPEPctofTotAssets(SDate=0CY,Period=FY1)",
          "TR.F.IncTaxRatePct(SDate=0CY,Period=FY1)",
          "TR.EffectiveTaxRate(SDate=0CY,Period=FY1)",
          "TR.F.TotAssets(SDate=0CY,Period=FY1)"
    , "TR.F.NetDebttoTotEq(SDate=0CY,Period=FY1)",
          "TR.F.MktCap(SDate=0CY,Period=FY1)",
          "TR.F.TotDebtPctofTotEq(SDate=0CY,Period=FY1)",
          "TR.F.ShHoldEqParentShHoldTot(SDate=0CY,Period=FY1)",
          "TR.F.TotLiabEq(SDate=0CY,Period=FY1)"]



df1,ek = ek.get_data(syntax, fields)



for ind, row in df1.iterrows():
    df1.loc[ind,"Year"] = "2021"

print(df1)
import pandas as pd

df1.set_index("Year")
df1.to_csv("data_10.csv")




