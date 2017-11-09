#
#cr$treatment_int<-factor(cr$treatment_id2,levels=c(levels(cr$treatment_id2),"creative_transfer"))
#######################################
### Definitions
#######################################
#
cr$neffort1<-(cr$effort1-mean(cr$effort1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort1[which(cr$treatment_id==21)],na.rm=T)
sl$neffort1<-(sl$effort1-mean(sl$effort1[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort1[which(sl$treatment_id==11)],na.rm=T)
cr$neffort2<-(cr$effort2-mean(cr$effort2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort2[which(cr$treatment_id==21)],na.rm=T)
sl$neffort2<-(sl$effort2-mean(sl$effort2[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort2[which(sl$treatment_id==11)],na.rm=T)
cr$neffort3<-(cr$effort3-mean(cr$effort3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort3[which(cr$treatment_id==21)],na.rm=T)
sl$neffort3<-(sl$effort3-mean(sl$effort3[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort3[which(sl$treatment_id==11)],na.rm=T)
#
cneu_proposer$neffort1<-(cneu_proposer$effort1-mean(cr$effort1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort1[which(cr$treatment_id==21)],na.rm=T)
sneu_proposer$neffort1<-(sneu_proposer$effort1-mean(sl$effort1[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort1[which(sl$treatment_id==11)],na.rm=T)
cneu_proposer$neffort2<-(cneu_proposer$effort2-mean(cr$effort2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort2[which(cr$treatment_id==21)],na.rm=T)
sneu_proposer$neffort2<-(sneu_proposer$effort2-mean(sl$effort2[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort2[which(sl$treatment_id==11)],na.rm=T)
cneu_proposer$neffort3<-(cneu_proposer$effort3-mean(cr$effort3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort3[which(cr$treatment_id==21)],na.rm=T)
sneu_proposer$neffort3<-(sneu_proposer$effort3-mean(sl$effort3[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort3[which(sl$treatment_id==11)],na.rm=T)
#
cr$ng1<-(cr$p_valid1-mean(cr$p_valid1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_valid1[which(cr$treatment_id==21)],na.rm=T)
cr$ng2<-(cr$p_valid2-mean(cr$p_valid2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_valid2[which(cr$treatment_id==21)],na.rm=T)
cr$ng3<-(cr$p_valid3-mean(cr$p_valid3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_valid3[which(cr$treatment_id==21)],na.rm=T)
#
cr$nf1<-(cr$p_flex1-mean(cr$p_flex1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_flex1[which(cr$treatment_id==21)],na.rm=T)
cr$nf2<-(cr$p_flex2-mean(cr$p_flex2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_flex2[which(cr$treatment_id==21)],na.rm=T)
cr$nf3<-(cr$p_flex3-mean(cr$p_flex3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_flex3[which(cr$treatment_id==21)],na.rm=T)
#
cr$no1<-(cr$p_original1-mean(cr$p_original1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_original1[which(cr$treatment_id==21)],na.rm=T)
cr$no2<-(cr$p_original2-mean(cr$p_original2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_original2[which(cr$treatment_id==21)],na.rm=T)
cr$no3<-(cr$p_original3-mean(cr$p_original3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$p_original3[which(cr$treatment_id==21)],na.rm=T)
#
###
#
cr$ndiff1<-cr$neffort2-cr$neffort1
cr$diff1<-cr$effort2-cr$effort1
#
sl$ndiff1<-sl$neffort2-sl$neffort1
sl$diff1<-sl$effort2-sl$effort1
#
cr$ndiff2<-cr$neffort3-cr$neffort2
sl$ndiff2<-sl$neffort3-sl$neffort2
#
cr$ndiff3<-cr$neffort3-cr$neffort1
sl$ndiff3<-sl$neffort3-sl$neffort1
#
cr$neffort1<-(cr$effort1-mean(cr$effort1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort1[which(cr$treatment_id==21)],na.rm=T)
cr$neffort2<-(cr$effort2-mean(cr$effort2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort2[which(cr$treatment_id==21)],na.rm=T)
cr$neffort3<-(cr$effort3-mean(cr$effort3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort3[which(cr$treatment_id==21)],na.rm=T)
cr$ndiff1<-cr$neffort2-cr$neffort1
cr$diff1<-cr$effort2-cr$effort1
cr$diff3<-cr$effort3-cr$effort1
#
sl$diff1<-sl$effort2-sl$effort1
sl$diff3<-sl$effort3-sl$effort1
#
sl$age2<-sl$age*sl$age
cr$age2<-cr$age*cr$age
#
#
cr$score1[which(cr$treatment_id%in%c(21:24))]<-cr$effort1[which(cr$treatment_id%in%c(21:24))]
cr$score2[which(cr$treatment_id%in%c(21:24))]<-cr$effort2[which(cr$treatment_id%in%c(21:24))]
cr$score3[which(cr$treatment_id%in%c(21:24))]<-cr$effort3[which(cr$treatment_id%in%c(21:24))]
#
cr$transfer1[which(cr$treatment_id%in%c(21:24))]<-cr$effort1[which(cr$treatment_id%in%c(21:24))]
cr$transfer2[which(cr$treatment_id%in%c(21:24))]<-cr$effort2[which(cr$treatment_id%in%c(21:24))]
cr$transfer3[which(cr$treatment_id%in%c(21:24))]<-cr$effort3[which(cr$treatment_id%in%c(21:24))]
#cr$score1[which(cr$treatment_id%in%c(21:24))]<-cr$effort1[which(cr$treatment_id%in%c(21:24))]
#cr$score2[which(cr$treatment_id%in%c(21:24))]<-cr$effort2[which(cr$treatment_id%in%c(21:24))]
#
cr$nscore1<-(cr$score1-mean(cr$score1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$score1[which(cr$treatment_id==21)],na.rm=T)
cr$nscore2<-(cr$score2-mean(cr$score2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$score2[which(cr$treatment_id==21)],na.rm=T)
cr$nscore3<-(cr$score3-mean(cr$score3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$score3[which(cr$treatment_id==21)],na.rm=T)
#
cr$ntransfer1<-(cr$transfer1-mean(cr$transfer1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$transfer1[which(cr$treatment_id==21)],na.rm=T)
cr$ntransfer2<-(cr$transfer2-mean(cr$transfer2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$transfer2[which(cr$treatment_id==21)],na.rm=T)
cr$ntransfer3<-(cr$transfer3-mean(cr$transfer3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$transfer3[which(cr$treatment_id==21)],na.rm=T)
cr$ndiff1_transfer<-cr$ntransfer2-cr$ntransfer1
cr$diff1_transfer<-cr$transfer2-cr$transfer1
#
cr$std_transfer1<-(cr$transfer1-mean(cr$transfer1[which(cr$treatment_id==41)],na.rm=T))/sd(cr$transfer1[which(cr$treatment_id==41)],na.rm=T)
cr$std_transfer2<-(cr$transfer2-mean(cr$transfer2[which(cr$treatment_id==41)],na.rm=T))/sd(cr$transfer2[which(cr$treatment_id==41)],na.rm=T)
cr$std_transfer1[which(cr$treatment_id<40)]<-NA
cr$std_transfer2[which(cr$treatment_id<40)]<-NA
#
cr$ndiff3_transfer<-cr$ntransfer3-cr$ntransfer1
cr$diff3_transfer<-cr$transfer3-cr$transfer1
#
cneu_neg$ntransfer1<-(cneu_neg$transfer1-mean(cr$transfer1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$transfer1[which(cr$treatment_id==21)],na.rm=T)
cneu_neg$ntransfer2<-(cneu_neg$transfer2-mean(cr$transfer2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$transfer2[which(cr$treatment_id==21)],na.rm=T)
cneu_neg$ntransfer3<-(cneu_neg$transfer3-mean(cr$transfer3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$transfer3[which(cr$treatment_id==21)],na.rm=T)
#
#cr$nscore1<-(cr$score1-mean(cr$score1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$score1[which(cr$treatment_id==21)],na.rm=T)
#cr$nscore2<-(cr$score2-mean(cr$score2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$score2[which(cr$treatment_id==21)],na.rm=T)
#cr$ndiff_score1<-cr$nscore2-cr$nscore1
cr$diff_score1<-cr$score2-cr$score1
cr$diff_transfer1<-cr$transfer2-cr$transfer1
#
sl$neffort1<-(sl$effort1-mean(sl$effort1[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort1[which(sl$treatment_id==11)],na.rm=T)
sl$neffort2<-(sl$effort2-mean(sl$effort2[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort2[which(sl$treatment_id==11)],na.rm=T)
sl$neffort3<-(sl$effort3-mean(sl$effort3[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort3[which(sl$treatment_id==11)],na.rm=T)
sl$ndiff1<-sl$neffort2-sl$neffort1
sl$diff1<-sl$effort2-sl$effort1
#
sl$transfer1<-sl$effort1
sl$transfer2<-sl$effort2
sl$transfer3<-sl$effort3
sl$ntransfer1<-sl$neffort1
sl$ntransfer2<-sl$neffort2
sl$ntransfer3<-sl$neffort3
#
mean(cr$neffort1[which(cr$treatment_id==21)],na.rm=T)
mean(cr$neffort2[which(cr$treatment_id==21)],na.rm=T)
mean(cr$neffort3[which(cr$treatment_id==21)],na.rm=T)
mean(sl$neffort1[which(sl$treatment_id==11)],na.rm=T)
mean(sl$neffort2[which(sl$treatment_id==11)],na.rm=T)
mean(sl$neffort3[which(sl$treatment_id==11)],na.rm=T)
#
sd(cr$neffort1[which(cr$treatment_id==21)],na.rm=T)
sd(cr$neffort2[which(cr$treatment_id==21)],na.rm=T)
sd(cr$neffort3[which(cr$treatment_id==21)],na.rm=T)
sd(sl$neffort1[which(sl$treatment_id==11)],na.rm=T)
sd(sl$neffort2[which(sl$treatment_id==11)],na.rm=T)
sd(sl$neffort3[which(sl$treatment_id==11)],na.rm=T)
#
mean(cr$ng1[which(cr$treatment_id==21)],na.rm=T)
mean(cr$ng2[which(cr$treatment_id==21)],na.rm=T)
mean(cr$ng3[which(cr$treatment_id==21)],na.rm=T)
mean(cr$nf1[which(cr$treatment_id==21)],na.rm=T)
mean(cr$nf2[which(cr$treatment_id==21)],na.rm=T)
mean(cr$nf3[which(cr$treatment_id==21)],na.rm=T)
mean(cr$no1[which(cr$treatment_id==21)],na.rm=T)
mean(cr$no2[which(cr$treatment_id==21)],na.rm=T)
mean(cr$no3[which(cr$treatment_id==21)],na.rm=T)
#
sd(cr$ng1[which(cr$treatment_id==21)],na.rm=T)
sd(cr$ng2[which(cr$treatment_id==21)],na.rm=T)
sd(cr$ng3[which(cr$treatment_id==21)],na.rm=T)
sd(cr$nf1[which(cr$treatment_id==21)],na.rm=T)
sd(cr$nf2[which(cr$treatment_id==21)],na.rm=T)
sd(cr$nf3[which(cr$treatment_id==21)],na.rm=T)
sd(cr$no1[which(cr$treatment_id==21)],na.rm=T)
sd(cr$no2[which(cr$treatment_id==21)],na.rm=T)
sd(cr$no3[which(cr$treatment_id==21)],na.rm=T)
#
cr$ndiff1g<-cr$ng2-cr$ng1
cr$ndiff1f<-cr$nf2-cr$nf1
cr$ndiff1o<-cr$no2-cr$no1
#
### Treatment als Faktor
cr$treatmentf<-factor(NA,levels=c("Control Group","Bonus All","Tournament","Feedback"))
cr$treatmentf[which(cr$treatment_id==21)]<-"Control Group"
cr$treatmentf[which(cr$treatment==2)]<-"Bonus All"
cr$treatmentf[which(cr$treatment==3)]<-"Tournament"
cr$treatmentf[which(cr$treatment==4)]<-"Feedback"
table(cr$treatmentf,cr$treatment)
#
sl$treatmentf<-factor(NA,levels=c("Control Group","Bonus All","Tournament","Feedback"))
sl$treatmentf[which(sl$treatment_id==11)]<-"Control Group"
sl$treatmentf[which(sl$treatment==2)]<-"Bonus All"
sl$treatmentf[which(sl$treatment==3)]<-"Tournament"
sl$treatmentf[which(sl$treatment==4)]<-"Feedback"
table(sl$treatmentf,sl$treatment)
#
### Subset containing both tasks
pooled<-rbind.fill(cr,sl)
pooled$treatment2<-factor(NA,levels=c("Slider Control","Slider Bonus All","Slider Tournament","Slider Feedback","Creative Control","Creative Bonus All","Creative Tournament","Creative Feedback"))
pooled$treatment2[which(pooled$treatmentf=="Control Group" & pooled$slidertask==1)]<-"Slider Control"
pooled$treatment2[which(pooled$treatmentf=="Control Group" & pooled$slidertask==0)]<-"Creative Control"
pooled$treatment2[which(pooled$treatmentf=="Bonus All" & pooled$slidertask==1)]<-"Slider Bonus All"
pooled$treatment2[which(pooled$treatmentf=="Bonus All" & pooled$slidertask==0)]<-"Creative Bonus All"
pooled$treatment2[which(pooled$treatmentf=="Tournament" & pooled$slidertask==1)]<-"Slider Tournament"
pooled$treatment2[which(pooled$treatmentf=="Tournament" & pooled$slidertask==0)]<-"Creative Tournament"
pooled$treatment2[which(pooled$treatmentf=="Feedback" & pooled$slidertask==1)]<-"Slider Feedback"
pooled$treatment2[which(pooled$treatmentf=="Feedback" & pooled$slidertask==0)]<-"Creative Feedback"
table(pooled$treatment2,pooled$treatmentf)
###
pooled$treatment3<-factor(pooled$treatment2,levels=c("Control",levels(pooled$treatment2)))
pooled$treatment3[which(pooled$treatment3=="Slider Control" | pooled$treatment3=="Creative Control")]<-"Control"
pooled$treatment3<-factor(pooled$treatment3)
### Subset with negative bonus decisions
sneu_neg$treatment2<-sneu_neg$treatment
cneu_neg$treatment2<-cneu_neg$treatment
sneu_neg$treatment<-5
cneu_neg$treatment<-5
cneu_neg$neffort1<-(cneu_neg$effort1-mean(cr$effort1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort1[which(cr$treatment_id==21)],na.rm=T)
sneu_neg$neffort1<-(sneu_neg$effort1-mean(sl$effort1[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort1[which(sl$treatment_id==11)],na.rm=T)
cneu_neg$neffort2<-(cneu_neg$effort2-mean(cr$effort2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort2[which(cr$treatment_id==21)],na.rm=T)
sneu_neg$neffort2<-(sneu_neg$effort2-mean(sl$effort2[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort2[which(sl$treatment_id==11)],na.rm=T)
cneu_neg$neffort3<-(cneu_neg$effort3-mean(cr$effort3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort3[which(cr$treatment_id==21)],na.rm=T)
sneu_neg$neffort3<-(sneu_neg$effort3-mean(sl$effort3[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort3[which(sl$treatment_id==11)],na.rm=T)
cneu_neg$ndiff1<-cneu_neg$neffort2-cneu_neg$neffort1
sneu_neg$ndiff1<-sneu_neg$neffort2-sneu_neg$neffort1
cneu_neg$ndiff3<-cneu_neg$neffort3-cneu_neg$neffort1
sneu_neg$ndiff3<-sneu_neg$neffort3-sneu_neg$neffort1
spooledb<-rbind.fill(sneu,sneu_neg)
cr2b<-rbind.fill(cr,cneu_neg)
### EKE / KEK
#eke_group_mean<-as.data.frame(tapply(eke$effort2,eke$group_rank,mean))
#colnames(eke_group_mean)<-c("mean_effort2_group")
#eke_group_mean$group_rank<-rownames(eke_group_mean)
#eke<-merge(eke,eke_group_mean,"group_rank",all=T)
#eke$winnerR2_turnier<-as.numeric(eke$effort2>eke$mean_effort2_group)
#
eke$neffort1<-(eke$effort1-mean(sl$effort1[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort1[which(sl$treatment_id==11)],na.rm=T)
kek$neffort1<-(kek$effort1-mean(cr$effort1[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort1[which(cr$treatment_id==21)],na.rm=T)
eke$neffort2<-(eke$effort2-mean(cr$effort2[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort2[which(cr$treatment_id==21)],na.rm=T)
kek$neffort2<-(kek$effort2-mean(sl$effort2[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort2[which(sl$treatment_id==11)],na.rm=T)
eke$neffort3<-(eke$effort3-mean(sl$effort3[which(sl$treatment_id==11)],na.rm=T))/sd(sl$effort3[which(sl$treatment_id==11)],na.rm=T)
kek$neffort3<-(kek$effort3-mean(cr$effort3[which(cr$treatment_id==21)],na.rm=T))/sd(cr$effort3[which(cr$treatment_id==21)],na.rm=T)
#
#eke$ndiff3<-eke$neffort3-eke$neffort1
#kek$ndiff3<-kek$neffort3-kek$neffort1
#
#
#
#
table(cr$fairwage)
cr$fairwage2<-factor("ok",levels=c("ok","underpaid","overpaid"))
cr$fairwage2[which(cr$fairwage==4 | cr$fairwage==5)]<-"underpaid"
cr$fairwage2[which(cr$fairwage==1 | cr$fairwage==2)]<-"overpaid"
cr$fairwage2[which(cr$fairwage==3)]<-"ok"
cr$fairwage2[which(is.na(cr$fairwage))]<-NA
table(cr$fairwage,cr$fairwage2)
tapply(cr$ndiff1,cr$fairwage2,mean)
#
#
table(sl$fairwage)
sl$fairwage2<-factor("ok",levels=c("ok","underpaid","overpaid"))
sl$fairwage2[which(sl$fairwage==4 | sl$fairwage==5)]<-"underpaid"
sl$fairwage2[which(sl$fairwage==1 | sl$fairwage==2)]<-"overpaid"
sl$fairwage2[which(sl$fairwage==3)]<-"ok"
sl$fairwage2[which(is.na(sl$fairwage))]<-NA
table(sl$fairwage,sl$fairwage2)
tapply(sl$ndiff1,sl$fairwage2,mean)
#