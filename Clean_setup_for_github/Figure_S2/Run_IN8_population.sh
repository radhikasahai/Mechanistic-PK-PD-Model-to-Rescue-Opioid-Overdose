#!/bin/sh
#SBATCH -a 1-2001
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1 
#SBATCH --ntasks=1  
#SBATCH -J IN8pop
#SBATCH -t 24:00:00
#SBATCH --mem=2G
# #SBATCH --output=output/logfiles/ 
# #SBATCH --error=output/logfiles/
#SBATCH --output=/dev/null 
#SBATCH --error=/dev/null 

if [ ! -d output/logfiles/"$SLURM_JOB_NAME".o"$SLURM_ARRAY_JOB_ID" ]; then
  mkdir -p output/logfiles/"$SLURM_JOB_NAME".o"$SLURM_ARRAY_JOB_ID"
fi


Rscript run_IN8_population.R -a "$SLURM_ARRAY_TASK_ID"  >& output/logfiles/"$SLURM_JOB_NAME".o"$SLURM_ARRAY_JOB_ID"/"$SLURM_ARRAY_TASK_ID".txt