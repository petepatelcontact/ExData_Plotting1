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

# Explicitly convert character data to numeric for plotting
for (i in 3:9)
{
 data[,i]=as.numeric(as.character(data[,i]))
}

# Create the png file for required Plot2
png("Plot1.png",bg="white")

# Plot 1
hist(data$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")

# Shut down current device
dev.off()