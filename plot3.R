#' plot3.R
#' 
#' @description
#' Generate a plot answering the second question of project 2 for
#' Exploratory Data Analysis on Coursera. The question is
#'
#' Of the four types of sources indicated by the type (point, nonpoint, onroad, 
#' nonroad) variable, which of these four sources have seen decreases in 
#' emissions from 1999–2008 for Baltimore City? Which have seen increases in 
#' emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
#' answer this question.
#' 
#' @docType package
#' @name plot3
#' @author Craig Struble <strubleca@@yahoo.com>
#' 
#' NB: This documentation is in roxygen2 format, but won't format as is.

# Make sure ggplot2 is available.
library(ggplot2)

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

# Aggregate emissions by year and type, creating an appropriate table.
totalEmissionsByYearAndType <- aggregate(Emissions ~ year + type,
                                         NEIBaltimore,
                                         sum)

# Now generate the requested plot using the ggplot2 package.
png("plot3.png", width=480, height=480)

g <- ggplot(totalEmissionsByYearAndType, aes(year, Emissions))
p <- g + geom_line(aes(color=type)) + 
    labs(title="Fine Particulate Matter Emissions\nBaltimore City, Maryland") +
    labs(x="Year") +
    labs(y=expression("Total " * PM[2.5] * " Emissions (tons)")) +
    scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
print(p)
dev.off()

# Change back to the original directory
setwd(originalWorkingDirectory)
