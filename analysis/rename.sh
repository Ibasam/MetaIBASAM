#!/bin/bash
npop=16 # nbr populations
nSIMUL=30 # nbr simulations

DIR="RES3.2"
mkdir $DIR # create folder to store results

for s in $(seq 1 $nSIMUL)
do
echo "Simul $s of $nSIMUL"
var=Simu$s  # create simul folder

for pop in $(seq 1 $npop)
do
cp $var/results/RES_Pop-$pop.RData $DIR/RES_Pop-$pop.RData # copy files to new folder
mv $DIR/RES_Pop-$pop.RData $DIR/RES_Pop-"$pop"_Simu-"$s".RData # rename files
done
done
