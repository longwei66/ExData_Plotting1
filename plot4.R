## =========================================================================
## plot1.R script :
## - load the Individual household electric power consumption Data Set
##
## the dataset should be previously downloaded and unzip in working directory
## - household_power_consumption.txt 
##
## [0]  Load the dataset into R
##      - check memory available vs. object size
##      - load the data, subset the dates needed
##      - convert the Date and Time variables to Date/Time classes, create
##        one more variable day.time of class "POSIXlt" "POSIXt"
##
##
## [4]  Create plot4.png - Tiled 4 graph as in the example chunk-5
##

## ========================================================================== 
## [0]  Load the dataset into R
## --------------------------------------------------------------------------
## 0.1  calculate a rough estimate of how much memory the dataset will 
##      require in memory before reading into R. Make sure your computer
##      has enough memory (most modern computers should be fine).
##      The dataset has 2,075,259 rows and 9 columns. 
##
##      Input your computer RAM in Mo
##      nb : I didn't find equivalent of memory.limit() for linux (I use linux)
myRam <- 1000

##      Quick check of object size in Mo : 8bit per 2075259 obs in 9 variables
dataSetSize <- 8*2075259*9 / 2^20

##      Stop the script if object uses more than 80% of your RAM
if (dataSetSize > myRam*0.8) {
    stop(paste("object size >",round(dataSetSize), "Mo"))
}

## --------------------------------------------------------------------------
## 0.2  We will only be using data from the dates 2007-02-01
##      and 2007-02-02. 
##      One alternative is to read the data from just those dates rather than
##      reading in the entire dataset and subsetting to those dates.
##      I decided to read the whole file, as the object is not that big
power <- read.csv("./household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?", stringsAsFactors=FALSE)

#       subset the dates we need 
power <- power[power$Date == "1/2/2007" | power$Date == "2/2/2007",]

## --------------------------------------------------------------------------
## 0.3  convert the Date and Time variables to Date/Time classes in R using
##      the `strptime()` and `as.Date()` functions.
##      create one more variable day.time of class "POSIXlt" "POSIXt"
power$day.time <- strptime(paste(power$Date, power$Time), format = "%d/%m/%Y %H:%M:%S")



## ========================================================================== 
## [2]  Create plot3.png - Evolution of the 3 energy subsystems metering vs.time
## --------------------------------------------------------------------------
##      Set locale to us to get proper date formatting in plot
##      if your system is not in english or american, you have to donwload locale first
##      These parameters work for linux but for windows try with :
##      Sys.setlocale(category = "LC_ALL", locale = "US_us")
Sys.setlocale(category = "LC_ALL", locale = "en_US.UTF-8")

##      Open a PNG device to construct the plot and save it to a PNG file
##      with a width of 480 pixels and a height of 480 pixels, transparent backgroundpng(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")

##      Create the 2x2 tiled chart to be filled by row
par(mfrow = c(2,2))

with(power, {
    # top left chart - see plot2
    plot(x = day.time, y = Global_active_power, col = "black", ylab = "Global Active Power", xlab = " ", type = "l", cex.lab = 0.98, cex.axis = 0.98, cex.main = 1.15)

    # top right chart - Voltage vs. time
    plot(x = day.time, y = Voltage, col = "black", ylab = "Voltage", xlab = "datetime", type = "l", cex.lab = 0.98, cex.axis = 0.98, cex.main = 1.15)
    
    # bottom left - global active power - per submetering, see plot 2
    plot(x = day.time, y = Global_active_power, col = "black", ylab = "Energy sub metering", xlab = " ", type = "n", cex.lab = 0.98, cex.axis = 0.98, cex.main = 1.15, ylim = c(0,38))
    lines(day.time, Sub_metering_1)
    lines(day.time, Sub_metering_2, col = "red")
    lines(day.time, Sub_metering_3, col = "blue")
    legend("topright", col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1), cex = 0.95, bty = "n")

    
    # bottom right global reactie power vs. time
    plot(x = day.time, y = Global_reactive_power, col = "black", ylab = "Global_reactive_power", xlab = "datetime", type = "l", cex.lab = 0.98, cex.axis = 0.98, cex.main = 1.15)
    })

##      Close the device to write the file
dev.off()