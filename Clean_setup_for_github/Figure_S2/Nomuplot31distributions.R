#library(FME)
library(optparse)
library(ggplot2)
#library(grid)
library(gridExtra)

#library(optparse)
parser<-OptionParser()

parser<-add_option(parser, c("-a", "--patient"), default="10",type="integer", help="Drug name [required]")

args<-parse_args(parser)
print(sessionInfo())
ids=args$patient
print(ids)
foldert="Step3_MCMC_lowJMP"
system(paste0("mkdir -p ",foldert))	

#-------------------------------------------------------------
#for (i in 1:30) {
#Lpk=189
nparm=7
totalpatient=24
Lpk=nparm*totalpatient
	allpar0<-read.csv(sprintf("/scratch/shilpa.chakravartula/Opioid/Naloxone PK/ClinicalManuscript_PK_Analysis/BHM/Iman_BHM_IN8mg/Step3_MCMC_lowJMP/results/parsfinal.csv"),header = TRUE)
	allpar=allpar0[,1:(nparm*totalpatient)]
#	ssss

	allpar_musd=allpar0[,(nparm*totalpatient+1):(nparm*totalpatient+nparm)]
	Kin=allpar[,seq(1,Lpk,nparm)]
	Kout=allpar[,seq(2,Lpk,nparm)]
	Ktr=allpar[,seq(3,Lpk,nparm)]
	V1=allpar[,seq(4,Lpk,nparm)]
	k12N=allpar[,seq(5,Lpk,nparm)]
	V2=allpar[,seq(6,Lpk,nparm)]
	F=allpar[,seq(7,Lpk,nparm)]
#	f1=allpar[,seq(8,Lpk,nparm)]
#	f2=allpar[,seq(9,Lpk,nparm)]
#	F=allpar[,seq(1,150,5)]
Kin1=Kout1=Ktr1=V1_1=k12N_1=V2_1=F_1=c() #=f1_1=f2_1=c()
for ( ii in 1:totalpatient) {
	Kin1=rbind(Kin1,cbind(Kin[,ii],ii))
	Kout1=rbind(Kout1,cbind(Kout[,ii],ii))
	Ktr1=rbind(Ktr1,cbind(Ktr[,ii],ii))
	V1_1=rbind(V1_1,cbind(V1[,ii],ii))
	k12N_1=rbind(k12N_1,cbind(k12N[,ii],ii))
	V2_1=rbind(V2_1,cbind(V2[,ii],ii))
	F_1=rbind(F_1,cbind(F[,ii],ii))
#	f1_1=rbind(f1_1,cbind(f1[,ii],ii))
#	f2_1=rbind(f2_1,cbind(f2[,ii],ii))
}
Kin1=data.frame(Kin1)
Kout1=data.frame(Kout1)
Ktr1=data.frame(Ktr1)
V1_1=data.frame(V1_1)
k12N_1=data.frame(k12N_1)
V2_1=data.frame(V2_1)
F_1=data.frame(F_1)
#f1_1=data.frame(f1_1)
#f2_1=data.frame(f2_1)

#------------average mu SD------------------
#optimal=c(
#		0.02728,
#		20.51,
#		0.004933,
#		86760,
#		33.32,
#		36070,
#		0.4015)
optimal=c(
		0.002151,
		25.98,
		0.01364,
		77160,
		74.63,
		74930,
		0.205)
#optimal=log(optimal)
optimalV=log(optimal)
mean_musd=colMeans(allpar_musd)
nnc=200000

Kin_musd=exp(rnorm(nnc,optimalV[1],mean_musd[1]))
Kout_musd=exp(rnorm(nnc,optimalV[2],mean_musd[2]))
Ktr_musd=exp(rnorm(nnc,optimalV[3],mean_musd[3]))
V1_musd=exp(rnorm(nnc,optimalV[4],mean_musd[4]))
k12N_musd=exp(rnorm(nnc,optimalV[5],mean_musd[5]))
V2_musd=exp(rnorm(nnc,optimalV[6],mean_musd[6]))
F_musd=exp(rnorm(nnc,optimalV[7],mean_musd[7]))
#f1_musd=exp(rnorm(nnc,optimalV[8],mean_musd[8]))
#f2_musd=exp(rnorm(nnc,optimalV[9],mean_musd[9]))

asdfs


F_musd[F_musd>0.9]=.9
all2000=cbind(Kin_musd,Kout_musd,Ktr_musd,V1_musd,k12N_musd,V2_musd,F_musd)
colnames(all2000)=c("Kin","Kout","Ktr","V1","k12N","V2","F")
write.csv(all2000,paste0(foldert,"/","all2000.csv"))

