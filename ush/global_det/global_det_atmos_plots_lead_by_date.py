'''
Name: global_det_atmos_plots_lead_by_date.py
Contact(s): Mallory Row
Abstract: This script generates a lead by date plot.
'''

import sys
import os
import logging
import datetime
import glob
import subprocess
import pandas as pd
pd.plotting.deregister_matplotlib_converters()
#pd.plotting.register_matplotlib_converters()
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import matplotlib.dates as md
import global_det_atmos_util as gda_util
import matplotlib.gridspec as gridspec
from global_det_atmos_plots_specs import PlotSpecs

class LeadByDate:
    """
    Create a lead by date graphic
    """
 
    def __init__(self, logger, input_dir, output_dir, model_info_dict,
                 date_info_dict, plot_info_dict, met_info_dict, logo_dir):
        """! Initalize LeadByDate class

             Args:
                 logger          - logger object
                 input_dir       - path to input directory (string)
                 output_dir      - path to output directory (string)
                 model_info_dict - model infomation dictionary (strings)
                 plot_info_dict  - plot information dictionary (strings)
                 date_info_dict  - date information dictionary (strings)
                 met_info_dict   - MET information dictionary (strings)
                 logo_dir        - directory with logo images (string)
 
             Returns:
        """
        self.logger = logger
        self.input_dir = input_dir
        self.output_dir = output_dir
        self.model_info_dict = model_info_dict
        self.date_info_dict = date_info_dict
        self.plot_info_dict = plot_info_dict
        self.met_info_dict = met_info_dict
        self.logo_dir = logo_dir

    def make_lead_by_date(self):
        """! Create the lead_by_date graphic

             Args:

             Returns:
        """
        self.logger.info(f"Creating time series...")
        self.logger.debug(f"Input directory: {self.input_dir}")
        self.logger.debug(f"Output directory: {self.output_dir}")
        self.logger.debug(f"Model information dictionary: "
                          +f"{self.model_info_dict}")
        self.logger.debug(f"Date information dictionary: "
                          +f"{self.date_info_dict}")
        self.logger.debug(f"Plot information dictionary: "
                          +f"{self.plot_info_dict}")
        # Make job image directory
        output_image_dir = os.path.join(self.output_dir, 'images')
        if not os.path.exists(output_image_dir):
            os.makedirs(output_image_dir)
        self.logger.info(f"Plots will be in: {output_image_dir}")
        # Create dataframe for all forecast hours
        self.logger.info("Building dataframe for all forecast hours")
        forecast_hours_df_dict = {}
        for forecast_hour in self.date_info_dict['forecast_hours']:
            self.logger.debug(f"Building data for {forecast_hour}")
            # Get dates to plot
            self.logger.info("Creating valid and init date arrays")
            valid_dates, init_dates = gda_util.get_plot_dates(
                self.logger,
                self.date_info_dict['date_type'],
                self.date_info_dict['start_date'],
                self.date_info_dict['end_date'],
                self.date_info_dict['valid_hr_start'],
                self.date_info_dict['valid_hr_end'],
                self.date_info_dict['valid_hr_inc'],
                self.date_info_dict['init_hr_start'],
                self.date_info_dict['init_hr_end'],
                self.date_info_dict['init_hr_inc'],
                forecast_hour
            )
            format_valid_dates = [valid_dates[d].strftime('%Y%m%d_%H%M%S') \
                                  for d in range(len(valid_dates))]
            format_init_dates = [init_dates[d].strftime('%Y%m%d_%H%M%S') \
                                 for d in range(len(init_dates))]
            if self.date_info_dict['date_type'] == 'VALID':
                self.logger.debug("Based on date information, plot will display "
                                  +"valid dates "+', '.join(format_valid_dates)+" "
                                  +"for forecast hour "
                                  +f"{forecast_hour} with initialization dates "
                                  +', '.join(format_init_dates))
                plot_dates = valid_dates
            elif self.date_info_dict['date_type'] == 'INIT':
                self.logger.debug("Based on date information, plot will display "
                                  +"initialization dates "
                                  +', '.join(format_init_dates)+" "
                                  +"for forecast hour "
                                  +f"{forecast_hour} with valid dates "
                                  +', '.join(format_valid_dates))
                plot_dates = init_dates
            # Read in data
            self.logger.info(f"Reading in model stat files from {self.input_dir}")
            all_model_df = gda_util.build_df(
                self.logger, self.input_dir, self.output_dir,
                self.model_info_dict, self.met_info_dict,
                self.plot_info_dict['fcst_var_name'],
                self.plot_info_dict['fcst_var_level'],
                self.plot_info_dict['fcst_var_thresh'],
                self.plot_info_dict['obs_var_name'],
                self.plot_info_dict['obs_var_level'],
                self.plot_info_dict['obs_var_thresh'],
                self.plot_info_dict['line_type'],
                self.plot_info_dict['grid'],
                self.plot_info_dict['vx_mask'],
                self.plot_info_dict['interp_method'],
                self.plot_info_dict['interp_points'],
                self.date_info_dict['date_type'],
                plot_dates, format_valid_dates,
                str(forecast_hour)
            )
            # Calculate statistic
            #self.logger.info(f"Calculating statstic {self.plot_info_dict['stat']} "
            #                 +f"from line type {self.plot_info_dict['line_type']}")
            #stat_df, stat_array = gda_util.calculate_stat(
            #    self.logger, all_model_df, self.plot_info_dict['line_type'],
            #    self.plot_info_dict['stat']
            #)
            #if self.plot_info_dict['event_equalization'] == 'YES':
            #    self.logger.debug("Doing event equalization")
            #    masked_stat_array = np.ma.masked_invalid(stat_array)
            #    stat_array = np.ma.mask_cols(masked_stat_array)
            #    stat_array = stat_array.filled(fill_value=np.nan)
            forecast_hours_df_dict[forecast_hour] = all_model_df
        forecast_hours_df = pd.concat(forecast_hours_df_dict)
        # Set up plot
        self.logger.info(f"Doing plot set up")
        plot_specs_ts = PlotSpecs(self.logger, 'lead_by_date')
        plot_specs_ts.set_up_plot()
        nsubplots = len(list(self.model_info_dict.keys()))
        if nsubplots == 1:
            gs_row, gs_col = 1, 1
            gs_hspace, gs_wspace = 0, 0
            gs_bottom, gs_top = 0.175, 0.825
        elif nsubplots == 2:
            gs_row, gs_col = 1, 2
            gs_hspace, gs_wspace = 0, 0.1
            gs_bottom, gs_top = 0.175, 0.825
        elif nsubplots > 2 and nsubplots <= 4:
            gs_row, gs_col = 2, 2
            gs_hspace, gs_wspace = 0.15, 0.1
            gs_bottom, gs_top = 0.125, 0.9
        elif nsubplots > 4 and nsubplots <= 6:
            gs_row, gs_col = 3, 2
            gs_hspace, gs_wspace = 0.15, 0.1
            gs_bottom, gs_top = 0.125, 0.9
        elif nsubplots > 6 and nsubplots <= 8:
            gs_row, gs_col = 4, 2
            gs_hspace, gs_wspace = 0.175, 0.1
            gs_bottom, gs_top = 0.125, 0.9
        elif nsubplots > 8 and nsubplots <= 10:
            gs_row, gs_col = 5, 2
            gs_hspace, gs_wspace = 0.225, 0.1
            gs_bottom, gs_top = 0.125, 0.9
        else:
            self.logger.error("TOO MANY SUBPLOTS REQUESTED, MAXIMUM IS 10")
            sys.exit(1)
        if nsubplots <= 2:
            plot_specs_ts.fig_size = (14., 7.)
        if nsubplots >= 2:
            n_xticks = 8
        else:
            n_xticks = 17
        if len(self.date_info_dict['forecast_hours']) < n_xticks:
            xtick_intvl = 1
        else:
            xtick_intvl = int(len(self.date_info_dict['forecast_hours'])
                              /n_xticks)
        n_yticks = 5
        if len(plot_dates) < n_xticks:
            ytick_intvl = 1
        else:
            ytick_intvl = int(len(plot_dates)/n_yticks)
        date_intvl = int((plot_dates[1]-plot_dates[0]).total_seconds())
        stat_plot_name = plot_specs_ts.get_stat_plot_name(
             self.plot_info_dict['stat']
        )
        fcst_units = all_model_df['FCST_UNITS'].values.astype('str')
        nan_idxs = np.where(fcst_units == 'nan')
        fcst_units = np.unique(np.delete(fcst_units, nan_idxs))
        if len(fcst_units) > 1:
            self.logger.error("DIFFERING UNITS")
            sys.exit(1)
        elif len(fcst_units) == 0:
            self.logger.warning("Empty dataframe")
            fcst_units = ['']
        plot_title = plot_specs_ts.get_plot_title(
            self.plot_info_dict, self.date_info_dict,
            fcst_units[0]
        )
        plot_left_logo = False
        plot_left_logo_path = os.path.join(self.logo_dir, 'noaa.png')
        if os.path.exists(plot_left_logo_path):
            plot_left_logo = True
            left_logo_img_array = matplotlib.image.imread(
                plot_left_logo_path
            )
            left_logo_xpixel_loc, left_logo_ypixel_loc, left_logo_alpha = (
                plot_specs_ts.get_logo_location(
                    'left', plot_specs_ts.fig_size[0],
                    plot_specs_ts.fig_size[1], plt.rcParams['figure.dpi']
                )
            )
        plot_right_logo = False
        plot_right_logo_path = os.path.join(self.logo_dir, 'nws.png')
        if os.path.exists(plot_right_logo_path):
            plot_right_logo = True
            right_logo_img_array = matplotlib.image.imread(
                plot_right_logo_path
            )
            right_logo_xpixel_loc, right_logo_ypixel_loc, right_logo_alpha = (
                plot_specs_ts.get_logo_location(
                    'right', plot_specs_ts.fig_size[0],
                    plot_specs_ts.fig_size[1], plt.rcParams['figure.dpi']
                )
            )
        image_name = plot_specs_ts.get_savefig_name(
            output_image_dir, self.plot_info_dict, self.date_info_dict
        )
        # Create plot
        self.logger.info(f"Creating plot for {self.plot_info_dict['stat']} ")
        fig = plt.figure(figsize=(plot_specs_ts.fig_size[0],
                                  plot_specs_ts.fig_size[1]))
        gs = gridspec.GridSpec(gs_row, gs_col,
                               bottom=gs_bottom, top=gs_top,
                               hspace=gs_hspace, wspace=gs_wspace)
        fig.suptitle(plot_title)
        if plot_left_logo:
            left_logo_img = fig.figimage(
                left_logo_img_array,
                left_logo_xpixel_loc - (left_logo_xpixel_loc * 0.5),
                left_logo_ypixel_loc, zorder=1, alpha=right_logo_alpha
            )
            left_logo_img.set_visible(True)
        if plot_right_logo:
            right_logo_img = fig.figimage(
                right_logo_img_array, right_logo_xpixel_loc,
                right_logo_ypixel_loc, zorder=1, alpha=right_logo_alpha
            )
        subplot_num = 1
        while subplot_num <= nsubplots:
            ax = plt.subplot(gs[subplot_num-1])
            ax.grid(True)
            ax.set_xlim([self.date_info_dict['forecast_hours'][0],
                          self.date_info_dict['forecast_hours'][-1]])
            ax.set_xticks(self.date_info_dict['forecast_hours'][::xtick_intvl])
            if ax.is_last_row() \
                    or (nsubplots % 2 != 0 and subplot_num == nsubplots -1):
                ax.set_xlabel('Forecast Hour')
            else:
                plt.setp(ax.get_xticklabels(), visible=False)
            ax.set_ylim([plot_dates[0], plot_dates[-1]])
            ax.set_yticks(plot_dates[::ytick_intvl])
            if date_intvl != 86400:
                ax.yaxis.set_major_formatter(md.DateFormatter('%d%b%Y %HZ'))
                if len(plot_dates) < 10:
                    ax.yaxis.set_minor_locator(md.HourLocator())
                else:
                    ax.yaxis.set_minor_locator(md.DayLocator())
            else:
                ax.yaxis.set_major_formatter(md.DateFormatter('%d%b%Y'))
                if len(plot_dates) < 60:
                    ax.yaxis.set_minor_locator(md.DayLocator())
                else:
                    ax.yaxis.set_minor_locator(md.MonthLocator())
            if ax.is_first_col():
                ax.set_ylabel(self.date_info_dict['date_type'].title()+' Date')
            else:
                plt.setp(ax.get_yticklabels(), visible=False)
            if subplot_num == 1:
                ax.set_title(
                    self.model_info_dict['model'+str(subplot_num)]['plot_name']
                )
            else:
                ax.set_title(
                    self.model_info_dict['model'+str(subplot_num)]['plot_name']
                    +'-'+self.model_info_dict['model1']['plot_name']
                )
            subplot_num+=1
        self.logger.info("Saving image as "+image_name)
        plt.savefig(image_name)
        plt.clf()
        plt.close('all')

