MetaIBASAM:  A demo-genetic agent-based model to simulate spatially structured salmon populations

MetaIbasam is an extension of the existing IBASAM model (https://github.com/Ibasam/IBASAM/wiki) by incorporating a dispersal process to describe Atlantic salmon metapopulation and its eco-evolutionary dynamics. MetaIBASAM allows an investigation of the consequences of dispersal on local populations and network dynamics at the demographic, phenotypic, and genotypic levels. More generally, it allows to explore eco-evolutionary dynamics by taking into account complex interactions between ecological and evolutionary processes (plasticity, genetic adaptation and dispersal), feedbacks (e.g. genetic <-> demography) and trade-offs (e.g. growth vs survival). By doing so, one can investigate responses to changing environments and alternative management strategies.


# NEWS

- v0.0.6
- [ ] bug fixation observe_redds
- [ ] waterflow now at natural scale

- v0.0.5
- [ ] add observe_redds

- v0.0.4
- [ ] add CollectID in observe_redds() (/!\ CollecID = 0 for non migrants)

- v0.0.3
- [ ] CollectID : number of the population of origin
- [ ] Indivivual ID: the last digits correspond to the population number (to avoid duplicates when a migrant individual arrives in a population. Note that, the ID of immigrants is not kept. Only the CollecID and the last digits (CollecID).

- v0.0.2
- [ ] add a pause function to wait for migrants files from all populations

- v0.0.1
- [ ] add the dispersal process


# COLLABORATORS
Mathieu Buoro (INRAE, UMR ECOBIOP)
Cyril Piou (CIRAD, Montpellier)
Etienne Prevost (INRAE, UMR ECOBIOP)
Amaïa Lamarins (INRAE, UMR ECOBIOP)

# STRUCTURE  

- master/ : contains source files and R functions of the package  

# Acknowledgement
This project is funded by OFB (French Office for Biodiversity) and INRAE via the OFB-INRAE-Institut Agro-UPPA cluster for the management of migrating fish in their environment.


Contact: mathieu.buoro@inrae.fr
