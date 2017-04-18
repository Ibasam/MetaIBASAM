# ! /bin/sh
#$ -S /bin/sh


npop=3
nyears=10

for pop in $(seq 1 $npop)
do

# Create R script for each populations
cp R/rIBASAM.R R/rIBASAM_$pop.R
sed 's|npop|'"$npop"'|g' -i R/rIBASAM_$pop.R
sed 's|Pop.o|'"$pop"'|g' -i R/rIBASAM_$pop.R
sed 's|nYears|'"$nyears"'|g' -i R/rIBASAM_$pop.R

# Create temporary folder (needed to put migrants files)
mkdir -p tmp/

# Run analysis
R CMD BATCH --no-save --no-restore --slave R/rIBASAM_$pop.R R/rIBASAM_$pop.out &

done
