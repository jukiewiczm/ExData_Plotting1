## R script file to draw exercise 2 plot and save it to png 480x480 file

## function for getting the proper data for the exercise
getData <- function() {
        fileName <- "household_power_consumption.txt"
        
        ## how to break this in code so it fits in 80 columns?
        zipFileUrl <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
        zipFileName <- paste0( "./", fileName, ".zip")
        
        ## check existence of the file in current directory
        ## if the file does not exist, try to download it
        ## if this fails, the function will crash on the next instruction
        ## which i believe is just fine
        if( !file.exists(fileName) ) {
                print("Could not find the file.\nTrying to download...")
                
                
                ## im downloading on windows
                download.file(zipFileUrl, 
                              destfile = zipFileName)
                
                ## unzip the file into current directory
                unzip(zipFileName)
                
                ##get rid of zip file
                file.remove(zipFileName)
        }
        
        ## a little piece of data to find the most classes
        inputData <- read.table(fileName, header = T, 
                                sep = ";", nrows = 100, na.strings = "?")
        
        colClasses <- sapply(inputData, class)
        
        ## read the actual data
        ## need to keep column names, as skip != 0 argument looses the header
        colNames <- names(inputData)
        
        ## i could not find a convenient way to read only the data i needed for 
        ## the exercise, so i've found the rows myself and inserted hard coded 
        ## values of skip and nrows here (which is terribly ugly)
        ## any hints on that would be appreciated
        inputData <- read.table("household_power_consumption.txt", header = F, 
                                sep = ";", na.strings = "?", 
                                colClasses = colClasses, 
                                skip = 66637, nrows = 2879)
        
        names(inputData) <- colNames
        
        ## get the date and time from the first two columns, make new column
        ## then drop the old ones
        DateTime <- strptime( paste(inputData$Date, inputData$Time),
                                format = "%d/%m/%Y %H:%M:%S")
        
        inputData <- cbind(DateTime, inputData)
        
        inputData <- subset(inputData, select = -c(Date, Time))
        
        ## return data
        inputData
}

## IMPORTANT NOTE: Despite the "Cz", "Pt" and "So" labels, the plot is actually
## correct. The reason is that i have Polish locale, which i fail to change
## in R Studio. The Cz (Czwartek) goes for Thursday, Pt (Piatek) goes for Friday
## and So (Sobota) goes for Saturday

## actual script content
## set the png device
## using cairo type as it looks a little bit more similar to
## exercise example (i believe the R functions used were actually the same)
## an example from the exercise is also a little more blurred, but i don't think
## that was a part of the task
png("plot2.png", 
    width = 480, 
    height = 480,
    bg = "transparent",
    type = "cairo")

## get the data
inputData <- getData()

## draw plot
plot(inputData$DateTime, inputData$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)")

dev.off()