Kin_musd=data.frame(Kin_musd)
Kout_musd=data.frame(Kout_musd)
Ktr_musd=data.frame(Ktr_musd)
V1_musd=data.frame(V1_musd)
k12N_musd=data.frame(k12N_musd)
V2_musd=data.frame(V2_musd)
F_musd=data.frame(F_musd)
#f1_musd=data.frame(f1_musd)
#f2_musd=data.frame(f2_musd)


Kin1$ii=as.character(Kin1$ii)
Kout1$ii=as.character(Kout1$ii)
Ktr1$ii=as.character(Ktr1$ii)
V1_1$ii=as.character(V1_1$ii)
k12N_1$ii=as.character(k12N_1$ii)
V2_1$ii=as.character(V2_1$ii)
F_1$ii=as.character(F_1$ii)
#f1_1$ii=as.character(f1_1$ii)
#f2_1$ii=as.character(f2_1$ii)

print("ploting***")


#optimal=log(optimal)
optimal=data.frame(optimal)
#sssssssssss


#kin---------------------------------------------
scplot=1
p1<-ggplot()
s1=90*scplot
p1=p1+geom_density(data=Kin1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2))+theme_bw()+theme(legend.position = "none") +xlab("Kin")
p1=p1+geom_density(data=Kin_musd, aes(Kin_musd,y=..density..*s1),color="red",fill=NA,size=1.5)+theme(legend.position = "none") +xlab("Kin")+
scale_y_continuous(
		name = "Density of 24 patients",
		sec.axis = sec_axis(~./s1, name="Population Level Density")
)+geom_vline(xintercept = optimal$optimal[1], linetype="dashed", 
		color = "blue", size=.8)+
#geom_vline(xintercept = exp(mean_musd[1]), linetype="dashed", 
#		color = "red", size=.8)+
theme(axis.line.y.right = element_line(color = "red"),
		axis.text.y.right = element_text(color = "red"),
		axis.title.y.right = element_text(color = "red"))+xlim(0.00035,.009)
ggsave(paste0(foldert,"/","Kin.png"), p1, width=6, height=4)

p2<-ggplot()
s2=60*scplot
p2=p2+geom_density(data=Kout1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2))+theme_bw()+theme(legend.position = "none") +xlab("Kout")+xlim(0,max(Kout1$V1))
p2=p2+geom_density(data=Kout_musd, aes(Kout_musd,y=..density..*s2),color="red",fill=NA,size=1.5)+theme(legend.position = "none") +xlab("Kout")+
scale_y_continuous(
		name = "Density of 24 patients",
		sec.axis = sec_axis(~./s2, name="Population Level Density")
)+geom_vline(xintercept = optimal$optimal[2], linetype="dashed", 
		color = "blue", size=.8)+
#geom_vline(xintercept = exp(mean_musd[5]), linetype="dashed", 
#		color = "red", size=.8)+
theme(axis.line.y.right = element_line(color = "red"),
		axis.text.y.right = element_text(color = "red"),
		axis.title.y.right = element_text(color = "red"))+xlim(0,50)
ggsave(paste0(foldert,"/","Kout.png"), p2, width=6, height=4)

p3<-ggplot()
s3=80*scplot
p3=p3+geom_density(data=Ktr1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2))+theme_bw()+theme(legend.position = "none") +xlab("Ktr") 
#p=p+stat_function(fun = dnorm, n = 101, args = list(mean = 0, sd = 1))
p3=p3+geom_density(data=Ktr_musd, aes(Ktr_musd,y=..density..*s3),color="red",fill=NA,size=1.5)+theme(legend.position = "none")+
#xlab("Ktr")
scale_y_continuous(
		name = "Density of 24 patients",
		
		# Add a second axis and specify its features
		sec.axis = sec_axis(~./s3, name="Population Level Density")
)+geom_vline(xintercept = optimal$optimal[3], linetype="dashed", 
		color = "blue", size=.8)+
geom_vline(xintercept = exp(mean_musd[7]), linetype="dashed", 
		color = "red", size=.8)+
theme(axis.line.y.right = element_line(color = "red"),
		axis.text.y.right = element_text(color = "red"),
		axis.title.y.right = element_text(color = "red"))+xlim(0,0.02)
ggsave(paste0(foldert,"/","Ktr.png"), p3, width=6, height=4)


s4=60*scplot
#rer=V1_1[V1_1$V1=min(V1_1$V1),]
#for(kkk in seq(1,30,2)) {
	p4<-ggplot()
