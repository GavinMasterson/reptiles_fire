# Load packages that are used more than once

library(tidyverse)

####################
# import dataset
raw_data <- readxl::read_xlsx(path = here::here("/data/all_data.xlsx"), sheet = "raw_data")


# clean the variable names
raw_data %>% janitor::clean_names()

# view a summary of the raw data
skimr::skim(raw_data)

# re-order columns and set data types
