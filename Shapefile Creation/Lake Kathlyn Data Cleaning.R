#Script for Building Lake Kathlyn Parameter Plots

#libraries required
library(devtools)
#library(rems)
library(tidyverse)
library(readxl)
library(sf)

#grabs the ems data from the past two years; use ?get_ems_data() for better fine-tuning
twoyear <- get_ems_data(which = "2yr", ask = FALSE)

#grabs all records related to Lake Kathlyn Water Testing Sites
lk <- filter(twoyear, EMS_ID %in% c("1131007", "E207551", "E207548", "E207549", "E283209", "E280261", "1100227", "E243036"))

#subsets tibble for attributes (cols) of interest
lk <- select(lk, EMS_ID, MONITORING_LOCATION, LATITUDE, LONGITUDE, COLLECTION_START, PARAMETER, RESULT, UNIT, UPPER_DEPTH, LOWER_DEPTH)

#subsets tibble for parameters (rows) of interest
lk <- filter(lk, PARAMETER %in% c("Turbidity", "Temperature-Field", "pH-Field", "Color True", "Phosphorus Total", "Nitrogen - Nitrite Dissolved (NO2)", "Nitrate (NO3) Dissolved", "Chloride Dissolved", "Dissolved Oxygen-Field", "Alkalinity Total 4.5", "Hardness Total (Total)", "Specific Conductivity-Field",
                                      "Coliform - Fecal"))

#downloads latest historic EMS data
download_historic_data(ask = FALSE)

#attaches historic data to a database
hist_db <- attach_historic_data()

#filter database for relevant information on Lake Kathlyn
filtered_historic_lk <- hist_db %>%
  select(EMS_ID, MONITORING_LOCATION, LATITUDE, LONGITUDE, COLLECTION_START, PARAMETER, RESULT, UNIT, UPPER_DEPTH, LOWER_DEPTH) %>%
  filter(EMS_ID %in% c("1131007", "E207551", "E207548", "E207549", "E283209", "E280261", "1100227", "E243036"),
  PARAMETER %in% c("Turbidity", "Temperature-Field", "pH-Field", "Color True", "Phosphorus Total", "Nitrogen - Nitrite Dissolved (NO2)", "Nitrate (NO3) Dissolved", "Chloride Dissolved", "Dissolved Oxygen-Field", "Alkalinity Total 4.5", "Hardness Total (Total)", "Specific Conductivity-Field",
                   "Coliform - Fecal"))

#view filtered table
filtered_historic_lk <- collect(filtered_historic_lk) %>% 
  mutate(COLLECTION_START = ems_posix_numeric(COLLECTION_START))
glimpse(filtered_historic_lk)

#bind the two-year data and historical data
lk_data <- bind_ems_data(lk, filtered_historic_lk)

#arrange the lk_data by date, then EMS_ID
lk_data  <- lk_data[(order(as.Date(lk_data$COLLECTION_START))),]
lk_data  <- lk_data[order(lk_data$EMS_ID),]

#writing lk_data into a shp file with crs 3005
lk_data_sf_obj <-st_as_sf(lk_data, coords = c(4, 3), crs = "+init=epsg:4326") %>%
  st_transform(., "+init=epsg:3005")
st_write(lk_data_sf_obj, "lk_data.shp")


