#!/usr/bin/python

###############################################################
# This script defines and calls a function to create a        #
# blank performance diagram, as introduced in Roebber (2009). #
# Commented lines 64-68 provide the syntax for plotting text  #
# and markers on the diagram. This script is provided as is.  #
# Author: Dan Halperin                                        #
###############################################################

#Import necessary modules
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import sys
import subprocess
import os

#Function definition
def get_bias_label_position(bias_value, radius):
  x = np.sqrt(np.power(radius, 2)/(np.power(bias_value, 2)+1))
  y = np.sqrt(np.power(radius, 2) - np.power(x, 2))
  return (x, y)

def performance_diag():
  #INPUT file with CTC line 
  CTCfile01 = os.environ['CTCfile01']
  row = np.loadtxt(CTCfile01, dtype=str, skiprows=1)
  #amodel = row[1:,10]
  #model = np.unique(amodel)
  total = row[1:,11]
  print('Printing total', total)
  hit = np.sum(np.array(row[1:,12], dtype=float))
  print('Printing hit', hit)
  falsea = np.sum(np.array(row[1:,13], dtype=float))
  print('Printing false alarms', falsea)
  miss = np.sum(np.array(row[1:,14], dtype=float))
  print('Printing misses', miss)
  hm = np.sum(np.add(hit, miss, dtype=float))
  print('Printing hit + misses', hm)
  hf = np.sum(np.add(hit, falsea, dtype=float))
  print('Printing hits + false alarms', hf)
  POD = np.sum(np.divide(hit, hm, out = np.zeros_like(hit), where = hm != 0))
  print('Printing POD', POD) #POD = hit/(hit + miss)
  FAR = np.sum(np.divide(hit, hf, out = np.zeros_like(hit), where = hf != 0))
  print('Printing FAR', FAR)  #FAR = falsea/(hit + falsea)
  SUR = 1.0 - FAR
  print('Printing SUR', SUR) #POD1 = POD + 0.03

  CTCfile02 = os.environ['CTCfile02']
  row = np.loadtxt(CTCfile02, dtype=str, skiprows=1)
  total2 = row[1:,11]
  print('Printing total 2', total2)
  hit2 = np.sum(np.array(row[1:,12], dtype=float))
  print('Printing hits 2', hit2)
  falsea2 = np.sum(np.array(row[1:,13], dtype=float))
  print('Printing false alarms 2', falsea2)
  miss2 = np.sum(np.array(row[1:,14], dtype=float))
  print('Printing misses 2', miss2)
  hm2 = np.sum(np.add(hit2, miss2, dtype=float))
  print('Printing hits + misses 2', hm2)
  hf2 = np.sum(np.add(hit2, falsea2, dtype=float))
  print('Printing hits + false alarms 2', hf2)
  POD2 = np.sum(np.divide(hit2, hm2, out = np.zeros_like(hit2), where = hm2 != 0))
  print('Printing POD2', POD2) #POD2 = hit2/(hit2 + miss2)
  FAR2 = np.sum(np.divide(hit2, hf2, out = np.zeros_like(hit2), where = hf2 != 0))
  print('Printing FAR2', FAR2) #FAR2 = falsea2/(hit2 + falsea2)
  SUR2 = 1.0 - FAR2
  print('Printing SUR2', SUR2) 
  #POD2 = POD2 + 0.03

  CTCfile03 = os.environ['CTCfile03']
  row = np.loadtxt(CTCfile03, dtype=str, skiprows=1)
  total3 = row[1:,11]
  print('Printing total 3', total3)
  hit3 = np.sum(np.array(row[1:,12], dtype=float))
  print('Printing hits 3', hit3)
  falsea3 = np.sum(np.array(row[1:,13], dtype=float))
  print('Printing false alarms 3', falsea3)
  miss3 = np.sum(np.array(row[1:,14], dtype=float))
  print('Printing misses 3', miss3)
  hm3 = np.sum(np.add(hit3, miss3, dtype=float))
  print('Printing hit + misses 3', hm3)
  falsea3 = np.sum(np.array(row[1:,13], dtype=float))
  print('Printing false alarms 3', falsea3)
  miss3 = np.sum(np.array(row[1:,14], dtype=float))
  print('Printing misses 3', miss3)
  hm3 = np.sum(np.add(hit3, miss3, dtype=float))
  print('Printing hits + misses 3', hm3)
  hf3 = np.sum(np.add(hit3, falsea3, dtype=float))
  print('Printing hits + false alarms 3', hf3)
  POD3 = np.sum(np.divide(hit3, hm3, out = np.zeros_like(hit3), where = hm3 != 0))
  print('Printing POD3', POD3) #POD3 = hit3/(hit3 + miss3)
  FAR3 = np.sum(np.divide(hit3, hf3, out = np.zeros_like(hit3), where = hf3 != 0))
  print('Printing FAR3', FAR3) #FAR3 = falsea3/(hit3 + falsea3)
  SUR3 = 1.0 - FAR3
  print('Printing SUR3', SUR3)
  SUR3 = 1.0 - FAR3
  #POD3 = POD3 + 0.03
  
  CTCfile04 = os.environ['CTCfile04']
  row = np.loadtxt(CTCfile04, dtype=str, skiprows=1)
  total4 = row[1:,11]
  print('Printing total 4', total4)
  hit4 = np.sum(np.array(row[1:,12], dtype=float))
  print('Printing hits 4', hit4)
  falsea4 = np.sum(np.array(row[1:,13], dtype=float))
  print('Printing false alarms 4', falsea4)
  miss4 = np.sum(np.array(row[1:,14], dtype=float))
  print('Printing misses 4', miss4)
  hm4 = np.sum(np.add(hit4, miss4, dtype=float))
  print('Printing hits + misses 4', hm4)
  falsea4 = np.sum(np.array(row[1:,13], dtype=float))
  print('Printing false alarms 4', falsea4)
  miss4 = np.sum(np.array(row[1:,14], dtype=float))
  print('Printing misses 4', miss4)
  hm4 = np.sum(np.add(hit4, miss4, dtype=float))
  print('Printing hits + misses 4', hm4)
  hf4 = np.sum(np.add(hit4, falsea4, dtype=float))
  print('Printing hits + false alarms 4', hf4)
  POD4 = np.sum(np.divide(hit4, hm4, out = np.zeros_like(hit4), where = hm4 != 0))
  print('Printing POD4', POD4) #POD4 = hit4/(hit4 + miss4)
  FAR4 = np.sum(np.divide(hit4, hf4, out = np.zeros_like(hit4), where = hf4 != 0))
  print('Printing FAR4', FAR4) #FAR4 = falsea4/(hit4 + falsea4)
  SUR4 = 1.0 - FAR4
  print('Printing SUR4', SUR4)
  SUR4 = 1.0 - FAR4
  #POD4 = POD4 + 0.03
  
  #Output file name
  rirw_thresh = os.environ['rirw_thresh']
  #stormBasin = os.environ['stormBasin']
  outf = f"tcrirw_performance_diagram_{rirw_thresh}.png"
  print(outf)
  
  #Define figure, plot axis
  fig = plt.figure(figsize=(8,8))
  ax  = fig.add_axes([0.1, 0.1, 0.8, 0.8])

  #Define range for x, y; create 2D array of x, y values
  x     = np.arange(0.001,1.01,0.01)
  y     = np.arange(0.001,1.01,0.01)
  xi,yi = np.meshgrid(x, y)

  #Calculate bias and CSI; set contour levels
  bias    = yi/xi
  blevs   = [0.1, 0.25, 0.5, 0.75, 1, 1.25, 2.5, 5, 10]
  csi     = 1/( (1/xi) + (1/yi) - 1 )
  csilevs = np.arange(0.1,1,0.1)

  #The second way-Calculate bias and CSI; set contour levels
  grid_ticks = np.arange(0.001, 1.01, 0.01)
  sr_g, pod_g = np.meshgrid(grid_ticks, grid_ticks)
  biasp = pod_g / sr_g
