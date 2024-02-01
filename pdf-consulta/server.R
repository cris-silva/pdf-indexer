# ======================
# BÚSQUEDA EN EXPEDIENTE
# ======================
# 
# Aplicación para la búsqueda de texto en el expediente digitalizado.
# 
# Autor: Cristian Silva Arias (cris.silva@me.com)
# 
# ----------------------
#
# Archivo de definición de lógica de aplicación
#

# Paquetes utilizados
library(shiny)
library(tidyverse)

# Lógica de la aplicación
function(input, output, session) {
  
  # Conectar a la base de datos
  source("conexion.R")
  
  # Obtener los resultados de la base de datos al presionar el botón de búsqueda
  resultados <- reactive({
    
    # Preparar la consulta
    consulta <- str_glue("SELECT archivo, pagina, ts_headline(contenido, plainto_tsquery('{t}')) AS resultado, ts_headline(contenido, plainto_tsquery('{t}'), 'HighlightAll=true') AS contenido
                         FROM fojas
                         WHERE ts @@ phraseto_tsquery('spanish', '{t}');",
                         t = input$texto_consulta)
    
    # Ejecutar la consulta y mostrar los resultados en una tabla DT
    dbGetQuery(con, consulta)
                
  }) %>% 
    bindEvent(input$boton_buscar)
  
  # Mostrar los resultados en una tabla
  output$tabla_resultados <- renderDT({
    
    # validate(
    #   need(length(resultados()) > 0, "Escriba un término para buscar y presione el botón [Buscar] para ver los resultados.")
    # )
    
    # Ejecutar la consulta y mostrar los resultados en una tabla DT:
    resultados() %>%
      select(-contenido) %>% 
      datatable(selection = "single",
                rownames = FALSE,
                colnames = c("Archivo", "Página", "Vista previa"),
                escape = FALSE,
                options = list(
                  language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json'),
                  pageLength = 5)
      )
    
  }) %>%
    bindEvent(input$boton_buscar)
  
  output$ubicacion <- renderPrint({
    
    resultado_seleccionado <-
      resultados() %>% 
      slice(input$tabla_resultados_rows_selected)
    
    h4(
      str_glue("Encontrado en {a}, página {p}.",
               a = resultado_seleccionado$archivo,
               p = resultado_seleccionado$pagina)
    )
    
  })
  
  # Mostrar el contenido del resultado seleccionado
  output$contenido_resultado <- renderPrint({
    
    # validate(
    #   need(length(resultados()) > 0, "Seleccione un resultado de la lista para ver el contenido completo de la página.")
    # )
    
    # Extraer el contenido de la fila de resultados seleccionada
    resultados() %>% 
      slice(input$tabla_resultados_rows_selected) %>% 
      pull(contenido)
    
  })
  
}
