#
# Library Dependencies
#
suppressMessages(library(xtable))    # Pretty printing dataframes
suppressMessages(library(ggplot2))   # Plotting
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
motor_vehicles_scc_codes <- source_classification_code$SCC[grepl("[Vv]ehicle",
                                                                 source_classification_code$EI.Sector)]
summary_motor_vehicles_pm25 <- subset(summary_scc_pm25, SCC %in% motor_vehicles_scc_codes)
summary_motor_vehicles_pm25_baltimore <- subset(summary_motor_vehicles_pm25, fips == "24510")
total_motor_vehicles_emissions_per_year_baltimore <-
  aggregate(Emissions ~ year, summary_motor_vehicles_pm25_baltimore, sum)

#
# Plot: Total Emissions from Motor Vehicles PM2.5 in Baltimore City, Maryland vs. Year
#
png(width = 800, height = 800, file = "../plots/plot5.png")

with(total_motor_vehicles_emissions_per_year_baltimore,
     plot(year, Emissions,
          main = "Total Emissions from Motor Vehicles PM2.5 in Baltimore City, Maryland",
          xlab ="Year",
          ylab = "Tons",
          xlim = range(1998, 2009),
          ylim = range(80, 400),
          pch = 20,
          cex = 4,
          col = "burlywood2",
          font.lab = 2,
          las = 1))

with(total_motor_vehicles_emissions_per_year_baltimore,
     lines(year, y = Emissions,
           lwd = 4,
           col = "burlywood2",
           type = "l"))

with(total_motor_vehicles_emissions_per_year_baltimore,
     abline(lm(Emissions ~ year),
            lwd = 3,
            col = "burlywood3",
            lty = "dotted"))

with(total_motor_vehicles_emissions_per_year_baltimore,
     text(x = year + 0.5, y = Emissions + 30,
          label = sapply(Emissions, format_label)))

dev.off ()