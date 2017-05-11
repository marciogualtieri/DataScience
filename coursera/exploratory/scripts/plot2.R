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
summary_scc_pm25_baltimore <- summary_scc_pm25[summary_scc_pm25$fips == "24510", ]
total_emissions_per_year_baltimore <- aggregate(Emissions ~ year, summary_scc_pm25_baltimore, sum)

#
# Plot: Total Emissions from PM2.5 in Baltimore City, Maryland vs. Year
#
png(width = 1000, height = 500, file = "../plots/plot2.png")

par(mfrow = c(1, 2), mar = c(4, 4, 4, 1))

title <- "Total Emissions from PM2.5 in Baltimore City, Maryland"

barplot(total_emissions_per_year_baltimore$Emissions,
        names.arg = total_emissions_per_year_baltimore$year,
        main = title,
        xlab ="Year",
        ylab = "Tons",
        ylim = range(0, 3500),
        las = 1,
        font.lab = 2,
        col = "burlywood1",
        border = NA)

with(total_emissions_per_year_baltimore,
     plot(year, Emissions,
          main = title,
          xlab ="Year",
          ylab = "Tons",
          xlim = range(1998, 2009),
          ylim = range(0, 3500),
          pch = 20,
          cex = 3,
          col = "burlywood2",
          font.lab = 2,
          las = 1))
with(total_emissions_per_year_baltimore,
     abline(lm(Emissions ~ year),
            lwd = 4,
            col = "burlywood4",
            lty = "dotted"))

dev.off ()