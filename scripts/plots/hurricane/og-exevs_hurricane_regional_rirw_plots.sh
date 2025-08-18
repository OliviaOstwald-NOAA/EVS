#!/bin/bash
set -x
export PS4=' + exevs_hurricane_regional_rirw_plots.sh line $LINENO: '

export stormYear=${YYYY}
export basinlist="al ep"
export numlist="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 \
	        21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40"

for bas in $basinlist; do
### bas do loop start
for num in $numlist; do
### num do loop start

export stormBasin=${bas}
export stbasin=`echo ${stormBasin} | tr "[a-z]" "[A-Z]"`
echo "${stbasin} upper case: AL/EP/WP"
export stormNumber=${num}

if [ ${stormBasin} = "al" ]; then
  COMINbdeck=${COMINbdeckNHC}
  export comoutatl=${COMOUT}/Atlantic
  if [ ! -d ${comoutatl} ]; then mkdir -p ${comoutatl}; fi
elif [ ${stormBasin} = "ep" ]; then
  COMINbdeck=${COMINbdeckNHC}
  export comoutepa=${COMOUT}/EastPacific
  if [ ! -d ${comoutepa} ]; then mkdir -p ${comoutepa}; fi
elif [ ${stormBasin} = "wp" ]; then
  COMINbdeck=${COMINbdeckJTWC}
  export comoutwpa=${COMOUT}/WestPacific
  if [ ! -d ${comoutwpa} ]; then mkdir -p ${comoutwpa}; fi
fi

export bdeckfile=${COMINbdeck}/b${stormBasin}${stormNumber}${stormYear}.dat
if [ -f ${bdeckfile} ]; then
numrecs=`cat ${bdeckfile} | wc -l`
if [ ${numrecs} -gt 0 ]; then
### two ifs start

export comoutroot=${COMOUT}/${bas}${num}
if [ ! -d ${comoutroot} ]; then mkdir -p ${comoutroot}; fi

#export COMINstats=/lfs/h2/emc/ptmp/$USER/com/evs/1.0/hurricane_regional/rirw/stats
export STORMroot=${DATA}/${bas}${num}
if [ ! -d ${STORMroot} ]; then mkdir -p ${STORMroot}; fi
cd ${STORMroot}
cp -r ${COMINstats}/${bas}${num}/tc_stat .

#---get the storm name from TC-vital file "syndat_tcvitals.${YYYY}"
if [ ${stormBasin} = "al" ]; then
  grep "NHC  ${stormNumber}L" ${COMINvit} > syndat_tcvitals.${YYYY}.${stormBasin}${stormNumber}
  echo $(tail -n 1 syndat_tcvitals.${YYYY}.${stormBasin}${stormNumber}) > TCvit_tail.txt
  sed -i 's/NHC/NHCC/' TCvit_tail.txt
elif [ ${stormBasin} = "ep" ]; then
  grep "NHC  ${stormNumber}E" ${COMINvit} > syndat_tcvitals.${YYYY}.${stormBasin}${stormNumber}
  echo $(tail -n 1 syndat_tcvitals.${YYYY}.${stormBasin}${stormNumber}) > TCvit_tail.txt
  sed -i 's/NHC/NHCC/' TCvit_tail.txt
elif [ ${stormBasin} = "wp" ]; then
  grep "JTWC ${stormNumber}W" ${COMINvit} > syndat_tcvitals.${YYYY}.${stormBasin}${stormNumber}
  echo $(tail -n 1 syndat_tcvitals.${YYYY}.${stormBasin}${stormNumber}) > TCvit_tail.txt
fi
cat TCvit_tail.txt|cut -c10-18 > TCname.txt
VARIABLE1=$( head -n 1 TCname.txt )
echo "$VARIABLE1"
VARIABLE2=$(printf '%s' "$VARIABLE1" | sed 's/[0-9]//g')
echo "$VARIABLE2"
stormName=$(sed "s/ //g" <<< $VARIABLE2)
echo "Name_${stormName}_Name"
echo "${stormBasin}, ${stormNumber}, ${stormYear}, ${stormName}"

