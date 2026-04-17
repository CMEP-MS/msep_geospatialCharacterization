# just using 2023 for now since I already have it

library(tidyverse)
library(sf)
library(terra)
library(tmap)
library(tidyterra)
library(tigris)
options(tigris_use_cache = TRUE)
source(here::here("R_other",
                  "definitions_NLCD.R"))

# lulc file
fl <- here::here("data", "processed",
                 "NLCD_MSEP.tif")

lulc <- rast(fl)
lulc_types <- as.data.frame(levels(lulc))

# counties

cts <- counties(state = "MS", cb = TRUE)
coastals3 <- cts |> 
    filter(NAME %in% c("Jackson", "Hancock", "Harrison")) |> 
    st_transform(crs = st_crs(lulc))
coastals6 <- cts |> 
    filter(NAME %in% c("Jackson", "Hancock", "Harrison",
                       "Stone", "George", "Pearl River")) |> 
    st_transform(crs = st_crs(lulc))

mapview::mapview(coastals6)

# lulc in 3 coastal counties
lulc_coastal3 <- mask(lulc, coastals3)
lulc_coastal3 <- crop(lulc_coastal3, coastals3)

ggplot() +
    geom_spatraster(data = lulc_coastal3)


# summarize
type_covers3 <- table(values(lulc_coastal3)) |> 
    as.data.frame() 

type_covers3 <- type_covers3 |> 
    mutate(value = as.numeric(as.character(Var1))) |>
    select(-Var1) |> 
    left_join(lulc_types_full)

sumpixels3 <- sum(type_covers3$Freq)

type_covers3 <- type_covers3 |> 
    dplyr::mutate(pct_cover = round(100 * Freq / sumpixels3, 1))

type_covers3 |> 
    select(value,
           `Land Cover Class` = type,
           `Percent of 3 Coastal Counties` = pct_cover) |> 
    gt::gt()


# category groups
type_covers3 <- type_covers3 |> 
    select(value, category, Freq) |> 
    summarize(.by = category,
              Freq = sum(Freq, na.rm = TRUE)) |> 
    mutate(pct_coastal3 = round(100 * Freq / sumpixels3, 1)) 

type_covers3 |> 
    select(category, `Percent of 3 Coastal Counties` = pct_coastal3) |> 
    gt::gt()

# entire watershed
type_covers <- table(values(lulc)) |> 
    as.data.frame() 

type_covers <- type_covers |> 
    mutate(value = as.numeric(as.character(Var1))) |>
    select(-Var1) |> 
    left_join(lulc_types_full)

sumpixels <- sum(type_covers$Freq)

type_covers <- type_covers |> 
    select(value, category, Freq) |> 
    summarize(.by = category,
              Freq = sum(Freq, na.rm = TRUE)) |> 
    mutate(pct_cover = round(100 * Freq / sumpixels, 1))

type_covers |> 
    select(category, `Percent of Watershed` = pct_cover) |> 
    gt::gt()


type_all <- left_join(type_covers, type_covers3,
                      by = "category")

type_all |> 
    select(category,
           `Percent of Watershed` = pct_cover,
           `Percent of 3 Coastal Counties` = pct_coastal3) |> 
    gt::gt()
