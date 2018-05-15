#import numpy as np
import matplotlib.pyplot as plt
from collections import OrderedDict
import pandas as pd
import ResultModule.util as u

report_tech = pd.read_csv("report_tech.csv")
report_hourly = pd.read_csv("report_hourly.csv")
summary = pd.read_csv("summary.csv")


u.plot_summary_investment(report_tech)

#def plot_generation_summary(df):
    
df_yearly_generation = u.df_per_res_share(report_tech, which='generation', unit='TWh')


df_yearly_curtailment = u.df_per_res_share(report_tech, which='curtailment', unit='TWh')


gross_demand = summary[summary['Indicator'] == 'energy demand gross']
gross_demand_pivot = gross_demand.pivot_table(index=gross_demand.columns[1],
                                              values=gross_demand.columns[-1]).div(1000000)

total_demand = summary[summary['Indicator'] == 'energy demand gross']
total_demand_pivot = total_demand.pivot_table(index=total_demand.columns[1],
                                              values=total_demand.columns[-1]).div(1000000)

hourly_subset = report_hourly['type'] == 'demand consumers'
hourly_demand = report_hourly[hourly_subset]
one_scenario = df_yearly_generation.index.values[0]
hourly_demand = hourly_demand[hourly_demand[hourly_demand.columns[1]] == one_scenario]
yearly_demand = hourly_demand[report_hourly.columns[-1]].astype(float).sum()/1000000

params = {'legend.fontsize': 8,
          'figure.figsize': (6, 6),
         'axes.labelsize': 8,
         'axes.titlesize': 8,
         'xtick.labelsize': 8,
         'ytick.labelsize': 8}
plt.rcParams.update(params)

f, axarr = plt.subplots(1, 2, sharex=True, sharey=True)


colors1 = map(u.colordict_fuel.get, df_yearly_generation.columns)

df_yearly_generation.plot(kind='bar',
                          ax=axarr[0],
                          stacked=True,
                          color=colors1,
                          legend=False,
                          title='Yearly generation in TWh')

colors2 = map(u.colordict_fuel.get, df_yearly_curtailment.columns)

df_yearly_curtailment.plot(kind='bar',
                           ax=axarr[1],
                           stacked=True,
                           color=colors2,
                           legend=False,
                           title='Yearly curtailment in TWh')

bar_width = 1/len(df_yearly_generation.index)

xmin = 0
xmax = 0

for share in gross_demand_pivot.index.values:
    
    xmin = xmax
    xmax += bar_width

    axarr[0].axhline(y=gross_demand_pivot.loc[share].values[0],
         xmin=xmin,
         xmax=xmax,
         color='black',
         linestyle='--',
         label='Gross demand')

axarr[0].axhline(y=yearly_demand,
         color='black',
         linestyle=':',
         label='Conv. demand')




handles, labels = axarr[0].get_legend_handles_labels()
by_label = OrderedDict(zip(labels, handles))
plt.legend(by_label.values(), by_label.keys(),
           ncol=2,
           loc='upper right',
           bbox_to_anchor=(1.03, 1),
           labelspacing=0.2,
           frameon=False)

f.tight_layout()



#plt.bar(stor_capacity_pivot)

report_hourly = pd.read_csv("report_hourly.csv")

report_hourly.fillna(0, inplace=True)

report_hourly[report_hourly.columns[5]] = report_hourly[report_hourly.columns[5]].map(lambda x: x[1:])

report_hourly[report_hourly.columns[5]] = report_hourly[report_hourly.columns[5]].astype(int)



report_hourly_pivot = report_hourly.pivot_table(index=report_hourly.columns[5], columns=report_hourly.columns[4], values=report_hourly.columns[7])

report_hourly_pivot.fillna(0, inplace=True)

report_hourly_pivot

