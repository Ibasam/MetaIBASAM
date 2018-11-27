MetaIBASAM: Adaptation des stratégies de gestion face au changement climatique :  influence des flux migratoires entre populations

Ce projet consiste à évaluer  des stratégies de gestion en tenant compte des interconnections entre populations exploitées (via des flux migratoires) et des effets synergiques de changements environnementaux, pêches sélectives (temporelles vs spatiales) sur la dynamique des populations.


# NEWS
- v0.04
- [ ] add CollectID in observe_redds() (/!\ CollecID = 0 for non migrants)

- v0.03
CollectID : numero de la popualtion d'origine
ID: les derniers chiffres correspondent au numéro de popualtion (pour éviter les doublons lorsque un individu migrant arrive dans une population)
/!\ L'ID des immigrants n'est pas conservé. Seul le CollecID et les derniers chiffres (CollecID).


# COLLABORATORS
Mathieu Buoro (INRA, ECOBIOP)
Cyril Piou (CIRAD, Montpellier)
Etienne Prevost (INRA, UMR ECOBIOP)

# STRUCTURE  

- master/ : contains files and functions of the package  
- myProjects/: contains scripts to run metaIBASAM  
  -> tmp/ : contains the temporary files (migrants files, results,...)  
  -> run.sh: bash script to run metaIBASAM with multiple populations (each populations running on different processes)  
- cleaning.sh: bash script to clean temporary files (into R/ and tmp/ folders)  

# Acknowledgement
This project is funded by AFB (French Agency for Biodiversity) and INRA.


Contact: mathieu.buoro@inra.fr
