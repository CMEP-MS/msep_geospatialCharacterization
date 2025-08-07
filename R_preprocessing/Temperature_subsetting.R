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
dat_monthly <- dat_nc[[c(grep("mlytavg_norm", names(dat_nc)), 
                         which(names(dat_nc) == "anntavg_norm"))]]
# name them
names(dat_monthly) <- c(month.abb, "annual")
# crop and mask to 3 states
lamsal <- st_transform(lamsal, crs = st_crs(dat_monthly))
dat_monthly <- crop(dat_monthly, lamsal)
dat_monthly <- mask(dat_monthly, lamsal)
# convert to inches and rename
tmp_30yr_in <- dat_monthly / 25.4
units(tmp_30yr_in) <- rep("inches", nlyr(dat_monthly))

# cleanup
rm(dat_nc, dat_monthly)


# 100 year, 1901-2000 ----
# read in
dat_nc <- rast(here(dir_path, 
                    "tavg-1901_2000-monthly-normals-v1.0.nc"))
# pull out layers we want
dat_monthly <- dat_nc[[c(grep("mlytavg_norm", names(dat_nc)), 
                         which(names(dat_nc) == "anntavg_norm"))]]
# name them
names(dat_monthly) <- c(month.abb, "annual")
# crop and mask to 3 states
lamsal <- st_transform(lamsal, crs = st_crs(dat_monthly))
dat_monthly <- crop(dat_monthly, lamsal)
dat_monthly <- mask(dat_monthly, lamsal)
# convert to inches and rename
tmp_100yr_in <- dat_monthly / 25.4
units(tmp_100yr_in) <- rep("inches", nlyr(dat_monthly))

# cleanup
rm(dat_nc, dat_monthly)


# 15 year, 2006-2020 ----
# read in
dat_nc <- rast(here(dir_path, 
                    "tavg-2006_2020-monthly-normals-v1.0.nc"))
# pull out layers we want
dat_monthly <- dat_nc[[c(grep("mlytavg_norm", names(dat_nc)), 
                         which(names(dat_nc) == "anntavg_norm"))]]
# name them
names(dat_monthly) <- c(month.abb, "annual")
# crop and mask to 3 states
lamsal <- st_transform(lamsal, crs = st_crs(dat_monthly))
dat_monthly <- crop(dat_monthly, lamsal)
dat_monthly <- mask(dat_monthly, lamsal)
# convert to inches and rename
tmp_15yr_in <- dat_monthly / 25.4
units(tmp_15yr_in) <- rep("inches", nlyr(dat_monthly))

# cleanup
rm(dat_nc, dat_monthly)


# save out ----
writeCDF(tmp_30yr_in,
         here(out_path, "tempAvg_30yrNormals.nc"),
         overwrite = TRUE)
writeCDF(tmp_100yr_in,
         here(out_path, "tempAvg_100yrBaseline.nc"),
         overwrite = TRUE)
writeCDF(tmp_15yr_in,
         here(out_path, "tempAvg_15yrNormals.nc"),
         overwrite = TRUE)
