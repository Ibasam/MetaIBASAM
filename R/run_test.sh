# ! /bin/sh
#$ -S /bin/sh

#REPbase=rep
#REPbase=~/Documents/IBASAM/CCvsFisheries
#vIBASAM=CC0_pecheSTAT

#mkdir -p $REPbase$vIBASAM
#cd $REPbase$vIBASAM

# IBASAM Version
#ver=version

# Parameters:
npop=4
#nSIMUL=nsim # Nb simulations
Init=5 # Nb years to initialized
Years=5 # Nb years simulated
rPROP=0.2 # proportion (popualtion size)

# Environmental conditions:
Temp=0 # Water Temperature (T° increase / Years; keep constant if 0)
Amp=1 # Flow amplitude (keep constant if 1)
Sea=1 # decreasing growth condition at sea (keep constant if 1)

# Fishing:
state=TRUE # TRUE If fishing applied
stage=TRUE # fishing on life stages (1SW/MSW) if TRUE, on Sizes ("small","med","big") otherwise
# Fishing rates:
# rate1=0.15
# rate2=0.15
# rate3=0.15

# 3 scenarios (iSIMUL) for STAT:
#grilse: 0.15 / MSW: 0.15 => "Control"
#grilse: 0.3 / MSW: 0 => "1SW"
#grilse: 0. / MSW: 0.3 => "MSW"

# 5 scenarios (iSIMUL) for TAILLE:
# small: 0.15 / med: 0.15 / big: 0.15 => "Control"
# small: 0.6 / med: 0 / big: 0 => "Small"
# small: 0 / med: 0.3 / big: 0 = "Med"
# small: 0 / med: 0 / big: 0.6 => "Big"
# small: 0.3 / med: 0 / big: 0.3 => "Big small"

# Create temporary folder (needed to put migrants files)
mkdir -p /tmp

for pop in $(seq 1 $npop)
do

cp scriptR.R tmp/scriptR_$pop.R
# sed 's|rPROP|'"$rPROP"'|g' -i scriptR_TMP.ssc

sed 's|init|'"$Init"'|g' -i tmp/scriptR_$pop.R
sed 's|years|'"$Years"'|' -i tmp/scriptR_$pop.R

sed 's|Npop|'"$npop"'|g' -i tmp/scriptR_$pop.R # Number of popualtions
sed 's|popo|'"$pop"'|' -i tmp/scriptR_$pop.R # Popualtion of origin
#sed 's|rPROP|'"$rPROP"'|' -i tmp/scriptR_$pop.R # Popualtion size (1/10 of production area)

sed 's|tempCC|'"$Temp"'|' -i tmp/scriptR_$pop.R
sed 's|ampCC|'"$Amp"'|' -i tmp/scriptR_$pop.R
sed 's|seaCC|'"$Sea"'|' -i tmp/scriptR_$pop.R

sed 's|fish.state|'"$state"'|' -i tmp/scriptR_$pop.R
sed 's|fish.stage|'"$stage"'|' -i tmp/scriptR_$pop.R

# Run analysis
R CMD BATCH --no-save --no-restore --slave tmp/scriptR_$pop.R tmp/scriptR_$pop.out &

# rm -f tmp/scriptR_$pop.out
# rm -f tmp/scriptR_$pop.R

done