#  csip = 1.0 / (1.0 / sr_g + 1.0 / pod_g - 1.0)
#  csi_cmap="Blues"
#  csi_contour = plt.contourf(sr_g, pod_g, csip, np.arange(0.1, 1.1, 0.1), extend="max", cmap=csi_cmap)
#  cbar = plt.colorbar(csi_contour)
#  csi_label="Critical Success Index"
#  cbar.set_label(csi_label, fontsize=14)

  bias_contour_vals = [0.1, 0.3, 0.6, 1., 1.5, 3., 10.]
  b_contour = plt.contour(sr_g, pod_g, biasp, bias_contour_vals,colors='gray', linestyles='--')
  plt.clabel(
      b_contour, fmt='%1.1f',
      manual=[
          get_bias_label_position(bias_value, .75)
          for bias_value in bias_contour_vals
      ]
  )

  #Axis labels, tickmarks
  ax.set_xlabel('Success Ratio (1 - False Alarm Ratio)',fontsize=12,fontweight='bold')
  ax.set_ylabel('Probability of Detection',fontsize=12,fontweight='bold')
  ax.set_xticks(np.arange(0,1.1,0.1))
  ax.set_yticks(np.arange(0,1.1,0.1))
  plt.setp(ax.get_xticklabels(),fontsize=13)
  plt.setp(ax.get_yticklabels(),fontsize=13)

  #Second y-axis for bias values < 1
