server <- function(input, output) {
  
  setwd("C:/Users/tdelzantda/Downloads")
  df = read.csv2("logs_fw-3.csv", header=T, sep=";")
  colnames(df)[1] = "id"
  
    #Word plot data
    proto <- reactive({
      if(as.numeric(input$port)==1){
        ports=0:65535
      }else if(as.numeric(input$port)==2){
        ports=0:1023
      }else if(as.numeric(input$port)==3){
        ports=1024:49151
      }else if(as.numeric(input$port)==4){
        ports=49152:65535
        }
      port = df %>% filter(proto %in% input$proto) %>% filter(action %in% input$action) %>% filter(dstport %in% ports )
      
    })
  
    actu <- reactive({
      tab=df %>% filter(proto %in% input$proto2) %>% filter(action %in% input$action2)
      tab=as.data.frame(tab)
    })
    
    ip <- reactive({
      ip = df %>% filter(proto %in% input$proto4) %>% filter(action %in% input$action4) %>% count(ipsrc,sort=T) %>% top_n(5)
    })
    
    topPorts <- reactive({
      ip = ip()
      p=df %>% filter(ipsrc %in% ip$ipsrc)
      p2 = p %>% count(ipsrc,dstport,  sort=T) %>% top_n(10)
    })
    
    
    

    portinf <- reactive ({
      portA = df %>% filter(dstport < 1024 & action=="PERMIT") %>% count(dstport, sort=T) %>% top_n(10)
    })
    
    hues <- c(60:330)
###################################################
###################################################   
###################################################   
    
    
    output$freqProto <- renderPlot({
        X <- proto()
        X = X %>% count(proto)
        ggplot(X, aes(x=proto, y=n, fill = as.factor(proto))) +
          geom_bar(stat = "identity", position = "dodge", col= "black") + xlab("protocole") + ylab("Nombre") +
          coord_flip() + scale_fill_hue(c = sample(hues, 1)) + guides(fill=FALSE)
      })
    
    output$pieProto <- renderPlot({
      X <- proto()
      X = X %>% count(proto) %>% mutate(pourcentage = round(n/sum(n)*100,2))
      ggplot(X, aes(x="", y=n, fill=proto)) +
        geom_bar(stat="identity", width=1, color="white") + 
        coord_polar("y", start=0) +
        theme_void() +
        geom_text(aes(y = n/3 + c(0, cumsum(n)[-length(n)]), 
                      label = pourcentage), size=5)
      
    })
    
    output$tabProto  <- DT::renderDataTable({
      X <- proto()
      X = X %>% select(id, datetime, ipsrc, ipdst, dstport, policyid)
      X
    })
    
    output$tabData  <- DT::renderDataTable({
      df = actu()
      df
      
    })
    
    output$plotTop <- renderPlot({
      ip = ip()
      ggplot(ip, aes(x=ipsrc, y=n, fill = as.factor(ipsrc))) +
        geom_bar(stat = "identity", position = "dodge", col= "black") + xlab("Ip Source") + ylab("Nombre") +
        coord_flip() + scale_fill_hue(c = sample(hues, 1)) + guides(fill=FALSE)
    })
    
    output$plotTop10 <- renderPlot({
      port = portinf()
      ggplot(port, aes(x=dstport, y=n, fill = as.factor(dstport), label=dstport)) +
        geom_bar(stat = "identity", position = "dodge", col= "black") + xlab("Port") + ylab("Nombre") +
        coord_flip() + scale_fill_hue(c = sample(hues, 1)) + guides(fill=FALSE) +
        geom_text(size = 3, position = position_stack(vjust = 0.5))
    })
    
    output$tabport <- renderTable({
      topPorts <- topPorts()
      topPorts
    })
    
    
    
    
    
    ############ visualisation 
    
    
    tab=as.matrix(table(df$ipsrc,df$action))
    
    c1=as.numeric(tab[,1])
    c2=as.numeric(tab[,2])
    
    m=matrix(c(c1,c2), byrow = F, ncol = 2)
    n=as.data.frame(m)
    colnames(n)=c('DENY', 'PERMIT')
    rownames(n)=rownames(tab)
    IP_contact=n$DENY+n$PERMIT
    bdd_visa=cbind(n,IP_contact)
    
    
    #bdd_visa=bdd_visa[order(bdd_visa$IP_contact, decreasing = TRUE),]
    
    bdd_visa=bdd_visa[1:250,]
    index=1:250
    bdd_visa=cbind(bdd_visa,index)
    
    output$visa <- renderPlot({
      
      ggplot(bdd_visa, aes(index, DENY)) + geom_point(colour = "red", size = 1.5, shape=3)+   labs(x = " ", y = "y1") + geom_point(aes(index, PERMIT),size=1.5, colour="blue", shape=1)+geom_vline(xintercept=input$'k1', color = "green", size=1)
      
      
      #  plot(bdd_visa$DENY[1:250],type="p", pch=3,col="red", ylab = "y1")
      
      #  lines(bdd_visa$PERMIT[1:250], type='p', col='blue')
      #      ggplot(port, aes(x=dstport, y=n, fill = as.factor(dstport), label=dstport)) +
      #        geom_bar(stat = "identity", position = "dodge", col= "black") + xlab("Port") + ylab("Nombre") +
      #       coord_flip() + scale_fill_hue(c = sample(hues, 1)) + guides(fill=FALSE) +
      #      geom_text(size = 3, position = position_stack(vjust = 0.5))
    })    
    
    
    
    output$tabvisa  <- renderDataTable({
      X <- bdd_visa[input$'k1',c("DENY","IP_contact")]
      X
    })
    
    
    
    
    
    
    
    
    
    
  
}