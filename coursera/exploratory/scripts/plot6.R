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

summary_motor_vehicles_pm25_baltimore_and_los_angeles <- subset(summary_motor_vehicles_pm25, fips == "24510" | fips == "06037")

summary_motor_vehicles_pm25_baltimore_and_los_angeles$city <-
  ifelse(summary_motor_vehicles_pm25_baltimore_and_los_angeles$fips == "24510",
         "Baltimore City, Maryland", "Los Angeles, California")

total_motor_vehicles_emissions_per_year_baltimore_and_los_angeles <-
  aggregate(Emissions ~ year + city, summary_motor_vehicles_pm25_baltimore_and_los_angeles, sum)

# Emission Change over Time (used for plot text annotations)
fit_baltimore <- lm(Emissions ~ year,
                    data = subset(total_motor_vehicles_emissions_per_year_baltimore_and_los_angeles,
                                  city == "Baltimore City, Maryland"))

fit_los_angeles <- lm(Emissions ~ year,
                      data = subset(total_motor_vehicles_emissions_per_year_baltimore_and_los_angeles,
                                    city == "Los Angeles, California"))
change_baltimore <- coef(fit_baltimore)[2]
change_los_angeles <- coef(fit_los_angeles)[2]

format_change_label <- function(change) {
  paste(format(round(as.numeric(change)), big.mark = ",", scientific = FALSE), "Tons / Year")
}

change_labels <- data.frame(year = 2004,
                            Emissions = Inf,
                            change = c(change_baltimore, change_los_angeles),
                            city = c("Baltimore City, Maryland", "Los Angeles, California"))
change_labels$change <- sapply(change_labels$change, format_change_label)

#
# Plot: Total Emissions from Motor Vehicles PM2.5 in Baltimore City, Maryland and Los Angeles, California vs. Year
#
png(width = 1000, height = 500, file = "../plots/plot6.png")

# Barplot
motor_vehicles_emissions_per_year_baltimore_and_los_angeles_barplot <-
  ggplot(total_motor_vehicles_emissions_per_year_baltimore_and_los_angeles,
         aes(x = as.factor(year), y = Emissions, fill = city)) + 
  geom_bar(stat = "identity", position=position_dodge(), alpha = 0.5) +
  ylim(0, 5000) +
  ggtitle("Total Emissions from Motor Vehicle PM2.5") +
  xlab("Year") +
  ylab("Tons") +
  theme(plot.title = element_text(size = 20, vjust = 10)) +
  theme(plot.margin = unit(c(1, 1, 1, 0), "cm")) +
  theme(legend.position = "bottom") +
  scale_fill_manual("legend", values = c("Baltimore City, Maryland" = "burlywood2", "Los Angeles, California" = "burlywood4"))

# Scatterplot
motor_vehicles_emissions_per_year_baltimore_and_los_angeles_scatterplot <-
  ggplot(total_motor_vehicles_emissions_per_year_baltimore_and_los_angeles, aes(year, Emissions)) +
  geom_point(col = "burlywood4") +
  geom_smooth(method="lm", col = "burlywood4", fill = "burlywood2") +
  facet_wrap(~ city, scales = "free") + 
  geom_text(aes(year, Emissions, label = change), data = change_labels, vjust = 1) +
  ggtitle("Total Emissions from Motor Vehicle PM2.5") +
  xlab("Year") +
  ylab("Tons") +
  theme(plot.title = element_text(size = 20, vjust = 10)) +
  theme(plot.margin = unit(c(1, 1, 2, 0), "cm"))

# Put both plots in a single grid
grid.arrange(motor_vehicles_emissions_per_year_baltimore_and_los_angeles_barplot,
             motor_vehicles_emissions_per_year_baltimore_and_los_angeles_scatterplot, ncol = 2)

dev.off ()