import eikon as ek

ek.set_app_key('fe0e84e4878d49a7ad8535cf66e84f45b631f704')

syntax = "SCREEN(U(IN(Equity(active,public,primary))/*UNV:Public*/), IN(TR.GICSSubIndustryCode,""10102010""), /*IN(TR.HQCountryCode,""NO"")*/, CURN=USD)"

fields = ["TR.CommonName;TR.HeadquartersCountry;TR.CompanyMarketCap;TR.PriceClose;TR.F.NetDebttoTotEq(SDate=0CY,Period=FY-15)"]

df,ek = ek.get_data(syntax, fields)

df.to_csv("data_15.csv")
