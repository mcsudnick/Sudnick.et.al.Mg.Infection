#Code written by Madeline Sudnick and Dr. Erin Sauer#

#Libraries

library(readr) 
library(ggplot2)
library(nlme)
library(psych)
library(tidyr) 
library(readxl)
library(wesanderson)
library(MuMIn)
library(mgcv)
library(DescTools)
library(dplyr)

#set your working directory
setwd()

#### Experiment 1 ####

####Loading in the Data####
#use Three.Year.Repeat.InfectionA.csv

threeyr<-read_csv("Three.Year.Repeat.InfectionA.csv")
View(threeyr)



#### eye score analysis ####
threeyr$Infection <- as.factor(threeyr$Infection)
Eyescore.gam <- gamm(Eye ~ Infection + s(day, by=Infection, k=9), # smoothing function
              family=nb, 
              random=list(Bird.ID=~1),
              correlation=corCAR1(form=~day|Un.ID), data = threeyr)
gam.check(ESgam$gam)#checking fit
summary(ESgam$gam)

#### tolerance analysis ####
threeyr$Infection <- as.factor(threeyr$Infection)
Tolerance.gam <- gamm(Eye ~ Infection*pathlog + s(day, k=7), # smoothing function
               family=nb, 
               random=list(Bird.ID=~1),
               correlation=corCAR1(form=~day|Un.ID), data = threeyr)
gam.check(Tolgam$gam)#checking fit
summary(Tolgam$gam)

#### MG load analysis ####

Pathmodel <- glmmTMB(pathlog ~ day*Infection+(1|Bird.ID), data=threeyr) 
summary(Pathmodel)
Anova(Pathmodel)

#### MG antibody analysis #####
hist(threeyr$antibody)

antmodel <- glmmTMB(ant ~ day*Infection+(1|Un.ID), data=threeyr) 
summary(antmodel)
Anova(antmodel)

#### change in fat analysis ####
cng.fat.model<-lme(cng.fat ~ Infection, na.action=na.omit, random = ~1|Bird.ID, data = sing.row, method="ML")
summary(sing.fat)

fatcng.AOV <- anova_test(
  data = sing.row, dv = cng.fat, wid = Bird.ID,
  within = c(Infection))

get_anova_table(fatcng.AOV)

#### change in mass analysis ####
sing.mass<-lme(cng.mass ~ Infection, na.action=na.omit, random = ~1|Bird.ID, data = sing.row, method="ML")
summary(sing.mass)

masscng.AOV <- anova_test(
  data = sing.row, dv = cng.mass, wid = Bird.ID,
  within = c(Infection))

get_anova_table(masscng.AOV)

#Change in hem analysis ####
sing.hem<-lme(cng.hem ~ Infection, na.action=na.omit, random = ~1|Bird.ID, data = sing.row, method="ML")
summary(sing.hem)

hemcng.AOV <- anova_test(
  data = sing.row, dv = cng.hem, wid = Bird.ID,
  within = c(Infection))

get_anova_table(hemcng.AOV)


####Experiment 2 ####


##########################################################################################################3
#### Using Fishers Test to look at differences in number of flocks with transmission####

Flocks<- read_csv("Flocks.upload.csv")
flocks <- as.data.frame(Flocks)
df<-flocks[2:3]
dfbac<-flocks[, c('Treat', 'Trans.bac')]

testbac <- fisher.test(table(dfbac))
summary(testbac)
testbac

####Investigating birds that transmitted and those that became infected by flock mates####
####read in the next 
trans.daily <- read_csv("Transmission.ExperimentA.csv")

trans.daily$pathlog<-(trans.daily$logSQ)
trans.daily$visitlog<-log(trans.daily$visit+1)
trans.daily <- trans.daily %>% mutate(tolINDEX = (Eye/(pathlog+1)))
trans.daily$tolINDEX
####making a data set for only index birds####
index <- trans.daily[trans.daily$IndexA=="1", ]



##index bird models
index.path<-lme(pathlog ~ TreatA  , na.action=na.omit, random = ~1|Bird.ID, data = index, method="ML")
summary(index.path)


index.ant<-lme(ant ~ TreatA , na.action=na.omit, random = ~1|Bird.ID, data = index, method="ML")
summary(index.ant)


index.visitlog<-lme(visitlog ~ TreatA*day , na.action=na.omit, random = ~1|Bird.ID, data = index, method="ML")
summary(index.visitlog)


index.hem<-lme(hem ~ TreatA , na.action=na.omit, random = ~1|Bird.ID, data = index, method="ML")
summary(index.hem)


atrans.eye<-lme(Eye ~ TreatA , na.action=na.omit, random = ~1|Bird.ID, data = index, method="ML")
summary(atrans.eye)


index$tolINDEX
index[index == 'NaN'] <- NA

aatrans.tol<-lme(tolINDEX ~ TreatA , na.action=na.omit, random = ~1|Bird.ID, data = index, method="ML")
summary(aatrans.tol)


atrans.mass<-lme(mass ~ TreatA*day, na.action=na.omit, random = ~1|Bird.ID, data = index, method="ML")
summary(atrans.mass)




