#PBS -S /bin/bash
#PBS -N jevs_hurricane_global_det_tcgen_plots
#PBS -j oe
#PBS -A VERF-DEV
#PBS -q dev
#PBS -l select=1:ncpus=1:mem=4GB
##PBS -l place=vscatter:exclhost,select=1:ncpus=128:ompthreads=1
#PBS -l walltime=00:30:00
#PBS -l debug=true

set -x

export HOMEevs=/mnt/lfs5/HFIP/hwrfv3/$USER/EVS
source ${HOMEevs}/versions/run.ver

evs_ver_2d=$(echo $evs_ver | cut -d'.' -f1-2)

export NET=evs
export COMPONENT=hurricane
export RUN=global_det
export STEP=plots
export VERIF_CASE=tcgen
export envir=dev
export cyc=00
export job=jevs_${COMPONENT}_${RUN}_${VERIF_CASE}_${STEP}_${cyc}
export jobid=$job.${PBS_JOBID:-$$}

############################################################
# Load modules
############################################################
module reset
module load prod_envir/${prod_envir_ver}
source ${HOMEevs}/dev/modulefiles/${COMPONENT}/${COMPONENT}_${STEP}.sh

#Set PDY to override setpdy.sh called in the j-jobs
export PDY=20241231

#Define the directories of your TC genesis stats files
export COMINstats=/mnt/lfs5/HFIP/hwrfv3/$USER/evs/${evs_ver_2d}/stats/${COMPONENT}/${RUN}/${VERIF_CASE}

#Define the directories of your NOAA/NWS logos ----> PATH UNKNOWN ON JET
#export FIXevs=/lfs/h2/emc/vpppg/noscrub/emc.vpppg/verification/EVS_fix

export DATAROOT=/mnt/lfs5/HFIP/hwrfv3/$USER/evs_test/$envir/tmp
export COMOUT=/mnt/lfs5/HFIP/hwrfv3/$USER/$NET/$evs_ver_2d
export KEEPDATA=NO


# CALL executable job script here
$HOMEevs/jobs/JEVS_HURRICANE_PLOTS