#V1_1e=V1_1[V1_1$ii==23 ,]
p4=p4+geom_density(data=V1_1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2),bins=100)+theme_bw()+theme(legend.position = "none") +xlab("V1")
p4=p4+geom_density(data=V1_musd, aes(V1_musd,y=..density..*s4),color="red",fill=NA,size=1.5)+theme(legend.position = "none") +
		xlab("V1")+
		scale_y_continuous(
				name = "Density of 24 patients",
				
				# Add a second axis and specify its features
				sec.axis = sec_axis(~./s4, name="Population Level Density")
		)+geom_vline(xintercept = optimal$optimal[4], linetype="dashed", 
				color = "blue", size=.8)+
#		geom_vline(xintercept = exp(mean_musd[9]), linetype="dashed", 
#				color = "red", size=.8)+
		theme(axis.line.y.right = element_line(color = "red"),
				axis.text.y.right = element_text(color = "red"),
				axis.title.y.right = element_text(color = "red"))+xlim(0,160000)
ggsave(paste0(foldert,"/","V1.png"), p4, width=6, height=4)



s5=4*scplot
p5<-ggplot()
#V1_1e=V1_1[V1_1$ii==23 ,]
p5=p5+geom_density(data=k12N_1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2),bins=100)+theme_bw()+theme(legend.position = "none")
p5=p5+geom_density(data=k12N_musd, aes(k12N_musd,y=..density..*s4),color="red",fill=NA,size=1.5)+theme(legend.position = "none") +
		xlab("k12N")+
		scale_y_continuous(
				name = "Density of 24 patients",
				
				# Add a second axis and specify its features
				sec.axis = sec_axis(~./s5, name="Population Level Density")
		)+geom_vline(xintercept = optimal$optimal[5], linetype="dashed", 
				color = "blue", size=.8)+
#		geom_vline(xintercept = exp(mean_musd[9]), linetype="dashed", 
#				color = "red", size=.8)+
		theme(axis.line.y.right = element_line(color = "red"),
				axis.text.y.right = element_text(color = "red"),
				axis.title.y.right = element_text(color = "red"))+xlim(5,110)
ggsave(paste0(foldert,"/","k12N.png"), p5, width=6, height=4)
s6=20*scplot
p6<-ggplot()
#V1_1e=V1_1[V1_1$ii==23 ,]
p6=p6+geom_density(data=V2_1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2),bins=100)+theme_bw()+theme(legend.position = "none")
p6=p6+geom_density(data=V2_musd, aes(V2_musd,y=..density..*s6),color="red",fill=NA,size=1.5)+theme(legend.position = "none") +
		xlab("V2")+
		scale_y_continuous(
				name = "Density of 24 patients",
				
				# Add a second axis and specify its features
				sec.axis = sec_axis(~./s6, name="Population Level Density")
		)+geom_vline(xintercept = optimal$optimal[6], linetype="dashed", 
				color = "blue", size=.8)+
#		geom_vline(xintercept = exp(mean_musd[9]), linetype="dashed", 
#				color = "red", size=.8)+
		theme(axis.line.y.right = element_line(color = "red"),
				axis.text.y.right = element_text(color = "red"),
				axis.title.y.right = element_text(color = "red"))+xlim(0,160000)
ggsave(paste0(foldert,"/","V2.png"), p6, width=6, height=4)
s7=60*scplot
p7<-ggplot()
#V1_1e=V1_1[V1_1$ii==23 ,]
p7=p7+geom_density(data=F_1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2),bins=100)+theme_bw()+theme(legend.position = "none") 
p7=p7+geom_density(data=F_musd, aes(F_musd,y=..density..*s7),color="red",fill=NA,size=1.5)+theme(legend.position = "none") +
		xlab("F")+
		scale_y_continuous(
				name = "Density of 24 patients",
				
				# Add a second axis and specify its features
				sec.axis = sec_axis(~./s7, name="Population Level Density")
		)+geom_vline(xintercept = optimal$optimal[7], linetype="dashed", 
				color = "blue", size=.8)+
#		geom_vline(xintercept = exp(mean_musd[9]), linetype="dashed", 
#				color = "red", size=.8)+
		theme(axis.line.y.right = element_line(color = "red"),
				axis.text.y.right = element_text(color = "red"),
				axis.title.y.right = element_text(color = "red"))+xlim(0,1)
ggsave(paste0(foldert,"/","F.png"), p7, width=6, height=4)

