##########################################################################################################################################
clx <- 
function(fm, dfcw, cluster){
         M <- length(unique(cluster))   
         N <- length(cluster)           
         K <- fm$rank                        
         dfc <- (M/(M-1))*((N-1)/(N-K))  
         uj  <- apply(estfun(fm),2, function(x) tapply(x, cluster, sum));
         vcovCL <- dfc*sandwich(fm, meat=crossprod(uj)/N)*dfcw
         coeftest(fm, vcovCL) }
#
robust.se <- function(model, cluster){
 require(sandwich)
 require(lmtest)
 M <- length(unique(cluster))
 N <- length(cluster)
 K <- model$rank
 dfc <- (M/(M - 1)) * ((N - 1)/(N - K))
 uj <- apply(estfun(model), 2, function(x) tapply(x, cluster, sum));
 rcse.cov <- dfc * sandwich(model, meat = crossprod(uj)/N)
 rcse.se <- coeftest(model, rcse.cov)
 return(list(rcse.cov, rcse.se))
}
#
ztest<-function(mx,sdx,my,sdy){
	cat("p-value: ",dnorm((mx-my)/sqrt(sdx^2+sdy^2)),"\n\n")
}
##########################################################################################################################################
################################################# Data ###################################################################################
########################################################################################################################################## 
#
options(digits = 12)
#fair<-read.table("D:/131002_FairWage.txt",sep="\t",header=T)
#colnames(fair[,2:3])<-tolower(colnames(fair[,2:3]))
###
if(any(grepl("fdb_old",names(neu)))){
	neu[,"feedback_old"]<-neu[,"fdb_old"]
	neu[,"fdb_old"]<-NULL
}
colnames(neu)<-tolower(colnames(neu))
neu$No<-neu$no
#
#
#
neu$start<-as.numeric(substr(neu$uhrzeit,1,2))
neu$date2<-as.Date(as.character(neu$date),format="%y%m%d")
neu$weekday<-weekdays(neu$date2)
#
#table(neu$group,neu$session)
#
#
table(table(neu$group,neu$session))
groups_per_session<-tapply(neu$group,neu$session,function(x){length(unique(x))})
neu$group_id<-NA
tmp<-0
for(i in 1:dim(neu)[1]){
	if(neu$session[i]==1){neu$group_id[i]<-neu$group[i]}
	if(neu$session[i]>1){
		if(neu$session[i]!=neu$session[i-1]){tmp<-tmp+groups_per_session[neu$session[i-1]]}
		neu$group_id[i]<-neu$group[i]+tmp
		}
}
table(neu$group_id,neu$session)
rm(tmp)
##########################################################################################################################################
################################################# Check Issues ###########################################################################
##########################################################################################################################################
#tn_problems<-c(327,347,863,864,960,1034,1019,1068,1073,1096,1164,1165,1261,1284)
#session_problems<-c(10,13,14,27,28,29,33,37,76,85,102)
dim(neu)
dim(neu[which(is.na(neu$no_problem)),])
dim(neu[which(neu$feedback_old==0 & neu$slider_fair==0),])
dim(neu[which(neu$feedback_old==0 & neu$slider_fair==0 & is.na(neu$session_problem)),])
dim(neu[which(neu$feedback_old==0 & neu$slider_fair==0 & is.na(neu$session_problem) & is.na(neu$no_problem)),])
table(neu[which(neu$feedback_old==0 & neu$slider_fair==0 & is.na(neu$session_problem)),"treatment_id2"])	
dim(neu[which(!is.na(neu$no_problem) & neu$treatment!=31 & neu$treatment!=32 & neu$treatment!=52),])
dim(neu[which(is.na(neu$no_problem) & is.na(neu$session_problem)),])
neu<-neu[which(is.na(neu$no_problem) & is.na(neu$session_problem)),]
neu<-neu[which(neu$session!=108),]
table(neu$feedback_old)
table(neu$slidertask,neu$treatment_id2)
table(neu$treatment_id,neu$treatment_id2)
#neu$slidertask[which(neu$session==120)]<-4
neu$gift<-0
neu$gift[which(neu$treatment_id==12 | neu$treatment_id==22)]<-1
neu$control<-0
neu$control[which(neu$treatment_id==11 | neu$treatment_id==21)]<-1
neu$control_trans<-0
neu$control_trans[which(neu$treatment_id==41)]<-1
neu$gift_trans<-0
neu$gift_trans[which(neu$treatment_id==42)]<-1
neu$gift_fair<-0
neu$gift_fair[which(neu$treatment_id==52)]<-1
#
neu$expert1<-apply(neu[,c("p_subj_6_1","p_subj_8_1","p_subj_9_1","p_subj_10_1","p_subj_11_1")],1,mean,na.rm=T)
neu$expert2<-apply(neu[,c("p_subj_6_2","p_subj_8_2","p_subj_9_2","p_subj_10_2","p_subj_11_2")],1,mean,na.rm=T)
#
neu<-neu[,!(grepl("p_subj_|spillover|grund|ge_transfer|self_det_|evaluator|nonspec|gewoehnlich|intmot|pressure",colnames(neu)))]
neu<-neu[,!(colnames(neu)%in%c("ztreeid","uhrzeit","sudoku"))]
##########################################################################################################################################
################################################# Define Subsets #########################################################################
##########################################################################################################################################
### Subset containing creative tasks
cneu<-subset(neu,bonus_dec==1 & proposer==0 & creative==1) 
### Subset containing slider tasks 
sneu<-subset(neu,bonus_dec==1 & proposer==0 & slider==1)
### Subset containing proposer
sneu_proposer<-subset(neu,bonus_dec==1 & proposer==1 & slider==1)
cneu_proposer<-subset(neu,bonus_dec==1 & proposer==1 & slider==0)
#
sneu_proposer2<-subset(neu,proposer==1 & slider==1)
cneu_proposer2<-subset(neu,proposer==1 & creative==1)
proposer<-subset(neu,proposer==1)
### Subset containing neg. bonus dec. 
sneu_neg<-subset(neu,bonus_dec==0 & proposer==0 & slider==1)
cneu_neg<-subset(neu,bonus_dec==0 & proposer==0 & slider==0)
#
eke<-subset(neu,bonus_dec==1 & proposer==0 & eke==1)
kek<-subset(neu,bonus_dec==1 & proposer==0 & kek==1)
### Subset containing creative tasks
cr<-subset(neu,bonus_dec==1 & proposer==0 & (creative==1 | creative_trans==1)) 
### Subset containing slider tasks
sl<-subset(neu,bonus_dec==1 & proposer==0 & (slider==1 | slider_fair==1)) 
###
sl<-subset(sl,treatment_id!=52)
##########################################################################################################################################
################################################# Top 30 Answers #########################################################################
########################################################################################################################################## 
source("151201_Definitions_NEU.r")
# Steve Idea
steve<-read.table("Data/steveidea.txt",header=T,sep="\t",stringsAsFactors=F)
colnames(steve)<-tolower(colnames(steve))
steve<-steve[which(steve$id%in%cneu$id),]
steve<-steve[,c("id","antoniatop30r1","antoniatop30r2")]
#
#steve<-merge(steve,cneu[,c("id","treatment_id","treatment_id2")],"id",all.y=T,all.x=F)
##########################################################################################################################################
################################################# Subjektive Bew #########################################################################
########################################################################################################################################## 
subj<-read.table("Data/Subjektive_Bewertungen.txt",header=T,sep="\t")
subj<-subj[,c(6,8:11)]
#
round1<-read.table("Data/Round1.txt",header=T,sep="\t",stringsAsFactors=F)
round2<-read.table("Data/Round2.txt",header=T,sep="\t",stringsAsFactors=F)
round3<-read.table("Data/Round3.txt",header=T,sep="\t",stringsAsFactors=F)
#
round1$valid<-round1$Gueltigkeit.spez
round1$invalid<-as.numeric(round1$Gueltigkeit.spez==0)
round1[which(round1$Kategorie=="-"),"Flexibilitaet"]<-0
round1[which(round1$Kategorie=="-"),"Originalitaet"]<-0
round1[which(round1$Gueltigkeit.unspez!=0),"Originalitaet"]<-0
round1<-round1[,grepl("ID|valid|Flexibilit|Originalit",colnames(round1))]
colnames(round1)<-tolower(colnames(round1))
round1$session.id<-NULL
colnames(round1)[which(colnames(round1)=="flexibilitaet")]<-"flex"
colnames(round1)[which(colnames(round1)=="originalitaet")]<-"original"
round1<-round1[which(round1$id%in%cr$id),]
round1$id<-as.numeric(round1$id)
round1$original1<-0
round1$original1[which(round1$original==0.5 | round1$original==1)]<-round1$original[which(round1$original==0.5 | round1$original==1)]
round1$original2<-as.numeric(round1$original==2)
round1<-merge(round1,cr[,c("id","treatment_id")],all=T)
#
#
round2$valid<-round2$Gueltigkeit.spez
round2$invalid<-as.numeric(round2$Gueltigkeit.spez==0)
round2[which(round2$Kategorie=="-"),"Flexibilitaet"]<-0
round2[which(round2$Kategorie=="-"),"Originalitaet"]<-0
round2[which(round2$Gueltigkeit.unspez!=0),"Originalitaet"]<-0
round2<-round2[,grepl("ID|valid|Flexibilit|Originalit",colnames(round2))]
colnames(round2)<-tolower(colnames(round2))
round2$session.id<-NULL
colnames(round2)[which(colnames(round2)=="flexibilitaet")]<-"flex"
colnames(round2)[which(colnames(round2)=="originalitaet")]<-"original"
round2<-round2[which(round2$id%in%cr$id),]
round2$id<-as.numeric(round2$id)
round2$original1<-0
round2$original1[which(round2$original==0.5 | round2$original==1)]<-round2$original[which(round2$original==0.5 | round2$original==1)]
round2$original2<-as.numeric(round2$original==2)
round2<-merge(round2,cr[,c("id","treatment_id")],all=T)
#
#
round3$valid<-round3$Gueltigkeit.spez
round3$invalid<-as.numeric(round3$Gueltigkeit.spez==0)
round3[which(round3$Kategorie=="-"),"Flexibilitaet"]<-0
round3[which(round3$Kategorie=="-"),"Originalitaet"]<-0
round3[which(round3$Gueltigkeit.unspez!=0),"Originalitaet"]<-0
round3<-round3[,grepl("ID|valid|Flexibilit|Originalit",colnames(round3))]
colnames(round3)<-tolower(colnames(round3))
round3$session.id<-NULL
colnames(round3)[which(colnames(round3)=="flexibilitaet")]<-"flex"
colnames(round3)[which(colnames(round3)=="originalitaet")]<-"original"
round3<-round3[which(round3$id%in%cr$id),]
round3$id<-as.numeric(round3$id)
round3$original1<-0
round3$original1[which(round3$original==0.5 | round3$original==1)]<-round3$original[which(round3$original==0.5 | round3$original==1)]
round3$original2<-as.numeric(round3$original==2)
round3<-merge(round3,cr[,c("id","treatment_id")],all=T)
#
#
round1_sum<-ddply(round1, c("id","treatment_id"), summarize,valid = sum(valid,na.rm=T), flex = sum(flex,na.rm=T), original = sum(original,na.rm=T), original1 = sum(original1,na.rm=T), original2 = sum(original2,na.rm=T), invalid = sum(invalid,na.rm=T), treatment_id = mean(treatment_id))
round1_sum$score<-round(round1_sum$valid+round1_sum$flex+round1_sum$original)
#
round2_sum<-ddply(round2, c("id","treatment_id"), summarize,valid = sum(valid,na.rm=T), flex = sum(flex,na.rm=T), original = sum(original,na.rm=T), original1 = sum(original1,na.rm=T), original2 = sum(original2,na.rm=T), invalid = sum(invalid,na.rm=T), treatment_id = mean(treatment_id))
round2_sum$score<-round(round2_sum$valid+round2_sum$flex+round2_sum$original)
#
round3_sum<-ddply(round3, c("id","treatment_id"), summarize,valid = sum(valid,na.rm=T), flex = sum(flex,na.rm=T), original = sum(original,na.rm=T), original1 = sum(original1,na.rm=T), original2 = sum(original2,na.rm=T), invalid = sum(invalid,na.rm=T), treatment_id = mean(treatment_id))
round3_sum$score<-round(round3_sum$valid+round3_sum$flex+round3_sum$original)