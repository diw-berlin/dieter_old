import ResultModule.dieter_result as result
import matplotlib.pyplot as plt


results = result.DieterResult()

results.Capacities
results.Storages

sto = results.Storages[results.Storages['Technology'] == 'Battery']
sto = sto[sto['Type'] == 'Energy']
sto

col = ['green','yellow','red']
fig, ax = plt.subplots()
for i,ev in enumerate([0,2000000,4000000]):
     current_df = sto[sto['EV'] == ev]
     current_df.plot(x='ResShare', y='Value', ax=ax, kind='scatter', label=ev, color=col[i])

fig.show()


sto2 = results.Storages[results.Storages['Technology'] == 'Battery']
sto2 = sto2[sto2['Type'] == 'Energy']
sto2
col2 = ['darkgreen','green','yellow','orange', 'red', 'darkred']
markers = ['x','.','v']

fig, ax = plt.subplots()
for i,p2g in enumerate([0,100,200,300,400,500]):

    current_df = sto2[sto2['Hydrogen'] == p2g]

    for j,ev in enumerate([0,2000000,4000000]):

        current_df2 = current_df[current_df['EV'] == ev]

        current_df2.plot(x='ResShare', y='Value', ax=ax, kind='scatter', label=p2g, color=col2[i], marker=markers[j])

fig.show()

fig, ax = plt.subplots()

for index, group in results.Capacities.groupby(['Technology']):
    group.plot(x='ResShare', y='Value', kind='scatter', ax=ax, label=index, color=results.dict_FuelColor[index], legend=False)
    print(index)
    print(group['Value'])

fig.show()

solar = results.Capacities[results.Capacities['Technology'] == 'Solar PV']

solar.plot(x='ResShare', y='Value', kind='scatter')
