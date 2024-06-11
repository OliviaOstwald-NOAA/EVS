## This script will pull in data from 2024 Hurricane Season to developer's local space ##
### Data includes: TCvital (syndat_vitals.2024), ATCF track files (tracks.atcfunix.24), and a & b-deck files ###

SHELL=/bin/bash 

#cron statement:
# MM HH DD MO YYYY sh /path/to/script       cyc
# 00 14 *  *   *   sh this/path/tcdata.sh   00
# $0 = path/to/script
# $1 = cyc

# 00 15 * * * sh /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/cron_jobs/tcdata.sh 1> /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/cron_jobs/logs/tcdata.out

#
##### Examples below ###
#
# 1) with path to logfile:
#    30 13 * * * sh /oath/to/your/script/script.sh 1> /path/to/logfiles/logfile.out
#       where 1 is output, 2 sends errors to log output
#
# 2)This sends output and errors to "dev/null" which is null (nothing), so no logfile is generated. Used by some for completeness.
#   30 13 * * * sh /oath/to/your/script/script.sh > /dev/null 2>&1
#
# 3) Combine output and errors into one logfile output 
#    30 13 * * * sh /oath/to/your/script/script.sh 1> /path/to/logfiles/logfile.out 2>&1
#
#################
#cyc=$1
#echo $0
#echo $cyc

echo "copying TCvital files"
# TCvital
cd /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/TCvital
cp /lfs/h1/ops/prod/com/gfs/v16.3/syndat/syndat_tcvitals.2024 .

echo "copying regional track files"
# regionalTrack
cd /lfs/h2/emc/hur/noscrub/emc.hur/trak_save/abdeck/aid
cp -r aal*2024.dat aep*2024.dat /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/regionalTrack
cd /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/regionalTrack
rm tracks.atcfunix.24
cat *dat >> tracks.atcfunix.24
rm -rf *dat

echo "copying adeck files"
# adeck
cd /lfs/h2/emc/hur/noscrub/emc.hur/trak_save/abdeck/aid
cp -r aal*2024* aep*2024* awp*2024* /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/adeck

echo "copying bdeck files"
# bdeck
cd /lfs/h2/emc/hur/noscrub/emc.hur/trak_save/abdeck/btk 
cp -r bal*2024* bep*2024* bwp*2024* /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/bdeck

echo "copying global track files"
# globalTrack
cd /lfs/h1/ops/prod/com/ens_tracker/v1.3/global/
cp tracks.atcfunix.24 /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2024/globalTrack

exit

echo "copying TCgen files"
# TCgen
# ask Shelley about these steps because you will need to use PDY variable
cd /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2023/TCgen
rm -rf *genesis*
cd /lfs/h1/ops/prod/com/ens_tracker/v1.3/gefs.$(date "+%Y%m%d")/${cyc}/genesis/
cp storms.gfso.atcf_gen.altg.$(date "+%Y%m%d")${cyc} /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2023/TCgen
cd /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2023/TCgen
mv storms.gfso.atcf_gen.altg.$(date "+%Y%m%d")${cyc} gfs_genesis_2023
cd /lfs/h1/ops/prod/com/ens_tracker/v1.3/cmce.$(date "+%Y%m%d")/${cyc}/genesis
cp storms.cmc.atcf_gen.altg.$(date "+%Y%m%d")${cyc} /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2023/TCgen
cd /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2023/TCgen
mv storms.cmc.atcf_gen.altg.$(date "+%Y%m%d")${cyc} cmc_genesis_2023
cd /lfs/h1/ops/prod/com/ens_tracker/v1.3/ecme.$(date "+%Y%m%d")/${cyc}/genesis
cp storms.emx.atcf_gen.altg.$(date "+%Y%m%d")${cyc} /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2023/TCgen
cd /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2023/TCgen
mv storms.emx.atcf_gen.$(date "+%Y%m%d")${cyc} ecmwf_genesis_2023

echo "copying complete"
