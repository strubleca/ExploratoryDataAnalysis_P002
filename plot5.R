#' plot5.R
#' 
#' @description
#' Generate a plot answering the fifth question of project 2 for
#' Exploratory Data Analysis on Coursera. The question is
#'
#' How have emissions from motor vehicle sources changed from 1999–2008 
#' in Baltimore City?
#' 
#' @docType package
#' @name plot5
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

# Identify motor vehicle sources. Including Motorcycles as well, since
# the question is somewhat underspecified.
vehicles <- grep("Vehicle", as.character(SCC$SCC.Level.Two), ignore.case=T)

# Get the subset of codes and short names. Transform to characters to make
# sure matching works correctly. Note, Short.Name was being explored to
# plot per source type.
SCCVehicles <- SCC[vehicles,c("SCC", "Short.Name")]
SCCVehicles <- transform(SCCVehicles, SCC=as.character(SCC))
SCCVehicles <- transform(SCCVehicles, Short.Name=as.character(Short.Name))

# Get the total emissions for each year
NEIVehicles <- subset(NEI, SCC %in% SCCVehicles$SCC & fips == "24510")

# Aggregate emissions by year and source, creating an appropriate table.
totalEmissionsByYearAndSource <- aggregate(Emissions ~ year + SCC,
                                         NEIVehicles,
                                         sum)
totalEmissionsByYearAndSource <- merge(totalEmissionsByYearAndSource,
                                       SCCVehicles,
                                       by="SCC")

# We'll add a set of total entries too for plotting
totalEmissionsByYear <- aggregate(Emissions ~ year,
                                  NEIVehicles,
                                  sum)
totalEmissionsByYear$SCC <- "Total"
totalEmissionsByYear$Short.Name <- "Total"
totalEmissionsByYear <- totalEmissionsByYear[,names(totalEmissionsByYearAndSource)]
totalEmissionsByYearAndSource <- rbind(totalEmissionsByYearAndSource,
                                       totalEmissionsByYear)

# Now generate the requested plot using the ggplot2 package.
png("plot5.png", width=960, height=960)

# Create bars by year. Need to convert years to a factor.
yearFactor <- factor(totalEmissionsByYearAndSource$year)
# Divide Emissions by 1000 for a more reasonable scale.
g <- ggplot(totalEmissionsByYearAndSource, aes(yearFactor, Emissions))
p <- g + geom_point() + 
    facet_wrap(~ SCC, as.table=FALSE) +
    labs(title="Fine Particulate Matter Emissions\nMotor Vehicle Sources in Baltimore City, Maryland") +
    labs(x="Year") +
    labs(y=expression("Total " * PM[2.5] * " Emissions (tons)")) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1), 
          text=element_text(size=18))
print(p)

dev.off()

# Change back to the original directory
setwd(originalWorkingDirectory)
