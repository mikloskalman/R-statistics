library(shiny)
library(nycflights13)
library(data.table)
library(ggplot2)

flights <- data.table(flights)

library(stringr)


flights$depart_date <- as.Date(paste(flights$year, flights$month, flights$day,sep='-'),format="%Y-%m-%d")

mindate <- min(flights$depart_date, na.rm = TRUE)
maxdate <- max(flights$depart_date, na.rm = TRUE)

flights$DayOfWeek <- weekdays(flights$depart_date)

flights$DistanceKMs <- flights$distance / 0.62137
flights$depart_time <- paste(str_pad(flights$hour, 2, pad = "0"),str_pad(flights$minute, 2, pad = "0"),sep=':')



flights <- merge(flights, airports, by.x = 'dest', by.y = 'faa')
names(flights)[21]<-"dest_airport_name"
names(flights)[22]<-"dest_lat"
names(flights)[23]<-"dest_lon"
names(flights)[24]<-"dest_alt"
names(flights)[25]<-"dest_tz"
names(flights)[26]<-"dest_dst"
flights <- merge(flights, airlines, by.x = 'carrier', by.y = 'carrier')
names(flights)[27]<-"carrier_name"

flights <- merge(flights, airports, by.x = 'origin', by.y = 'faa')
names(flights)[28]<-"origin_airport_name"
names(flights)[29]<-"origin_lat"
names(flights)[30]<-"origin_lon"
names(flights)[31]<-"origin_alt"
names(flights)[32]<-"origin_tz"
names(flights)[33]<-"origin_dst"


flights <- merge(flights, planes, by.x = 'tailnum', by.y = 'tailnum')


names(flights)[34]<-"plane_year"
names(flights)[35]<-"plane_type"
names(flights)[36]<-"plane_manufacturer"
names(flights)[37]<-"plane_model"
names(flights)[38]<-"plane_engines"
names(flights)[39]<-"plane_seats"
names(flights)[40]<-"plane_speed"
names(flights)[41]<-"plane_engine"

names(flights)[5]<-"year"

#factor origin/dest airport name
flights$origin_airport_name <- factor(flights$origin_airport_name)
flights$dest_airport_name <- factor(flights$dest_airport_name)


#factor DayOfWeek
flights$DayOfWeek <- factor(flights$DayOfWeek)

#factor plane_manufacturer
flights$plane_manufacturer <- factor(flights$plane_manufacturer)

#factor plane_engine
flights$plane_engine <- factor(flights$plane_engine)



