# ======================
# BÚSQUEDA EN EXPEDIENTE
# ======================
# 
# Aplicación para la búsqueda de texto en el expediente digitalizado.
# 
# Autor: Cristian Silva Arias (csilva@centrogeo.edu.mx)
# 
# ----------------------
#
# Archivo de configuración del acceso a la base de datos
#

library(RPostgres)

# Configurar el acceso a la base de datos:
con <- dbConnect(Postgres(),
                 host = "localhost",
                 port = 5432,
                 dbname = "ayt-expedientes",
                 user = "postgres")