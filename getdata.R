#' getdata.R
#' 
#' @description
#' Get the "Electric power consumption" data set for the "Exploratory
#' Data Analysis" Coursera course. See https://class.coursera.org/exdata-006/
#' for details.
#' 
#' @docType package
#' @name getdata
#' @author Craig Struble <strubleca@@yahoo.com>
#' 
#' NB: This documentation is in roxygen2 format, but won't format as is.

# Load common declarations and functions
if (file.exists("common.R")) {
    source("common.R") # assumes the working directory contains this file.    
} else {
    stop("working directory does not contain the common.R script.")
}

# Create the data directory for storing the raw data and download the file,
# if they don't exist.
if (!file.exists(dataDir)) {
    writeLines(paste("        Creating data directory:", dataDir))
    dir.create(dataDir)
}

# Download the raw data file
if (!file.exists(rawDataFile)) {
    writeLines(paste("        Downloading raw data file:", rawDataFile, "..."))
    # Select a download method that will work on Mac OS X (Darwin) or
    # other operating systems.
    os <- Sys.info()["sysname"]
    if (os == "Darwin") {
        try(download.file(dataUrl, 
                          destfile=rawDataFile, 
                          method="curl", 
                          quiet=TRUE))
    } else {
        # XXX: Untested! Don't have another machine to use.
        # Try to download file using default method. 
        try(download.file(dataUrl, 
                          destfile=rawDataFile,
                          quiet=TRUE))
    }
    
    if (!file.exists(rawDataFile)) {
        writeLines(paste("        Could not download data file:", rawDataFile))
        writeLines("        Manually download ZIP file.")
        writeLines("Stopping script execution.")
        stop() # Stop script execution.        
    }
    
    dateDownloaded <- date()
    writeLines(dateDownloaded, con=dateFile)
}

# Unzip the data set
if (!file.exists(unzippedDataFile)) {
    writeLines(paste("        Unzipping", rawDataFile, "to", unzippedDataFile))
    unzip(rawDataFile, exdir = dataDir, setTimes = TRUE)  
}


