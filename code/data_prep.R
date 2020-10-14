# Load packages that are used more than once

library(here)
library(tidyverse)
library(readxl)
library(janitor)
library(lubridate)
library(skimr)

# import raw data as captured during project
raw_data <- read_xlsx(path = here("/data/all_data.xlsx"), sheet = "raw_data")

# clean the variable names, set variable types and split "funnel-x" into two variables.
clean_data <- raw_data %>%
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
skimr::skim(clean_data)
write_csv(clean_data, here("/data/clean_data.csv"))
