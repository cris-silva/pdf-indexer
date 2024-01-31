
library(shiny)
library(tidyverse)

# Lógica de la aplicación
function(input, output, session) {
  
  # Conectar a la base de datos
  source("conexion.R")
  
  # resultados <- reactive()
  
  output$tabla_resultados <- renderDT({
    
    consulta <- str_glue("SELECT archivo, pagina, ts_headline(contenido, plainto_tsquery('{t}')) AS resultado, ts_headline(contenido, plainto_tsquery('{t}'), 'HighlightAll=true') AS contenido
                         FROM fojas
                         WHERE ts @@ phraseto_tsquery('spanish', '{t}');",
                         t = input$texto_consulta)
    
    # Ejecutar la consulta y mostrar los resultados en una tabla DT:
    dbGetQuery(con, consulta) %>% 
      datatable(selection = "single",
                rownames = FALSE,
                options = list(
                  columnDefs = list(list(visible = FALSE, targets = c("contenido")))  # Ocultar la columna "contenido"
                )
      )
    
  }) %>%
    bindEvent(input$boton_buscar)
  
  output$consulta_salida <- renderPrint(
    input$tabla_resultados_rows_selected[,1]
  )
  
}
