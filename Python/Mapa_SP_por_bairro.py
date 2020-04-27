# -*- coding: utf-8 -*-
"""
Created on Mon Apr 27 04:02:55 2020

@author: Gustavo Varela-Alvarenga

Codigo para criacao do mapa da cidade de Sao Paulo, colorido por bairros.
"""

###############################################################################
# LIBRARIES
###############################################################################

import geopandas as gpd
import matplotlib.pyplot as plt
import numpy as np

###############################################################################
# Importa GeoJSON
###############################################################################

df_bairros = gpd.read_file('https://raw.githubusercontent.com/gu-stat/mapa_sp_bairro/master/geojson/bairros_sp.geojson')

###############################################################################
# Plotar Mapa
###############################################################################

# Mapa Geral
mapa_bairros = df_bairros.plot(figsize = (15, 12), color = "whitesmoke", edgecolor = "lightgrey", linewidth = 0.5)

# Colorir por Bairro
df_bairros[df_bairros["bairros"] == "ZONA CENTRAL"].plot(ax = mapa_bairros , color = "#ebc314", edgecolor = "white", linewidth = 0.5)
df_bairros[df_bairros["bairros"] == "ZONA LESTE"].plot(ax = mapa_bairros , color = "#d06541", edgecolor = "white", linewidth = 0.5)
df_bairros[df_bairros["bairros"] == "ZONA NORTE"].plot(ax = mapa_bairros , color = "#b4dac5", edgecolor = "white", linewidth = 0.5)
df_bairros[df_bairros["bairros"] == "ZONA OESTE"].plot(ax = mapa_bairros , color = "#b688b6", edgecolor = "white", linewidth = 0.5)
df_bairros[df_bairros["bairros"] == "ZONA SUL"].plot(ax = mapa_bairros , color = "#2761a8", edgecolor = "white", linewidth = 0.5)

