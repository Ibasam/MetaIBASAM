

##### 1. Aire production #####
# vecteur Aire estimée en 2015 dans cet ordre, unité m²
# Couesnon, Leff, Trieux, Jaudy, Leguer, Yar, Douron, Penze, Elorn, Aulne, Goyen, Odet, Aven, Laïta, Scorff, Blavet
aireScript=c(110794, 72305, 213733, 47561, 197283, 37104, 95451, 106753,  164699, 252659, 53603, 249049, 142686, 669028, 229027, 393985)
aireScript=c(aireScript[pop], rep(aireScript[pop]/(npop-1), npop-1))

##### 2. Stock-recrutement #####
# vecteur Rmax dans le même ordre, on prend les estimations médianes, unité nbr tacons0+/100m²
RmaxScript=c(12.41, 27.32, 16.28, 31.95, 25.30, 15.94, 25.98, 40.51, 29.17, 4.319, 36.23, 31.48, 20.26, 23.51, 15.13, 14.62)
RmaxScript=rep(RmaxScript[pop], npop)

# vecteur alpha dans le même ordre, on prend les estimations médianes
alphaScript=c(0.03140, 0.06913, 0.04119, 0.08084, 0.06401, 0.04034, 0.06575, 0.1025, 0.07381, 0.01093, 0.09168, 0.07965, 0.05126, 0.05949, 0.03828, 0.03698)
alphaScript=rep(alphaScript[pop], npop)

# choix de travailler avec les facteurs multiplicatifs par rapport au Scorff
M=c(0.82032, 1.8058, 1.0760, 2.1118, 1.6723, 1.0537, 1.7174, 2.6776, 1.9280, 0.28545, 2.3948, 2.0805, 1.3391, 1.5540, 1.0000, 0.96606)
M=rep(M[pop], npop)


##### 3. Matrice de connectivite #####
if (npop < 2){
  pstrayScript = matrix(1,npop,npop)
} else {
  # première matrice h=1, deuxième matrice h=0.942, troisième matrice h=0.80
  #load("data/Matrices_Laplace_AireLog.RData")
  #pstrayScript=connect[[scenarioConnect]]
  #pstrayScript = matrix(0.5,npop,npop)
  
  pstrayScript = matrix(0,npop,npop)
  pstrayScript[1,1]=1
  pstrayScript[2:npop,2:npop]=.5
}

# vérification sous R : si on crée un vecteur et qu'on dit dans une fonction d'aller
# chercher une valeur de ce vecteur, cela fonctionne
# dans chaque scriptR_pop, on a aireScript[pop] avec le numéro de la pop
# pour chaque lancement de ces scripts, R va chercher la pop-ième valeur du vecteur aireScript
# idem pour Rmax, alpha et pstray
# Si on fait partir 16 pop mais qu'on a pas 16 lignes dans pstray, il dit qu'il y a un problème 


##### 4. Changement climatique #####
# scenario 1 c'est absence de CC (temp=0, amp=1, sea=1)
# scenario 2 c'est présence de CC (temp=3, amp=1.25, sea=0.75)
# liste des scénarii de CC testé, ordre tempCC/ampCC/seaCC
env=list(c(0,1,1), c(3,1.25,0.75))
# je récupère le scenario dans la liste puis je vais chercher chaque paramètre
tempCC=env[[scenarioEnvi]][1]
ampCC=env[[scenarioEnvi]][2]
seaCC=env[[scenarioEnvi]][3]

