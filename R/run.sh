# ! /bin/sh
#$ -S /bin/sh

#for iSIMUL in "0" "1"
#do

#cp sim.R scriptR_$iSIMUL.R
# sed 's|sim1|'"sim1"'|g' -i scriptR_TMP.ssc


R CMD BATCH --no-save --no-restore --slave '--args 1 2 0.2 3' sim.R test1.out &
R CMD BATCH --no-save --no-restore --slave '--args 2 1 0.1 6' sim.R test2.out &

#done
