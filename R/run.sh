#!/bin/sh
#$ -S /bin/sh

# Parameters
npop=4
nyears=5


# Create temporary folder (needed to put migrants files)
mkdir -p /tmp

for pop in $(seq 1 $npop)
do

# Create straying matrix
#cp R/stray.R R/stray_$npop.R # copy stray.R
#sed 's|npop|'"$npop"'|g' -i R/stray_$npop.R # replace npop into stray.R

# Create R script for each populations
cp rIBASAM.R tmp/rIBASAM_$pop.R
sed 's|npop|'"$npop"'|g' -i tmp/rIBASAM_$pop.R
sed 's|Pop.o|'"$pop"'|g' -i tmp/rIBASAM_$pop.R
sed 's|nYears|'"$nyears"'|g' -i tmp/rIBASAM_$pop.R


# Run analysis
#R CMD BATCH --no-save --no-restore --slave R/stray_$npop.R R/stray_$npop.Rout &

# Run analysis
R CMD BATCH --no-save --no-restore --slave tmp/rIBASAM_$pop.R tmp/rIBASAM_$pop.out &

# Cleaning
#rm -f tmp/rIBASAM_$pop.R
#rm -f R/rIBASAM_$pop.out

done