#---Storm Plots 
echo "Starting storm plots"

export LOGOroot=${FIXevs}/logos
export PLOTDATA=${STORMroot}
#export RUN="rirw"
export img_quality="low"

export fhr_list="0,6,12,18,24,30,36,42,48,54,60,66,72,78,84,90,96,102,108,114,120,126"
export model_tmp_atcf_name_list="MD01,MD02,MD03,MD04"
export model_plot_name_list="GFS,HWRF,HMON,CTCX"
export plot_CI_bars="NO"
export under="_"
export tc_name=${stbasin}${under}${stormYear}${under}${stormName}
export basin=${stbasin}
export tc_num=${stormNumber}
export rirw_model_type="regional"
python ${USHevs}/${COMPONENT}/${STEP}/plot_rirw_lead_average.py

nimgs=$(ls ${STORMroot}/plot/${tc_name}/images/* |wc -l)
if [ $nimgs -ne 0 ]; then
  cd ${STORMroot}/plot/${tc_name}/images
  convert ABSAMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.png ABSAMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.gif
  convert AMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.png AMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.gif
  convert ABSTK_ERR_fhrmean_${tc_name}_regional.png ABSTK_ERR_fhrmean_${tc_name}_regional.gif
  convert ALTK_ERR_fhrmean_${tc_name}_regional.png ALTK_ERR_fhrmean_${tc_name}_regional.gif
  convert CRTK_ERR_fhrmean_${tc_name}_regional.png CRTK_ERR_fhrmean_${tc_name}_regional.gif
  rm -f *.png
  if [ "$SENDCOM" = 'YES' ]; then
    cp ${STORMroot}/plot/${tc_name}/images/ABSAMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.gif ${comoutroot}/evs.hurricane_regional.abswind_err.${stormBasin}.${stormYear}.${stormName}${stormNumber}.png
    cp ${STORMroot}/plot/${tc_name}/images/AMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.gif ${comoutroot}/evs.hurricane_regional.wind_bias.${stormBasin}.${stormYear}.${stormName}${stormNumber}.png 
    cp ${STORMroot}/plot/${tc_name}/images/ABSTK_ERR_fhrmean_${tc_name}_regional.gif ${comoutroot}/evs.hurricane_regional.abstk_err.${stormBasin}.${stormYear}.${stormName}${stormNumber}.png
    cp ${STORMroot}/plot/${tc_name}/images/ALTK_ERR_fhrmean_${tc_name}_regional.gif ${comoutroot}/evs.hurricane_regional.altk_bias.${stormBasin}.${stormYear}.${stormName}${stormNumber}.png
    cp ${STORMroot}/plot/${tc_name}/images/CRTK_ERR_fhrmean_${tc_name}_regional.gif ${comoutroot}/evs.hurricane_regional.crtk_bias.${stormBasin}.${stormYear}.${stormName}${stormNumber}.png
  fi
fi

### two ifs end
fi
fi
### num do loop end
done

#export COMINstats=/lfs/h2/emc/ptmp/$USER/com/evs/1.0/hurricane_regional/rirw/stats

if [ ${stormBasin} = "al" ]; then
  export comoutbas=${comoutatl}
  export metTCcomout=${DATA}/Atlantic
  if [ ! -d $metTCcomout ]; then mkdir -p $metTCcomout; fi
  cd $metTCcomout
  cp -r ${COMINstats}/Atlantic/tc_stat .
  cp $metTCcomout/tc_stat/tc_stat_basin.out $metTCcomout/tc_stat/tc_stat.out
elif [ ${stormBasin} = "ep" ]; then
  export comoutbas=${comoutepa}
  export metTCcomout=${DATA}/EastPacific
  if [ ! -d $metTCcomout ]; then mkdir -p $metTCcomout; fi
  cd $metTCcomout
  cp -r ${COMINstats}/EastPacific/tc_stat .
  cp $metTCcomout/tc_stat/tc_stat_basin.out $metTCcomout/tc_stat/tc_stat.out
elif [ ${stormBasin} = "wp" ]; then
  export comoutbas=${comoutwpa}
  export metTCcomout=${DATA}/WestPacific
  if [ ! -d $metTCcomout ]; then mkdir -p $metTCcomout; fi
  cd $metTCcomout
  cp -r ${COMINstats}/WestPacific/tc_stat .
  cp $metTCcomout/tc_stat/tc_stat_basin.out $metTCcomout/tc_stat/tc_stat.out
fi

#--- Basin-Storms Plots 
echo "Starting Basin Storm Plots"

export LOGOroot=${FIXevs}/logos
export PLOTDATA=${metTCcomout}
#export RUN="rirw"
export img_quality="low"

export fhr_list="0,6,12,18,24,30,36,42,48,54,60,66,72,78,84,90,96,102,108,114,120,126"
export model_tmp_atcf_name_list="MD01,MD02,MD03,MD04"
export model_plot_name_list="GFS,HWRF,HMON,CTCX"
export plot_CI_bars="NO"
export stormNameB=Basin
export tc_name=${stbasin}${under}${stormYear}${under}${stormNameB}
export basin=${stbasin}
export tc_num= 
export rirw_model_type="regional"
python ${USHevs}/${COMPONENT}/${STEP}/plot_rirw_lead_average.py

bimgs=$(ls ${metTCcomout}/plot/${tc_name}/images/* |wc -l)
if [ $bimgs -ne 0 ]; then
  cd ${metTCcomout}/plot/${tc_name}/images
  convert ABSAMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.png ABSAMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.gif
  convert AMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.png AMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.gif
  convert ABSTK_ERR_fhrmean_${tc_name}_regional.png ABSTK_ERR_fhrmean_${tc_name}_regional.gif
  convert ALTK_ERR_fhrmean_${tc_name}_regional.png ALTK_ERR_fhrmean_${tc_name}_regional.gif
  convert CRTK_ERR_fhrmean_${tc_name}_regional.png CRTK_ERR_fhrmean_${tc_name}_regional.gif
  rm -f *.png
  if [ "$SENDCOM" = 'YES' ]; then
    cp -r ${metTCcomout}/plot/${tc_name}/images/ABSAMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.gif ${comoutbas}/evs.hurricane_regional.abswind_err.${stormBasin}.${stormYear}.season.png
    cp -r ${metTCcomout}/plot/${tc_name}/images/AMAX_WIND-BMAX_WIND_fhrmean_${tc_name}_regional.gif ${comoutbas}/evs.hurricane_regional.wind_bias.${stormBasin}.${stormYear}.season.png
    cp -r ${metTCcomout}/plot/${tc_name}/images/ABSTK_ERR_fhrmean_${tc_name}_regional.gif ${comoutbas}/evs.hurricane_regional.abstk_err.${stormBasin}.${stormYear}.season.png
    cp -r ${metTCcomout}/plot/${tc_name}/images/ALTK_ERR_fhrmean_${tc_name}_regional.gif ${comoutbas}/evs.hurricane_regional.altk_bias.${stormBasin}.${stormYear}.season.png
    cp -r ${metTCcomout}/plot/${tc_name}/images/CRTK_ERR_fhrmean_${tc_name}_regional.gif ${comoutbas}/evs.hurricane_regional.crtk_bias.${stormBasin}.${stormYear}.season.png
  fi
fi
### bas do loop end

#---tc_stat_rirw.out
for rirw_thresh in ge30 le-30; do
 export rirw_thresh=$rirw_thresh

if [ ${rirw_thresh} = "ge30" ]; then
  export rirw_label="ri"
elif [ ${rirw_thresh} = "le-30" ]; then
  export rirw_label="rw"
fi

#for modelname in gfs hwrf hmon ctcx; do
# export modelname=$modelname

if [ ${stormBasin} = "al" ]; then
  export comoutbas=${comoutatl}
  export metTCcomout=${DATA}/Atlantic
if [ ! -d $metTCcomout ]; then mkdir -p $metTCcomout; fi
  cd $metTCcomout
  cp -r ${COMINstats}/Atlantic/tc_stat_rirw .
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md01.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md01.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md02.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md02.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md03.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md03.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md04.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md04.txt
elif [ ${stormBasin} = "ep" ]; then
  export comoutbas=${comoutepa}
  export metTCcomout=${DATA}/EastPacific
if [ ! -d $metTCcomout ]; then mkdir -p $metTCcomout; fi
  cd $metTCcomout
  cp -r ${COMINstats}/EastPacific/tc_stat_rirw .
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md01.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md01.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md02.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md02.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md03.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md03.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md04.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md04.txt
elif [ ${stormBasin} = "wp" ]; then
  export comoutbas=${comoutwpa}
  export metTCcomout=${DATA}/WestPacific
if [ ! -d $metTCcomout ]; then mkdir -p $metTCcomout; fi
  cd $metTCcomout
  cp -r ${COMINstats}/WestPacific/tc_stat_rirw .
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md01.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md01.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md02.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md02.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md03.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md03.txt
  cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md04.out $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md04.txt
fi

#--- Performance Diagram Plots
echo "Starting Performance Diagram Plots"
#export TCRIRWcases="TC RIRW(05/01/${YEAR}-11/30/${YEAR})"
export LOGOroot=${FIXevs}/logos
export PLOTDATA=${metTCcomout}/tc_stat_rirw/
#export RUN="regional"
export img_quality="low"

export fhr_list="6,12,18,24,30,36,42,48,54,60,66,72,78,84,90,96,102,108,114,120,126"
export model_tmp_atcf_name_list="MD01,MD02,MD03,MD04"
export model_plot_name_list="GFS,HWRF,HMON,CTCX"
export plot_CI_bars="NO"
export stormNameB=Basin
export tc_name=${stbasin}${under}${stormYear}${under}${stormNameB}
export basin=${stbasin}
export tc_num=
export rirw_model_type="regional"

export DATAplot=$metTCcomout/plot/

if [ ! -d ${DATAplot} ]; then mkdir -p ${DATAplot}; fi
cd ${DATAplot}
cp ${USHevs}/${COMPONENT}/${STEP}/tcrirw_performance_diagram.py .
cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md01.out .
cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md02.out .
cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md03.out .
cp $metTCcomout/tc_stat_rirw/tc_stat_basin_rirw_${rirw_thresh}_md04.out .

export CTCfile01="tc_stat_basin_rirw_${rirw_thresh}_md01.out"
export CTCfile02="tc_stat_basin_rirw_${rirw_thresh}_md02.out"
export CTCfile03="tc_stat_basin_rirw_${rirw_thresh}_md03.out"
export CTCfile04="tc_stat_basin_rirw_${rirw_thresh}_md04.out"
python tcrirw_performance_diagram.py

rimgs=$(ls ${metTCcomout}/plot/${tc_name}/images/* |wc -l)
if [ $rimgs -ne 0 ]; then
 cd ${metTCcomout}/plot/
 convert tcrirw_performance_diagram_${rirw_thresh}.png tcrirw_performance_diagram_${rirw_thresh}.gif
 rm -f *.png

if [ "$SENDCOM" = 'YES' ]; then
 cp ${metTCcomout}/plot/tcrirw_performance_diagram_${rirw_thresh}.gif ${comoutbas}/evs.hurricane_regional.${rirw_label}_perfdiag.${stormBasin}.${stormYear}.season.png
fi
fi

### two ifs end
done
done
