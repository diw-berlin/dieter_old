import ResultModule.dieter_result as result
import matplotlib.pyplot as plt
import matplotlib.colors
import pandas as pd
import numpy as np


results = result.DieterResult()

results.Capacities
results.EnergyStorages
results.PowerStorages

power = results.PowerStorages

power = power[power['EV'] == 0]
power = power[power['Heat'] == 0]
power

p2g_scen = [0,100,200,300,500]

cmap = plt.cm.Blues
norm = matplotlib.colors.Normalize(vmin=0, vmax=500)

markers = ['.','o','v','s','p','+']
f, ax = plt.subplots()
for i,p2g in enumerate(p2g_scen):
    current_df = power[power['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g))
            )

f.legend(loc=2, bbox_to_anchor=(0.12,0.84))


energy = results.EnergyStorages

energy = energy[energy['EV'] == 0]
energy = energy[energy['Heat'] == 0]
energy

p2g_scen = [0,100,200,300,500]

markers = ['.','o','v','s','p','+']
f, ax = plt.subplots()
for i,p2g in enumerate(p2g_scen):
    current_df = energy[energy['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g))
            )

f.legend(loc=2, bbox_to_anchor=(0.14,0.84))
