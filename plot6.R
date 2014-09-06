#' plot6.R
#' 
#' @description
#' Generate a plot answering the sixth question of project 2 for
#' Exploratory Data Analysis on Coursera. The question is
#'
#' Compare emissions from motor vehicle sources in Baltimore City with 
#' emissions from motor vehicle sources in Los Angeles County, California 
#' (fips == "06037"). Which city has seen greater changes over time in motor
#' vehicle emissions?
#' 
#' @docType package
#' @name plot6
#' @author Craig Struble <strubleca@@yahoo.com>
#' 
#' NB: This documentation is in roxygen2 format, but won't format as is.

# Make sure ggplot2 is available.
library(ggplot2)
# To plot multiple plots on a single page, use gridExtra
library(gridExtra)

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

# Identify motor vehicle sources. This uses the definition in section
# 4.6 of http://www.epa.gov/ttn/chief/net/2008neiv3/2008_neiv3_tsd_draft.pdf,
# which defines "On-road – all Diesel and Gasoline vehicles".
vehicles <- with(SCC,
                 which(grepl("Mobile", SCC.Level.One, ignore.case=T) &
                           Data.Category == "Onroad"))

# Get the subset of codes and short names. Transform to characters to make
# sure matching works correctly. Note, Short.Name was being explored to
# plot per source type.
SCCVehicles <- SCC[vehicles,c("SCC", "Short.Name")]
SCCVehicles <- transform(SCCVehicles, SCC=as.character(SCC))
SCCVehicles <- transform(SCCVehicles, Short.Name=as.character(Short.Name))

# Get the total emissions for each year
NEIVehicles <- subset(NEI, 
                      SCC %in% SCCVehicles$SCC & fips %in% c("24510", "06037"))
NEIVehicles <- merge(NEIVehicles, SCCVehicles, by="SCC")

# Aggregate emissions by year and source, creating an appropriate table.
totalEmissionsByYearAndLocation <- aggregate(Emissions ~ year + fips,
                                         NEIVehicles,
                                         sum)
totalEmissionsByYearAndLocation$Location <- 
    ifelse(totalEmissionsByYearAndLocation$fips == "24510",
           "Baltimore City, Maryland",
           "Los Angeles County, California")

# Compute changes relative to the 1999 amounts to normalize the different
# magnitudes of the data.
relativeEmissionsByYearAndLocation <- by(totalEmissionsByYearAndLocation,
                                         totalEmissionsByYearAndLocation$fips,
                                         function(x) {
                                             e1999 <- x$Emissions[x$year == "1999"]
                                             x$Emissions <- 100 * (x$Emissions / e1999)
                                             x
                                         })
relativeEmissionsByYearAndLocation <- do.call(rbind, 
                                              relativeEmissionsByYearAndLocation)

# Now generate the requested plot using the ggplot2 package.
png("plot6.png", width=960, height=960)

# Create bars by year. Need to convert years to a factor.
yearFactor <- factor(totalEmissionsByYearAndLocation$year)
# Divide Emissions by 1000 for a more reasonable scale.
g <- ggplot(totalEmissionsByYearAndLocation, aes(yearFactor, Emissions))
p <- g + geom_bar(stat = "identity") + 
    facet_wrap(~ Location, as.table=FALSE) +
    labs(title="Absolute Emissions Over Time") +
    labs(x="Year") +
    labs(y=expression("Total " * PM[2.5] * " Emissions (tons)")) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1), 
          text=element_text(size=18))

# Relative changes over time.
rg <- ggplot(relativeEmissionsByYearAndLocation, aes(yearFactor, Emissions))
rp <- rg + geom_bar(stat = "identity") + 
    facet_wrap(~ Location, as.table=FALSE) +
    labs(title="Relative Emissions, 1999 Baseline") +
    labs(x="Year") +
    labs(y="Emissions Relative to 1999 (%)") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1), 
          text=element_text(size=18))

# Plot both on the same page. Idea from
# https://github.com/hadley/ggplot2/wiki/Mixing-ggplot2-graphs-with-other-graphical-output
grid.arrange(rp, p, ncol=1, 
             main = textGrob("Fine Particulate Matter Emissions from Motor Vehicle Sources",
                          gp=gpar(fontsize=32)))
dev.off()

# Change back to the original directory
setwd(originalWorkingDirectory)
