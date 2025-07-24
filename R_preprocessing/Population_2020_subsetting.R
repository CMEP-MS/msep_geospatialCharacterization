# ran this interactively but didnt' end up saving the output raster
# because it's big and I'm not convinced this is the best way to do it

library(terra)
library(msepBoundaries)
library(sf)
library(tigris)
options(tigris_use_cache = TRUE)
library(ggplot2)
library(tidyterra)

in_path <- here::here("data",
                      "Population",
                      "2020_Dasymetric_Population_CONUS_V1_1",
                      "2020_Dasymetric_Population_CONUS_V1_1",
                      "2020_Dasymetric_Population_CONUS_V1_1.tif")
out_path <- here::here("data",
                       "processed",
                       "Population_Dasymetric_2020.tif")

pop2020 <- rast(in_path)

msep_bound <- outline_full |> 
    st_transform(crs = st_crs(pop2020))

ms_sf <- states(cb = FALSE) |> 
    dplyr::filter(NAME == "Mississippi") |> 
    st_transform(crs = st_crs(pop2020))

msep_and_ms <- st_union(ms_sf, msep_bound)

pop2020_cropped <- crop(pop2020, msep_and_ms)
pop2020_msep_and_ms <- mask(pop2020_cropped, msep_and_ms)

msep_ms <- outline_ms_full |> 
    st_transform(crs = st_crs(pop2020))

pop_ms <- mask(pop2020_msep_and_ms, ms_sf)
pop_msep <- mask(pop2020_msep_and_ms, msep_bound)
pop_msep_msonly <- mask(pop2020_msep_and_ms, msep_ms)

# calculate for entire state as a check
sum(values(pop_ms), na.rm = TRUE)
# 2.96 million

# save - msep boundary only (187 mb if saving whole state + rest of msep bnd)
writeRaster(pop2020_msep_and_ms,
            filename = out_path,
            overwrite = TRUE,
            gdal = c("COMPRESS=DEFLATE", "PREDICTOR=2", "TILED=YES"))


# calculations ----
# entire state
sum(values(pop_ms), na.rm = TRUE)
# 2.96 million

# msep watershed
sum(values(pop_msep), na.rm = TRUE)
# 1.7185 million

# msep watershed in ms
sum(values(pop_msep_ms), na.rm = TRUE)
# 1.539 million
