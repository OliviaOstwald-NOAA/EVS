#PBS -S /bin/bash
#PBS -N jevs_hurricane_global_ens_spread_stats
#PBS -j oe
#PBS -A ENSTRACK-DEV
#PBS -q dev
<<<<<<< HEAD
#PBS -l select=1:ncpus=2:mem=4GB
##PBS -l place=vscatter:exclhost,select=1:ncpus=128:ompthreads=1
#PBS -l walltime=04:00:00
=======
#PBS -l select=1:ncpus=1:mem=4GB
#PBS -l walltime=06:00:00
>>>>>>> 83978b7a1d6a14776032680db58b92e2196c71e5
#PBS -l debug=true
#PBS -V

set -x

export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS
source ${HOMEevs}/versions/run.ver

evs_ver_2d=$(echo $evs_ver | cut -d'.' -f1-2)

export NET=evs
export COMPONENT=hurricane
export RUN=global_ens
export STEP=stats
export VERIF_CASE=spread
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
<<<<<<< HEAD
export PDY=20241231

#Define TC-vital file, TC track file and the directory for Bdeck files
export COMINvit=/lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/TCvital/syndat_tcvitals.2024
export COMINtrack=/lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/globalTrack/tracks.atcfunix.24
export COMINbdeckNHC=/lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/bdeck
export COMINbdeckJTWC=/lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/bdeck
#export COMINvit=/lfs/h2/emc/vpppg/noscrub/$USER/evs_tc_2023/tcskill/syndat_tcvitals.2023
#export COMINtrack=/lfs/h2/emc/vpppg/noscrub/$USER/evs_tc_2023/tcskill/tracks.atcfunix.23
#export COMINbdeckNHC=/lfs/h2/emc/vpppg/noscrub/$USER/evs_tc_2023/tcskill/bdeck
#export COMINbdeckJTWC=/lfs/h2/emc/vpppg/noscrub/$USER/evs_tc_2023/tcskill/bdeck
=======
export PDY=20231231

#Define TC-vital file, TC track file and the directory for Bdeck files
export COMINvit=/lfs/h2/emc/vpppg/noscrub/$USER/evs_tc_2023/syndat_tcvitals.2023
export COMINtrack=/lfs/h2/emc/vpppg/noscrub/$USER/evs_tc_2023/tracks.atcfunix.23
export COMINbdeckNHC=/lfs/h2/emc/vpppg/noscrub/$USER/evs_tc_2023/bdeck
export COMINbdeckJTWC=/lfs/h2/emc/vpppg/noscrub/$USER/evs_tc_2023/bdeck
>>>>>>> 83978b7a1d6a14776032680db58b92e2196c71e5

export DATAROOT=/lfs/h2/emc/stmp/$USER
export COMOUT=/lfs/h2/emc/vpppg/noscrub/$USER/$NET/$evs_ver_2d
export KEEPDATA=YES

# CALL executable job script here
$HOMEevs/jobs/JEVS_HURRICANE_STATS



