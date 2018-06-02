import numpy as np
import matplotlib.pyplot as plt
from collections import OrderedDict
import math as m
import pandas as pd
import ResultModule.util as u

report_tech = pd.read_csv("report_tech.csv")
report_hourly = pd.read_csv("report_hourly.csv")
summary = pd.read_csv("summary.csv")
report_tech_hourly = pd.read_csv("report_tech_hourly.csv")

u.plot_summary_investment(report_tech)

   
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



handles = []
labels = []
for ax in axarr:
    
    new_handles, new_labels = ax.get_legend_handles_labels()
    handles.extend(new_handles)
    labels.extend(new_labels)

by_label = OrderedDict(zip(labels, handles))
f.legend(by_label.values(), by_label.keys(),
         ncol=4,
         loc='lower left',
         bbox_to_anchor=(0.105, -0.04),
         labelspacing=0.2,
         frameon=False)


f.tight_layout()
f.subplots_adjust(bottom=0.12)




subset1 = ['generation conventional',
           'generation renewable',
           'generation storage',
           'Gas to power']

generation_hourly = report_tech_hourly[report_tech_hourly['type'].isin(subset1)]
generation_hourly = generation_hourly[generation_hourly[generation_hourly.columns[1]] == 100]

generation_hourly = u.rescale_values(generation_hourly, 1000)
generation_hourly['hour_set'] = generation_hourly[generation_hourly.columns[5]].apply(lambda x: x[1:]).astype(int)

def hour_to_week(hour):
    week = m.trunc(hour/168) + 1
    return week

generation_hourly['week'] =  generation_hourly['hour_set'].apply(hour_to_week)


generation_hourly_pivot = generation_hourly.pivot_table(
        index='week',
        columns=generation_hourly.columns[4],
        values=generation_hourly.columns[7],
        aggfunc= np.sum)

generation_hourly_pivot.fillna(0, inplace=True)
generation_hourly_pivot = u.rename_and_order_technologies(generation_hourly_pivot)

generation_hourly_pivot.drop(generation_hourly_pivot.index[52], inplace=True)

hourly_demand['hour_set'] = hourly_demand[hourly_demand.columns[4]].apply(lambda x: x[1:]).astype(int)
hourly_demand['week'] =  hourly_demand['hour_set'].apply(hour_to_week)
hourly_demand[hourly_demand.columns[6]] = hourly_demand[hourly_demand.columns[6]].astype(float)

hourly_demand_pivot = hourly_demand.pivot_table(
        index='week',
        values=hourly_demand.columns[6],
        aggfunc= np.sum)



rescaled_hourly_demand_pivot = hourly_demand_pivot.div(1000).drop(hourly_demand_pivot.index[52])

rescaled_hourly_demand_pivot.columns = ['Demand']

f2, ax = plt.subplots()

generation_hourly_pivot.plot.area(ax=ax,
                                  color=map(u.colordict_fuel.get, generation_hourly_pivot.columns),
                                  legend=False)

rescaled_hourly_demand_pivot.plot(ax=ax, color='black', kind='line',
                                  legend=False)
