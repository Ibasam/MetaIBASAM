#!/bin/bash

# Parameters:
npop=16
nSIMUL=100 # Nb simulations 100
Init=15 # Nb years to initialized 15
Years=50 # Nb years simulated 50
rPROP_RT=0.2 # proportion (population size) 20% de l'aire
maxtime=40 # time of each simualtion (minutes)

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


# Connectivity conditions:
scenarioConnectRT=3 #scenario 1 pour h=1.00, scenario 2 pour h=0.942, scenario 3 pour h=0.80

# Environmental conditions:
scenarioEnviRT=1 #scenario 1 pour absence de CC, scenario 2 pour CC
#Temp=0 # Water Temperature (T° increase / Years; keep constant if 0)
#Amp=1 # Flow amplitude (keep constant if 1)
#Sea=1 # decreasing growth condition at sea (keep constant if 1)


# 1. SCENARIO
#Transfert des scripts dans dossier correspondant au scenario
scenario=Scenario"$scenarioConnectRT"_"$scenarioEnviRT"

if [ ! -d "$scenario" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir -p $scenario
  # Copy files to scenario folder
  cp scriptR.R $scenario
  cp demoIbasam.R $scenario
  cp Matrices_Laplace_AireLog.RData $scenario
  cp rename.sh $scenario
fi

cd $scenario # move directory to scenario folder

# 2. SIMULATION
echo "BEGINNING OF SIMULATION FOR $scenario"
echo "PID du processus courant : $$"
for s in $(seq 35 $nSIMUL) # scenario 3.1
#for s in $(seq 31 $nSIMUL) # scenario 2.1

do

if [ ! -d "Simu$s" ]; then
mkdir Simu$s  # create simul folder
# Copy files to simul folder
cp scriptR.R Simu$s
cp demoIbasam.R Simu$s
cp Matrices_Laplace_AireLog.RData Simu$s
fi

cd Simu$s # move to simul folder

## Create temporary folder (needed to put migrants files)
mkdir results
mkdir tmp

# Create Rscript for each population
for pop in $(seq 1 $npop)
do

cp scriptR.R scriptR_$pop.R

sed 's|nSimu|'"$nSIMUL"'|g' -i scriptR_$pop.R

sed 's|init|'"$Init"'|g' -i scriptR_$pop.R
sed 's|years|'"$Years"'|' -i scriptR_$pop.R

sed 's|Npop|'"$npop"'|g' -i scriptR_$pop.R # Number of populations
sed 's|popo|'"$pop"'|' -i scriptR_$pop.R # Population of origin
sed 's|rPROPScript|'"$rPROP_RT"'|' -i scriptR_$pop.R # Proportion de la taille de pop

#sed 's|tempCC|'"$Temp"'|' -i scriptR_$pop.R
#sed 's|ampCC|'"$Amp"'|' -i scriptR_$pop.R
#sed 's|seaCC|'"$Sea"'|' -i scriptR_$pop.R

sed 's|fish.state|'"$state"'|' -i scriptR_$pop.R
sed 's|fish.stage|'"$stage"'|' -i scriptR_$pop.R

sed 's|scenarioConnect|'"$scenarioConnectRT"'|' -i scriptR_$pop.R
sed 's|scenarioEnvi|'"$scenarioEnviRT"'|' -i scriptR_$pop.R

done # end loop pop
wait


# 3. ANALYSIS
# see also bash script run.sh
##ls scriptR_{1..16}.R|xargs -n 1 -P 0 R --vanilla
##parallel -j0 R --vanilla ::: scriptR_{1..16}.R
##(Rscript --vanilla tmp/scriptR_1.R) | parallel
declare -a PIDS
#declare -a PIDS2
for pop in $(seq 1 $npop)
do
R CMD BATCH --vanilla scriptR_$pop.R &
#sleep 1
PIDS+=("$!") # add PID du processus lance dans l'array
#PIDS2+=(pgrep -P "$!")
#echo "${PIDS[@]}"
#echo "${PIDS2[@]}"
#echo "PID du processus courant : $$"
#echo "PID du processus lancé : $!"
## rm -f scriptR_$pop.out
## rm -f scriptR_$pop.R
done # end loop pop
sleep 5 # sleep 5 seconds


# 4. CHECK
DIR="results/" # directory where to save results
STARTTIME=$(date +%s);
SECONDS=0;
declare -a simFAILED

# Infinite loop:
while : ; do
	sleep 60;   # sleep for minute
	# Break while if DIR no empty:
  [[ -n "$(ls -A $DIR 2>/dev/null)" ]] && break

# check if Rout files contain "Execution halted"
  if grep -q "Execution halted" *.Rout;then 
      echo "Simulation $s failed"
	      simFAILED+=("$s")
        nSIMUL=$(( $nSIMUL + 1 )) # add 1 simulation to nSimul
      for pid in "${PIDS[@]}"; do
        pkill -P "$pid" # kill grandchild processes
        done
        pkill -P $$ #kill $(ps -s $$ -o pid=) # kills all children of the current given process $$
        
        #cd .. # return to main directory
        #rm -R Simu$s # remove failed simulation
	      break       	   #Abandon the while loop
  fi
done # end while loop
#wait 

ENDTIME=$(date +%s);
#ENDTIME2=$SECONDS;
MINUTES=$(( ($ENDTIME - $STARTTIME) / 60 ));
#DURATION=$(( $ENDTIME2 / 60 ));

if [ -n "$(ls -A $DIR 2>/dev/null)" ];then # check if DIR is not empty
  echo "Simulation $s successful! Duration: $MINUTES minutes" 
  sleep 60 # sleep for 60 seconds   
fi

# return to main directory
cd ..

# end loop simul
done

echo "SIMULATIONS $simFAILED FAILED"
echo "END OF SIMULATION"

