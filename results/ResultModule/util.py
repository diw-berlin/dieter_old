import matplotlib.pyplot as plt

colordict_fuel = {
    'Nuclear': (174/255, 57/255, 63/255),
    'Lignite': (117/255, 73/255, 55/255),
    'Hard coal': (68/255, 54/255, 46/255),
    'CCGT': (229/255, 66/255, 19/255),
    'OCGT': (170/255, 0/255, 0/255),
    'Oil': (39/255, 39/255, 36/255),
    'Biomass': (124/255, 179/255, 66/255),
    'Run-of-River': (13/255, 71/255, 161/255),
    'Wind onshore': (81/255, 137/255, 150/255),
    'Wind offshore': (16/255, 76/255,90/255),
    'Solar PV': (255/255, 235/255, 59/255),
    'Other': (183/255, 199/255, 207/255),
    'Storage': (142/255, 142/255, 181/255),
    'Trade': (149/255, 38/255, 183/255),
    'Sum':  (0, 0, 0),
    'PSP': (103/255, 130/255, 228/255),
    'Sto1': (67/255, 69/255, 102/255),
    'Sto7': (174/255, 18/255, 58/255),
    'Hydrogen vessel': (0/255, 48/255, 61/255),
    'Alkaline': (38/255, 198/255, 218/255),
    'PEM': (0/255, 122/255, 140/255),
    'Investment Generation': (0.121, 0.188, 0.492),
    'Investment Grid': (0.473, 0.629, 0.699),
    'Investment Storage': (0.820, 0.871, 0.989),
    'Generation': (0.301, 0.301, 0.301),
    'O&M': (0.5, 0.5, 0.5),
    'Demand': (0, 0, 0),
    'Infeasibility': (1, 0, 0),
    'Residual Demand': (0, 0, 1),

}

rename_dict = {'CCGT': 'CCGT',
               'OCGT': 'OCGT',
               'nuc': 'Nuclear',
               'ror': 'Run-of-River',
               'Alka_p2g': 'Alkaline',
               'PEM_p2g': 'PEM',
               'Sto7': 'Sto7',
               'Sto5': 'PSP',
               'Sto1': 'Sto1',
               'oil': 'Oil',
               'wind_off': 'Wind offshore',
               'wind_on': 'Wind onshore',
               'bio': 'Biomass',
               'vessel': 'Hydrogen vessel',
               'pv': 'Solar PV',
               'hc': 'Hard coal',
               'lig': 'Lignite',
               'other': 'Other'}

technology_order = ['Nuclear',
                    'Lignite',
                    'Hard coal',
                    'Oil',
                    'CCGT',
                    'OCGT',
                    'Other',
                    'Run-of-River',
                    'Biomass',
                    'Wind offshore',
                    'Wind onshore',
                    'Solar PV',
                    'PSP',
                    'Sto1',
                    'Sto2',
                    'Sto3',
                    'Sto4',
                    'Sto6',
                    'Sto7',
                    'Alkaline',
                    'PEM'
                    ]

scale_dict = {'MW': 1,
              'MWh': 1,
              'GW': 1000,
              'GWh': 1000,
              'TW': 1000000,
              'TWh': 1000000}


def rename_and_order_technologies(df):   
    
    df = df.rename(mapper=rename_dict, axis='columns')
    order = [item for item in technology_order if item in df.columns]
    df = df[order]
    return df

def rescale_values(df, scale):
        
    rescaled_df = df.copy()
    rescaled_df.iloc[:,-1] = df.iloc[:,-1].div(scale)  
    return rescaled_df
    

def stacked_to_pivot_df(df, subset, scale=1):
    
    rescaled_df = rescale_values(df, scale)  
    
    rescaled_df = rescaled_df[rescaled_df['Parameter'].isin(subset)]
    
    df_pivot = rescaled_df.pivot(
        index=rescaled_df.columns[1],
        columns=rescaled_df.columns[4],
        values=rescaled_df.columns[6])
    
    df_pivot.fillna(0, inplace=True)
    df_pivot = rename_and_order_technologies(df_pivot)
    return df_pivot


subset_dict = {'capacity': ['capacities conventional', 'capacities renewable'],
               'stor_gen': ['capacities storage MW',
                            'capacities power to gas',
                            'capacities gas to power'],
               'stor_cap': ['capacities storage MWh', 'capacities gas storage'],
               'generation': ['Yearly energy']
               }

def df_per_res_share(df, which, unit):

    scale = scale_dict[unit]
    subset = subset_dict[which]
    df_pivot = stacked_to_pivot_df(df, subset, scale=scale)

    return df_pivot


def plot_summary_investment(df):

    a = df_per_res_share(df, which='capacity', unit='GW')
    b = df_per_res_share(df, which='stor_gen', unit='GW')
    c = df_per_res_share(df, which='stor_cap', unit='GWh')
    
    
    params = {'legend.fontsize': 8,
              'figure.figsize': (6, 6),
             'axes.labelsize': 8,
             'axes.titlesize': 8,
             'xtick.labelsize': 8,
             'ytick.labelsize': 8}
    plt.rcParams.update(params)
    f = plt.figure()
    ax1 = f.add_subplot(131)
    ax2 = f.add_subplot(132, sharex=ax1, sharey=ax1)
    ax3 = f.add_subplot(133, sharex=ax1)
    axarr = [ax1, ax2, ax3]
    data_arr = [a, b, c]
    titles = ['Generation capacity in GW',
              'Storage generation in GW',
              'Storage energy in GWh']
    
    for i, df in enumerate(data_arr):
        df.plot(kind='bar',
                stacked=True,
                ax=axarr[i],
                legend=False,
                title=titles[i],
                color=map(colordict_fuel.get, df.columns))
    

    
    f.legend(ncol=5, loc='lower left',
             bbox_to_anchor=(0.06, -0.01),
             labelspacing=0.2,
             frameon=False)
    
    f.tight_layout()
    f.subplots_adjust(bottom=0.16, top=0.96)
     
    
    f.savefig("plot_summary_investment.pdf")