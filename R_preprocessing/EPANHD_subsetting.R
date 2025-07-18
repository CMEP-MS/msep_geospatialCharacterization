# subset the big EPA NHD+ files to only the MSEP geography

# original files downloaded on 6/12/25 from EPA NHD version 2
# 03f, 03g (for Pearl River) and VPU-Wide

library(tidyverse)
library(msepBoundaries)
library(sf)
library(units)
library(tigris)
options(tigris_use_cache = TRUE)
library(foreign)


# set paths ----
# South Atlantic region (east MS)
path_sa_db <- here::here("data",
                         "EPA NHDPlus",
                         "NHDPlusV21_SA_03W_NHDSnapshot_04",
                         "NHDPlusSA",
                         "NHDPlus03W",
                         "NHDSnapshot")
path_sa_shps <- here::here(path_sa_db,
                           "Hydrography")

# Lower Mississippi region (west MS)
path_ms_db <- here::here("data",
                         "EPA NHDPlus",
                         "NHDPlusV21_MS_08_NHDSnapshot_07",
                         "NHDPlusMS",
                         "NHDPlus08",
                         "NHDSnapshot")
path_ms_shps <- here::here(path_ms_db,
                           "Hydrography")

# FCodes with descriptions 
db_codes <- read.dbf(here::here(path_sa_db,
                                "NHDFCode.dbf"))

# MSEP boundary ----
# use 'outline_full'


# read and clip MS flowlines ----
flowline_ms <- st_read(here::here(path_ms_shps,
                                  "NHDFlowline.shp"))
msep_bnd <- outline_full |> 
    st_transform(crs = st_crs(flowline_ms))
flowline_ms <- st_intersection(flowline_ms, msep_bnd)
gc()


# read and clip SA flowlines ----
flowline_sa <- st_read(here::here(path_sa_shps,
                                  "NHDFlowline.shp"))
flowline_sa <- st_transform(flowline_sa, st_crs(msep_bnd))
flowline_sa <- st_intersection(flowline_sa, msep_bnd)
gc()


# make sure it worked
ggplot() +
    geom_sf(data = msep_bnd,
            fill = "gray90",
            col = "black") +
    geom_sf(data = flowline_sa,
            col = "blue") +
    geom_sf(data = flowline_ms,
            col = "red")

# combine two objects into one ----
flowline_MSEP <- bind_rows(flowline_ms,
                         flowline_sa)

# write out ----
st_write(flowline_MSEP,
         here::here("data",
                    "processed",
                    "EPA_NHDplus_flowline_MSEP.gpkg"),
         append = FALSE)

####################################################

# read and clip waterbody polygons ----
polys_ms <- st_read(here::here(path_ms_shps,
                               "NHDWaterbody.shp"))
polys_ms2 <- st_make_valid(polys_ms) |> 
    st_transform(st_crs(msep_bnd))
# sum(st_is_valid(polys_ms2) == FALSE)

polys_ms <- st_intersection(polys_ms2, msep_bnd)
rm(polys_ms2)
gc()

# read and clip SA polygons ----
polys_sa <- st_read(here::here(path_sa_shps,
                               "NHDWaterbody.shp"))
polys_sa2 <- st_make_valid(polys_sa) |> 
    st_transform(st_crs(msep_bnd))
polys_sa <- st_intersection(polys_sa2, msep_bnd)
rm(polys_sa2)
gc()

# combine two objects into one ----
# have to make the names the same first
polys_ms <- janitor::clean_names(polys_ms)
names(polys_ms) <- str_remove_all(names(polys_ms), "_")

polys_sa <- janitor::clean_names(polys_sa)
names(polys_sa) <- str_remove_all(names(polys_sa), "_")

polys_MSEP <- bind_rows(polys_ms,
                      polys_sa)

# write out ----
st_write(polys_MSEP,
         here::here("data",
                    "processed",
                    "EPA_NHDplus_waterbody_MSEP.gpkg"),
         delete_dsn = TRUE)