#s8=10
#p8<-ggplot()
##V1_1e=V1_1[V1_1$ii==23 ,]
#p8=p8+geom_density(data=f1_1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2),bins=100)+theme_bw()+theme(legend.position = "none") +xlab("V1")
#p8=p8+geom_density(data=f1_musd, aes(f1_musd,y=..density..*s2),color="red",fill=NA,size=1.5)+theme(legend.position = "none") +
#		xlab("f1")+
#		scale_y_continuous(
#				name = "Density of 24 patients",
#				
#				# Add a second axis and specify its features
#				sec.axis = sec_axis(~./s2, name="Population Level Density")
#		)+geom_vline(xintercept = optimal$optimal[8], linetype="dashed", 
#				color = "blue", size=.8)+
##		geom_vline(xintercept = exp(mean_musd[9]), linetype="dashed", 
##				color = "red", size=.8)+
#		theme(axis.line.y.right = element_line(color = "red"),
#				axis.text.y.right = element_text(color = "red"),
#				axis.title.y.right = element_text(color = "red"))+xlim(0,.5)
#ggsave(paste0(foldert,"/","f1.png"), p8, width=6, height=4)
#
#s9=30
#p9<-ggplot()
##V1_1e=V1_1[V1_1$ii==23 ,]
#p9=p9+geom_density(data=f2_1, aes(V1,group=ii,fill=ii,y=..density..,alpha=.2),bins=100)+theme_bw()+theme(legend.position = "none") +xlab("V1")
#p9=p9+geom_density(data=f2_musd, aes(f2_musd,y=..density..*s9),color="red",fill=NA,size=1.5)+theme(legend.position = "none") +
#		xlab("f2")+
#		scale_y_continuous(
#				name = "Density of 24 patients",
#				
#				# Add a second axis and specify its features
#				sec.axis = sec_axis(~./s9, name="Population Level Density")
#		)+geom_vline(xintercept = optimal$optimal[9], linetype="dashed", 
#				color = "blue", size=.8)+
##		geom_vline(xintercept = exp(mean_musd[9]), linetype="dashed", 
##				color = "red", size=.8)+
#		theme(axis.line.y.right = element_line(color = "red"),
#				axis.text.y.right = element_text(color = "red"),
#				axis.title.y.right = element_text(color = "red"))+xlim(0,.5)
#ggsave(paste0(foldert,"/","f2.png"), p9, width=6, height=4)

plotlist1=list()

plotlist1[[1]] = p1
plotlist1[[2]] = p2
plotlist1[[3]] = p3
plotlist1[[4]] = p4
plotlist1[[5]] = p5
plotlist1[[6]] = p6
plotlist1[[7]] = p7
#plotlist1[[8]] = p8
#plotlist1[[9]] = p9
pall1 <- grid.arrange(grobs=plotlist1,ncol=3)
ggsave(paste0(foldert,"/","all.png"), pall1, width=16, height=6)



pp1=density(Kin_musd$Kin_musd) 
pp2=density(Kout_musd$Kout_musd)
pp3=density(Ktr_musd$Ktr_musd)
pp4=density(V1_musd$V1_musd)
pp5=density(k12N_musd$k12N_musd)
pp6=density(V2_musd$V2_musd) 
pp7=density(F_musd$F_musd)
#pp8=density(f1_musd$f1_musd)
#pp9=density(f2_musd$f2_musd)

#mean=mean(F_musd$F_musd)
#mean1=mean(Kin_musd$Kin_musd)
#mean2=mean(Kout_musd$Kout_musd)
#mean3=mean(Ktr_musd$Ktr_musd)
#mean4=mean(V1_musd$V1_musd)
#mean1=mean(V1_musd$V1_musd) 
#mean2=mean(F_musd$F_musd)
#mean3=mean(Kin_musd$Kin_musd)
#mean4=mean(Kout_musd$Kout_musd)
#mean5=mean(Ktr_musd$Ktr_musd)
#mean6=mean(K12_musd$K12_musd) 
#mean7=mean(K21_musd$K21_musd)
#mean8=mean(V2_musd$V2_musd)

mean_musd=exp(mean_musd)
pdf(sprintf('%s/rplotloh3.pdf',foldert))

plot(pp1)
abline(v=optimal$optimal[1],col="blue")
#abline(v=mean_musd[1],col="red")

plot(pp2)
abline(v=optimal$optimal[2],col="blue")
#abline(v=mean_musd[3],col="red")

plot(pp3)
abline(v=optimal$optimal[3],col="blue")
#abline(v=mean_musd[5],col="red")

plot(pp4)
abline(v=optimal$optimal[4],col="blue")
#abline(v=mean_musd[7],col="red")

plot(pp5)
abline(v=optimal$optimal[5],col="blue")
#abline(v=mean_musd[9],col="red")

plot(pp6)
abline(v=optimal$optimal[6],col="blue")

plot(pp7)
abline(v=optimal$optimal[7],col="blue")

#plot(pp8)
#abline(v=optimal$optimal[8],col="blue")
#
#plot(pp9)
#abline(v=optimal$optimal[9],col="blue")
dev.off()



