#' plot1.R
#' 
#' @description
#' Generate a plot answering the first question of project 2 for
#' Exploratory Data Analysis on Coursera. The question is
#' 
#' Have total emissions from PM2.5 decreased in the United States from 1999 
#' to 2008? Using the base plotting system, make a plot showing the total PM2.5 
#' emission from all sources for each of the years 1999, 2002, 2005, and 2008.
#' 
#' @docType package
#' @name plot1
#' @author Craig Struble <strubleca@@yahoo.com>
#' 
#' NB: This documentation is in roxygen2 format, but won't format as is.

# Read the data. The data is kept in the data subdirectory for clearer
# organization.
NEI <- readRDS("data/summarySCC_PM25.rds") # Be patient!
SCC <- readRDS("data/Source_Classification_Code.rds")

# If it doesn't already exist, create a plots subdirectory and change into
# it. We'll change back to the current working directory at the end.
originalWorkingDirectory <- getwd()
plotsDir <- "plots"
if (!file.exists(plotsDir)) {
    writeLines(paste("Creating plot directory:", plotsDir))
    dir.create(plotsDir)
}
setwd(plotsDir)

# Get the total emissions for each year
totalEmissions <- with(NEI, tapply(Emissions, year, sum))

# Now generate the requested plot using the base package.
png("plot1.png", width=480, height=480)
barplot(totalEmissions / 1000000, # Convert to millions of tons for readability
        xlab="Year",
        ylab=expression("Total " * PM[2.5] * " Emissions (millions of tons)"),
        main="Fine Particulate Matter Emissions, All Sources")
dev.off()

# Change back to the original directory
setwd(originalWorkingDirectory)
