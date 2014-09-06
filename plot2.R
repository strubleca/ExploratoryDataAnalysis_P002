#' plot2.R
#' 
#' @description
#' Generate a plot answering the second question of project 2 for
#' Exploratory Data Analysis on Coursera. The question is
#'
#' Have total emissions from PM2.5 decreased in the Baltimore City, 
#' Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system 
#' to make a plot answering this question. 
#' 
#' @docType package
#' @name plot2
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
NEIBaltimore <- subset(NEI, fips == "24510")
totalEmissions <- with(NEIBaltimore, tapply(Emissions, year, sum))

# Now generate the requested plot using the base package.
png("plot2.png", width=480, height=480)
barplot(totalEmissions,
        xlab="Year",
        ylab=expression("Total " * PM[2.5] * " Emissions (tons)"),
        main="Fine Particulate Matter Emissions\nBaltimore City, Maryland")
dev.off()

# Change back to the original directory
setwd(originalWorkingDirectory)
