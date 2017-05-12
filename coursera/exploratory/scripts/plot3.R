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
total_emissions_per_year_and_type_baltimore <- aggregate(Emissions ~ year + type, summary_scc_pm25_baltimore, sum)

#
# Plot: Total Emissions from PM2.5 in Baltimore City, Maryland vs. Year per Source Type
#
png(width = 800, height = 800, file = "../plots/plot3.png")

ggplot(total_emissions_per_year_and_type_baltimore, aes(year, Emissions)) +
  geom_point(col = "burlywood4") +
  geom_smooth(method="lm", col = "burlywood4", fill = "burlywood2") +
  facet_wrap(~ type, scales = "free") + 
  ggtitle("Total Emissions from PM2.5 in Baltimore City, Maryland per Source Type") +
  xlab("Year") +
  ylab("Tons") +
  theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5, margin = margin(b = 30, unit = "pt"))) +
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"))

dev.off ()