#  ax2 = ax.twinx()
#  ax2.set_yticks(blevs[0:5])
#  plt.setp(ax2.get_yticklabels(),fontsize=13)

  #Axis labels for bias values > 1
#  ax.text(0.1,1.015,'10',fontsize=13,va='center',ha='center')
#  ax.text(0.2,1.015,'5',fontsize=13,va='center',ha='center')
#  ax.text(0.4,1.015,'2.5',fontsize=13,va='center',ha='center')
#  ax.text(0.8,1.015,'1.25',fontsize=13,va='center',ha='center')

  #Plot bias and CSI lines at specified contour intervals
#  cbias =  ax.contour(x,y,bias,blevs,colors='black',linewidths=1,linestyles='--')
  ccsi  =  ax.contour(x,y,csi,csilevs,colors='gray',linewidths=1,linestyles='-')
  plt.clabel(ccsi,csilevs,inline=True,fmt='%.1f',fontsize=10,colors='black')

  #for MD in model:
  #    print(MD)

  #Test/sample markers/text
  ax.plot(SUR,POD,marker='o',markersize=10,c='#000000')
  #ax.text(SUR,POD,'GFS',fontsize=10,fontweight='bold',ha='center',va='bottom',color='#000000')

  ax.plot(SUR2,POD2,marker='o',markersize=10,c='#8400C8')
  #ax.text(SUR2,POD2,'HWRF',fontsize=10,fontweight='bold',ha='center',va='bottom',color='#8400C8')

  ax.plot(SUR3,POD3,marker='o',markersize=10,c='#00DC00')
  #ax.text(SUR3,POD3,'HMON',fontsize=10,fontweight='bold',ha='center',va='bottom',color='#00DC00')

  ax.plot(SUR4,POD4,marker='o',markersize=10,c='#56B4E9')
  #ax.text(SUR4,POD4,'CTCX',fontsize=10,fontweight='bold',ha='center',va='bottom',color='#56B4E9')
  
  ax.plot(0.13,0.95,marker='o',markersize=5,c='#000000')
  ax.text(0.16,0.95,'GFS',fontsize=7,fontweight='bold',ha='center',va='center',color='#000000')

  ax.plot(0.22,0.95,marker='o',markersize=5,c='#8400C8')
  ax.text(0.26,0.95,'HWRF',fontsize=7,fontweight='bold',ha='center',va='center',color='#8400C8')

  ax.plot(0.33,0.95,marker='o',markersize=5,c='#00DC00')
  ax.text(0.37,0.95,'HMON',fontsize=7,fontweight='bold',ha='center',va='center',color='#00DC00')

  ax.plot(0.43,0.95,marker='o',markersize=5,c='#56B4E9')
  ax.text(0.47,0.95,'CTCX',fontsize=7,fontweight='bold',ha='center',va='center',color='#56B4E9')

  # Build formal plot title
  full_title = 'RI/RW Performance Diagram' 
  #full_title = formal_stat_name+'\n'
  #full_title = ""
#  if basin == 'al':
#      formal_basin = 'Atlantic'
#  elif basin == 'cp':
#      formal_basin = 'Central Pacific'
#  elif basin == 'ep':
#      formal_basin = 'Eastern Pacific'
#  elif basin == 'wp':
#      formal_basin = 'Western Pacific'
#  if len(plot_info) == 2:
#      full_title = full_title+formal_basin+' Mean\n'
#  else:
#      full_title = full_title + name.title().upper() + ' ' + '(' + basin + str(tc_num) + ' ' + year + ')'
 #full_title = (full_title+'Cycles: '+', '.join(init_hour_list)+', '
 #Valid Hours: '+', '.join(valid_hour_list))
  ax.set_title(full_title)
#  noaa_img = fig.figimage(noaa_logo_img_array,
#  noaa_logo_xpixel_loc, noaa_logo_ypixel_loc,
#  zorder=1, alpha=noaa_logo_alpha)
#  nws_img = fig.figimage(nws_logo_img_array,
#  nws_logo_xpixel_loc, nws_logo_ypixel_loc,
#  zorder=1, alpha=nws_logo_alpha)

  title="Performance Diagram"
  plt.title(title, fontsize=12, fontweight="bold")
  #TCRIRWcases = os.environ['TCRIRWcases']
  #plt.title('Rapid Intensification/Weakening', fontsize=12, fontweight="bold")
 
  #Save, close, and trim whitespace around plot
  #plt.savefig(outf,pad_inches=0.01, orientation='landscape')
  #plt.savefig(outf)  
  plt.savefig(outf, dpi=160, bbox_inches='tight')
  plt.close()
 #subprocess.call("convert -trim "+outf+" "+outf, shell=True)

#Function call
performance_diag()

sys.exit()
