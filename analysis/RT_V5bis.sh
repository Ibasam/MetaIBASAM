
# ! /bin/sh
#$ -S /bin/sh

# Parameters:
npop=16
nSIMUL=100 # Nb simulations 100
Init=15 # Nb years to initialized 15
Years=50 # Nb years simulated 50
rPROP_RT=0.2 # proportion (population size) 20% de l'aire

# Connectivity conditions:
scenarioConnectRT=3 #scenario 1 pour h=1.00, scenario 2 pour h=0.942, scenario 3 pour h=0.80

# Environmental conditions:
scenarioEnviRT=1 #scenario 1 pour absence de CC, scenario 2 pour CC

# Crée mon dossier pour stocker les résultats de ce scénario
scenario=Scenario"$scenarioConnectRT"_"$scenarioEnviRT"
mkdir -p $scenario
cp scriptR_V5bis.R $scenario
cp demoIbasam_V3bis.R $scenario
cp Matrices_Laplace_AireLog.RData $scenario
cd $scenario


# Create temporary folder (needed to put migrants files)
mkdir results
mkdir tmp
cd tmp
for s in $(seq 1 $nSIMUL)
do
mkdir Simu$s 
done

cd ..

for pop in $(seq 1 $npop)
do

cp scriptR_V5bis.R tmp/scriptR_$pop.R

sed 's|nSimu|'"$nSIMUL"'|g' -i tmp/scriptR_$pop.R

sed 's|init|'"$Init"'|g' -i tmp/scriptR_$pop.R
sed 's|years|'"$Years"'|' -i tmp/scriptR_$pop.R

sed 's|Npop|'"$npop"'|g' -i tmp/scriptR_$pop.R # Number of populations
sed 's|popo|'"$pop"'|' -i tmp/scriptR_$pop.R # Population of origin
sed 's|rPROPScript|'"$rPROP_RT"'|' -i tmp/scriptR_$pop.R # Proportion de la taille de pop

#sed 's|tempCC|'"$Temp"'|' -i tmp/scriptR_$pop.R
#sed 's|ampCC|'"$Amp"'|' -i tmp/scriptR_$pop.R
#sed 's|seaCC|'"$Sea"'|' -i tmp/scriptR_$pop.R

sed 's|fish.state|'"$state"'|' -i tmp/scriptR_$pop.R
sed 's|fish.stage|'"$stage"'|' -i tmp/scriptR_$pop.R

sed 's|scenarioConnect|'"$scenarioConnectRT"'|' -i tmp/scriptR_$pop.R
sed 's|scenarioEnvi|'"$scenarioEnviRT"'|' -i tmp/scriptR_$pop.R

# Run analysis
R CMD BATCH --no-save --no-restore --slave tmp/scriptR_$pop.R tmp/scriptR_$pop.out &

# rm -f tmp/scriptR_$pop.out
# rm -f tmp/scriptR_$pop.R

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

#Temp=0 # Water Temperature (T° increase / Years; keep constant if 0)
#Amp=1 # Flow amplitude (keep constant if 1)
#Sea=1 # decreasing growth condition at sea (keep constant if 1)

done