shinyServer(function(input, output) {

  

  output$flighttable <- renderDataTable({
    #---------------------- GLOBAL ------------------
    from<-as.Date(input$daterange[1])
    to<-as.Date(input$daterange[2])
    
    min_dist <- as.integer(input$range[1])
    max_dist <- as.integer(input$range[2])
    
    res<- flights[DistanceKMs<max_dist & DistanceKMs>min_dist & depart_date>=from & depart_date<=to]
    #---------------------  GLOBAL --------------------
    
    outputD<-res[,c("depart_date","depart_time","origin_airport_name","dest_airport_name","DistanceKMs","carrier_name","dep_delay","arr_delay"),with=FALSE]
      setorder(outputD,depart_date,depart_time)
      outputD
      
    })
  
  output$carriertable <- renderDataTable({
    #---------------------- GLOBAL ------------------
    from<-as.Date(input$daterange[1])
    to<-as.Date(input$daterange[2])
    
    min_dist <- as.integer(input$range[1])
    max_dist <- as.integer(input$range[2])
    
    res<- flights[DistanceKMs<max_dist & DistanceKMs>min_dist & depart_date>=from & depart_date<=to]
    #---------------------  GLOBAL --------------------
    
      flights_per_carrier <- res[,.N, by=carrier_name]
    
    })
  
  output$airporttable <- renderDataTable({
    #---------------------- GLOBAL ------------------
    from<-as.Date(input$daterange[1])
    to<-as.Date(input$daterange[2])
    
    min_dist <- as.integer(input$range[1])
    max_dist <- as.integer(input$range[2])
    
    res<- flights[DistanceKMs<max_dist & DistanceKMs>min_dist & depart_date>=from & depart_date<=to]
    #---------------------  GLOBAL --------------------
    
    res[,.N, by=dest_airport_name]
    
  })
  
  output$destinationplot<- renderPlot({
    #---------------------- GLOBAL ------------------
    from<-as.Date(input$daterange[1])
    to<-as.Date(input$daterange[2])
    
    min_dist <- as.integer(input$range[1])
    max_dist <- as.integer(input$range[2])
    
    res<- flights[DistanceKMs<max_dist & DistanceKMs>min_dist & depart_date>=from & depart_date<=to]
    #---------------------  GLOBAL --------------------
    
    
    plot_data<-res[, .('average_delay'=mean(arr_delay, na.rm = TRUE)), by = dest_airport_name]
    plot <-ggplot(plot_data , aes(x = dest_airport_name, y = average_delay,fill=dest_airport_name)) + geom_bar(width = 1, stat = "identity") +coord_flip() + xlab("Aiport") + ylab("Average Delay") + ggtitle("Average Delay per Airport")
    
    
    print(plot)
    
  })
  
  output$carrierplot<- renderPlot({
    #---------------------- GLOBAL ------------------
    from<-as.Date(input$daterange[1])
    to<-as.Date(input$daterange[2])
    
    min_dist <- as.integer(input$range[1])
    max_dist <- as.integer(input$range[2])
    
    res<- flights[DistanceKMs<max_dist & DistanceKMs>min_dist & depart_date>=from & depart_date<=to]
    #---------------------  GLOBAL --------------------
    
    plot_data<-res[, .('average_delay'=mean(arr_delay, na.rm = TRUE)), by = carrier_name]
    plot <- ggplot(plot_data , aes(x = carrier_name, y = average_delay,fill=carrier_name)) + geom_bar(width = 1, stat = "identity") +coord_flip() + xlab("Aiport") + ylab("Average Delay") + ggtitle("Average Delay by Carrier")
    
    
    print(plot)
    
  })
  
  output$ontimecarriertable <- renderDataTable({
    #---------------------- GLOBAL ------------------
    from<-as.Date(input$daterange[1])
    to<-as.Date(input$daterange[2])
    
    min_dist <- as.integer(input$range[1])
    max_dist <- as.integer(input$range[2])
    
    res<- flights[DistanceKMs<max_dist & DistanceKMs>min_dist & depart_date>=from & depart_date<=to]
    #---------------------  GLOBAL --------------------
    on_time <- res[arr_delay<=0,.('on_time_count'=.N),by = carrier_name]
    total_flight <- res[,.('total_flights'=.N),by = carrier_name]
    
    flight_stat <- merge(total_flight, on_time, by.x = 'carrier_name', by.y = 'carrier_name')
    
    flight_stat$on_time_ratio=flight_stat$on_time_count*100 / flight_stat$total_flights
    flight_stat
    
    })
  
  output$weekdayplot<- renderPlot({
    #---------------------- GLOBAL ------------------
    from<-as.Date(input$daterange[1])
    to<-as.Date(input$daterange[2])
    
    min_dist <- as.integer(input$range[1])
    max_dist <- as.integer(input$range[2])
    
    res<- flights[DistanceKMs<max_dist & DistanceKMs>min_dist & depart_date>=from & depart_date<=to]
    #---------------------  GLOBAL --------------------
    
    data<-flights[,.('total_flights'=.N),by=DayOfWeek]
    
    plot<- ggplot(data, aes(x=DayOfWeek, y=total_flights,fill=DayOfWeek)) +  geom_bar(width = 1, stat = "identity")
    
    
    print(plot)
    
  })
  
})
