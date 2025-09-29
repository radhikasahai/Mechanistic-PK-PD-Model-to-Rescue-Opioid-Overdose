#!/bin/bash

# make fresh logfiles to prevent them from building up with many runs
if [ -d output/logfiles ]; then
  rm -r output/logfiles
fi

mkdir -p output/logfiles


# run the population
jobstring=$(sbatch Run_IN8_population.sh)

# get job ID
jobid=${jobstring##* }

# submit plotting to run after the population is done

sbatch --dependency=afterany:${jobid} Run_figure_S2_plotting.sh


