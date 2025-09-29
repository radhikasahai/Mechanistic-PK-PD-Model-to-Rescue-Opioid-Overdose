#!/bin/sh
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1 
#SBATCH --ntasks=1  
#SBATCH -J IN8plot
#SBATCH -t 24:00:00
#SBATCH --mem=16G
# #SBATCH --output=output/logfiles/ 
# #SBATCH --error=output/logfiles/
#SBATCH --output=/dev/null 
#SBATCH --error=/dev/null 

#if using smaller timestep, might need to request more ram (e.g., --mem=32G)
if [ ! -d output/logfiles/"$SLURM_JOB_NAME".o"$SLURM_JOB_ID" ]; then
  mkdir -p output/logfiles/"$SLURM_JOB_NAME".o"$SLURM_JOB_ID"
fi

Rscript IN8_population_stats.R >& output/logfiles/"$SLURM_JOB_NAME".o"$SLURM_JOB_ID"/stats.txt
Rscript plot_figure_S2.R >& output/logfiles/"$SLURM_JOB_NAME".o"$SLURM_JOB_ID"/plotting.txt