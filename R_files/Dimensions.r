# Score / Validity / Flexibility / Originality / Flexibility Rate /  Originality Rate / Top Answers / Invalid / Breaks
# Tournament
cat("Tournament",sprintf("%.3f",coef(cregc)["turnier"]),sprintf("%.3f",coef(cregg)["turnier"]),sprintf("%.3f",coef(cregf)["turnier"]),sprintf("%.3f",coef(crego)["turnier"]),sprintf("%.3f",coef(reg_sharefb)["turnier"]),sprintf("%.3f",coef(reg_shareob)["turnier"]),sprintf("%.3f",coef(steve30)["turnier"]),sprintf("%.3f",coef(reg_invalid)["turnier"]),sep=" & ")
cat("\\\\")
cat("\n")
cat(cat("&"),cat("(",sprintf("%.3f",coeftest(cregc, vcov=vcovHC(cregc,type="HC1")) ["turnier",2]),") &",sep=""),cat("(",sprintf("%.3f",coeftest(cregg, vcov=vcovHC(cregg,type="HC1")) ["turnier",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(cregf, vcov=vcovHC(cregf,type="HC1")) ["turnier",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(crego, vcov=vcovHC(crego,type="HC1")) ["turnier",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_sharefb, vcov=vcovHC(reg_sharefb,type="HC1")) ["turnier",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_shareob, vcov=vcovHC(reg_shareob,type="HC1")) ["turnier",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(steve30, vcov=vcovHC(steve30,type="HC1")) ["turnier",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_invalid, vcov=vcovHC(reg_invalid,type="HC1")) ["turnier",2]),")",sep=""))
cat("\\\\[4mm]")
cat("\n")
# Gift
cat("Gift",sprintf("%.3f",coef(cregc)["gift"]),sprintf("%.3f",coef(cregg)["gift"]),sprintf("%.3f",coef(cregf)["gift"]),sprintf("%.3f",coef(crego)["gift"]),sprintf("%.3f",coef(reg_sharefb)["gift"]),sprintf("%.3f",coef(reg_shareob)["gift"]),sprintf("%.3f",coef(steve30)["gift"]),sprintf("%.3f",coef(reg_invalid)["gift"]),sep=" & ")
cat("\\\\")
cat("\n")
cat(cat("&"),cat("(",sprintf("%.3f",coeftest(cregc, vcov=vcovHC(cregc,type="HC1")) ["gift",2]),") &",sep=""),cat("(",sprintf("%.3f",coeftest(cregg, vcov=vcovHC(cregg,type="HC1")) ["gift",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(cregf, vcov=vcovHC(cregf,type="HC1")) ["gift",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(crego, vcov=vcovHC(crego,type="HC1")) ["gift",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_sharefb, vcov=vcovHC(reg_sharefb,type="HC1")) ["gift",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_shareob, vcov=vcovHC(reg_shareob,type="HC1")) ["gift",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(steve30, vcov=vcovHC(steve30,type="HC1")) ["gift",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_invalid, vcov=vcovHC(reg_invalid,type="HC1")) ["gift",2]),")",sep=""))
cat("\\\\[4mm]")
cat("\n")
# Period 1
cat("Period 1",sprintf("%.3f",coef(cregc)["neffort1"]),sprintf("%.3f",coef(cregg)["ng1"]),sprintf("%.3f",coef(cregf)["nf1"]),sprintf("%.3f",coef(crego)["no1"]),sprintf("%.3f",coef(reg_sharefb)["sharef1b"]),sprintf("%.3f",coef(reg_shareob)["shareo1b"]),sprintf("%.3f",coef(steve30)["antoniatop30r1"]),sprintf("%.3f",coef(reg_invalid)["p_invalid1"]),sep=" & ")
cat("\\\\")
cat("\n")
cat(cat("&"),cat("(",sprintf("%.3f",coeftest(cregc, vcov=vcovHC(cregc,type="HC1")) ["neffort1",2]),") &",sep=""),cat("(",sprintf("%.3f",coeftest(cregg, vcov=vcovHC(cregg,type="HC1")) ["ng1",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(cregf, vcov=vcovHC(cregf,type="HC1")) ["nf1",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(crego, vcov=vcovHC(crego,type="HC1")) ["no1",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_sharefb, vcov=vcovHC(reg_sharefb,type="HC1")) ["sharef1b",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_shareob, vcov=vcovHC(reg_shareob,type="HC1")) ["shareo1b",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(steve30, vcov=vcovHC(steve30,type="HC1")) ["antoniatop30r1",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_invalid, vcov=vcovHC(reg_invalid,type="HC1")) ["p_invalid1",2]),")",sep=""))
cat("\\\\[4mm]")
cat("\n")
# Intercept
cat("Constant",sprintf("%.3f",coef(cregc)["(Intercept)"]),sprintf("%.3f",coef(cregg)["(Intercept)"]),sprintf("%.3f",coef(cregf)["(Intercept)"]),sprintf("%.3f",coef(crego)["(Intercept)"]),sprintf("%.3f",coef(reg_sharefb)["(Intercept)"]),sprintf("%.3f",coef(reg_shareob)["(Intercept)"]),sprintf("%.3f",coef(steve30)["(Intercept)"]),sprintf("%.3f",coef(reg_invalid)["(Intercept)"]),sep=" & ")
cat("\\\\")
cat("\n")
cat(cat("&"),cat("(",sprintf("%.3f",coeftest(cregc, vcov=vcovHC(cregc,type="HC1")) ["(Intercept)",2]),") &",sep=""),cat("(",sprintf("%.3f",coeftest(cregg, vcov=vcovHC(cregg,type="HC1")) ["(Intercept)",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(cregf, vcov=vcovHC(cregf,type="HC1")) ["(Intercept)",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(crego, vcov=vcovHC(crego,type="HC1")) ["(Intercept)",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_sharefb, vcov=vcovHC(reg_sharefb,type="HC1")) ["(Intercept)",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_shareob, vcov=vcovHC(reg_shareob,type="HC1")) ["(Intercept)",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(steve30, vcov=vcovHC(steve30,type="HC1")) ["(Intercept)",2]),") & ",sep=""),cat("(",sprintf("%.3f",coeftest(reg_invalid, vcov=vcovHC(reg_invalid,type="HC1")) ["(Intercept)",2]),")",sep=""))
cat("\\\\")
cat("\n")