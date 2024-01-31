
library(shiny)
library(DT)

# Definición de la interfaz de usuario:
fluidPage(

    # Título de la aplicación
    titlePanel("Consulta en expediente"),

    # Barra lateral
    sidebarLayout(
        sidebarPanel(
          
            textInput("texto_consulta",
                      label = "Buscar en el expediente",
                      placeholder = "Palabra o frase a buscar"),
            
            actionButton("boton_buscar",
                         label = "Buscar",
                         icon = icon("search"))
        ),

        # Mostrar la lista de resultados
        mainPanel(
          DTOutput("tabla_resultados"),
          htmlOutput(outputId = "consulta_salida")
        )
    )
)
