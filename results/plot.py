#import numpy as np
#import matplotlib.pyplot as plt
import pandas as pd
import ResultModule.util as u

report_tech = pd.read_csv("report_tech.csv")
report_tech.iloc[:,-1] = report_tech.iloc[:,-1].div(1000)

u.plot_summary_investment(report_tech)




#plt.bar(stor_capacity_pivot)

report_hourly = pd.read_csv("report_hourly.csv")

report_hourly.fillna(0, inplace=True)

report_hourly[report_hourly.columns[5]] = report_hourly[report_hourly.columns[5]].map(lambda x: x[1:])

report_hourly[report_hourly.columns[5]] = report_hourly[report_hourly.columns[5]].astype(int)



report_hourly_pivot = report_hourly.pivot_table(index=report_hourly.columns[5], columns=report_hourly.columns[4], values=report_hourly.columns[7])

report_hourly_pivot.fillna(0, inplace=True)

report_hourly_pivot
