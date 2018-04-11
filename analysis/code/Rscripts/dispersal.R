## FUNCTIONS
invlogit<-function(x) {1/(1+exp(-(x)))}
logit<-function(x) {log(x/(1-x))}

n.sites =10
area=runif(n.sites,0,10)
alpha=c(-1.4,-2, -.1)
p.homing = .8
lpsi=w=PSI=matrix(NA, ncol = n.sites, nrow = n.sites);SUM=NULL

#-------- MOVEMENT ------#
#        Two sets of constraints must be imposed on estimates of movement probabilities: 
#       (1) each of them must be in the interval [0, 1] 
#       (2) they must sum to 1.
#       there are two possible solutions: 
#       (1) Dirichlet distribution:
#       for (j in 1:n.sites){
#         PSI[j,1:n.sites]~ddirch(a[1:n.sites]) # Dirichelt prior
#         a[j]<-1 # uninformative prior
#       } # end loop j

#       (2) multinomial logit link function          
# for (j in 1:n.sites){
#   for (k in 1:n.sites) { 
#     #epsi[j,k] <- exp(psi[j,k])
#     PSI[j,k]  <- psi[j,k] / sum(psi[j,])   # constrain the transition such that their sum < 1 :   
#   } # end loop k
#   log(psi[j,1])<-0 #Reference category, set to zero
#   for (k in 2:n.sites) { log(psi[j,k]) <- kappa[1] + kappa[2] * abs(j-k)}    
# } # end loop j 


for (j in 1:n.sites){
  for (k in 1:n.sites) { w[j,k] <- alpha[1] + alpha[2] * abs(j-k)} 
  w[j,j]<- 0  #Reference category, set to zero
  w[j,j]<- sum(w[j,])/(1-p.homing)  #Reference category, set to zero
  for (k in 1:n.sites) { 
    PSI[j,k]  <- w[j,k] / sum(w[j,])   # constrain the transition such that their sum < 1 :   
  } # end loop k
} # end loop j 

rowSums(PSI)
plot(1:n.sites,PSI[,1],type='l',ylim=c(0,1))
for (i in 2:n.sites){lines(1:n.sites, PSI[i,],type='l',col=i) }

##------------------- PROBABILTIES OF MOVEMENT -------------------##

## MODEL NULL = NO MOVEMENT
# PSI=matrix(0, ncol = n.sites, nrow = n.sites)
# diag(PSI)<-1


## MODEL 1 = MOVEMENT CONSTANT OVER TIME / DEPENDENT OF DISTANCE BETWEEN SITES abs(j-k)

for (j in 1:n.sites){
  for (k in 1:n.sites) { 
    w[j,k] <- alpha[1] + alpha[2]*abs(j-k) + alpha[3]*(area[k]/area[j])  # Movement is
    w[j,k] <- exp(w[j,k]) # end loop k
  }
  #psi[j,j]<-0.8

  for (k in 1:n.sites) {
    PSI[j,k]  <- w[j,k] / sum(w[j,])   # constrain the transition such thqt their sum < 1 :
} # end loop k
} # end loop j

plot(1:n.sites,PSI[,1],type='l',ylim=c(0,1))
for (i in 2:n.sites){lines(1:n.sites, PSI[i,],type='l',col=i) }

