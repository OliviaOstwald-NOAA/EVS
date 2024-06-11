## EVS-hurricane package for 2024 Hurricane Season ##
# This script will run a cron job for 3 regional TC jobs and 2* global TC jobs

#cron statement:
# MM HH DD MO YYYY sh /path/to/script       cyc
# 00 14 *  *   *   sh this/path/tcdata.sh   00
# $0 = path/to/script
# $1 = cyc

# go to logs directory
cd /lfs/h2/emc/ptmp/olivia.ostwald/logs

# run regional and global stats scripts
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_early_tropcyc_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_late_tropcyc_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_tropcyc_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_global_det_tropcyc_stats.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_global_ens_tropcyc_stats.sh 
#qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/stats/hurricane/jevs_hurricane_regional_global_det_tcgen_stats.sh 

sleep 900

# run regional and global plots scripts
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/plots/hurricane/jevs_hurricane_regional_early_tropcyc_plots.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/plots/hurricane/jevs_hurricane_regional_late_tropcyc_plots.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/plots/hurricane/jevs_hurricane_regional_tropcyc_plots.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/plots/hurricane/jevs_hurricane_global_det_tropcyc_plots.sh 
qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/plots/hurricane/jevs_hurricane_global_ens_tropcyc_plots.sh 
#qsub /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/EVS/dev/drivers/scripts/plots/hurricane/jevs_hurricane__global_det_tcgen_plots.sh 
