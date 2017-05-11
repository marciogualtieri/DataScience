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
coal_scc_codes <- source_classification_code$SCC[grepl("[Cc]oal", source_classification_code$EI.Sector)]
summary_coal_pm25 <- subset(summary_scc_pm25, SCC %in% coal_scc_codes)
total_coal_emissions_per_year <- aggregate(Emissions ~ year, summary_coal_pm25, sum)

#
# Plot: Total Emissions from Coal PM2.5 in the U.S. vs. Year
#
png(width = 800, height = 800, file = "../plots/plot4.png")

par(mar = c(4, 6, 4, 1))

with(total_coal_emissions_per_year,
     plot(year, Emissions,
          axes = FALSE,
          ann = FALSE,
          xlim = range(1998, 2010),
          ylim = range(300000, 600000),
          pch = 20,
          cex = 4,
          col = "burlywood2"))
axis(1, at = 1998:2010, cex.axis = 1)
mtext(side = 1, text = "Year", line = 1.5, padj = 2, cex = 1.2, font = 2)
axis(2, cex.axis = 1, las = 1)
mtext(side = 2, text = "Tons", line=1.5, padj = -4, cex = 1.2, font = 2)
title(main = "Total Emissions from Coal PM2.5 in the U.S.")
box(lty = "solid")

with(total_coal_emissions_per_year,
     lines(year, y = Emissions,
           lwd = 4,
           col = "burlywood2",
           type = "l"))

with(total_coal_emissions_per_year,
     abline(lm(Emissions ~ year),
            lwd = 3,
            col = "burlywood3",
            lty = "dotted"))

with(total_coal_emissions_per_year,
     text(x = year + 0.5, y = Emissions + 20000,
          label = sapply(Emissions, format_label)))

dev.off ()