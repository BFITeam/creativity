rm(list=ls(all=TRUE))
#
#setwd("C:/Users/Arne/Dropbox/Work/Projekte/Aktiv/WOEK/")
#setwd("D:/Dropbox/Work/Projekte/Aktiv/WOEK/")
path <-"C:/Users/gtierney/Dropbox (Personal)/creativity/R_files"
setwd(path)

require(foreign)
require(reshape)
require(plyr)
require(sandwich)
require(lmtest)
require(car)
require(plm)
require(np)
require(quantreg)
require(lme4)
require(coin)
#
memory.limit(5000)
#
##########################################################################################################################################
################################################# Load Data ##############################################################################
########################################################################################################################################## 
### Load current dataset
neu<-read.table("../raw_data/r_data/150520_Overview.txt",sep="\t",header=T)
#
source("170130_Referee_Do_R_Intro.r")
#
options(digits = 3)

##########################################################################################################################################
################################################# Make Bar Chart #########################################################################
##########################################################################################################################################
source("Bar_chart.r")
##########################################################################################################################################
################################################# Descriptives ###########################################################################
########################################################################################################################################## 
#
cr$p_invalid1<-cr$answers1-cr$p_valid1
cr$p_invalid2<-cr$answers2-cr$p_valid2
cr$p_invalid3<-cr$answers3-cr$p_valid3
#
data.frame(Group=c(rep("Control",3),rep("Tournament",3),rep("Gift",3)),
Round=c("Round 1","Round 2","Round 3"),
Effort=c(mean(cr$effort1[which(cr$treatment_id==21)]),mean(cr$effort2[which(cr$treatment_id==21)]),mean(cr$effort3[which(cr$treatment_id==21)]),mean(cr$effort1[which(cr$treatment_id==23)]),mean(cr$effort2[which(cr$treatment_id==23)]),mean(cr$effort3[which(cr$treatment_id==23)]),mean(cr$effort1[which(cr$treatment_id==22)]),mean(cr$effort2[which(cr$treatment_id==22)]),mean(cr$effort3[which(cr$treatment_id==22)])),
p_valid=c(mean(cr$p_valid1[which(cr$treatment_id==21)]),mean(cr$p_valid2[which(cr$treatment_id==21)]),mean(cr$p_valid3[which(cr$treatment_id==21)]),mean(cr$p_valid1[which(cr$treatment_id==23)]),mean(cr$p_valid2[which(cr$treatment_id==23)]),mean(cr$p_valid3[which(cr$treatment_id==23)]),mean(cr$p_valid1[which(cr$treatment_id==22)]),mean(cr$p_valid2[which(cr$treatment_id==22)]),mean(cr$p_valid3[which(cr$treatment_id==22)])),
p_flex=c(mean(cr$p_flex1[which(cr$treatment_id==21)]),mean(cr$p_flex2[which(cr$treatment_id==21)]),mean(cr$p_flex3[which(cr$treatment_id==21)]),mean(cr$p_flex1[which(cr$treatment_id==23)]),mean(cr$p_flex2[which(cr$treatment_id==23)]),mean(cr$p_flex3[which(cr$treatment_id==23)]),mean(cr$p_flex1[which(cr$treatment_id==22)]),mean(cr$p_flex2[which(cr$treatment_id==22)]),mean(cr$p_flex3[which(cr$treatment_id==22)])),
p_original=c(mean(cr$p_original1[which(cr$treatment_id==21)]),mean(cr$p_original2[which(cr$treatment_id==21)]),mean(cr$p_original3[which(cr$treatment_id==21)]),mean(cr$p_original1[which(cr$treatment_id==23)]),mean(cr$p_original2[which(cr$treatment_id==23)]),mean(cr$p_original3[which(cr$treatment_id==23)]),mean(cr$p_original1[which(cr$treatment_id==22)]),mean(cr$p_original2[which(cr$treatment_id==22)]),mean(cr$p_original3[which(cr$treatment_id==22)])),
p_invalid=c(mean(cr$p_invalid1[which(cr$treatment_id==21)]),mean(cr$p_invalid2[which(cr$treatment_id==21)]),mean(cr$p_invalid3[which(cr$treatment_id==21)]),mean(cr$p_invalid1[which(cr$treatment_id==23)]),mean(cr$p_invalid2[which(cr$treatment_id==23)]),mean(cr$p_invalid3[which(cr$treatment_id==23)]),mean(cr$p_invalid1[which(cr$treatment_id==22)]),mean(cr$p_invalid2[which(cr$treatment_id==22)]),mean(cr$p_invalid3[which(cr$treatment_id==22)]))
)

