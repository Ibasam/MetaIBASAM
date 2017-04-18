# ! /bin/sh
#$ -S /bin/sh


npop=3


for pop in $(seq 1 $npop)
do

cp R/test0.R R/test0_$pop.R
sed 's|npop|'"$npop"'|g' -i R/test0_$pop.R
sed 's|Pop.o|'"$pop"'|g' -i R/test0_$pop.R

R CMD BATCH --no-save --no-restore --slave R/test0_$pop.R test$pop.out &

done
