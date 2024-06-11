# This script runs global and regional tropcyc stats. #

# go to logs directory
cd /lfs/h2/emc/ptmp/olivia.ostwald/logs

# run regional and global stats scripts
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_late_tropcyc_ops_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_late_tropcyc_legacy_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_early_tropcyc_ops_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_early_tropcyc_legacy_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_tropcyc_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_global_det_tropcyc_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_global_ens_tropcyc_stats.sh 
#qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_global_det_tcgen_stats.sh 

