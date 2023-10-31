#!/bin/bash -e

# =============================================================================
#
# NAME: exevs_hireswarw_precip_stats.sh
# CONTRIBUTOR(S): Marcel Caron, marcel.caron@noaa.gov, NOAA/NWS/NCEP/EMC-VPPPGB
# PURPOSE: Handle all components of an EVS HiRes Window ARW Precipitation - 
#          Statistics job
# DEPENDENCIES: $HOMEevs/jobs/JEVS_CAM_STATS 
#
# =============================================================================

set -x

# Set Basic Environment Variables
last_cyc="22"
NEST_LIST="conus ak pr hi" # this is reset after reformat
export BOOL_NBRHD=False

# Reformat MET Data
export job_type="reformat"
export njob=1
export run_restart=true
for NEST in $NEST_LIST; do
    export NEST=$NEST
    for ACC in "01" "03" "24"; do
        export ACC=$ACC
        if [ "${ACC}" = "01" ]; then
            VHOUR_LIST="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
        elif [ "${ACC}" = "03" ]; then
            VHOUR_LIST="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
        elif [ "${ACC}" = "24" ]; then
            VHOUR_LIST="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
        else
            echo "${ACC} is not supported"
            exit 1
        fi
        source $USHevs/cam/cam_stats_precip_filter_valid_hours_list.sh
        for VHOUR in $VHOUR_LIST; do
            export VHOUR=$VHOUR
            source $config

            # Check For Restart Files
            if [ "$run_restart" = true ]; then
                python ${USHevs}/cam/cam_production_restart.py
                status=$?
                [[ $status -ne 0 ]] && exit $status
                [[ $status -eq 0 ]] && echo "Successfully ran ${USHevs}/cam/cam_production_restart.py"
                export run_restart=false
            fi

            # Check User's Configuration Settings
            python $USHevs/cam/cam_check_settings.py
            status=$?
            [[ $status -ne 0 ]] && exit $status
            [[ $status -eq 0 ]] && echo "Successfully ran cam_check_settings.py ($job_type)"
            echo

            # Check Availability of Input Data
            python $USHevs/cam/cam_check_input_data.py
            status=$?
            [[ $status -ne 0 ]] && exit $status
            [[ $status -eq 0 ]] && echo "Successfully ran cam_check_input_data.py ($job_type)"
            echo
     
            # Create Output Directories
            python $USHevs/cam/cam_create_output_dirs.py
            status=$?
            [[ $status -ne 0 ]] && exit $status
            [[ $status -eq 0 ]] && echo "Successfully ran cam_create_output_dirs.py ($job_type)"

            # Create Reformat Job Script 
            python $USHevs/cam/cam_stats_precip_create_job_script.py
            status=$?
            [[ $status -ne 0 ]] && exit $status
            [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_job_script.py ($job_type)"
            export njob=$((njob+1))
        done
    done
done

# Create Reformat POE Job Scripts
if [ $USE_CFP = YES ]; then
    python $USHevs/cam/cam_stats_precip_create_poe_job_scripts.py
    status=$?
    [[ $status -ne 0 ]] && exit $status
    [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_poe_job_scripts.py ($job_type)"
fi

# Run all HiRes Window ARW precip/stats Reformat jobs
chmod u+x ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/*
ncount_job=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job* |wc -l)
nc=1
if [ $USE_CFP = YES ]; then
    ncount_poe=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe* |wc -l)
    while [ $nc -le $ncount_poe ]; do
        poe_script=${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe_jobs${nc}
        chmod 775 $poe_script
        export MP_PGMMODEL=mpmd
        export MP_CMDFILE=${poe_script}
        if [ $machine = WCOSS2 ]; then
            launcher="mpiexec -np $nproc -ppn $nproc --cpu-bind verbose,depth cfp"
        elif [$machine = HERA -o $machine = ORION -o $machine = S4 -o $machine = JET ]; then
            export SLURM_KILL_BAD_EXIT=0
            launcher="srun --export=ALL --multi-prog"
        else
            echo "Cannot submit jobs to scheduler on this machine.  Set USE_CFP=NO and retry."
            exit 1    
        fi
        $launcher $MP_CMDFILE
        nc=$((nc+1))
    done
else
    set -x
    while [ $nc -le $ncount_job ]; do
        ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job${nc}
        nc=$((nc+1))
    done
    set -x
fi

NEST_LIST="conus ak"
# Generate MET Data
export job_type="generate"
export njob=1
for NEST in $NEST_LIST; do
    export NEST=$NEST
    for ACC in "01" "03" "24"; do
        export ACC=$ACC
        if [ "${ACC}" = "01" ]; then
            VHOUR_LIST="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
        elif [ "${ACC}" = "03" ]; then
            VHOUR_LIST="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
        elif [ "${ACC}" = "24" ]; then
            VHOUR_LIST="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
        else
            echo "${ACC} is not supported"
            exit 1
        fi
        source $USHevs/cam/cam_stats_precip_filter_valid_hours_list.sh
        for VHOUR in $VHOUR_LIST; do
            export VHOUR=$VHOUR
            for BOOL_NBRHD in True False; do
                export BOOL_NBRHD=$BOOL_NBRHD
                source $config

                # Check User's Configuration Settings
                python $USHevs/cam/cam_check_settings.py
                status=$?
                [[ $status -ne 0 ]] && exit $status
                [[ $status -eq 0 ]] && echo "Successfully ran cam_check_settings.py ($job_type)"
                echo

                # Create Output Directories
                python $USHevs/cam/cam_create_output_dirs.py
                status=$?
                [[ $status -ne 0 ]] && exit $status
                [[ $status -eq 0 ]] && echo "Successfully ran cam_create_output_dirs.py ($job_type)"

                # Create Generate Job Script
                python $USHevs/cam/cam_stats_precip_create_job_script.py
                status=$?
                [[ $status -ne 0 ]] && exit $status
                [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_job_script.py ($job_type)"
                export njob=$((njob+1))
            done
        done
    done
done

# Create Generate POE Job Scripts
if [ $USE_CFP = YES ]; then
    python $USHevs/cam/cam_stats_precip_create_poe_job_scripts.py
    status=$?
    [[ $status -ne 0 ]] && exit $status
    [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_poe_job_scripts.py ($job_type)"
fi

# Run All HiRes Window ARW precip/stats Generate Jobs
chmod u+x ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/*
ncount_job=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job* |wc -l)
nc=1
if [ $USE_CFP = YES ]; then
    ncount_poe=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe* |wc -l)
    while [ $nc -le $ncount_poe ]; do
        poe_script=${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe_jobs${nc}
        chmod 775 $poe_script
        export MP_PGMMODEL=mpmd
        export MP_CMDFILE=${poe_script}
        if [ $machine = WCOSS2 ]; then
            launcher="mpiexec -np $nproc -ppn $nproc --cpu-bind verbose,depth cfp"
        elif [$machine = HERA -o $machine = ORION -o $machine = S4 -o $machine = JET ]; then
            export SLURM_KILL_BAD_EXIT=0
            launcher="srun --export=ALL --multi-prog"
        else
            echo "Cannot submit jobs to scheduler on this machine.  Set USE_CFP=NO and retry."
            exit 1
        fi
        $launcher $MP_CMDFILE
        nc=$((nc+1))
    done
else
    set -x
    while [ $nc -le $ncount_job ]; do
        ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job${nc}
        nc=$((nc+1))
    done
    set -x
fi

export job_type="gather"
export njob=1
for NEST in $NEST_LIST; do
    export NEST=$NEST
    source $config
    # Create Output Directories
    python $USHevs/cam/cam_create_output_dirs.py
    status=$?
    [[ $status -ne 0 ]] && exit $status
    [[ $status -eq 0 ]] && echo "Successfully ran cam_create_output_dirs.py ($job_type)"
    
    # Create Gather Job Script
    python $USHevs/cam/cam_stats_precip_create_job_script.py
    status=$?
    [[ $status -ne 0 ]] && exit $status
    [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_job_script.py ($job_type)"
    export njob=$((njob+1))
done

# Create Gather POE Job Scripts
if [ $USE_CFP = YES ]; then
    python $USHevs/cam/cam_stats_precip_create_poe_job_scripts.py
    status=$?
    [[ $status -ne 0 ]] && exit $status
    [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_poe_job_scripts.py ($job_type)"
fi

# Run All HiRes Window ARW precip/stats Gather Jobs
chmod u+x ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/*
ncount_job=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job* |wc -l)
nc=1
if [ $USE_CFP = YES ]; then
    ncount_poe=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe* |wc -l)
    while [ $nc -le $ncount_poe ]; do
        poe_script=${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe_jobs${nc}
        chmod 775 $poe_script
        export MP_PGMMODEL=mpmd
        export MP_CMDFILE=${poe_script}
        if [ $machine = WCOSS2 ]; then
            launcher="mpiexec -np $nproc -ppn $nproc --cpu-bind verbose,depth cfp"
        elif [$machine = HERA -o $machine = ORION -o $machine = S4 -o $machine = JET ]; then
            export SLURM_KILL_BAD_EXIT=0
            launcher="srun --export=ALL --multi-prog"
        else
            echo "Cannot submit jobs to scheduler on this machine.  Set USE_CFP=NO and retry."
            exit 1
        fi
        $launcher $MP_CMDFILE
        nc=$((nc+1))
    done
else
    set -x
    while [ $nc -le $ncount_job ]; do
        ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job${nc}
        nc=$((nc+1))
    done
    set -x
fi

export job_type="gather2"
export njob=1
source $config
# Create Output Directories
python $USHevs/cam/cam_create_output_dirs.py
status=$?
[[ $status -ne 0 ]] && exit $status
[[ $status -eq 0 ]] && echo "Successfully ran cam_create_output_dirs.py ($job_type)"

# Create Gather 2 Job Script
python $USHevs/cam/cam_stats_precip_create_job_script.py
status=$?
[[ $status -ne 0 ]] && exit $status
[[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_job_script.py ($job_type)"
export njob=$((njob+1))


# Create Gather 2 POE Job Scripts
if [ $USE_CFP = YES ]; then
    python $USHevs/cam/cam_stats_precip_create_poe_job_scripts.py
    status=$?
    [[ $status -ne 0 ]] && exit $status
    [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_poe_job_scripts.py ($job_type)"
fi

# Run All HiRes Window ARW precip/stats Gather 2 Jobs
chmod u+x ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/*
ncount_job=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job* |wc -l)
nc=1
if [ $USE_CFP = YES ]; then
    ncount_poe=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe* |wc -l)
    while [ $nc -le $ncount_poe ]; do
        poe_script=${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe_jobs${nc}
        chmod 775 $poe_script
        export MP_PGMMODEL=mpmd
        export MP_CMDFILE=${poe_script}
        if [ $machine = WCOSS2 ]; then
            launcher="mpiexec -np $nproc -ppn $nproc --cpu-bind verbose,depth cfp"
        elif [$machine = HERA -o $machine = ORION -o $machine = S4 -o $machine = JET ]; then
            export SLURM_KILL_BAD_EXIT=0
            launcher="srun --export=ALL --multi-prog"
        else
            echo "Cannot submit jobs to scheduler on this machine.  Set USE_CFP=NO and retry."
            exit 1
        fi
        $launcher $MP_CMDFILE
        nc=$((nc+1))
    done
else
    set -x
    while [ $nc -le $ncount_job ]; do
        ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job${nc}
        nc=$((nc+1))
    done
    set -x
fi

# Copy files to desired location
#all commands to copy output files into the correct EVS COMOUT directory
if [ $SENDCOM = YES ]; then
    for MODEL_DIR_PATH in $MET_PLUS_OUT/stat_analysis/$MODELNAME*; do
        for FILE in $MODEL_DIR_PATH/*; do
            cp -v $FILE $COMOUTsmall/.
        done
    done
    for DIR_PATH in $MET_PLUS_OUT/*/pcp_combine/*; do
        DIR=$(echo ${DIR_PATH##*/})
        if [ "$DIR" == "confs" ] || [ "$DIR" == "logs" ] || [ "$DIR" == "tmp" ]; then
            continue
        fi
        mkdir -p $COMOUTsmall/$DIR
        for FILEn in $DIR_PATH/*a24h*; do
            if [ -f "$FILEn" ]; then
                cp -vr $FILEn $COMOUTsmall/${DIR}/.
            fi
        done
    done
fi

# Final Stats Job
if [ "$vhr" -ge "$last_cyc" ]; then
    if [ $SENDCOM = YES ]; then
        export job_type="gather3"
        export njob=1
        source $config
        # Create Output Directories
        python $USHevs/cam/cam_create_output_dirs.py
        status=$?
        [[ $status -ne 0 ]] && exit $status
        [[ $status -eq 0 ]] && echo "Successfully ran cam_create_output_dirs.py ($job_type)"

        # Create Gather 3 Job Script
        python $USHevs/cam/cam_stats_precip_create_job_script.py
        status=$?
        [[ $status -ne 0 ]] && exit $status
        [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_job_script.py ($job_type)"
        export njob=$((njob+1))

        # Create Gather 3 POE Job Scripts
        if [ $USE_CFP = YES ]; then
            python $USHevs/cam/cam_stats_precip_create_poe_job_scripts.py
            status=$?
            [[ $status -ne 0 ]] && exit $status
            [[ $status -eq 0 ]] && echo "Successfully ran cam_stats_precip_create_poe_job_scripts.py ($job_type)"
        fi

        # Run All NAM Nest precip/stats Gather 3 Jobs
        chmod u+x ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/*
        ncount_job=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job* |wc -l)
        nc=1
        if [ $USE_CFP = YES ]; then
            ncount_poe=$(ls -l ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe* |wc -l)
            while [ $nc -le $ncount_poe ]; do
                poe_script=${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/poe_jobs${nc}
                chmod 775 $poe_script
                export MP_PGMMODEL=mpmd
                export MP_CMDFILE=${poe_script}
                if [ $machine = WCOSS2 ]; then
                    launcher="mpiexec -np $nproc -ppn $nproc --cpu-bind verbose,depth cfp"
                elif [ $machine = HERA -o $machine = ORION -o $machine = S4 -o $machine = JET ]; then
                    export SLURM_KILL_BAD_EXIT=0
                    launcher="srun --export=ALL --multi-prog"
                else
                    echo "Cannot submit jobs to scheduler on this machine.  Set USE_CFP=NO and retry."
                    exit 1    
                fi
                $launcher $MP_CMDFILE
                nc=$((nc+1))
            done
        else
            set -x
            while [ $nc -le $ncount_job ]; do
                ${DATA}/${VERIF_CASE}/${STEP}/METplus_job_scripts/${job_type}/job${nc}
                nc=$((nc+1))
            done
            set -x
        fi
    fi
fi

# Cat the METplus log files
log_dirs="$DATA/$VERIF_CASE/METplus_output/*/out/logs"
for log_dir in $log_dirs; do
    if [ -d $log_dir ]; then
        log_file_count=$(find $log_dir -type f | wc -l)
        if [[ $log_file_count -ne 0 ]]; then
            log_files=("$log_dir"/*)
            for log_file in "${log_files[@]}"; do
                if [ -f "$log_file" ]; then
                    echo "Start: $log_file"
                    cat "$log_file"
                    echo "End: $log_file"
                fi
            done
        fi
    fi
done
log_dir="$DATA/$VERIF_CASE/METplus_output/out/logs"
if [ -d $log_dir ]; then
    log_file_count=$(find $log_dir -type f | wc -l)
    if [[ $log_file_count -ne 0 ]]; then
        log_files=("$log_dir"/*)
        for log_file in "${log_files[@]}"; do
            if [ -f "$log_file" ]; then
                echo "Start: $log_file"
                cat "$log_file"
                echo "End: $log_file"
            fi
        done
    fi
fi