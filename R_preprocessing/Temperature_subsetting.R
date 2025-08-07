library(tidyverse)
library(sf)
library(terra)
library(tigris)
options(tigris_use_cache = TRUE)
library(here)

dir_path <- here("data", "Temperature_NCEI")
out_path <- here("data", "processed")

# three states ----
lamsal <- states(cb = FALSE) |> 
    filter(NAME %in% c("Louisiana",
                       "Mississippi",
                       "Alabama"))

# 30 year, 1991-2020 ----
# read in
dat_nc <- rast(here(dir_path, 
                    "tavg-1991_2020-monthly-normals-v1.0.nc"))
# pull out layers we want
dat_monthly <- dat_nc["mlytavg_norm"]
dat_annual <- dat_nc["anntavg_norm"]
# name them
names(dat_monthly) <- month.abb
names(dat_annual) <- "annual"
# crop and mask to 3 states
lamsal <- st_transform(lamsal, crs = st_crs(dat_monthly))
dat_monthly <- crop(dat_monthly, lamsal)
dat_monthly <- mask(dat_monthly, lamsal)
dat_annual <- crop(dat_annual, lamsal)
dat_annual <- mask(dat_annual, lamsal)
# convert to F
dat_monthly <- (dat_monthly * 9/5) + 32
units(dat_monthly) <- "degree_Fahrenheit"
dat_annual <- (dat_annual * 9/5) + 32
units(dat_annual) <- "degree_Fahrenheit"

# combine and write out
combined <- sds(dat_monthly, dat_annual)
writeCDF(combined,
         here(out_path, "tempAvg_30yrNormals.nc"),
         overwrite = TRUE)

# cleanup
rm(dat_nc, dat_monthly, dat_annual, combined)


# 100 year, 1901-2000 ----
# read in
dat_nc <- rast(here(dir_path, 
                    "tavg-1901_2000-monthly-normals-v1.0.nc"))
# pull out layers we want
dat_monthly <- dat_nc["mlytavg_norm"]
dat_annual <- dat_nc["anntavg_norm"]
# name them
names(dat_monthly) <- month.abb
names(dat_annual) <- "annual"
# crop and mask to 3 states
lamsal <- st_transform(lamsal, crs = st_crs(dat_monthly))
dat_monthly <- crop(dat_monthly, lamsal)
dat_monthly <- mask(dat_monthly, lamsal)
dat_annual <- crop(dat_annual, lamsal)
dat_annual <- mask(dat_annual, lamsal)
# convert to F
dat_monthly <- (dat_monthly * 9/5) + 32
units(dat_monthly) <- "degree_Fahrenheit"
dat_annual <- (dat_annual * 9/5) + 32
units(dat_annual) <- "degree_Fahrenheit"

# combine and write out
combined <- sds(dat_monthly, dat_annual)
writeCDF(combined,
         here(out_path, "tempAvg_100yrBaseline.nc"),
         overwrite = TRUE)

# cleanup
rm(dat_nc, dat_monthly, dat_annual, combined)


# 15 year, 2006-2020 ----
# read in
dat_nc <- rast(here(dir_path, 
                    "tavg-2006_2020-monthly-normals-v1.0.nc"))
# pull out layers we want
dat_monthly <- dat_nc["mlytavg_norm"]
dat_annual <- dat_nc["anntavg_norm"]
# name them
names(dat_monthly) <- month.abb
names(dat_annual) <- "annual"
# crop and mask to 3 states
lamsal <- st_transform(lamsal, crs = st_crs(dat_monthly))
dat_monthly <- crop(dat_monthly, lamsal)
dat_monthly <- mask(dat_monthly, lamsal)
dat_annual <- crop(dat_annual, lamsal)
dat_annual <- mask(dat_annual, lamsal)
# convert to F
dat_monthly <- (dat_monthly * 9/5) + 32
units(dat_monthly) <- "degree_Fahrenheit"
dat_annual <- (dat_annual * 9/5) + 32
units(dat_annual) <- "degree_Fahrenheit"

# combine and write out
combined <- sds(dat_monthly, dat_annual)
writeCDF(combined,
         here(out_path, "tempAvg_15yrNormals.nc"),
         overwrite = TRUE)

# cleanup
rm(dat_nc, dat_monthly, dat_annual, combined)

