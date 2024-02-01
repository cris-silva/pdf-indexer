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
# Archivo de definición de la interfaz de usuario
#

# Paquetes utilizados
library(shiny)
library(DT)

# Definición de la interfaz de usuario:
fluidPage(
  
  # Título de la aplicación
  titlePanel("Búsqueda en expediente"),
  
  # Barra lateral
  sidebarLayout(
    sidebarPanel(
      
      # Cuadro de texto para escribir el texto a buscar
      textInput("texto_consulta",
                label = "Buscar en el expediente",
                placeholder = "Palabra o frase a buscar"),
      
      # Botón para iniciar la consulta
      actionButton("boton_buscar",
                   label = "Buscar",
                   icon = icon("search")),
      
      width = 3
    ),
    
    # Mostrar la lista de resultados y el contenido del resultado seleccionado
    mainPanel(
      h2("Resultados"),
      DTOutput("tabla_resultados"),
      hr(),
      h2("Contenido de la página"),
      htmlOutput(outputId = "consulta_salida")
    )
  )
)
