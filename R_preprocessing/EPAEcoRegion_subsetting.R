library(tidyverse)
library(msepBoundaries)
library(sf)
library(units)
library(tigris)
options(tigris_use_cache = TRUE)
library(foreign)
library(here)


# set path ----
path <- here("data", "EPA EcoRegions", "unzipped")


# read in - level 3 ----
ms3 <- st_read(here(path, "ms_eco_l3.shp"))
al3 <- st_read(here(path, "al_eco_l3.shp"))
la3 <- st_read(here(path, "la_eco_l3.shp"))

# read in - level 4 ----
ms4 <- st_read(here(path, "ms_eco_l4.shp"))
al4 <- st_read(here(path, "al_eco_l4.shp"))
la4 <- st_read(here(path, "la_eco_l4.shp"))


# combine ----

all3 <- bind_rows(ms3, al3, la3)
all4 <- bind_rows(ms4, al4, la4)

# MSEP boundary ----
# use 'outline_full'
msep_boundary <- outline_full |> 
    st_transform(crs = st_crs(all3))

msep3 <- st_intersection(all3, msep_boundary)
msep4 <- st_intersection(all4, msep_boundary)

fl_out <- here("data", "processed",
               "EPA_EcoRegion.gpkg")
st_write(all3,
         fl_out,
         layer = "level3_lamsal",
         append = FALSE,
         delete_layer = TRUE)
st_write(msep3,
         fl_out,
         layer = "level3_mssoundwatershed",
         append = FALSE,
         delete_layer = TRUE)
st_write(msep4,
         fl_out,
         layer = "level4_mssoundwatershed",
         append = FALSE,
         delete_layer = TRUE)
