
pdf(file = "outputs/Dispersal_kernels.pdf", width = 10, height = 10)
par(mfrow=c(3,2))


## Exponential-power
exp.pow = function(x,a) {(1/(2*pi*a^2*gamma(2/b)))*exp(-(x/a)^b)}
# x <- seq(from=0, to=300, by=1)
# alpha=1
# plot(x, exp.pow(x,alpha,0.5), ylim=c(0,.05), type="l", main="Probability Function",
#      ylab="density", col="red")
# lines(x, exp.pow(x,alpha,1), type="l", col="green")
# lines(x, exp.pow(x,10,.3), type="l", col="blue")
# #lines(x, exp.pow(x,.5,1), type="l", col="yellow")
# legend(1.5, 0.9, expression(paste(alpha==1, ", ", beta==0.5),
#                             paste(alpha==1, ", ", beta==1),
#                             paste(alpha==1, ", ", beta==2)),
#        lty=c(1,1,1), col=c("red","green","blue"),bty="n")



x <- seq(from=0, to=300, length=15)
a<-exp.pow(x,10,.3)
p = (a/sum(a))
plot(x, p, ylim=c(0,.4), type="l", main="Exponential-power Function", ylab="Probability", col="red")
lines(x, p*(1-.95), type='l',col="green")
lines(x, p*(1-.8), type='l',col="blue")
abline(v=50,lty=2)
legend("topright", expression(paste(homing==0),
                              paste(homing==.95),
                              paste(homing==.8)),
       lty=c(1,1,1), col=c("red","green","blue"),bty="n")
text(100,.2, labels = paste0("Prop disp < 50km = ",round(sum(p[x<50]),2)))
text(200,.2, labels = paste0("Prop disp > 200km = ",round(sum(p[x>200]),2)))



## Exponential-power
exp.pow = function(x,a,b) {(b/(2*pi*a^2*gamma(2/b)))*exp(-(x/a)^b)}
# x <- seq(from=0, to=300, by=1)
# alpha=1
# plot(x, exp.pow(x,alpha,0.5), ylim=c(0,.05), type="l", main="Probability Function",
#      ylab="density", col="red")
# lines(x, exp.pow(x,alpha,1), type="l", col="green")
# lines(x, exp.pow(x,10,.3), type="l", col="blue")
# #lines(x, exp.pow(x,.5,1), type="l", col="yellow")
# legend(1.5, 0.9, expression(paste(alpha==1, ", ", beta==0.5),
#                             paste(alpha==1, ", ", beta==1),
#                             paste(alpha==1, ", ", beta==2)),
#        lty=c(1,1,1), col=c("red","green","blue"),bty="n")



x <- seq(from=0, to=300, length=15)
a<-exp.pow(x,10,.3)
p = (a/sum(a))
plot(x, p, ylim=c(0,.4), type="l", main="Exponential-power Function", ylab="Probability", col="red")
lines(x, p*(1-.95), type='l',col="green")
lines(x, p*(1-.8), type='l',col="blue")
abline(v=50,lty=2)
legend("topright", expression(paste(homing==0),
                            paste(homing==.95),
                            paste(homing==.8)),
       lty=c(1,1,1), col=c("red","green","blue"),bty="n")
text(100,.2, labels = paste0("Prop disp < 50km = ",round(sum(p[x<50]),2)))
text(200,.2, labels = paste0("Prop disp > 200km = ",round(sum(p[x>200]),2)))



## Logistic
logistic = function(x,a,b) {(b/(2*pi*a^2*gamma(2/b)*gamma(1-(2/b))))*((1+(x/a)^b)^(-1))}
# x <- seq(from=0, to=300, by=1)
# plot(x, logistic(x,1,2.5), ylim=c(0,1), type="l", main="Probability Function",
#      ylab="density", col="red")
# lines(x, logistic(x,1,5), type="l", col="green")
# lines(x, logistic(x,1,10), type="l", col="blue")
# legend(1.5, 0.9, expression(paste(alpha==1, ", ", beta==0.1),
#                             paste(alpha==1, ", ", beta==2),
#                             paste(alpha==1, ", ", beta==5)),
#        lty=c(1,1,1), col=c("red","green","blue"),bty="n")


x <- seq(from=0, to=300, length=15)
a<-logistic(x,40,3.5)
p = (a/sum(a))
plot(x, p, ylim=c(0,.4), type="l", main="Logistic Function",ylab="Probability", col="red")
lines(x, p*(1-.95), type='l',col="green")
lines(x, p*(1-.8), type='l',col="blue")
abline(v=50,lty=2)
legend("topright", expression(paste(homing==0),
                              paste(homing==.95),
                              paste(homing==.8)),
       lty=c(1,1,1), col=c("red","green","blue"),bty="n")
text(100,.2, labels = paste0("Prop disp < 50km = ",round(sum(p[x<50]),2)))
text(200,.2, labels = paste0("Prop disp > 200km = ",round(sum(p[x>200]),2)))





## Laplace
laplace = function(x,mu,beta) {(1/2*beta)*exp(-(x-mu)/beta)}
#laplace = function(x,mu,sigma) {exp(-(x-mu)/sigma)}
#gaussianMixture = function(x,p,a1,a2) {p*(1/(2*pi*a1^2))*exp(-(x/a1)^2) + (1-p)*(1/(2*pi*a2^2))*exp(-(x/a2)^2)}
#laplaceMixture = function(x,p,lambda1,lambda2) {p*(lambda1/2)*exp(-lambda1*x) + (1-p)*(lambda2/2)*exp(-lambda2*x)}
# x <- seq(from=0, to=300, by=1)
# #p=1
# plot(x, laplace(x,0,10), ylim=c(0,2), type="l", main="Probability Function",
#      ylab="density", col="red")
# lines(x, laplace(x,0,2), type="l", col="green")
# lines(x, laplace(x,0,1), type="l", col="blue")
# legend(1.5, 0.9, expression(paste(alpha==1, ", ", beta==0.1),
#                             paste(alpha==1, ", ", beta==2),
#                             paste(alpha==1, ", ", beta==5)),
#        lty=c(1,1,1), col=c("red","green","blue"),bty="n")