############### Transmitting bird model selection######################
#come up with a list of things I want
####calculate area under the curve####
birds <- unique(index$Bird.ID)# make each ID its own 
summed <- matrix(nrow=0,ncol=7) #creating a blank matrix, make it the same number of columns
index <- index %>% mutate(ant.max = max(ant, na.rm = TRUE))
View(index)
#test code

treat1.index<-subset(index, TreatA == 1)
names(treat1.index)
treat1.ind.und<-subset(treat1.index, day <= 10)
View(treat1.ind.und)
names(treat1.ind.und)


for(i in 1:length(birds)){
  data <- subset(treat1.ind.und, Bird.ID == birds[i])
  try({
    data$ES.AUC <- AUC(data$day, data$Eye, method="spline", na.rm = TRUE)
    data$load.AUC <- AUC(data$day,data$pathlog, method="spline", na.rm = TRUE)
    data$visit.AUC <- AUC(data$day,data$visitlog, method="spline", na.rm = TRUE)
    data$tol.AUC <- AUC(data$day,data$tolINDEX, method="spline", na.rm = TRUE)
    data$mass.AUC <- AUC(data$day,data$mass, method="spline", na.rm = TRUE)
    data <- data %>% mutate(hem.max = max(hem, na.rm = TRUE))
    data <- data %>% mutate(ant.max = max(ant, na.rm = TRUE))
    data <- data %>% mutate(tol.min = min(tolINDEX, na.rm = TRUE))
    data <- data %>% mutate(mass.max = max(mass, na.rm = TRUE))
    summed <- rbind(summed, data)
  })}


colnames(summed)
View(summed)
summedAUC <- summed[,c(1,12,14,16,32,33,34,35,36,37,38,39,40)]
View(summedAUC)
colnames(summedAUC)
summedAUC$Bird.ID <- as.character(summedAUC$Bird.ID)
summedAUC <- summedAUC %>% group_by(Bird.ID) %>% summarize_all(max, na.rm = TRUE)
colnames(summedAUC)
View(summedAUC)
day3 <- subset(trans.daily, day == 3)
colnames(day3)
day3 <- day3[,c(1,31)]
summedAUC<-merge(day3, summedAUC, by="Bird.ID")
colnames(summedAUC)
View(summedAUC)
summedAUC$load.AUC
#new data base for my purposes


glm.globalA <- glm(Trans.bac.A ~ hem.max + load.AUC  + ES.AUC  + visit.AUC + ant.max + tol.AUC + mass.AUC, na.action=na.fail,
                   data = summedAUC,
                   family = binomial)
summary(glm.globalA)
glm.globalAd <- dredge(glm.global4, trace =1)
glm.globalAd

glmA.hem <- glm(Trans.bac.A ~ hem.max, na.action=na.fail,
                       data = summedAUC,
                       family = binomial)
summary(glmA.hem)




####  birds becoming infected ####

#make the data set
nonindex <- trans.daily[trans.daily$IndexA=="0", ]
nonind.1<-nonindex[nonindex$TreatA=="1", ]
nonindbac.1Y<-nonindex[nonindex$Trans.bac=="Y", ]


####calculate area under the curve####
birds <- unique(nonindbac.1Y$Bird.ID)# make each ID its own 
summedr <- matrix(nrow=0,ncol=6) #creating a blank matrix, make it the same number of columns
nonindbac.1Y <- nonindbac.1Y %>% mutate(ant.max = max(ant, na.rm = TRUE))
View(nonindbac.1Y)
View(data)
names(data)
treat1.index<-subset(index, TreatA == 1)


for(i in 1:length(birds)){
  datar <- subset(nonindbac.1Y, Bird.ID == birds[i])
  try({
    datar$visit.AUC <- AUC(datar$day,datar$visitlog, method="spline", na.rm = TRUE)
    summedr <- rbind(summedr, datar)
  })}


colnames(summedr)

summedAUCr <- summedr[,c(1,5,6,7,8,9,10,11,12,13,14,33)]
View(summedAUCr)
summedAUCr$Bird.ID <- as.character(summedAUCr$Bird.ID)
summedAUCr <- summedAUCr %>% group_by(Bird.ID) %>% summarize_all(max, na.rm = TRUE)
colnames(summedAUCr)
View(summedAUCr)
day0 <- subset(nonindbac.1Y, day == 0)
colnames(day0)
day0 <- day0[,c(1,22,23,24,25)]
summedAUCr<-merge(day0, summedAUCr, by="Bird.ID")
View(summedAUCr)
colnames(summedAUCr)

summedAUCr.na<-na.omit(summedAUCr) 



glmer.global.rec <- glmer(Statusbac ~ visit.AUC  + hem   + mass + ant + (1|Flock.ID), na.action=na.fail,
                         data = summedAUCr.na,
                         family = binomial)
summary(glmer.global.rec)
cov2cor(vcov(glmer.global.rec))
glmer.globalr <- dredge(glmer.global.rec, trace =1)
glmer.globalr

glmer.recmassA <- glmer(Statusbac ~   mass + (1|Flock.ID), na.action=na.fail,
                          data = summedAUCr.na,
                          family = binomial)
summary(glmer.recmassA)


