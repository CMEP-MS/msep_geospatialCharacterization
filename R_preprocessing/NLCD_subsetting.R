# National Land Cover Database
# (USGS)
# 2023 data file


library(tidyverse)
library(terra)
library(sf)
library(msepBoundaries)

nlcd <- rast(here::here("data",
                        "NLCD",
                        "Annual_NLCD_LndCov_2023_CU_C1V0.tif"))

lulc <- nlcd["Annual_NLCD_LndCov_2023_CU_C1V0"]


# crop and mask to msep area
msep <- st_transform(outline_full, crs = st_crs(lulc))
lulc_msep <- crop(lulc, msep)
lulc_msep <- mask(lulc_msep, msep)

# data dictionary of values
lulc_types <- tibble::tribble(
    ~"value", ~"type", ~"RGB",
    11, "Open Water", "70, 107, 159",
    # 12, "Perennial Ice/Snow", "209, 222, 248",  # commented out bc we don't have this in MS
    21, "Developed, Open Space", "222, 197, 197",
    22, "Developed, Low Intensity", "217, 146, 130",
    23, "Developed, Medium Intensity", "235, 0, 0",
    24, "Developed, High Intensity", "171, 0, 0",
    31, "Barren Land (Rock/Sand/Clay)", "179, 172, 159",
    41, "Deciduous Forest", "104, 171, 95",
    42, "Evergreen Forest", "28, 95, 44",
    43, "Mixed Forest", "181, 197, 143",
    52, "Shrub/Scrub", "204, 184, 121",
    71, "Grassland/Herbaceous", "223, 223, 194",
    81, "Pasture/Hay", "220, 217, 57",
    82, "Cultivated Crops", "171, 108, 40",
    90, "Woody Wetlands", "184, 217, 235",
    95, "Emergent Herbaceous Wetlands", "108, 159, 184"
) 

# turn the raster into a factor with assigned levels
# the raster has an associated color table already
lulc_msep <- as.factor(lulc_msep)
levels(lulc_msep) <- lulc_types %>%
    select(value, type) %>%
    rename(ID = value)

writeRaster(
    lulc_msep,
    filename = here::here("data", "processed", "NLCD_MSEP.tif"),
    datatype = "INT1U",  
    overwrite = TRUE
)
