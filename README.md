# Códigos para criação de mapas da cidade de São Paulo com divisões por bairro

Este repositório contem códigos em R e em Python para criação de mapas da cidade de São Paulo com divisões por bairro a partir de um shapefile. Após manipulações para adicionar uma coluna 'bairros' no arquivo original, os dados foram exportados para um arquivo GeoJSON.

------
## R
O código principal, [Mapa_SP_por_bairro.R](https://raw.githubusercontent.com/gu-stat/mapa_sp_bairro/master/R/Mapa_SP_por_bairro.R), foi escrito em R. Nele, o arquivo com o shapefile dos distritos da cidade de São Paulo é importado a partir do arquivo ZIP disponível pela Prefeitura de SP. O código também faz o download do dicionário de dados.

A partir desse arquivos, foram criadas duas colunas novas: 'bairros' e 'bairros_fact' (bairros como fatores). 

Os bairros foram inicialmente criados a partir da variavel COD_SUB (Código da Subprefeitura) da seguinte forma:

- Se COD_SUB for 01, 02, 03, 04, 08, ou 10, então bairro é "ZONA OESTE";
- se COD_SUB for 05, 06, ou 07, então bairro é "ZONA NORTE";
- se COD_SUB estiver entre 12 e 20 (inclusive), então bairro é "ZONA SUL";
- se COD_SUB estiver entre 21 e 32 (inclusive), então bairro é "ZONA LESTE";
- Para todos os restantes, bairro é "ZONA SUL".

Após essa classificação, foi possível notar que alguns distritos foram classificados incorretamente (quando comparados com as informações aqui apresentadas: [http://www.mapas-sp.com/bairros.htm](http://www.mapas-sp.com/bairros.htm)). 

Assim, foi feita a seguinte correção a partir da variável COD_DIST (Código do Distrito):

- Se COD_DIST for 14, 35, 45, 54, ou 94, então bairro é "ZONA SUL",
- se COD_DIST for 2 e 62, então bairro é "ZONA OESTE",
- se COD_DIST for 6, 10, ou 56, então bairro é "ZONA CENTRAL",
- se COD_DIST for 21, então bairro é "ZONA NORTE".

Após essa correção, foi possível produzir o seguinte mapa:
![Mapa da Cidade de SP com divisoes por bairro, feito no R.](https://raw.githubusercontent.com/gu-stat/mapa_sp_bairro/master/Mapas/mapa_R.png)

------

## GeoJSON

Os dados finais, com adição das colunas 'bairros' e 'bairros-fact', foram exportados para o arquivo GeoJSON: [bairros_sp](https://raw.githubusercontent.com/gu-stat/mapa_sp_bairro/master/geojson/bairros_sp.geojson).

------
## Python

O arquivo GeoJSON com informações do bairro de SP foi usado para criar o seguinte mapa no [Python](https://raw.githubusercontent.com/gu-stat/mapa_sp_bairro/master/Python/Mapa_SP_por_bairro.py):

![Mapa da Cidade de SP com divisoes por bairro, feito no Python.](https://raw.githubusercontent.com/gu-stat/mapa_sp_bairro/master/Mapas/mapa_Python.png).

# Fontes

------
#### Shapefile

Dados Distritos - Prefeitura de SP [http://dados.prefeitura.sp.gov.br/dataset/distritos](http://dados.prefeitura.sp.gov.br/dataset/distritos)

Arquivo ZIP: [Clique para download](http://dados.prefeitura.sp.gov.br/dataset/af41e7c4-ae27-4bfc-9938-170151af7aee/resource/9e75c2f7-5729-4398-8a83-b4640f072b5d/download/layerdistrito.zip)

Data Acesso: 27/04/2020

Licença: [Creative Commons CCZero](http://opendefinition.org/licenses/cc-zero/)

------
#### CSV com Dicionario das Variaveis

Dados Distritos - Prefeitura de SP [http://dados.prefeitura.sp.gov.br/dataset/distritos](http://dados.prefeitura.sp.gov.br/dataset/distritos)

Arquivo CSV: [Clique para download](http://dados.prefeitura.sp.gov.br/dataset/af41e7c4-ae27-4bfc-9938-170151af7aee/resource/f130b877-5b3d-446f-bf97-f184265b9663/download/dicionariodistritos.zip)

Data Acesso: 27/04/2020

Licença: [Creative Commons CCZero](http://opendefinition.org/licenses/cc-zero/)

