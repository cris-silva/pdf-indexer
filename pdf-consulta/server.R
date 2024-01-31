
library(shiny)
library(tidyverse)

# Lógica de la aplicación
function(input, output, session) {
  
  # Conectar a la base de datos
  source("conexion.R")
  
  resultados <- reactive({
    
    consulta <- str_glue("SELECT archivo, pagina, ts_headline(contenido, plainto_tsquery('{t}')) AS resultado, ts_headline(contenido, plainto_tsquery('{t}'), 'HighlightAll=true') AS contenido
                         FROM fojas
                         WHERE ts @@ phraseto_tsquery('spanish', '{t}');",
                         t = input$texto_consulta)
    
    # Ejecutar la consulta y mostrar los resultados en una tabla DT:
    dbGetQuery(con, consulta)
                
  }) %>% 
    bindEvent(input$boton_buscar)
  
  output$tabla_resultados <- renderDT({
    
    consulta <- str_glue("SELECT archivo, pagina, ts_headline(contenido, plainto_tsquery('{t}')) AS resultado, ts_headline(contenido, plainto_tsquery('{t}'), 'HighlightAll=true') AS contenido
                         FROM fojas
                         WHERE ts @@ phraseto_tsquery('spanish', '{t}');",
                         t = input$texto_consulta)
    
    # Ejecutar la consulta y mostrar los resultados en una tabla DT:
    resultados() %>%
      select(-contenido) %>% 
      datatable(selection = "single",
                rownames = FALSE)
    
  }) %>%
    bindEvent(input$boton_buscar)
  
  output$consulta_salida <- renderPrint(
    resultados() %>% 
      slice(input$tabla_resultados_rows_selected) %>% 
      pull(contenido)
  )
  
}
