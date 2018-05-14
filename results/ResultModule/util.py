import matplotlib.pyplot as plt


def stacked_to_pivot_df(df, subset):
    
    df = df[df['Parameter'].isin(subset)]
    
    df_pivot = df.pivot(
        index=df.columns[1],
        columns=df.columns[4],
        values=df.columns[6])
    
    df_pivot.fillna(0, inplace=True)
    
    return df_pivot


subset_dict = {'capacity': ['capacities conventional', 'capacities renewable'],
               'stor_gen': ['capacities storage MW',
                            'capacities power to gas',
                            'capacities gas to power'],
               'stor_cap': ['capacities storage MWh', 'capacities gas storage']
               }

def capacity_per_res_share(df, which):

    subset = subset_dict[which]
    df_pivot = stacked_to_pivot_df(df, subset)

    return df_pivot


def plot_summary_investment(df):

    a = capacity_per_res_share(df, which='capacity')
    b = capacity_per_res_share(df, which='stor_gen')
    c = capacity_per_res_share(df, which='stor_cap')
    
    
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
                title=titles[i])
    

    
    f.legend(ncol=6, loc='lower left', bbox_to_anchor=(0.06, -0.01))
    f.subplots_adjust(bottom=0.16, top=0.96)
     
    
    f.savefig("plot_summary_investment.pdf")