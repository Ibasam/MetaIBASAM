# ! /bin/sh
#$ -S /bin/sh

# 3. ANALYSIS
npop=16
#ls scriptR_{1..16}.R|xargs -n 1 -P 0 R --vanilla
#parallel -j0 R --vanilla ::: scriptR_{1..16}.R &
#(Rscript --vanilla tmp/scriptR_1.R) | parallel
for pop in $(seq 1 $npop)
do
R CMD BATCH --vanilla scriptR_$pop.R &
  # rm -f scriptR_$pop.out
  # rm -f scriptR_$pop.R
done # end loop pop