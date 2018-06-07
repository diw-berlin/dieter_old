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


p2g_scen = power['Hydrogen'].unique()

cmap = matplotlib.cm.get_cmap('Blues')
norm =matplotlib.colors.Normalize(vmin=np.min(p2g_scen)-300, vmax=np.max(p2g_scen))

f, ax = plt.subplots()
for i,p2g in enumerate(p2g_scen):
    current_df = power[power['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g))
            )
plt.title('Installed storage power in MW')
f.legend(loc=2, bbox_to_anchor=(0.12,0.84))
f.savefig('output/effect_p2g_power_raw.pdf')

energy = results.EnergyStorages

energy = energy[energy['EV'] == 0]
energy = energy[energy['Heat'] == 0]
energy

p2g_scen = [0,250,500]


f, ax = plt.subplots()
for i,p2g in enumerate(p2g_scen):
    current_df = energy[energy['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g))
            )
plt.title('Installed storage energy in MWh')
f.legend(loc=2, bbox_to_anchor=(0.14,0.84))
f.savefig('output/effect_p2g_energy_raw.pdf')



power = results.PowerStorages

power = select_scen_by_parameter(power, 'Hydrogen', 0)
power = select_scen_by_parameter(power, 'EV', 0)

power


scen = sorted(power['Heat'].unique())

cmap = matplotlib.cm.get_cmap('Reds')
norm =matplotlib.colors.Normalize(vmin=np.min(scen)-100, vmax=np.max(scen))

f, ax = plt.subplots()
for i,heat in enumerate(scen):
    current_df = power[power['Heat'] == heat]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=heat,
            color=cmap(norm(heat))
            )
plt.title('Installed storage power in MW')
f.legend(loc=2, bbox_to_anchor=(0.12,0.84))
f.savefig('output/effect_heat_power_raw.pdf')

energy = results.EnergyStorages

energy = select_scen_by_parameter(energy, 'Hydrogen', 0)
energy = select_scen_by_parameter(energy, 'EV', 0)

energy


scen = sorted(energy['Heat'].unique())

cmap = matplotlib.cm.get_cmap('Reds')
norm =matplotlib.colors.Normalize(vmin=np.min(scen)-100, vmax=np.max(scen))

f, ax = plt.subplots()
for i,heat in enumerate(scen):
    current_df = energy[energy['Heat'] == heat]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=heat,
            color=cmap(norm(heat))
            )
plt.title('Installed storage energy in MW')
f.legend(loc=2, bbox_to_anchor=(0.12,0.84))
f.savefig('output/effect_heat_energy_raw.pdf')

###############################################################################


power = results.PowerStorages

power = select_scen_by_parameter(power, 'Hydrogen', 0)
power = select_scen_by_parameter(power, 'Heat', 0)

power


scen = sorted(power['EV'].unique())

cmap = matplotlib.cm.get_cmap('Greys')
norm =matplotlib.colors.Normalize(vmin=np.min(scen)-5e6, vmax=np.max(scen))

f, ax = plt.subplots()
for i,ev in enumerate(scen):
    current_df = power[power['EV'] == ev]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=ev,
            color=cmap(norm(ev))
            )
plt.title('Installed storage power in MW')
f.legend(loc=2, bbox_to_anchor=(0.12,0.84))
f.savefig('output/effect_ev_power_raw.pdf')

energy = results.EnergyStorages

energy = select_scen_by_parameter(energy, 'Hydrogen', 0)
energy = select_scen_by_parameter(energy, 'Heat', 0)

energy


scen = sorted(energy['EV'].unique())

cmap = matplotlib.cm.get_cmap('Greys')
norm =matplotlib.colors.Normalize(vmin=np.min(scen)-100, vmax=np.max(scen))

f, ax = plt.subplots()
for i,ev in enumerate(scen):
    current_df = energy[energy['EV'] == ev]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=ev,
            color=cmap(norm(ev))
            )
plt.title('Installed storage energy in MW')
f.legend(loc=2, bbox_to_anchor=(0.12,0.84))
f.savefig('output/effect_ev_energy_raw.pdf')


###############################################################################
capacities = results.Capacities

capacities = capacities[capacities['EV'] == 0]
capacities = capacities[capacities['Heat'] == 0]
#capacities = capacities[capacities['Technology'] == 'Solar PV']
capacities

scen = sorted(capacities['Hydrogen'].unique())

markers = ['.','v','x']

cmap = (matplotlib.cm.get_cmap('Oranges'),
        matplotlib.cm.get_cmap('Blues'),
        matplotlib.cm.get_cmap('Greens'))
norm =matplotlib.colors.Normalize(vmin=np.min(scen)-300, vmax=np.max(scen))

f, ax = plt.subplots()
for j,tech in enumerate(['Solar PV','Wind onshore','Wind offshore']):
    for i,p2g in enumerate(scen):

        current_df = capacities[capacities['Hydrogen'] == p2g]
        current_df = current_df[current_df['Technology'] == tech]

        current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

        current_cmap = cmap[j]
        label = str(tech) + ' ' + str(p2g)

        ax.plot(current_df,
                label=label,
                marker=markers[i],
                color=current_cmap(norm(p2g))
                )

