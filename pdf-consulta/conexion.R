library(RPostgres)

# Configurar el acceso a la base de datos:
con <- dbConnect(Postgres(),
                 host = "localhost",
                 port = 5432,
                 dbname = "ayt-expedientes",
                 user = "postgres")