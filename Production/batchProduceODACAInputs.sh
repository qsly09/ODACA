#!/bin/bash
#SBATCH -J input
#SBATCH -p quanah
#SBATCH -o out-input-%A_%4a.out
#SBATCH -e err-input-%A_%4a.err
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 48:00:00
#SBATCH -a 1-1:1
#SBATCH --mail-user=shi.qiu@ttu.edu
#SBATCH --mem-per-cpu=100G


#NOTE: This job is to arrage cores in My Matlab function.  nocona  quanah
#The variable $SGE_TASK_ID is the ID for this task. 
#The variable $SGE_TASK_FIRST is the ID for the first task.
#The variable $SGE_TASK_LAST is the ID for the last task.
#This script is a companion script for submitmjobs for MATLAB apps
#It demonstrates how the passed "task" can be used to make each of
#The ntasks to perform a different task or use different data. If your
#app is a function m-file, "task" needs to be passed as input argument.
#If your app is a script m-file, "task" is automatically available
#because it shares the same workspace as myscript.
# IMPORTANT: DONOT indent any of the below statements

cd /home/qiu25856/ODACA/Production
module load matlab
# matlab -nodisplay -singleCompThread -r "batchProduceODACAInputs($SLURM_ARRAY_TASK_ID, $SLURM_ARRAY_TASK_MAX); exit"
matlab -nodisplay -singleCompThread -r "batchProduceODACAInputs(170, 200); exit"
# 2 125 25  82 130 168 153 61 170  
