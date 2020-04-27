# ************************************************************************* ----
# Pacotes                                                                   ----
# ************************************************************************* ----

library("dplyr") # para manipular dados

library("ggplot2") # para plotar mapas

library("sf") # para importar os arquivos SHP

library("geojsonio") # para converter para GeoJSON e exportar o arquivo

# ************************************************************************* ----
# Importar Shapefile dos Distritos de SP                                    ----
# ************************************************************************* ----

# FONTE DO SHP: Prefeitura de SP
# http://dados.prefeitura.sp.gov.br/dataset/distritos
# ARQUIVO "Layers - Distritos"
# ULR: http://dados.prefeitura.sp.gov.br/dataset/af41e7c4-ae27-4bfc-9938-170151af7aee/resource/9e75c2f7-5729-4398-8a83-b4640f072b5d/download/layerdistrito.zip
# Data Acesso: 27/04/2020
# Licenca: Creative Commons CCZero http://opendefinition.org/licenses/cc-zero/

# |_ Cria um diretorio local para salvar os arquivos ===========================

local_dir <- "Distritos_SP"

if (!file.exists(local_dir)) {
  dir.create(local_dir)
}

# |_ Faz download e unzip dos arquivos SHP =====================================

url <- "http://dados.prefeitura.sp.gov.br/dataset/af41e7c4-ae27-4bfc-9938-170151af7aee/resource/9e75c2f7-5729-4398-8a83-b4640f072b5d/download/layerdistrito.zip"

file <- paste(local_dir, basename(url), sep='/')

if (!file.exists(file)) {
  download.file(url, file)
  unzip(file, junkpaths = TRUE, exdir=local_dir)
}

# |_ Importa os dados para o R =================================================

## Forneca o nome do arquivo SHP (sem extensao)
file_name <- "DEINFO_DISTRITO"

## Cria nome do layer com base no diretorio salvo e nome do arquivo

layer_name <- paste0("./", local_dir, "/", file_name, ".shp")

## Importa o arquivo SHP (nome: DEINFO_DISTRITO.shp)

mapa_distritos_sp <- sf::st_read(layer_name)

# ************************************************************************* ----
# Importar Dicionario de Variaveis                                          ----
# ************************************************************************* ----

# FONTE DO CSV: Prefeitura de SP
# http://dados.prefeitura.sp.gov.br/dataset/distritos
# ARQUIVO "Dicionário - Distritos"
# ULR: http://dados.prefeitura.sp.gov.br/dataset/af41e7c4-ae27-4bfc-9938-170151af7aee/resource/f130b877-5b3d-446f-bf97-f184265b9663/download/dicionariodistritos.zip
# Data Acesso: 27/04/2020
# Licenca: Creative Commons CCZero http://opendefinition.org/licenses/cc-zero/

# |_ Faz download e unzip dos arquivos CSV =====================================

url_dic <- "http://dados.prefeitura.sp.gov.br/dataset/af41e7c4-ae27-4bfc-9938-170151af7aee/resource/f130b877-5b3d-446f-bf97-f184265b9663/download/dicionariodistritos.zip"

file_dic <- paste(local_dir, basename(url_dic), sep='/')

if (!file.exists(file_dic)) {
  download.file(url_dic, file_dic)
  unzip(file_dic, junkpaths = TRUE, exdir=local_dir)
}

# |_ Importa o dicionario para o R =============================================

#file_name_dic <- "DEINFO_DICIONARIO_DISTRITO_Variáveis.csv"

file_name_dic <- "DEINFO_DICIONARIO_DISTRITO_Vari veis.csv"

dic_name <- paste0("./", local_dir, "/", file_name_dic)

dicionario <- read.csv(dic_name)

dicionario_limpo <- dicionario %>% filter(Arquivo != "")
  

# ************************************************************************* ----
# Manipulacao dos Dados                                                     ----
# ************************************************************************* ----

# |_ Criar Bairros a Partir dos Distritos ======================================