##########################################################################################################################################
################################################# Imbalances / Baseline Differences ###################################################################
########################################################################################################################################## 
# Score = Effort for Treatment <40
wilcox.test(sl$effort1[which(sl$treatment_id==12)],sl$effort1[which(sl$treatment_id==11)],paired=F)$p.value
wilcox.test(sl$effort1[which(sl$treatment_id==13)],sl$effort1[which(sl$treatment_id==11)],paired=F)$p.value
wilcox.test(sl$effort1[which(sl$treatment_id==14)],sl$effort1[which(sl$treatment_id==11)],paired=F)$p.value
wilcox.test(cr$effort1[which(cr$treatment_id==22)],cr$effort1[which(cr$treatment_id==21)],paired=F)$p.value
wilcox.test(cr$effort1[which(cr$treatment_id==23)],cr$effort1[which(cr$treatment_id==21)],paired=F)$p.value
wilcox.test(cr$effort1[which(cr$treatment_id==24)],cr$effort1[which(cr$treatment_id==21)],paired=F)$p.value
# 
wilcox.test(cr$score1[which(cr$treatment_id==41)],cr$score1[which(cr$treatment_id==42)],paired=F)$p.value
wilcox.test(cr$transfer1[which(cr$treatment_id==41)],cr$transfer1[which(cr$treatment_id==42)],paired=F)$p.value
#
sl_high_baseline<-lm(ntransfer2~ntransfer1+gift+turnier,data=subset(sl,neffort1>=0 & treatment_id<14))
coeftest(sl_high_baseline, vcov=vcovHC(sl_high_baseline,type="HC1"))
sl_low_baseline<-lm(ntransfer2~ntransfer1+gift+turnier,data=subset(sl,neffort1<0 & treatment_id<14))
coeftest(sl_low_baseline, vcov=vcovHC(sl_low_baseline,type="HC1"))
#
cr_high_baseline<-lm(ntransfer2~ntransfer1+gift+turnier,data=subset(cr,ntransfer1>=0 & treatment_id<24))
coeftest(cr_high_baseline, vcov=vcovHC(cr_high_baseline,type="HC1"))
cr_low_baseline<-lm(ntransfer2~ntransfer1+gift+turnier,data=subset(cr,ntransfer1<0 & treatment_id<24))
coeftest(cr_low_baseline, vcov=vcovHC(cr_low_baseline,type="HC1"))
#
tmp_mean_cr_transfer_baseline<-mean(subset(cr,treatment_id==41)$transfer1)
cr_transfer_high_baseline<-lm(ntransfer2~ntransfer1+gift_trans,data=subset(cr,transfer1>=tmp_mean_cr_transfer_baseline & treatment_id>40))
coeftest(cr_transfer_high_baseline, vcov=vcovHC(cr_transfer_high_baseline,type="HC1"))
cr_transfer_low_baseline<-lm(ntransfer2~ntransfer1+gift_trans,data=subset(cr,transfer1<tmp_mean_cr_transfer_baseline & treatment_id>40))
coeftest(cr_transfer_low_baseline, vcov=vcovHC(cr_transfer_low_baseline,type="HC1"))
rm(tmp_mean_cr_transfer_baseline)
# Semi-parametric
np_cr<-npplreg(ntransfer2~gift+turnier+feedback+creative_trans+creative_trans:gift_trans | ntransfer1,data=cr)
# 
# library(MatchIt)
# library(Zelig)
library(arm)
#
prop_slider_gift<-glm(gift~effort1,data=subset(sl,treatment_id%in%c(11,12)))
prop2_slider_gift<-predict (prop_slider_gift, type="link")
matches_slider_gift <- matching(subset(sl,treatment_id%in%c(11,12))$gift, score=prop2_slider_gift)
matched_slider_gift <- subset(sl,treatment_id%in%c(11,12))[matches_slider_gift$matched,]
summary(lm(neffort2~neffort1+gift,data=matched_slider_gift))

prop_slider_tournament<-glm(turnier~effort1,data=subset(sl,treatment_id%in%c(11,13)))
prop2_slider_tournament<-predict (prop_slider_tournament, type="link")
matches_slider_tournament <- matching (subset(sl,treatment_id%in%c(11,13))$turnier, score=prop2_slider_tournament)
matched_slider_tournament <- subset(sl,treatment_id%in%c(11,13))[matches_slider_tournament$matched,]
summary(lm(neffort2~neffort1+turnier,data=matched_slider_tournament))
#
prop_slider_gift<-predict(glm(gift~effort1,data=subset(sl,treatment_id%in%c(11,12))),type = "response")
summary(lm(neffort2~gift+neffort1,data=subset(sl,treatment_id%in%c(11,12)),weights=1/prop_slider_gift))
summary(lm(neffort2~gift+neffort1,data=subset(sl,treatment_id%in%c(11,12)))) 
#
prop_slider_turnier<-predict(glm(turnier~effort1,data=subset(sl,treatment_id%in%c(11,13))),type = "response")
summary(lm(neffort2~neffort1+turnier,data=subset(sl,treatment_id%in%c(11,13)),weights=1/prop_slider_turnier))
summary(lm(neffort2~turnier + neffort1,data=subset(sl,treatment_id%in%c(11,13)))) 
#

graph_matching_gift<-data.frame("gift"=subset(sl,treatment_id%in%c(11,12))[,c("gift")])
graph_matching_gift$prop_gift<-prop_slider_gift
graph_matching_turnier<-data.frame("turnier"=subset(sl,treatment_id%in%c(11,13))[,c("turnier")])
graph_matching_turnier$prop_turnier<-prop_slider_turnier
#
png("Results/Prop_Tournament.png")
plot(NA,xlim=c(0,1),ylim=c(0,3.5),xlab="Propensity Score",ylab="Distribution",main="Propensity Score for Tournament Treatment (Slider-Task)")
abline(v=seq(0,1,.1),lwd=0.1,lty=4,col="lightgray")
abline(h=seq(0,3.5,.25),lwd=0.1,lty=4,col="lightgray")
lines(density(subset(graph_matching_turnier,turnier==0)$prop_turnier,bw=.05),lwd=3,col="darkgray")
lines(density(subset(graph_matching_turnier,turnier==1)$prop_turnier,bw=.05),lwd=3,col="darkblue")
legend("bottom",c("Tournament Treatment","Control Group"),lwd=3,col=c("darkblue","darkgray"))
dev.off()
#tendency.to.forgive
#
#https://cran.r-project.org/web/packages/np/vignettes/np.pdf
library(np)
pooled$gift_slider <- pooled$gift*pooled$slider
pooled$turnier_slider <- pooled$turnier*pooled$slider
np <- npplreg(neffort2~gift+gift_slider+turnier+turnier_slider | neffort1,data=subset(pooled,treatment_id%in%c(11,12,13,21,22,23)))
np
#plot(np)
png(paste0(path,"/Results/np_reg.png"))
plot(np)
dev.off()

