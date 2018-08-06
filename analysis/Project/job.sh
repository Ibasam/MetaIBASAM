#!/bin/bash

#DIR="results/" # directory where to save results
#cd $DIR

nSIMUL=2 # Nb simulations 100

# SIMULATION
echo "BEGINNING OF SIMULATIONS"
echo "PID du processus courant : $$"

for s in $(seq 1 $nSIMUL)
do

STARTTIME=$(date +%s);

Rscript --vanilla metaIbasam.R $s > out.txt

ENDTIME=$(date +%s);
MINUTES=$(( ($ENDTIME - $STARTTIME) / 60 ));

echo "Simulation $s successful! Duration: $MINUTES minutes" 
done # end loop 

echo "END OF SIMULATIONS"
