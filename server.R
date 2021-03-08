server <- function(input, output, session) {
  
  setwd("C:/Users/tdelzantda/Downloads")
  df = read.csv2("logs_fw-3.csv", header=T, sep=";")
  
  
    #Word plot data
    proto <- reactive({
      port = df %>% filter(proto=="")

    })
  
    
      #word frequency barplot
      output$freqPlot <- renderPlot({
        freq <- proto()
        new_df <- freq[1:input$numWords,]
        ggplot(new_df, aes(x=reorder(word, n), y=n, fill = as.factor(word))) +
          geom_bar(stat = "identity", position = "dodge", col= "black") + xlab("Mots") + ylab("Nombre") +
          coord_flip() + scale_fill_hue(c = sample(hues, 1)) + guides(fill=FALSE)
      })
  
}