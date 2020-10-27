# Load packages that are used more than once

library(tidyverse)
library(readxl)
library(lubridate)
library(skimr)
library(taxadb)
library(here)

# import raw data as captured during project
raw_data <- read_xlsx(path = here("/data/all_data.xlsx"),
                      sheet = "raw_data")

# clean the variable names, set variable types and split "funnel-x" into two variables.
clean_data <- raw_data %>%
          janitor::clean_names() %>%
          mutate(date = as_date(date),
                 arm = as_factor(arm),
                 block = as_factor(block)) %>%
          separate(trap_type,
                   c("trap_type",
                     "trap_position"),
                   sep = "[-]",
                   fill = "right") %>%
          write_csv(here("/data/clean_data.csv"))

# clean up
rm(raw_data)

# view a summary of the data
clean_data %>%
  mutate_if(is.character, as.factor) %>%
  skimr::skim()

#######################################################################################################
# normalise the database for this project by creating additional dataframes
# specific to each observational unit e.g. captures, trap_sites, phase, species taxonomy etc.

clean_data <- read_csv(here("/data/clean_data.csv"))

# Trap site
trapsite_data <- clean_data %>%
  select(trap_site, block, lat, long) %>%
  distinct() %>%
  drop_na() %>%
  write_csv(here("/data/trapsite_data.csv"))

# Project phase
phase_data <- clean_data %>%
  select(date, phase) %>%
  distinct() %>%
  arrange(date) %>%
  write_csv(here("/data/phase_data.csv"))

# Capture data
capture_data <- clean_data %>%
  select(-phase, -block, -treatment, -lat, -long) %>%
  drop_na(species) %>%
  write_csv(here("/data/capture_data.csv"))

# Species data (correct taxonomy using {taxadb}, common names, snake/lizard)
species_data <- clean_data %>%
  select(species) %>%
  distinct() %>%
  drop_na() %>%
  arrange(species) %>%
  as.matrix() %>%
  as.character() %>%
  # The filter_name function only works on a character vector so we convert it for this function
  filter_name() %>%
  select(taxonomy_2006 = input,
         taxonomicStatus,
         genus_ITIS = genus,
         specificEpithet_ITIS = specificEpithet,
         vernacularName,
         everything(),
         -sort,
         -scientificName) %>%
  write_csv(here("/data/species_data.csv"))

# TODO: Need to figure out how to deal with treatment and the dates the traps weren't checked.
# Plotting time series of days using a dataset of dates checked and not-checked would allow for visualising the zero detection days from the not-checked days.


