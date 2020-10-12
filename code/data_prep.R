# Load packages that are used more than once

library(here)
library(tidyverse)
library(readxl)
library(janitor)
library(skimr)
library(lubridate)

# import dataset
raw_data <- read_xlsx(path = here("/data/all_data.xlsx"), sheet = "raw_data")

# clean the variable names, set variable types and split "funnel-x" into two variables.
data <- raw_data %>%
          clean_names() %>%
          mutate(date = as_date(date),
                 arm = as_factor(arm),
                 block = as_factor(block)) %>%
          separate(trap_type,
                   c("trap_type",
                     "trap_position"),
                   sep = "[-]",
                   fill = "right") %>%
          mutate_if(is.character,as.factor)

# view a summary of the data
skimr::skim(data)

#####################################################################################################
# Split this to take these tables to the relevant Rmarkdown documents
# create pivot tables for later analysis
# create pivot table of species per day, per trap array and phase

sitephase_summary <- data %>%
                      group_by(array, species, phase, date) %>%
                      summarise(count_by_array = n())


