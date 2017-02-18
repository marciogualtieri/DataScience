---
title: 'Fake News Proliferation: An Interactive Graphical Exploration'
author: "Marcio Gualtieri"
highlighter: highlight.js
hitheme: tomorrow
job: null
knit: slidify::knit2slides
mode: selfcontained
subtitle: February 18, 2017
framework: io2012
widgets: []
---

## Overview

The data used in this notebook has been taken from a survey performed by [BuzzFeed](https://www.buzzfeed.com/), which attempted to measure how effectual is the proliferation of fake news in different states in the U.S.. You will find the article that makes use of the data [here](https://www.buzzfeed.com/craigsilverman/fake-news-survey). 

After reading the article, I noticed that they could have used some interactivity in the graphs. They needed a somehow large number of static graphs to express their results. They could have been equally expressive with a much smaller number of interactive graphs, thus my choice of using this data-set to showcase my [leaflet](http://leafletjs.com/) and [plotly](https://plot.ly/) skills.

The raw data-set provided by BuzzFeed required quite a bit of cleanup, so I have created a separated notebook for this purpose, which is available [here](../scripts/fakenews.nb.html).

--- .class #id

## Required Packages

### Install Packages

The `devtools` package is required, given that `slidify` is only available on GitHub at the moment:



```r
install.packages("xtable")
install.packages("devtools")
install.packages("xtable")
install.packages("dplyr")
install.packages("plyr")
install.packages("leaflet")
install.packages("rgdal")
install.packages("raster")
install.packages("RColorBrewer")
install.packages("htmlwidgets")
```

### Install `slidify`:


```r
suppressMessages(library(devtools))
install_github("ramnathv/slidify")
install_github("ramnathv/slidifyLibraries")
```

--- .class #id 

### Load Packages


```r
suppressMessages(library(sp, quietly = TRUE))
suppressMessages(library(xtable))                        # Pretty printing dataframes
suppressMessages(library(plyr, warn.conflicts = FALSE))  # Manipulating dataframes
suppressMessages(library(dplyr, warn.conflicts = FALSE))
suppressMessages(library(leaflet))                       # Interactive graphs
suppressMessages(library(rgdal))
suppressMessages(library(raster))                        # Loading geo-spacial data
suppressMessages(library(RColorBrewer))                  # Preview palletes
suppressMessages(library(slidify))
suppressMessages(library(slidifyLibraries))
suppressMessages(library(htmlwidgets))
```

--- .class #id 

## Loading Data


```r
headlines <- read.csv("../input/headlines.csv",
                      na.strings=c("NA", "NULL", ""),
                      stringsAsFactors = FALSE)

recall_data <- read.csv("../output/recall_data.csv",
                        na.strings=c("NA", "NULL", ""),
                        stringsAsFactors = FALSE)

accuracy_data <- read.csv("../output/accuracy_data.csv",
                          na.strings=c("NA", "NULL", ""),
                          stringsAsFactors = FALSE)

news_source_score_data <- read.csv("../output/news_source_score_data.csv",
                                   na.strings=c("NA", "NULL", ""),
                                   stringsAsFactors = FALSE)
```

More details about these data-sets are available in a separated notebook, which you will find [here](../scripts/fakenews.nb.html).

--- .class #id 

## Computing Statistics

### Accuracy


```r
compute_accuracy_percentages <- function(data, group_columns) {
  if(length(group_columns) > 0)
      data <- data[!is.na(data[, group_columns]), ]
  count_column <- "guessed_correctly"
  counts <- plyr::count(data, vars = c("state", group_columns, count_column))
  percentages <- group_by_(counts, .dots = c("state", group_columns)) %>% dplyr::mutate(percentage = round(freq * 100 / sum(freq), 2))
  percentages <- percentages[percentages[[count_column]] == "no", ]
  return(percentages)
}

overall_accuracy_percentages <- compute_accuracy_percentages(accuracy_data, c())
education_accuracy_percentages <- compute_accuracy_percentages(accuracy_data, "education")
party_accuracy_percentages <- compute_accuracy_percentages(accuracy_data, "party")
candidate_accuracy_percentages <- compute_accuracy_percentages(accuracy_data, "candidate")
income_accuracy_percentages <- compute_accuracy_percentages(accuracy_data, "income")
ethnicity_accuracy_percentages <- compute_accuracy_percentages(accuracy_data, "ethnicity")
```

--- .class #id 

Here's how the percentages look like:


```r
render_table <- function(data, digits = 2)
  print(xtable(data, digits = digits), type = "html",
        sanitize.text.function = function(x) x)

sample_data_frame <- function(data, size) {
  sample_index <- sample(1:nrow(data), size)
  return(data[sample_index, ])
}

render_table(sample_data_frame(overall_accuracy_percentages, 6))
```

<!-- html table generated in R 3.3.2 by xtable 1.8-2 package -->
<!-- Sat Feb 18 20:08:09 2017 -->
<table border=1>
<tr> <th>  </th> <th> state </th> <th> guessed_correctly </th> <th> freq </th> <th> percentage </th>  </tr>
  <tr> <td align="right"> 1 </td> <td> Texas </td> <td> no </td> <td align="right">  98 </td> <td align="right"> 38.43 </td> </tr>
  <tr> <td align="right"> 2 </td> <td> Louisiana </td> <td> no </td> <td align="right">  24 </td> <td align="right"> 42.11 </td> </tr>
  <tr> <td align="right"> 3 </td> <td> Virginia </td> <td> no </td> <td align="right">  52 </td> <td align="right"> 38.81 </td> </tr>
  <tr> <td align="right"> 4 </td> <td> Tennessee </td> <td> no </td> <td align="right">  30 </td> <td align="right"> 37.50 </td> </tr>
  <tr> <td align="right"> 5 </td> <td> Montana </td> <td> no </td> <td align="right">   3 </td> <td align="right"> 21.43 </td> </tr>
  <tr> <td align="right"> 6 </td> <td> Maine </td> <td> no </td> <td align="right">   5 </td> <td align="right"> 33.33 </td> </tr>
   </table>

--- .class #id 

### Recall


```r
compute_overall_recall_percentages <- function(data) {
  count_column <- "recall_fake_headline"
  counts <- plyr::count(data, vars = c("state", count_column))
  percentages <- group_by_(counts, .dots = c("state")) %>% dplyr::mutate(percentage = round(freq * 100 / sum(freq), 2))
  percentages <- percentages[percentages[[count_column]] == "yes", ]
  return(percentages)
}

overall_recall_percentages <- compute_overall_recall_percentages(recall_data)
render_table(sample_data_frame(overall_recall_percentages, 6))
```

<!-- html table generated in R 3.3.2 by xtable 1.8-2 package -->
<!-- Sat Feb 18 20:08:09 2017 -->
<table border=1>
<tr> <th>  </th> <th> state </th> <th> recall_fake_headline </th> <th> freq </th> <th> percentage </th>  </tr>
  <tr> <td align="right"> 1 </td> <td> California </td> <td> yes </td> <td align="right"> 162 </td> <td align="right"> 16.98 </td> </tr>
  <tr> <td align="right"> 2 </td> <td> Louisiana </td> <td> yes </td> <td align="right">  27 </td> <td align="right"> 29.03 </td> </tr>
  <tr> <td align="right"> 3 </td> <td> Florida </td> <td> yes </td> <td align="right"> 156 </td> <td align="right"> 21.76 </td> </tr>
  <tr> <td align="right"> 4 </td> <td> Idaho </td> <td> yes </td> <td align="right">  10 </td> <td align="right"> 20.83 </td> </tr>
  <tr> <td align="right"> 5 </td> <td> Nebraska </td> <td> yes </td> <td align="right">   5 </td> <td align="right"> 10.42 </td> </tr>
  <tr> <td align="right"> 6 </td> <td> Massachusetts </td> <td> yes </td> <td align="right">  26 </td> <td align="right"> 13.76 </td> </tr>
   </table>

--- .class #id 

### News Sources

For simplicity, I'm only going calculate the percentages for major source of news:


```r
is_a_major_source <- function(data)
  data$news_source_score == "Is a major source of news for me"

counts <- group_by_(
  news_source_score_data[is_a_major_source(news_source_score_data), ],
  .dots = c("state", "news_source")) %>%
  summarise(freq = sum(Weightvar))

news_sources_percentages <- group_by_(counts, .dots = c("state")) %>%
  dplyr::mutate(percentage = round(freq * 100 / sum(freq), 2))
```

--- .class #id 

Here's how the percentages look like:


```r
render_table(sample_data_frame(news_sources_percentages, 6))
```

<!-- html table generated in R 3.3.2 by xtable 1.8-2 package -->
<!-- Sat Feb 18 20:08:09 2017 -->
<table border=1>
<tr> <th>  </th> <th> state </th> <th> news_source </th> <th> freq </th> <th> percentage </th>  </tr>
  <tr> <td align="right"> 1 </td> <td> Florida </td> <td> Washington Post </td> <td align="right"> 49.85 </td> <td align="right"> 7.24 </td> </tr>
  <tr> <td align="right"> 2 </td> <td> Tennessee </td> <td> Business Insider </td> <td align="right"> 4.67 </td> <td align="right"> 6.17 </td> </tr>
  <tr> <td align="right"> 3 </td> <td> New York </td> <td> Huffington Post </td> <td align="right"> 39.29 </td> <td align="right"> 4.79 </td> </tr>
  <tr> <td align="right"> 4 </td> <td> Louisiana </td> <td> VICE </td> <td align="right"> 3.29 </td> <td align="right"> 4.25 </td> </tr>
  <tr> <td align="right"> 5 </td> <td> California </td> <td> CNN </td> <td align="right"> 101.99 </td> <td align="right"> 14.14 </td> </tr>
  <tr> <td align="right"> 6 </td> <td> Tennessee </td> <td> VICE </td> <td align="right"> 1.50 </td> <td align="right"> 1.99 </td> </tr>
   </table>

--- .class #id 

## Adding Geo-coordinates

Our leaftlet interactive plot require shape coordinates for the U.S. states:


```r
states <- shapefile("../input/cb_2015_us_state_20m/cb_2015_us_state_20m.shp")
```

For centering the map in the U.S., we also need its coordinates:


```r
usa_longitude = -95.7129
usa_latitude = 37.0902
```

I'm also going to add an ID for color, so each state polygon is assigned a different color at random:



```r
states$color <- sample(1:nrow(states))
```

--- .class #id 

## Building the Leaflet Interactive Map

The leaflet plot we are going to build shows the percentage of survey responders, who when asked about the headlines below, could not tell which ones were real or fake:


```r
render_table(headlines)
```

<!-- html table generated in R 3.3.2 by xtable 1.8-2 package -->
<!-- Sat Feb 18 20:08:09 2017 -->
<table border=1>
<tr> <th>  </th> <th> headline_id </th> <th> headline_value </th> <th> headline_status </th> <th> fact_check_link </th>  </tr>
  <tr> <td align="right"> 1 </td> <td> A </td> <td> Pope Francis Shocks World Endorses Donald Trump for President Releases Statement </td> <td> Fake </td> <td> <a href=http://www.snopes.com/pope-francis-donald-trump-endorsement/>Snopes</a> </td> </tr>
  <tr> <td align="right"> 2 </td> <td> B </td> <td> Donald Trump Sent His Own Plane to Transport 200 Stranded Marines </td> <td> Fake </td> <td> <a href=http://www.snopes.com/trump-tower-air/>Snopes</a> </td> </tr>
  <tr> <td align="right"> 3 </td> <td> C </td> <td> FBI Agent Suspected in Hillary Email Leaks Found Dead in Apparent Murder - Suicide </td> <td> Fake </td> <td> <a href=http://www.snopes.com/fbi-agent-murder-suicide/>Snopes</a> </td> </tr>
  <tr> <td align="right"> 4 </td> <td> D </td> <td> Donald Trump Protester Speaks Out ‘I Was Paid $3500 to Protest Trump’s Rally’ </td> <td> Fake </td> <td> <a href=http://www.snopes.com/donald-trump-protester-speaks-out/>Snopes</a> </td> </tr>
  <tr> <td align="right"> 5 </td> <td> E </td> <td> FBI Director Comey Just Put a Trump Sign On His Front Lawn </td> <td> Fake </td> <td> <a href=http://www.snopes.com/fbi-director-james-comeys-trump-sign/>Snopes</a> </td> </tr>
  <tr> <td align="right"> 6 </td> <td> F </td> <td> Melania Trump’s Girl-on-Girl Photos From Racy Shoot Revealed </td> <td> Real </td> <td> <a href=http://www.mirror.co.uk/3am/celebrity-news/donald-trumps-wife-melania-naked-8542914>Mirror</a> </td> </tr>
  <tr> <td align="right"> 7 </td> <td> G </td> <td> Barbara Bush: ‘I don’t know how women can vote for Trump’ </td> <td> Real </td> <td> <a href=http://www.cbsnews.com/videos/barbara-bush-i-dont-know-how-women-can-vote-for-donald-trump/>CSB News</a> </td> </tr>
  <tr> <td align="right"> 8 </td> <td> H </td> <td> Donald Trump Says He’d ‘Absolutely’ Require Muslims to Register </td> <td> Real </td> <td> <a href=https://www.nytimes.com/politics/first-draft/2015/11/20/donald-trump-says-hed-absolutely-require-muslims-to-register/>New York Times</a> </td> </tr>
  <tr> <td align="right"> 9 </td> <td> I </td> <td> Trump: ‘I Will Protect Our LGBTQ Citizens’ </td> <td> Real </td> <td> <a href=http://www.nbcnews.com/card/trump-i-will-protect-our-lgbtq-citizens-n614621>NBC News</a> </td> </tr>
  <tr> <td align="right"> 10 </td> <td> J </td> <td> I Ran the C.I.A Now I’m Endorsing Hillary Clinton </td> <td> Real </td> <td> <a href=https://www.nytimes.com/2016/08/05/opinion/campaign-stops/i-ran-the-cia-now-im-endorsing-hillary-clinton.html>New York Times</a> </td> </tr>
  <tr> <td align="right"> 11 </td> <td> K </td> <td> Donald Trump on Refusing Presidential Salary ‘I’m not taking it’ </td> <td> Real </td> <td> <a href=http://www.cbsnews.com/news/did-donald-trump-say-hed-refuse-to-take-a-salary-as-president/>CBS News</a> </td> </tr>
   </table>

--- .class #id 

The following code creates HTML popups for each state:


```r
format_percentage <- function(percentage) {
  if(length(percentage) == 0) percentage <- "NO DATA"
  else percentage <- paste0(percentage, "%")
  return(percentage)
}

build_overall_popup <- function(data, state){
  state_data <- data[data$state == state, ]
  content <- paste0("<h3>", state, "</h3>")
  content <- paste0(content, "<p>", format_percentage(state_data$percentage))
  return(content)
}

build_column_popup <- function(data, column, state){
  state_data <- data[data$state == state, ]
  state_data <- state_data[with(state_data, order(-state_data$percentage)), ]
  content <- paste0("<h3>", state, "</h3>")
  column_values <- unique(state_data[[column]])
  for(column_value in column_values) {
    percentage <- state_data$percentage[state_data[[column]] == column_value]
    content <- paste0(content, "<p>", column_value, ": ", format_percentage(percentage))
  }
  return(content)
}
```

--- .class #id 

The popup shows the correspondent percentages for the state when it's clicked on the map:


```r
states$accuracy_popup <-sapply(states$NAME, build_overall_popup, data = overall_accuracy_percentages)
states$recall_popup <-sapply(states$NAME, build_overall_popup, data = overall_recall_percentages)
states$news_sources_popup <-sapply(states$NAME, build_column_popup, data = news_sources_percentages, column = "news_source")
states$education_popup <- sapply(states$NAME, build_column_popup, data = education_accuracy_percentages, column = "education")
states$party_popup <-sapply(states$NAME, build_column_popup, data = party_accuracy_percentages, column = "party")
states$candidate_popup <-sapply(states$NAME, build_column_popup, data = candidate_accuracy_percentages, column = "candidate")
states$income_popup <-sapply(states$NAME, build_column_popup, data = income_accuracy_percentages, column = "income")
states$ethnicity_popup <-sapply(states$NAME, build_column_popup, data = ethnicity_accuracy_percentages, column = "ethnicity")
```

--- .class #id 

## Fake News Interactive Map


```r
add_polygons <- function (map, states, column, group) {
  map %>% addPolygons(
    stroke = TRUE, weight = 2, fillOpacity = 0.3, smoothFactor = 0.1,
    color = "white", fillColor = ~colorNumeric("Paired", states$color)(color),
    popup = states[[column]], group = group
  )
}

fake_news_survey_map <- function() {
  leaflet(states, width = "100%") %>%
    setView(usa_longitude, usa_latitude, zoom = 4) %>% addTiles() %>%
    add_polygons(states, "news_sources_popup", "Major News Sources") %>%
    add_polygons(states, "recall_popup", "Overall Fake Headline Recall") %>%
    add_polygons(states, "accuracy_popup", "Overall Fake Headline Tricked") %>%
    add_polygons(states, "education_popup", "By Education Tricked") %>%
    add_polygons(states, "party_popup", "By Party Tricked") %>%
    add_polygons(states, "candidate_popup", "By Candidate Tricked") %>%
    add_polygons(states, "income_popup", "By Income Tricked") %>%
    add_polygons(states, "ethnicity_popup", "By Ethnicity Tricked") %>%
    addLayersControl(
      baseGroups = c("Major News Sources",
                     "Overall Fake Headline Recall", "Overall Fake Headline Tricked",
                     "By Education Tricked", "By Party Tricked", "By Candidate Tricked",
                     "By Income Tricked", "By Ethnicity Tricked"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>%
    showGroup(group = "Overall Fake Headline Tricked")
}

saveWidget(fake_news_survey_map(), file="fake_news_survey_map.html")
```

--- .class #id

Choose the type of statistics you want to see by clicking the correspondent radio box and then click the state on the U.S. map to get the statistic for the state:

<iframe src="fake_news_survey_map.html"></iframe>
