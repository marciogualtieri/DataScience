#
# Library Dependencies
#
suppressMessages(library(xtable))  # Pretty printing dataframes
suppressMessages(library(ggplot2)) # Plotting
suppressMessages(library(gridExtra))

#
# Data Load
#
load_data <- function(url, file_name) {
  temp_file <- tempfile()
  download.file(url, temp_file)
  unzip(zipfile = temp_file, files = c(file_name), exdir = "./")
  data <- readRDS(file_name)
  unlink(temp_file)
  unlink(file_name)
  data
}
summary_scc_pm25 <- load_data("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                              "summarySCC_PM25.rds")
source_classification_code <- load_data("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                                        "Source_Classification_Code.rds")

#
# Data Computation
#
total_emissions_per_year <- aggregate(Emissions ~ year, summary_scc_pm25, sum)

format_label <- function(emission) {
  paste(format(round(emission), big.mark = ",", scientific = FALSE), 'Tons')
}

#
# Plot: Total Emissions from PM2.5 in the U.S. vs. Year
#
png(width = 800, height = 800, file = "../plots/plot1.png")

par(mar = c(4, 1, 4, 1))

total_barplot <- barplot(total_emissions_per_year$Emissions,
                         names.arg = total_emissions_per_year$year,
                         main = "Total Emissions from PM2.5 in the U.S.",
                         xlab ="Year",
                         yaxt = "n",
                         ylim = range(0, 8000000),
                         font.lab = 2,
                         col = "burlywood1",
                         border = NA)
text(x = total_barplot, y = total_emissions_per_year$Emissions,
     label = sapply(total_emissions_per_year$Emissions, format_label),
     pos = 3, cex = 1, col = "black")

dev.off ()