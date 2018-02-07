# ! /bin/sh
#$ -S /bin/sh

REPbase=rep
#REPbase=~/Documents/IBASAM/CCvsFisheries
vIBASAM=CC0_pecheSTAT

#mkdir -p $REPbase$vIBASAM
cd $REPbase$vIBASAM

# IBASAM Version
#ver=version

# Parameters:
nSIMUL=nsim # Nb simulations
Init=ninit # Nb years to initialized
Years=nyears # Nb years simulated
rPROP=nsize # proportion (popualtion size)

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

for iSIMUL in "0" "1" "2"
do

cp scriptR.R scriptR_$iSIMUL.R
# sed 's|rPROP|'"$rPROP"'|g' -i scriptR_TMP.ssc
# sed 's|REPbase|'"$REPbase"'|' -i scriptR_TMP.ssc
# sed 's|iSIMUL|'"$iSIMUL"'|' -i scriptR_TMP.ssc
# sed 's|nSIMUL|'"$nSIMUL"'|' -i scriptR_TMP.ssc
# sed 's|nTEMPS|'"$nTEMPS"'|' -i scriptR_TMP.ssc
# sed 's|vIBASAM|'"$vIBASAM"'|g' -i scriptR_TMP.ssc

#sed 's|ver|'"$ver"'|' -i scriptR_iSIMUL.R
sed 's|REPbase|'"$REPbase"'|' -i scriptR_$iSIMUL.R
sed 's|vIBASAM|'"$vIBASAM"'|g' -i scriptR_$iSIMUL.R
#sed 's|scenario|'"$scenario"'|' -i scriptR_iSIMUL.R

sed 's|iSIMUL|'"$iSIMUL"'|' -i scriptR_$iSIMUL.R
sed 's|nSIMUL|'"$nSIMUL"'|' -i scriptR_$iSIMUL.R
sed 's|init|'"$Init"'|g' -i scriptR_$iSIMUL.R
sed 's|years|'"$Years"'|' -i scriptR_$iSIMUL.R

sed 's|tempCC|'"$Temp"'|' -i scriptR_$iSIMUL.R
sed 's|ampCC|'"$Amp"'|' -i scriptR_$iSIMUL.R
sed 's|seaCC|'"$Sea"'|' -i scriptR_$iSIMUL.R

sed 's|fish.state|'"$state"'|' -i scriptR_$iSIMUL.R
sed 's|fish.stage|'"$stage"'|' -i scriptR_$iSIMUL.R

# Fishing rates:
if [ $iSIMUL = 0 ]
then
rate1=0.15;
rate2=0.15;
rate3=0;
fi

if [ $iSIMUL = 1 ]
then
rate1=0.3;
rate2=0;
rate3=0;
fi

if [ $iSIMUL = 2 ]
then
rate1=0;
rate2=0.3;
rate3=0;
fi

sed 's|rate1|'"$rate1"'|' -i scriptR_$iSIMUL.R
sed 's|rate2|'"$rate2"'|' -i scriptR_$iSIMUL.R
sed 's|rate3|'"$rate3"'|' -i scriptR_$iSIMUL.R

# R CMD BATCH --no-save --no-restore scriptR_$iSIMUL.R
# 
# rm -f demoIbasam"$iSIMUL"_TMP.R
# rm -f scriptR_$iSIMUL.R
# rm -f scriptR_$iSIMUL.Rout

#scp RESsimul* jp@147.100.14.190:$REPsimul/$vIBASAM/.
#rm -f RESsimul*

done

