cd /lfs/h2/emc/vpppg/noscrub/olivia.ostwald/Data/Year2023/ukmet

cp -r /lfs/h1/ops/dev/dcom/$(date -d "-1 day" "+%Y%m%d")/wtxtbul/ukmet_hurr/* .
echo "Copying $(date -d "-1 day" "+%Y%m%d") UKMET files"
#cp -r /lfs/h1/ops/dev/dcom/$(date "+%Y%m%d")/wtxtbul/ukmet_hurr/* .
#echo "Copying $(date -d "+%Y%m%d") UKMET files"

