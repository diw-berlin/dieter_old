import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import gdxr
import os.path
import subprocess



def readGdxFile(filename, parameter):
    if os.path.isfile(filename) is True:
        with gdxr.GdxFile(filename) as file:
            # Read the parameter and convert to usable data frame
            return file.get(parameter).to_frame().reset_index()
    else:
        raise FileNotFoundError('file %s not found' % filename)


def renameColumns(df, mapper):
    df.rename(index=str, columns=mapper, inplace=True)


def renameTechnologies(df, dict):
    df['Technology'].replace(dict, inplace=True)


def convertColToInt(df, column):
    df[column] = pd.to_numeric(df[column]).astype(int)


def scenarioColsToInt(df):
    for col in ['ResShare','EV','Prosumer','Heat','Hydrogen']:
        convertColToInt(df, col)

def extractParameterFromGdx(file, parameter):
    df = readGdxFile(file, parameter)
    renameColumns(df, DieterResult.columns_mapper[parameter])
    renameTechnologies(df, DieterResult.dict_TechRename)
    scenarioColsToInt(df)
    return df


class DieterResult():

    dict_FuelColor = {
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
        'Vessel': (150/255, 255/255, 255/255),
        'Cavern': (0/255, 48/255, 61/255),
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

    dict_TechRename = {'CCGT': 'CCGT',
                       'OCGT': 'OCGT',
                       'nuc': 'Nuclear',
                       'ror': 'Run-of-River',
                       'Alka_p2g': 'Alkaline',
                       'PEM_g2p': 'PEM',
                       'Sto7': 'Sto7',
                       'Sto5': 'PSP',
                       'Sto1': 'Battery',
                       'oil': 'Oil',
                       'wind_off': 'Wind offshore',
                       'wind_on': 'Wind onshore',
                       'bio': 'Biomass',
                       'vessel': 'Vessel',
                       'cavern': 'Cavern',
                       'pv': 'Solar PV',
                       'hc': 'Hard coal',
                       'lig': 'Lignite',
                       'other': 'Other'}


    columns_mapper_generation = {"level_0": "ScenarioNumber",
                                 "level_1": "ResShare",
                                 "level_2": "EV",
                                 "level_3": "Prosumer",
                                 "level_4": "Heat",
                                 "level_5": "Hydrogen",
                                 "level_6": "Technology",
                                 0: "Value"}

    columns_mapper_storage = {"level_0": "ScenarioNumber",
                              "level_1": "Type",
                              "level_2": "ResShare",
                              "level_3": "EV",
                              "level_4": "Prosumer",
                              "level_5": "Heat",
                              "level_6": "Hydrogen",
                              "level_7": "Technology",
                              0: "Value"}

    columns_mapper = {"Portfolio_Generation": columns_mapper_generation,
                      "Portfolio_Storages": columns_mapper_storage}


    def __init__(self):

        subprocess.call('gdxmerge  gdx\summary_scen*.gdx')

        self.Capacities = extractParameterFromGdx("merged.gdx", "Portfolio_Generation")

        self.Storages = extractParameterFromGdx("merged.gdx", "Portfolio_Storages")
