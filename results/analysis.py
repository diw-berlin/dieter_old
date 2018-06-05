import ResultModule.dieter_result as result
import matplotlib.pyplot as plt


results = result.DieterResult()

results.Capacities
results.Storages


fig, ax = plt.subplots()

for index, group in results.Capacities.groupby(['Technology']):
    group.plot(x='ResShare', y='Value', kind='scatter', ax=ax, label=index, color=results.dict_FuelColor[index], legend=False)
    print(index)
    print(group['Value'])

fig.show()

solar = results.Capacities[results.Capacities['Technology'] == 'Solar PV']

solar.plot(x='ResShare', y='Value', kind='scatter')
