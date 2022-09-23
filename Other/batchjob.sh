#!/bin/bash
#SBATCH -J delt
#SBATCH -p quanah
#SBATCH -o out-delt-%A_%4a.out
#SBATCH -e err-delt-%A_%4a.err
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 48:00:00
#SBATCH -a 1-1:1


cd /home/qiu25856/ODACA/Other
module load matlab
matlab -nodisplay -singleCompThread -r "removeFolders; exit"