plt.title('Installed capacity in MW')
f.legend(loc=2, bbox_to_anchor=(0.12,0.84))
f.savefig('output/effect_p2g_cap_raw.pdf')


###############################################################################

f, ax = plt.subplots()
power = results.PowerStorages


power = power[power['EV'] == 4e6]
power = power[power['Heat'] == 0]

power


p2g_scen = power['Hydrogen'].unique()

cmap = matplotlib.cm.get_cmap('Blues')
norm =matplotlib.colors.Normalize(vmin=np.min(p2g_scen)-300, vmax=np.max(p2g_scen))


for i,p2g in enumerate(p2g_scen):
    current_df = power[power['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g)),
            marker='x'
            )

power = results.PowerStorages


power = power[power['EV'] == 0]
power = power[power['Heat'] == 0]

power


p2g_scen = power['Hydrogen'].unique()

cmap = matplotlib.cm.get_cmap('Blues')
norm =matplotlib.colors.Normalize(vmin=np.min(p2g_scen)-300, vmax=np.max(p2g_scen))


for i,p2g in enumerate(p2g_scen):
    current_df = power[power['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g)),
            marker='o'
            )

plt.title('Installed storage power in MW depend of P2G with EV')
f.legend(loc=2, bbox_to_anchor=(0.12,0.84))
f.savefig('output/effect_p2g_power_with_ev.pdf')


f, ax = plt.subplots()
energy = results.EnergyStorages

energy = energy[energy['EV'] == 4e6]
energy = energy[energy['Heat'] == 0]
energy

p2g_scen = [0,250,500]



for i,p2g in enumerate(p2g_scen):
    current_df = energy[energy['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g)),
            marker='x'
            )

energy = results.EnergyStorages

energy = energy[energy['EV'] == 0]
energy = energy[energy['Heat'] == 0]
energy

p2g_scen = [0,250,500]


for i,p2g in enumerate(p2g_scen):
    current_df = energy[energy['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g)),
            marker='o'
            )


plt.title('Installed storage energy in MWh P2G with EV')
f.legend(loc=2, bbox_to_anchor=(0.14,0.84))
f.savefig('output/effect_p2g_energy_with_ev.pdf')


###############################################################################

f, ax = plt.subplots()
power = results.PowerStorages


power = power[power['EV'] == 0]
power = power[power['Heat'] == 100]

power


p2g_scen = power['Hydrogen'].unique()

cmap = matplotlib.cm.get_cmap('Blues')
norm =matplotlib.colors.Normalize(vmin=np.min(p2g_scen)-300, vmax=np.max(p2g_scen))


for i,p2g in enumerate(p2g_scen):
    current_df = power[power['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g)),
            marker='x'
            )

power = results.PowerStorages


power = power[power['EV'] == 0]
power = power[power['Heat'] == 0]

power


p2g_scen = power['Hydrogen'].unique()

cmap = matplotlib.cm.get_cmap('Blues')
norm =matplotlib.colors.Normalize(vmin=np.min(p2g_scen)-300, vmax=np.max(p2g_scen))


for i,p2g in enumerate(p2g_scen):
    current_df = power[power['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g)),
            marker='o'
            )

plt.title('Installed storage power in MW P2G with Heat')
f.legend(loc=2, bbox_to_anchor=(0.12,0.84))
f.savefig('output/effect_p2g_power_with_heat.pdf')


f, ax = plt.subplots()
energy = results.EnergyStorages

energy = energy[energy['EV'] == 4e6]
energy = energy[energy['Heat'] == 0]
energy

p2g_scen = [0,250,500]



for i,p2g in enumerate(p2g_scen):
    current_df = energy[energy['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g)),
            marker='x'
            )

energy = results.EnergyStorages

energy = energy[energy['EV'] == 0]
energy = energy[energy['Heat'] == 0]
energy

p2g_scen = [0,250,500]


for i,p2g in enumerate(p2g_scen):
    current_df = energy[energy['Hydrogen'] == p2g]

    current_df = pd.pivot_table(current_df, values='Value', index='ResShare', aggfunc=np.sum)

    ax.plot(current_df,
            label=p2g,
            color=cmap(norm(p2g)),
            marker='o'
            )


plt.title('Installed storage energy in MWh P2g with heat')
f.legend(loc=2, bbox_to_anchor=(0.14,0.84))
f.savefig('output/effect_p2g_energy_with_heat.pdf')

###############################################################################

capacities = results.Capacities

capacities = capacities[capacities['EV'] == 0]
capacities = capacities[capacities['Heat'] == 0]
capacities = capacities[capacities['Hydrogen'] == 0]
capacities


capacities = pd.pivot_table(capacities, values='Value', columns='Technology', index='ResShare', aggfunc=np.sum)

capacities


f, ax = plt.subplots()
capacities.plot(kind='bar',stacked=True,ax=ax,legend=False)
