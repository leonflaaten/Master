import eikon as ek
import pandas as pd

#Read!!!
# If you change a variable in Refinitiv Screener, you need to replace it in the code below,
# both in the "fields" and in "fields2".

ek.set_app_key('fe0e84e4878d49a7ad8535cf66e84f45b631f704')

syntax = "SCREEN(U(IN(ORSTED.CO,IBE.MC,NEE.N,ENEI.MI)/*UNV:Public*/))"


fields = ["TR.HeadquartersCountry","TR.CreditComboImpliedRating","TR.F.ReturnCapEmployedPct(SDate=0CY,Period=FY1)",
         "TR.F.NetPPEPctofTotAssets(SDate=0CY,Period=FY1)",
          "TR.TaxRateActValue(SDate=0CY,Period=FY1)",
          "TR.EffectiveTaxRate(SDate=0CY,Period=FY1)",
          "TR.TaxRateMean(SDate=0CY,Period=FY1)",
          "TR.F.TotAssets(SDate=0CY,Period=FY1)"
    , "TR.F.NetDebttoTotEq(SDate=0CY,Period=FY1)",
          "TR.F.MktCap(SDate=0CY,Period=FY1)",
          "TR.F.TotDebtPctofTotEq(SDate=0CY,Period=FY1)",
          "TR.F.ShHoldEqParentShHoldTot(SDate=0CY,Period=FY1)",
          "TR.F.TotLiabEq(SDate=0CY,Period=FY1)"]

df, ek = ek.get_data(syntax, fields)

for ind, row in df.iterrows():
    df.loc[ind,"Year"] = 2021

print(df)


import eikon as ek
ek.set_app_key('fe0e84e4878d49a7ad8535cf66e84f45b631f704')

fields0 = ["TR.HeadquartersCountry",
           "TR.CreditComboImpliedRating",
           "TR.F.ReturnCapEmployedPct(SDate=0CY,Period=FY0)", "TR.F.NetPPEPctofTotAssets(SDate=0CY,Period=FY0)",
          "TR.TaxRateActValue(SDate=0CY,Period=FY0)",
          "TR.EffectiveTaxRate(SDate=0CY,Period=FY0)",
          "TR.TaxRateMean(SDate=0CY,Period=FY0)",
          "TR.F.TotAssets(SDate=0CY,Period=FY0)"
    , "TR.F.NetDebttoTotEq(SDate=0CY,Period=FY0)",
          "TR.F.MktCap(SDate=0CY,Period=FY0)",
          "TR.F.TotDebtPctofTotEq(SDate=0CY,Period=FY0)",
          "TR.F.ShHoldEqParentShHoldTot(SDate=0CY,Period=FY0)",
          "TR.F.TotLiabEq(SDate=0CY,Period=FY0)"]

df0, ek = ek.get_data(syntax, fields0)

for ind, row in df0.iterrows():
    df0.loc[ind,"Year"] = 2020

df = pd.merge(df, df0, how="outer")

syntax2 = "SCREEN(U(IN(Equity(active,public,primary))/*UNV:Public*/), " \
         "IN(TR.CommonName,""Iberdrola SA"")" \
          " OR IN(TR.CommonName,""Orsted A/S"") " \
         "OR IN(TR.CommonName,""Enel SpA"")" \
          " OR IN(TR.CommonName,""Nextera Energy Inc""), CURN=USD)"
i = "1"


for x in range(0, 10):
    import eikon as ek
    ek.set_app_key('fe0e84e4878d49a7ad8535cf66e84f45b631f704')

    i = i.replace(str(x), str(x+1))
    fields2 = ["TR.HeadquartersCountry",
               "TR.CreditComboImpliedRating",
               "TR.F.ReturnCapEmployedPct(SDate=0CY,Period=FY-"+i+")","TR.F.NetPPEPctofTotAssets(SDate=0CY,Period=FY-"+i+")",
          "TR.TaxRateActValue(SDate=0CY,Period=FY-"+i+")",
          "TR.EffectiveTaxRate(SDate=0CY,Period=FY-"+i+")",
               "TR.TaxRateMean(SDate=0CY,Period=FY-"+i+")",
          "TR.F.TotAssets(SDate=0CY,Period=FY-"+i+")",
               "TR.F.NetDebttoTotEq(SDate=0CY,Period=FY-"+i+")",
          "TR.F.MktCap(SDate=0CY,Period=FY-"+i+")",
          "TR.F.TotDebtPctofTotEq(SDate=0CY,Period=FY-"+i+")",
          "TR.F.ShHoldEqParentShHoldTot(SDate=0CY,Period=FY-"+i+")",
          "TR.F.TotLiabEq(SDate=0CY,Period=FY-"+i+")"]
    print(i)
    df1, ek = ek.get_data(syntax2, fields2)

    for ind, row in df1.iterrows():
        txt1 = 2019 - x
        df1.loc[ind, "Year"] = txt1
    #df1.to_csv(i+".csv")

    df = pd.merge(df, df1, how="outer")

print(df)
df.to_csv("dfTrans.csv",index=False)

