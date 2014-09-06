#' common.R
#' 
#' @description
#' Definition of variables and functions used in all the files. Sourced
#' in each plotting script file used in this project.
#' 
#' @docType package
#' @name common
#' @author Craig Struble <strubleca@@yahoo.com>
#' 
#' NB: This documentation is in roxygen2 format, but won't format as is.

# The data URL
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# The local data directory for where the data should be placed. 
dataDir <- "./data"  

# The plots directory
plotsDir <- "./plots"

# Name of the raw data file
rawDataFile <- file.path(dataDir, "NEI_data.zip")

# The top level directory name of the raw data. From the ZIP file.
unzippedDataFile <- file.path(dataDir, "summarySCC_PM25.rds")

# The file containing the date the raw data was downloaded.
dateFile <- file.path(dataDir, "dateDownloaded.txt")

#' Prepare the current working directory for storing plots.
#' 
#' Prepare the current working directory for storing plots. Creates a
#' directory using the defined plots directory.
prepareForPlots <- function() {
    if (!file.exists(plotsDir)) {
        writeLines(paste("Creating", plotsDir))
        dir.create(plotsDir)
    }
}

#' Generate a file path for a plot file name.
#' 
#' Generate a file path for a plot file name.
#' 
#' @param plotName the name of the plot file
#' @returns a character vector containing the name of the plot in the plotting
#' output directory.
#' @examples
#' plotFilePath("plot1.png") # returns ./plots/plot1.png with default values.
plotFilePath <- function(plotName) {
    file.path(plotsDir, plotName)
}