## Para chegar as categorias corretas, foi feita uma comparacao visual do mapa 
## plotado aqui usando COD_SUB (primeiramente) e COD_DIST (em uma segunda 
## avaliacao) como fatores e o mapa disponivel em 
## http://www.mapas-sp.com/bairros.htm (acesso em 27/04/2020).

mapa_bairros_sp <-
  mapa_distritos_sp %>%
  mutate(
    bairros = case_when(
      as.numeric(COD_SUB) %in% c(01,02,03,04,08,10) ~ "ZONA OESTE",
      as.numeric(COD_SUB) %in% seq(12,20) ~ "ZONA SUL",
      as.numeric(COD_SUB) %in% c(05,06,07) ~ "ZONA NORTE",
      as.numeric(COD_SUB) %in% seq(21,32) ~ "ZONA LESTE",
      TRUE ~ "ZONA CENTRAL"
    )
  ) %>%
  mutate(
    bairros = case_when(
      COD_DIST %in% c("14", "35", "45", "54", "94") ~ "ZONA SUL",
      COD_DIST %in% c("2", "62") ~ "ZONA OESTE",
      COD_DIST %in% c("6", "10", "56") ~ "ZONA CENTRAL",
      COD_DIST %in% c("21") ~ "ZONA NORTE",
      TRUE ~ bairros
    )
  ) %>%
  mutate(
    bairros_fact = as.factor(bairros)
  )

# |_ Transformar Base em Formato Proprio para o GGPLOT =========================

## Transforma para SpatialPolygonsDataFrame

map.ggplot.bairros.sp <- as(mapa_bairros_sp, "Spatial")

## Adiciona nova coluna chamada "id" composta dos rownames do SpatialPolygonsDataFrame

map.ggplot.bairros.sp@data$id = row.names(map.ggplot.bairros.sp@data)

## Cria um data frame a partir do objeto espacial (para ser usado no GGPLOT)

df.map.ggplot <- suppressMessages(ggplot2::fortify(map.ggplot.bairros.sp))

## Faz um merge dos dados "fortified" com os dados do objeto espacial 

df.map.ggplot <- dplyr::left_join(df.map.ggplot, map.ggplot.bairros.sp@data, by = "id")

# ************************************************************************* ----
# Mapa de SP por Bairros                                                    ----
# ************************************************************************* ----

ggplot() +
  geom_polygon(
    data = df.map.ggplot,
    mapping = aes(x = long, y = lat, group = group, fill = bairros_fact),
    colour = "white"
  ) + 
  # PLOTA O NUMERO DOS SUBDISTRITOS NO PONTO CENTRAL DE CADA SUBDISTRITO
  # geom_text(
  #   data = df.map.ggplot %>%
  #     group_by(COD_SUB) %>%
  #     summarise(lat = mean(c(max(lat), min(lat))),
  #               long = mean(c(max(long), min(long))))
  #   ,
  #   mapping = aes(x = long, y = lat, label = COD_SUB)
  # ) +
  # PLOTA O NUMERO DOS DISTRITOS NO PONTO CENTRAL DE CADA DISTRITO
  # geom_text(
  #   data = df.map.ggplot %>%
  #     group_by(COD_DIST) %>%
  #     summarise(lat = mean(c(max(lat), min(lat))),
  #               long = mean(c(max(long), min(long))))
  #   ,
  #   mapping = aes(x = long, y = lat, label = COD_DIST)
  # ) +
  # CORES PARA BATER COM O GRAFICO EM http://www.mapas-sp.com/bairros.htm
  scale_fill_manual(
    values = c("#ebc314", "#d06541", "#b4dac5", "#b688b6", "#2761a8"),
    aesthetics = "fill"
  ) +
  ggtitle("Mapa dos bairros de SP criado no R") +
  theme_void()

# ************************************************************************* ----
# Exporta Spatial Data para GeoJSON                                         ----
# ************************************************************************* ----

## Transforma para GeoJSON
map.ggplot.bairros.sp_json <- geojson_json(map.ggplot.bairros.sp)

## Exporta

export_name <- paste0("./", local_dir, "/bairros_sp.geojson")

geojson_write(map.ggplot.bairros.sp_json, file = export_name)