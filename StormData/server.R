library(shiny)
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(lazyeval))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(xtable))

top_10 <- function(df, group_name, column_name) {
    df %>%
        ungroup() %>%
        select_(interp(~c(grp, col), .values = list(grp = as.name(group_name), col = as.name(column_name)))) %>%
        transmute_(GRP = interp(~grp, grp = as.name(group_name)), VAL = interp(~col, col = as.name(column_name))) %>%
        group_by(GRP) %>%
        summarise_all(funs(sum)) %>%
        arrange(VAL) %>%
        top_n(10, VAL) -> t010
    t010$GRP <- factor(t010$GRP, levels = t010$GRP[order(t010$VAL)])
    return(t010)
}

if(!exists("dfStorm")) {
    dfStorm <- readRDS("data/Events.rds")
}


shinyServer(function(input, output) {
    
    valInput <- eventReactive(input$vActie, {
        switch(input$vColumn,
               "Total damage" = "TOTALDAMAGE",
               "Crop damage" = "CROPDAMAGE",
               "Property damage" = "PROPDAMAGE",
               "Injuries" = "INJURIES",
               "Fatalities" = "FATALITIES")
    }, ignoreNULL = FALSE)
    
    grpInput <- eventReactive(input$vActie, {
        switch(input$vGroup,
               "Year" = "YEAR",
               "Eventtype" = "EVTYPE")
    }, ignoreNULL = FALSE)

    dataInput <- reactive({
        input$vActie
        val <- isolate(valInput())
        grp <- isolate(grpInput())
        top10 <- isolate(top_10(dfStorm, grp, val))
    })
    
    output$vPlot <- renderPlot({
        ylab <- isolate(input$vColumn)
        g <- ggplot(dataInput(), aes(x = GRP, y = VAL, fill = VAL))
        g <- g + theme_bw()
        g <- g + geom_bar(stat = "identity")
        g <- g + coord_flip()
        g <- g + scale_fill_gradient2(low = "purple", high = "blue", guide = F)
        g <- g + labs(x = "", y = ylab, title ="Top 10 harm")
        g <- g + theme(plot.title = element_text(hjust = 0.5))
        g
    })

    output$Type <- renderTable({
        df <- dataInput()
        df <- df[order(df$VAL, decreasing = T),]
        colnames(df) <- isolate(c(input$vGroup, input$vColumn))
        xt <- xtable(df)
        display(xt)[3] <- "d"
        xt
    })
})
