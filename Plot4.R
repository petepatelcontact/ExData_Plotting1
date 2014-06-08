#Get Power file from URL
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile="power.zip")

# Read file into data frame by extracting single file from downloaded zip file using unz
powerDf=read.table(unz("power.zip","household_power_consumption.txt"),sep=";",header=TRUE)

# Convert string to date
powerDf$Date=as.Date(powerDf$Date,format="%d/%m/%Y")

# Limit to required two-day period in February, 2007: 1st and 2nd
data=subset(powerDf, Date==as.Date("2007-02-01")|Date==as.Date("2007-02-02"))

# Create time variable by first creating a datetime variable
a=paste(as.character(data$Date),as.character(data$Time),sep=" ")
b=strptime(a,format="%Y-%m-%d %H:%M")
data$Time=b

# Explicity convert character data to numeric for plotting
for (i in 3:9)
{
 data[,i]=as.numeric(as.character(data[,i]))
}

# Create the png file for required Plot4
png("Plot4.png",bg="white")

# Setup page to hold a matrix of 4 plots
par(mfrow=c(2,2))

# Plot 1st of 4 
plot(data$Time,data$Global_active_power,ylab="Global Active Power",type="l",xlab="")

# Plot 2nd of 4
plot(data$Time,data$Voltage,ylab="Voltage",type="l",xlab="datetime")

#Plot 3rd of 4
plot(data$Time,data$Sub_metering_1,ylab="Energy sub metering",type="l",xlab="")
# Create legend for 3rd Plot
plot.xy(xy.coords(data$Time,data$Sub_metering_2),type="l",col="red")
plot.xy(xy.coords(data$Time,data$Sub_metering_3),type="l",col="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),col=c("black","red","blue"))

# plot 4th of 4
plot(data$Time,data$Global_reactive_power,ylab="Global_reactive_power",type="l",xlab="datetime")

# Shut down current device
dev.off()