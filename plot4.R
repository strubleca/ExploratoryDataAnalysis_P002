#' plot4.R
#' 
#' @description
#' Generate a plot answering the fourth question of project 2 for
#' Exploratory Data Analysis on Coursera. The question is
#'
#' Across the United States, how have emissions from coal combustion-related 
#' sources changed from 1999–2008?
#' 
#' @docType package
#' @name plot4
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

# Identify coal combustion sources
combustion <- grep("Combustion", as.character(SCC$SCC.Level.One))
coal <- grep("Coal", as.character(SCC$SCC.Level.Three))
coalCombustion <- intersect(combustion, coal)

# Get the subset of codes and short names. Transform to characters to make
# sure matching works correctly. 
SCCCoalCombustion <- as.character(SCC$SCC[coalCombustion])

# Get the total emissions for each year
NEICoal <- subset(NEI, SCC %in% SCCCoalCombustion)

# Total emissions by year
totalEmissionsByYear <- aggregate(Emissions ~ year,
                                  NEICoal,
                                  sum)

# Now generate the requested plot using the ggplot2 package.
png("plot4.png", width=480, height=480)

# Create bars by year. Need to convert years to a factor.
yearFactor <- factor(totalEmissionsByYear$year)
# Divide Emissions by 1000 for a more reasonable scale.
g <- ggplot(totalEmissionsByYear, aes(yearFactor, Emissions/1000))
p <- g + geom_bar(stat="identity") + 
    labs(title="Fine Particulate Matter Emissions\nCoal Combustion Sources") +
    labs(x="Year") +
    labs(y=expression("Total " * PM[2.5] * " Emissions (thousands of tons)")) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1), 
          text=element_text(size=12))
print(p)

dev.off()

# Change back to the original directory
setwd(originalWorkingDirectory)
