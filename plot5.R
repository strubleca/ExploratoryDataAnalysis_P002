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
NEIVehicles <- subset(NEI, SCC %in% SCCVehicles$SCC & fips == "24510")

# Aggregate emissions by year creating an appropriate table.
# There are too many different sources to consider individually in this
# plot, so only the totals are shown.
totalEmissionsByYear <- aggregate(Emissions ~ year,
                                         NEIVehicles,
                                         sum)

# Now generate the requested plot using the ggplot2 package.
png("plot5.png", width=480, height=480)

# Create bars by year. Need to convert years to a factor.
yearFactor <- factor(totalEmissionsByYear$year)
# Divide Emissions by 1000 for a more reasonable scale.
g <- ggplot(totalEmissionsByYear, aes(yearFactor, Emissions))
p <- g + geom_bar(stat = "identity") + 
    labs(title="Fine Particulate Matter Emissions\nMotor Vehicle Sources in Baltimore City, Maryland") +
    labs(x="Year") +
    labs(y=expression("Total " * PM[2.5] * " Emissions (tons)"))
print(p)

dev.off()

# Change back to the original directory
setwd(originalWorkingDirectory)