def main():
    # Need settings
    INPUT_DIR = os.environ['HOME']
    OUTPUT_DIR = os.environ['HOME']
    LOGO_DIR = os.environ['HOME'],
    MODEL_INFO_DICT = {
        'model1': {'name': 'MODEL_A',
                   'plot_name': 'PLOT_MODEL_A',
                   'obs_name': 'MODEL_A_OBS'},
    }
    DATE_INFO_DICT = {
        'date_type': 'DATE_TYPE',
        'start_date': 'START_DATE',
        'end_date': 'END_DATE',
        'valid_hr_start': 'VALID_HR_START',
        'valid_hr_end': 'VALID_HR_END',
        'valid_hr_inc': 'VALID_HR_INC',
        'init_hr_start': 'INIT_HR_START',
        'init_hr_end': 'INIT_HR_END',
        'init_hr_inc': 'INIT_HR_INC',
        'forecast_hours': ['FORECAST_HOURS']
    }
    PLOT_INFO_DICT = {
        'line_type': 'LINE_TYPE',
        'grid': 'GRID',
        'stat': 'STAT',
        'vx_mask': 'VX_MASK',
        'event_equalization': 'EVENT_EQUALIZATION',
        'interp_method': 'INTERP_METHOD',
        'interp_points': 'INTERP_POINTS',
        'fcst_var_name': 'FCST_VAR_NAME',
        'fcst_var_level': 'FCST_VAR_LEVEL',
        'fcst_var_thresh': 'FCST_VAR_THRESH',
        'obs_var_name': 'OBS_VAR_NAME',
        'obs_var_level': 'OBS_VAR_LEVEL',
        'obs_var_thresh': 'OBS_VAR_THRESH',
    }
    MET_INFO_DICT = {
        'root': '/PATH/TO/MET',
        'version': '10.1.1'
    }
    # Create OUTPUT_DIR
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
    # Set up logging
    logging_dir = os.path.join(OUTPUT_DIR, 'logs')
    if not os.path.exists(logging_dir):
         os.makedirs(logging_dir)
    job_logging_file = os.path.join(logging_dir, 
                                    os.path.basename(__file__)+'_runon'
                                    +datetime.datetime.now()\
                                    .strftime('%Y%m%d%H%M%S')+'.log')
    logger = logging.getLogger(job_logging_file)
    logger.setLevel('DEBUG')
    formatter = logging.Formatter(
        '%(asctime)s.%(msecs)03d (%(filename)s:%(lineno)d) %(levelname)s: '
        + '%(message)s',
        '%m/%d %H:%M:%S'
    )
    file_handler = logging.FileHandler(job_logging_file, mode='a')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger_info = f"Log file: {job_logging_file}"
    print(logger_info)
    logger.info(logger_info)
    p = LeadAverage(logger, INPUT_DIR, OUTPUT_DIR, MODEL_INFO_DICT,
                    DATE_INFO_DICT, PLOT_INFO_DICT, MET_INFO_DICT, LOGO_DIR)
    p.make_lead_average()

if __name__ == "__main__":
    main()