np_sl <- npplreg(neffort2~gift+turnier | neffort1,data=subset(pooled,treatment_id%in%c(11,12,13)))
np_sl
plot(np_sl)

summary(lm(neffort2~gift+ turnier + neffort1,data=subset(sl,treatment_id%in%c(11,12,13)))) 


#
##########################################################################################################################################
################################################# Table 4 Ohne Feedback ##################################################################
########################################################################################################################################## 
column1<-lm(neffort2~gift+gift:slider+turnier+turnier:slider,data=subset(pooled,treatment_id%in%c(11,12,13,21,22,23)))
coeftest(column1, vcov=vcovHC(column1,type="HC1")) 
c(summary(column1)$r.squared,length(summary(column1)$residuals))
# Regression 2
column2<-lm(neffort2~neffort1+neffort1:slider+gift+gift:slider+turnier+turnier:slider,data=subset(pooled,treatment_id%in%c(11,12,13,21,22,23)))
coeftest(column2, vcov=vcovHC(column2,type="HC1")) 
c(summary(column2)$r.squared,length(summary(column2)$residuals))
# Regression 3
column3<-lm(neffort2~neffort1+neffort1:slider+gift+gift:slider+turnier+turnier:slider+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(pooled,treatment_id%in%c(11,12,13,21,22,23)))
coeftest(column3, vcov=vcovHC(column3,type="HC1")) 
c(summary(column3)$r.squared,length(summary(column3)$residuals))
# Regression 4
column4<-lm(ntransfer2~ntransfer1+ntransfer1:slider+gift+gift:slider+turnier+turnier:slider+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi+creative_trans+creative_trans:gift_trans,data=subset(pooled,!treatment_id%in%c(14,24)))
coeftest(column4, vcov=vcovHC(column4,type="HC1")) 
# Transfer
column_transfer1<-lm(std_transfer2~std_transfer1+gift_trans,data=subset(cr,treatment_id>40))
coeftest(column_transfer1, vcov=vcovHC(column_transfer1,type="HC1")) 
c(summary(column_transfer1)$r.squared,length(summary(column_transfer1)$residuals))
column_transfer2<-lm(std_transfer2~std_transfer1+gift_trans+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id>40))
coeftest(column_transfer2, vcov=vcovHC(column_transfer2,type="HC1")) 
c(summary(column_transfer2)$r.squared,length(summary(column_transfer2)$residuals))
##########################################################################################################################################
################################################# Dimensions Table #######################################################################
########################################################################################################################################## 
# current Table 5
ddply(round1_sum, c("treatment_id"), summarize, score = mean(score,na.rm=T), valid = mean(valid,na.rm=T), flex = mean(flex,na.rm=T), original = mean(original,na.rm=T), original1 = mean(original1,na.rm=T), original2 = mean(original2,na.rm=T), invalid = mean(invalid,na.rm=T),treatment_id = mean(treatment_id))
ddply(round2_sum, c("treatment_id"), summarize, score = mean(score,na.rm=T), valid = mean(valid,na.rm=T), flex = mean(flex,na.rm=T), original = mean(original,na.rm=T), original1 = mean(original1,na.rm=T), original2 = mean(original2,na.rm=T), invalid = mean(invalid,na.rm=T),treatment_id = mean(treatment_id))
ddply(round3_sum, c("treatment_id"), summarize, score = mean(score,na.rm=T), valid = mean(valid,na.rm=T), flex = mean(flex,na.rm=T), original = mean(original,na.rm=T), original1 = mean(original1,na.rm=T), original2 = mean(original2,na.rm=T), invalid = mean(invalid,na.rm=T),treatment_id = mean(treatment_id))
#
ddply(round3_sum, c("treatment_id"), summarize, score = mean(score,na.rm=T), valid = mean(valid,na.rm=T), flex = mean(flex,na.rm=T), original = mean(original,na.rm=T), original1 = mean(original1,na.rm=T), original2 = mean(original2,na.rm=T), invalid = mean(invalid,na.rm=T),treatment_id = mean(treatment_id))[1,]
#
# Score (wo controls)
cregc<-lm(neffort2~neffort1+gift+turnier,data=subset(cr,treatment_id<=23))
coeftest(cregc, vcov=vcovHC(cregc,type="HC1")) 
cat("n=",length(cregc$resid)," ","R2=",summary(cregc)$r.squared,"\n")
#
#
# Score
cregc<-lm(neffort2~neffort1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id<=23))
coeftest(cregc, vcov=vcovHC(cregc,type="HC1")) 
cat("n=",length(cregc$resid)," ","R2=",summary(cregc)$r.squared,"\n")
# Validity
cregg<-lm(ng2~ng1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id<=23))
coeftest(cregg, vcov=vcovHC(cregg,type="HC1")) 
c(summary(cregg)$r.squared,length(summary(cregg)$residuals))
# Flexibility 
cregf<-lm(nf2~nf1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id<=23))
coeftest(cregf, vcov=vcovHC(cregf,type="HC1")) 
cat("n=",length(cregf$resid)," ","R2=",summary(cregf)$r.squared,"\n")
# Originality
crego<-lm(no2~no1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id<=23))
coeftest(crego, vcov=vcovHC(crego,type="HC1")) 
cat("n=",length(crego$resid)," ","R2=",summary(crego)$r.squared,"\n")
# Flexibility Rate
cr$sharef1b<-cr$p_flex1/cr$p_valid1
cr$sharef2b<-cr$p_flex2/cr$p_valid2
reg_sharefb<-lm(sharef2b~sharef1b+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,is.finite(sharef1b) & is.finite(sharef2b) & treatment_id<=23))
coeftest(reg_sharefb,vcov=vcovHC(reg_sharefb,type="HC1"))
cat("n=",length(reg_sharefb$resid)," ","R2=",summary(reg_sharefb)$r.squared,"\n")
# Originality Rate
cr$shareo1b<-cr$p_original1/cr$p_valid1
cr$shareo2b<-cr$p_original2/cr$p_valid2
reg_shareob<-lm(shareo2b~shareo1b+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,is.finite(shareo1b) & is.finite(shareo2b) & treatment_id<=23))
coeftest(reg_shareob,vcov=vcovHC(reg_shareob,type="HC1"))
cat("n=",length(reg_shareob$resid)," ","R2=",summary(reg_shareob)$r.squared,"\n")
# Top Answers
cr2<-merge(cr,steve,"id",all.x=T,all.y=F)
steve30<-lm(antoniatop30r2~antoniatop30r1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr2,treatment_id<=23))
coeftest(steve30, vcov=vcovHC(steve30,type="HC1")) 
cat("n=",length(steve30$resid)," ","R2=",summary(steve30)$r.squared,"\n")
rm(cr2)
# Invalid
cr$p_invalid1<-cr$answers1-cr$p_valid1
cr$p_invalid2<-cr$answers2-cr$p_valid2
reg_invalid<-lm(p_invalid2~p_invalid1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id<=23))
coeftest(reg_invalid, vcov=vcovHC(reg_invalid,type="HC1"))
cat("n=",length(reg_invalid$resid)," ","R2=",summary(reg_invalid)$r.squared,"\n")
#
#
#
#
#
options(digits=2)
source("Dimensions.r")
options(digits=3)
#
#
#
creg_ratings<-lm(expert2~expert1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id<24))
coeftest(creg_ratings, vcov=vcovHC(creg_ratings,type="HC1")) 
cat("n=",length(creg_ratings$resid)," ","R2=",summary(creg_ratings)$r.squared,"\n")
#
#
cr$sharef1<-cr$p_flex1/cr$effort1
cr$sharef2<-cr$p_flex2/cr$effort2
reg_sharef<-lm(sharef2~sharef1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,is.finite(sharef1) & is.finite(sharef2) & treatment_id<=23))
coeftest(reg_sharef,vcov=vcovHC(reg_sharef,type="HC1"))
cat("n=",length(reg_sharef$resid)," ","R2=",summary(reg_sharef)$r.squared,"\n")
#
cr$shareo1<-cr$p_original1/cr$effort1
cr$shareo2<-cr$p_original2/cr$effort2
reg_shareo<-lm(shareo2~shareo1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,is.finite(shareo1) & is.finite(shareo2) & treatment_id<=23))
coeftest(reg_shareo,vcov=vcovHC(reg_shareo,type="HC1"))
cat("n=",length(reg_shareo$resid)," ","R2=",summary(reg_shareo)$r.squared,"\n")
##########################################################################################################################################
################################################# Ex-Post ################################################################################
##########################################################################################################################################
#
ex_post1<-lm(neffort3~neffort1+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(sl,treatment_id<=13))
coeftest(ex_post1, vcov=vcovHC(ex_post1,type="HC1")) 
cat("n=",length(ex_post1$resid)," ","R2=",summary(ex_post1)$r.squared,"\n")
#
ex_post2<-lm(neffort3~neffort1+gift+I(turnier==1 & bonus_recvd==0)+I(turnier==1 & bonus_recvd==1)+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(sl,treatment_id<=13))
coeftest(ex_post2, vcov=vcovHC(ex_post2,type="HC1")) 
cat("n=",length(ex_post2$resid)," ","R2=",summary(ex_post2)$r.squared,"\n")
#
#
ex_post3<-lm(ntransfer3~ntransfer1+gift+turnier+creative_trans+creative_trans:gift_trans+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id!=24))
coeftest(ex_post3, vcov=vcovHC(ex_post3,type="HC1")) 
cat("n=",length(ex_post3$resid)," ","R2=",summary(ex_post3)$r.squared,"\n")
#
ex_post4<-lm(ntransfer3~ntransfer1+gift+I(turnier==1 & bonus_recvd==0)+I(turnier==1 & bonus_recvd==1)+creative_trans+creative_trans:gift_trans+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id!=24))
coeftest(ex_post4, vcov=vcovHC(ex_post4,type="HC1")) 
cat("n=",length(ex_post4$resid)," ","R2=",summary(ex_post4)$r.squared,"\n")
#
#
wilcox.test(cr$effort3[which(cr$treatment_id==24)],cr$effort3[which(cr$treatment_id==21)],paired=F)$p.value
##########################################################################################################################################
################################################# Breaks #################################################################################
########################################################################################################################################## 
cr$pausen_diff1<-cr$pausen2-cr$pausen1
sl$pausen_diff1<-sl$pausen2-sl$pausen1
#
wilcox.test(cr$pausen_diff1[which(cr$treatment_id==21)],cr$pausen_diff1[which(cr$treatment_id==22)],paired=F)$p.value
wilcox.test(cr$pausen_diff1[which(cr$treatment_id==21)],cr$pausen_diff1[which(cr$treatment_id==23)],paired=F)$p.value
wilcox.test(sl$pausen_diff1[which(sl$treatment_id==11)],sl$pausen_diff1[which(sl$treatment_id==12)],paired=F)$p.value
wilcox.test(sl$pausen_diff1[which(sl$treatment_id==11)],sl$pausen_diff1[which(sl$treatment_id==13)],paired=F)$p.value
#
summary(lm(ntransfer2~ntransfer1+as.factor(treatment)+pausen_diff1+creative_trans+creative_trans:gift_trans,data=cr))
summary(lm(neffort2~neffort1+as.factor(treatment)+pausen_diff1,data=sl))
# Neue Variable zur Pausenberechnung
sl$pausen1f<-factor(NA,levels=c("0 Breaks in Round 1","1-3 Breaks in Round 1","4-7 Breaks in Round 1","8 Breaks in Round 1"))
sl$pausen1f[which(sl$pausen1==0)]<-"0 Breaks in Round 1"
sl$pausen1f[which(sl$pausen1>=1 & sl$pausen1<=3)]<-"1-3 Breaks in Round 1"
sl$pausen1f[which(sl$pausen1>=4 & sl$pausen1<=7)]<-"4-7 Breaks in Round 1"
sl$pausen1f[which(sl$pausen1>=8)]<-"8 Breaks in Round 1"
#
cr$pausen1f<-factor(NA,levels=c("0 Breaks in Round 1","1-3 Breaks in Round 1","4-7 Breaks in Round 1","8 Breaks in Round 1"))
cr$pausen1f[which(cr$pausen1==0)]<-"0 Breaks in Round 1"
cr$pausen1f[which(cr$pausen1>=1 & cr$pausen1<=3)]<-"1-3 Breaks in Round 1"
cr$pausen1f[which(cr$pausen1>=4 & cr$pausen1<=7)]<-"4-7 Breaks in Round 1"
cr$pausen1f[which(cr$pausen1>=8)]<-"8 Breaks in Round 1"
#
sreg_breaks<-lm(neffort2~neffort1+gift+turnier+pausen1f*pausen_diff1,data=subset(sl,treatment_id<=13))
coeftest(sreg_breaks, vcov=vcovHC(sreg_breaks,type="HC1")) 
cat("n=",length(sreg_breaks$resid)," ","R2=",summary(sreg_breaks)$r.squared,"\n")
#
creg_breaks<-lm(ntransfer2~ntransfer1+gift+turnier+pausen1f*pausen_diff1,data=subset(cr,treatment_id<=23))
coeftest(creg_breaks, vcov=vcovHC(creg_breaks,type="HC1")) 
cat("n=",length(creg_breaks$resid)," ","R2=",summary(creg_breaks)$r.squared,"\n")
#
summary(lm(ndiff1~neffort1+as.factor(treatment)+as.factor(pausen1)*as.factor(pausen_diff1),data=cr))
#
#
reg_effort_slider<-lm(neffort2~neffort1+turnier+gift,data=subset(sl,treatment_id<14))
coeftest(reg_effort_slider, vcov=vcovHC(reg_effort_slider,type="HC1")) 
cat("n=",length(reg_effort_slider$resid)," ","R2=",summary(reg_effort_slider)$r.squared,"\n")
#
reg_effort_creative<-lm(neffort2~neffort1+turnier+gift,data=subset(cr,treatment_id<24))
coeftest(reg_effort_creative, vcov=vcovHC(reg_effort_creative,type="HC1")) 
cat("n=",length(reg_effort_creative$resid)," ","R2=",summary(reg_effort_creative)$r.squared,"\n")
#
#
reg_break_slider<-lm(pausen2~pausen1+turnier+gift,data=subset(sl,treatment_id<14))
coeftest(reg_break_slider, vcov=vcovHC(reg_break_slider,type="HC1")) 
cat("n=",length(reg_break_slider$resid)," ","R2=",summary(reg_break_slider)$r.squared,"\n")
#
reg_break_creative<-lm(pausen2~pausen1+turnier+gift,data=subset(cr,treatment_id<24))
coeftest(reg_break_creative, vcov=vcovHC(reg_break_creative,type="HC1")) 
cat("n=",length(reg_break_creative$resid)," ","R2=",summary(reg_break_creative)$r.squared,"\n")
#
#
reg_break_pooled<-lm(pausen2~slider+pausen1+pausen1:slider+gift+gift:slider+turnier+turnier:slider,data=subset(pooled,treatment_id%in%c(11,12,13,21,22,23)))
coeftest(reg_break_pooled, vcov=vcovHC(reg_break_pooled,type="HC1")) 
c(summary(reg_break_pooled)$r.squared,length(summary(reg_break_pooled)$residuals))
#
#
#
#
sl$time1<-300-sl$pausen1*20
sl$time2<-300-sl$pausen2*20
#
sl$effort_time1<-sl$effort1/sl$time1
sl$neffort_time1<-(sl$effort_time1-mean(sl$effort_time1[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort_time1[which(sl$treatment_id==11)],na.rm=T)
#
sl$effort_time2<-sl$effort2/sl$time2
sl$neffort_time2<-(sl$effort_time2-mean(sl$effort_time2[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort_time2[which(sl$treatment_id==11)],na.rm=T)
reg_break2_slider<-lm(neffort_time2~neffort_time1+turnier+gift,data=subset(sl,treatment_id<14))
coeftest(reg_break2_slider, vcov=vcovHC(reg_break2_slider,type="HC1")) 
cat("n=",length(reg_break2_slider$resid)," ","R2=",summary(reg_break2_slider)$r.squared,"\n")
reg_break2_slider_nostd <- lm(I(neffort2/time2) ~ I(neffort1/time1)+turnier+gift,data=subset(sl,treatment_id<14))
coeftest(reg_break2_slider_nostd, vcov=vcovHC(reg_break2_slider_nostd,type="HC1")) 

#
cr$time1<-300-cr$pausen1*20
cr$time2<-300-cr$pausen2*20
#
cr$effort_time1<-cr$effort1/cr$time1
cr$neffort_time1<-(cr$effort_time1-mean(cr$effort_time1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort_time1[which(cr$treatment_id==21)],na.rm=T)
#
cr$effort_time2<-cr$effort2/cr$time2
cr$neffort_time2<-(cr$effort_time2-mean(cr$effort_time2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort_time2[which(cr$treatment_id==21)],na.rm=T)
#
reg_break2_creative<-lm(neffort_time2~neffort_time1+turnier+gift,data=subset(cr,treatment_id<24))
coeftest(reg_break2_creative, vcov=vcovHC(reg_break2_creative,type="HC1")) 
cat("n=",length(reg_break2_creative$resid)," ","R2=",summary(reg_break2_creative)$r.squared,"\n")
##########################################################################################################################################
################################################# Transfertreatment ######################################################################
##########################################################################################################################################
# Achtung Wir verwenden nur die nachtraeglich verwendeten "Scores" (ausser bei Transfer)
# und nicht den im Experiment genutzten "Effort"
# denn die im Experiment genutzten liegen uns nicht mehr vorkenntnisse
# Effort/Score ist immer nachtraeglich fuer treatment_id<=24 (also nicht transfer)
# Aber fuer transfer gehen beide ausseinander ("Effort" im Experiment bewertet, "Score" danach) 
cr_lm_score<-lm(nscore2~nscore1+gift_trans,data=subset(cr,treatment_id>40))
coeftest(cr_lm_score, vcov=vcovHC(cr_lm_score,type="HC1"))
cat("n=",length(cr_lm_score$resid)," ","R2=",summary(cr_lm_score)$r.squared,"\n")
#
cr_lm_transfer<-lm(ntransfer2~ntransfer1+gift_trans,data=subset(cr,treatment_id>40))
coeftest(cr_lm_transfer, vcov=vcovHC(cr_lm_transfer,type="HC1"))
cat("n=",length(cr_lm_transfer$resid)," ","R2=",summary(cr_lm_transfer)$r.squared,"\n")
#
cr_lm_amount_transferred<-lm(I(transfer2/score2)~I(transfer1/score1)+gift_trans,data=subset(cr,treatment_id>24))
coeftest(cr_lm_amount_transferred, vcov=vcovHC(cr_lm_amount_transferred,type="HC1"))
cat("n=",length(cr_lm_amount_transferred$resid)," ","R2=",summary(cr_lm_amount_transferred)$r.squared,"\n")
#
#png("Results/Amount_transferred.png")
plot(NA,xlim=c(0,1),ylim=c(0,1),xlab="Amount Transferred Period 1",ylab="Amount Transferred Period 2")
abline(h=seq(0,1,0.2),lwd=0.1,col="lightgray")
abline(v=seq(0,1,0.2),lwd=0.1,col="lightgray")
with(subset(cr,treatment_id>24),
lines(jitter(I(transfer1/effort1),factor=25),jitter(I(transfer2/effort2),factor=25),pch=16,cex=1,type="p",col="darkblue"))
#dev.off()
#
#
cr$transfer_all1<-NA
cr$transfer_all1[which(cr$treatment_id>40)]<-0
cr$transfer_all1[which(cr$treatment_id>40 & cr$transfer1==cr$effort1 & cr$effort1>0)]<-1
#
#
mean(cr$score1[which(cr$treatment_id==41)],na.rm=T)
mean(cr$score1[which(cr$treatment_id==42)],na.rm=T)
mean(cr$score1[which(cr$treatment_id==41 & cr$transfer_all1==1)],na.rm=T)
mean(cr$score1[which(cr$treatment_id==42 & cr$transfer_all1==1)],na.rm=T)
mean(cr$score1[which(cr$treatment_id==41 & cr$transfer_all1==0)],na.rm=T)
mean(cr$score1[which(cr$treatment_id==42 & cr$transfer_all1==0)],na.rm=T)
#
mean(cr$score2[which(cr$treatment_id==41)],na.rm=T)
mean(cr$score2[which(cr$treatment_id==42)],na.rm=T)
mean(cr$score2[which(cr$treatment_id==41 & cr$transfer_all1==1)],na.rm=T)
mean(cr$score2[which(cr$treatment_id==42 & cr$transfer_all1==1)],na.rm=T)
mean(cr$score2[which(cr$treatment_id==41 & cr$transfer_all1==0)],na.rm=T)
mean(cr$score2[which(cr$treatment_id==42 & cr$transfer_all1==0)],na.rm=T)
#
#
with(subset(cr,treatment_id==41),mean(I(transfer1/effort1),na.rm=T))
with(subset(cr,treatment_id==42),mean(I(transfer1/effort1),na.rm=T))
with(subset(cr,treatment_id==41 & transfer_all1==1),mean(I(transfer1/effort1),na.rm=T))
with(subset(cr,treatment_id==42 & transfer_all1==1),mean(I(transfer1/effort1),na.rm=T))
with(subset(cr,treatment_id==41 & transfer_all1==0),mean(I(transfer1/effort1),na.rm=T))
with(subset(cr,treatment_id==42 & transfer_all1==0),mean(I(transfer1/effort1),na.rm=T))
#
with(subset(cr,treatment_id==41),mean(I(transfer2/effort2),na.rm=T))
with(subset(cr,treatment_id==42),mean(I(transfer2/effort2),na.rm=T))
with(subset(cr,treatment_id==41 & transfer_all1==1),mean(I(transfer2/effort2),na.rm=T))
with(subset(cr,treatment_id==42 & transfer_all1==1),mean(I(transfer2/effort2),na.rm=T))
with(subset(cr,treatment_id==41 & transfer_all1==0),mean(I(transfer2/effort2),na.rm=T))
with(subset(cr,treatment_id==42 & transfer_all1==0),mean(I(transfer2/effort2),na.rm=T))
#
#
reg_split_transferred<-lm(ntransfer2~gift_trans*transfer_all1 + ntransfer1,data=subset(cr,treatment_id>40))
coeftest(reg_split_transferred, vcov=vcovHC(reg_split_transferred,type="HC1"))
cat("n=",length(reg_split_transferred$resid)," ","R2=",summary(reg_split_transferred)$r.squared,"\n")
#
reg_split_transferred<-lm(nscore2~gift_trans+transfer_all1 + nscore1,data=subset(cr,treatment_id>40))
coeftest(reg_split_transferred, vcov=vcovHC(reg_split_transferred,type="HC1"))
cat("n=",length(reg_split_transferred$resid)," ","R2=",summary(reg_split_transferred)$r.squared,"\n")
#
reg_split_transferred<-lm(nscore2~gift_trans*transfer_all1 + nscore1,data=subset(cr,treatment_id>40))
coeftest(reg_split_transferred, vcov=vcovHC(reg_split_transferred,type="HC1"))
cat("n=",length(reg_split_transferred$resid)," ","R2=",summary(reg_split_transferred)$r.squared,"\n")
#
#
reg_transfer_all<-lm(ntransfer2~gift_trans + ntransfer1,data=subset(cr,treatment_id>40 & transfer_all1==1))
coeftest(reg_transfer_all, vcov=vcovHC(reg_transfer_all,type="HC1"))
cat("n=",length(reg_transfer_all$resid)," ","R2=",summary(reg_transfer_all)$r.squared,"\n")
#
reg_transfer_not_all<-lm(ntransfer2~gift_trans + ntransfer1,data=subset(cr,treatment_id>40 & transfer_all1==0))
coeftest(reg_transfer_not_all, vcov=vcovHC(reg_transfer_not_all,type="HC1"))
cat("n=",length(reg_transfer_not_all$resid)," ","R2=",summary(reg_transfer_not_all)$r.squared,"\n")
#
#
wilcox.test(cr$transfer1[which(cr$treatment_id==41)],cr$effort1[which(cr$treatment_id==21)],paired=F)
wilcox.test(cr$transfer2[which(cr$treatment_id==41)],cr$effort2[which(cr$treatment_id==21)],paired=F)
wilcox.test(cr$transfer1[which(cr$treatment_id==42)],cr$effort1[which(cr$treatment_id==22)],paired=F)
wilcox.test(cr$transfer2[which(cr$treatment_id==42)],cr$effort2[which(cr$treatment_id==22)],paired=F)
##########################################################################################################################################
################################################# Reciprocity ############################################################################
########################################################################################################################################## 
# Reciprocity / Reziprozität
rec1a<-lm(neffort2~neffort1+turnier+turnier*tendency.to.forgive,data=subset(pooled,treatment_id%in%c(11,13)))
coeftest(rec1a, vcov=vcovHC(rec1a,type="HC1")) 
rec1b<-lm(neffort2~neffort1+turnier+turnier*tendency.to.forgive,data=subset(pooled,treatment_id%in%c(21,23)))
coeftest(rec1b, vcov=vcovHC(rec1b,type="HC1")) 
rec2a<-lm(neffort2~neffort1+gift*tendency.to.forgive,data=subset(pooled,treatment_id%in%c(11,12)))
coeftest(rec2a, vcov=vcovHC(rec2a,type="HC1")) 
rec2b<-lm(neffort2~neffort1+gift*tendency.to.forgive,data=subset(pooled,treatment_id%in%c(21,22)))
coeftest(rec2b, vcov=vcovHC(rec2b,type="HC1")) 
rec2c<-lm(neffort2~neffort1+gift+turnier+feedback+tendency.to.forgive,data=subset(pooled,treatment_id%in%c(21,22,23,24)))
coeftest(rec2c, vcov=vcovHC(rec2c,type="HC1")) 
#
rec2<-lm(neffort2~neffort1+gift+gift:slider+gift*tendency.to.forgive+turnier+turnier:slider+turnier*tendency.to.forgive+turnier:slider:tendency.to.forgive+gift:slider:tendency.to.forgive,data=subset(pooled,treatment_id%in%c(11,12,13,21,22,23)))
coeftest(rec2, vcov=vcovHC(rec2,type="HC1")) 
cat("n=",length(rec2$resid)," ","R2=",summary(rec2)$r.squared,"\n")

rec3<-lm(neffort2~neffort1+gift+gift:slider+turnier+turnier:slider+tendency.to.forgive,data=subset(pooled,treatment_id%in%c(11,12,13,21,22,23)))
coeftest(rec3, vcov=vcovHC(rec3,type="HC1")) 
cat("n=",length(rec3$resid)," ","R2=",summary(rec3)$r.squared,"\n")
#

wilcox.test(I(sl$effort2[which(sl$treatment_id==12)]-sl$effort1[which(sl$treatment_id==12)]),I(sl$effort2[which(sl$treatment_id==11)]-sl$effort1[which(sl$treatment_id==11)]),paired=F)$p.value
wilcox.test(sl$effort2[which(sl$treatment_id==12)],sl$effort2[which(sl$treatment_id==11)],paired=F)$p.value

wilcox.test(sl$effort2[which(sl$treatment_id==13)],sl$effort2[which(sl$treatment_id==14)],paired=F)$p.value



wilcox.test(cr$effort2[which(cr$treatment_id==22)],cr$effort2[which(cr$treatment_id==21)],paired=F)$p.value


wilcox.test(sl$effort1[which(sl$treatment_id==11)],sl$effort2[which(sl$treatment_id==11)],paired=F)$p.value
wilcox.test(cr$effort1[which(cr$treatment_id==21)],cr$effort2[which(cr$treatment_id==21)],paired=F)$p.value
with(subset(sl,treatment_id==11),wilcox.test(effort1,effort2,paired=T)$p.value)
with(subset(cr,treatment_id==21),wilcox.test(effort1,effort2,paired=T)$p.value)
with(subset(sl,treatment_id==11),wilcox.test(pausen1,pausen2,paired=T)$p.value)
with(subset(cr,treatment_id==21),wilcox.test(pausen1,pausen2,paired=T)$p.value)


wilcox.test(cr$score1[which(cr$treatment_id==41)],cr$score2[which(cr$treatment_id==41)],paired=T)$p.value
wilcox.test(cr$score1[which(cr$treatment_id==42)],cr$score2[which(cr$treatment_id==42)],paired=T)$p.value
wilcox.test(cr$score1[which(cr$treatment_id==42)],cr$score1[which(cr$treatment_id==41)],paired=F)$p.value
wilcox.test(cr$score2[which(cr$treatment_id==42)],cr$score2[which(cr$treatment_id==41)],paired=F)$p.value

wilcox.test(cr$transfer1[which(cr$treatment_id==41)],cr$transfer2[which(cr$treatment_id==41)],paired=T)$p.value
wilcox.test(cr$transfer1[which(cr$treatment_id==42)],cr$transfer2[which(cr$treatment_id==42)],paired=T)$p.value
wilcox.test(cr$transfer1[which(cr$treatment_id==42)],cr$transfer1[which(cr$treatment_id==41)],paired=F)$p.value
wilcox.test(cr$transfer2[which(cr$treatment_id==42)],cr$transfer2[which(cr$treatment_id==41)],paired=F)$p.value

reg3<-lm(neffort2~neffort1+neffort1:slider+gift+gift:slider+turnier+turnier:slider+feedback+feedback:slider+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi+tendency.to.forgive,data=subset(pooled,treatment_id<40))
coeftest(reg3, vcov=vcovHC(reg3,type="HC1")) 
c(summary(reg3)$r.squared,length(summary(reg3)$residuals))


reg4<-lm(ntransfer2~ntransfer1+ntransfer1:slider+gift+gift:slider+turnier+turnier:slider+I(treatment_id==14)+I(treatment_id==24)+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi+tendency.to.forgive+creative_trans+creative_trans:gift_trans,data=pooled)
coeftest(reg4, vcov=vcovHC(reg4,type="HC1")) 
c(summary(reg4)$r.squared,length(summary(reg4)$residuals))

summary(lm(neffort2~neffort1+tendency.to.forgive+gift*tendency.to.forgive+turnier*tendency.to.forgive+feedback*tendency.to.forgive,data=subset(sl,treatment_id<40)))
summary(lm(neffort2~neffort1+tendency.to.forgive+gift*tendency.to.forgive+turnier*tendency.to.forgive+feedback*tendency.to.forgive,data=subset(cr,treatment_id<40)))

reg_flex<-lm(I(p_flex2/effort2)~I(p_flex1/effort1)+gift+turnier,data=subset(cr,treatment_id<=23))
coeftest(reg_flex, vcov=vcovHC(reg_flex,type="HC1")) 



reg3<-lm(neffort2~neffort1+neffort1:slider+gift+gift:slider+turnier+turnier:slider+feedback+feedback:slider+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(pooled,treatment_id<40))
coeftest(reg3, vcov=vcovHC(reg3,type="HC1")) 
c(summary(reg3)$r.squared,length(summary(reg3)$residuals))

qreg<-rq(neffort2~neffort1+neffort1:slider+gift+gift:slider+turnier+turnier:slider+feedback+feedback:slider,data=subset(pooled,treatment_id<40),tau=.8)
summary(qreg,se = "boot")





cregf<-lm(nf2~p_valid2+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id<=23))
coeftest(cregf, vcov=vcovHC(cregf,type="HC1")) 
cat("n=",length(cregf$resid)," ","R2=",summary(cregf)$r.squared,"\n")
crego<-lm(no2~p_valid2+gift+turnier+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=subset(cr,treatment_id<=23))
coeftest(crego, vcov=vcovHC(crego,type="HC1")) 
cat("n=",length(crego$resid)," ","R2=",summary(crego)$r.squared,"\n")

## Feedback period 3
sl_period3_wl<-lm(neffort3~neffort1+gift+I(treatment_id==13 & bonus_recvd==1)+I(treatment_id==13 & bonus_recvd==0)+I(treatment_id==14 & feedback_pos==1)+I(treatment_id==14 & feedback_pos==0)+age+I(age^2)+sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=sl)
coeftest(sl_period3_wl, vcov=vcovHC(sl_period3_wl,type="HC1"))
c(summary(sl_period3_wl)$r.squared,length(summary(sl_period3_wl)$residuals))

cr_period3_wl<-lm(ntransfer3~ntransfer1+gift+I(treatment_id==23 & bonus_recvd==1)+I(treatment_id==23 & bonus_recvd==0)+I(treatment_id==24 & feedback_pos==1)+I(treatment_id==24 & feedback_pos==0)+age+I(age^2)+
                    creative_trans + gift_trans + 
                    sex+mannheim+ferienzeit+pruefungszeit+wiwi+recht+nawi+gewi,data=cr)
coeftest(cr_period3_wl, vcov=vcovHC(cr_period3_wl,type="HC1"))
c(summary(cr_period3_wl)$r.squared,length(summary(cr_period3_wl)$residuals))