x <- seq(from=0, to=300, length=15)
beta=70
a<-laplace(x,0,beta)
sqrt(2)*beta
p = (a/sum(a))
plot(x, p, ylim=c(0,.4), type="l", main="Laplace Function", ylab="Probability", col="red")
lines(x, p*(1-.95), type='l',col="green")
lines(x, p*(1-.8), type='l',col="blue")
abline(v=50,lty=2)
legend("topright", expression(paste(homing==0),
                              paste(homing==.95),
                              paste(homing==.8)),
       lty=c(1,1,1), col=c("red","green","blue"),bty="n")
text(100,.2, labels = paste0("Prop disp < 50km = ",round(sum(p[x<50]),2)))
text(200,.2, labels = paste0("Prop disp > 200km = ",round(sum(p[x>200]),2)))







## Student
student = function(x,sigma) {(1/(2*pi*sigma^2)) *exp(-((x^2)/(2*(sigma^2))))}
# x <- seq(from=0, to=10, by=.1)
# p=1
# plot(x, student(x,1), ylim=c(0,1), type="l", main="Probability Function",
#      ylab="density", col="red")
# lines(x, student(x,.1), type="l", col="green")
# lines(x, student(x,10), type="l", col="blue")
# legend(1.5, 0.9, expression(paste(sigma==1),
#                             paste(sigma==.1),
#                             paste(sigma==.5)),
#        lty=c(1,1,1), col=c("red","green","blue"),bty="n")

x <- seq(from=0, to=300, length=15)
a<-student(x,50)
p = (a/sum(a))
plot(x, p, ylim=c(0,.4), type="l", main="Student Function", ylab="Probability", col="red")
lines(x, p*(1-.95), type='l',col="green")
lines(x, p*(1-.8), type='l',col="blue")
abline(v=50,lty=2)
legend("topright", expression(paste(homing==0),
                              paste(homing==.95),
                              paste(homing==.8)),
       lty=c(1,1,1), col=c("red","green","blue"),bty="n")
text(100,.2, labels = paste0("Prop disp < 50km = ",round(sum(p[x<50]),2)))
text(200,.2, labels = paste0("Prop disp > 200km = ",round(sum(p[x>200]),2)))




### Student kernel
# d > .5 for student ditri with 2*d-1 ddf
student = function(x,sigma, d) {(1+(x/sigma)^2)^-d}
#twoDt = function(x,alpha,beta) {((beta-1)/(pi*alpha^2)) * (1+(x/alpha)^2)^(-beta)}
# x <- seq(from=0, to=10, by=.1)
# plot(x, student(x,1,1), ylim=c(0,1), type="l", main="Probability Function",
#      ylab="density", col="red")
# lines(x, student(x,1,2), type="l", col="green")
# lines(x, student(x,1,10), type="l", col="blue")


x <- seq(from=0, to=300, length=15)
a<-student(x,20,.5)
p = (a/sum(a))
plot(x, p, ylim=c(0,.4), type="l", main="Student Function", ylab="Probability", col="red")
lines(x, p*(1-.95), type='l',col="green")
lines(x, p*(1-.8), type='l',col="blue")
abline(v=50,lty=2)
legend("topright", expression(paste(homing==0),
                              paste(homing==.95),
                              paste(homing==.8)),
       lty=c(1,1,1), col=c("red","green","blue"),bty="n")
text(100,.2, labels = paste0("Prop disp < 50km = ",round(sum(p[x<50]),2)))
text(200,.2, labels = paste0("Prop disp > 200km = ",round(sum(p[x>200]),2)))




twoDt = function(x,alpha,beta) {((beta-1)/(pi*alpha^2)) * (1+(x/alpha)^2)^(-beta)}
# x <- seq(from=0, to=10, by=.1)
# plot(x, twoDt(x,1,2), ylim=c(0,1), type="l", main="Probability Function",
#      ylab="density", col="red")
# lines(x, twoDt(x,2,2), type="l", col="green")
# lines(x, twoDt(x,1,.3), type="l", col="blue")
# legend(1.5, 0.9, expression(paste(alpha==1, ", ", beta==2),
#                             paste(alpha==2, ", ", beta==2),
#                             paste(alpha==.5, ", ", beta==1)),
#        lty=c(1,1,1), col=c("red","green","blue"),bty="n")


x <- seq(from=0, to=300, length=15)
a<-twoDt(x,1,.3)
p = (a/sum(a))
plot(x, p, ylim=c(0,.4), type="l", main="twoDt Function", ylab="Probability", col="red")
lines(x, p*(1-.95), type='l',col="green")
lines(x, p*(1-.8), type='l',col="blue")
abline(v=50,lty=2)
legend("topright", expression(paste(homing==0),
                              paste(homing==.95),
                              paste(homing==.8)),
       lty=c(1,1,1), col=c("red","green","blue"),bty="n")
text(100,.2, labels = paste0("Prop disp < 50km = ",round(sum(p[x<50]),2)))
text(200,.2, labels = paste0("Prop disp > 200km = ",round(sum(p[x>200]),2)))

dev.off()





