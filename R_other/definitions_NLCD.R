# data dictionary of pixel values, categories, and detailed categories
# for the NLCD dataset, Land Cover
lulc_types_full <- tibble::tribble(
    ~"value", ~"category", ~"type", ~"RGB",
    11, "Water", "Open Water", "70, 107, 159",
    # 12, "Water", "Perennial Ice/Snow", "209, 222, 248",  # commented out bc we don't have this in MS
    21, "Developed", "Developed, Open Space", "222, 197, 197",
    22, "Developed", "Developed, Low Intensity", "217, 146, 130",
    23, "Developed", "Developed, Medium Intensity", "235, 0, 0",
    24, "Developed", "Developed, High Intensity", "171, 0, 0",
    31, "Barren", "Barren Land (Rock/Sand/Clay)", "179, 172, 159",
    41, "Forest", "Deciduous Forest", "104, 171, 95",
    42, "Forest", "Evergreen Forest", "28, 95, 44",
    43, "Forest", "Mixed Forest", "181, 197, 143",
    52, "Shrubland", "Shrub/Scrub", "204, 184, 121",
    71, "Herbaceous", "Grassland/Herbaceous", "223, 223, 194",
    81, "Planted/Cultivated", "Pasture/Hay", "220, 217, 57",
    82, "Planted/Cultivated", "Cultivated Crops", "171, 108, 40",
    90, "Wetlands", "Woody Wetlands", "184, 217, 235",
    95, "Wetlands", "Emergent Herbaceous Wetlands", "108, 159, 184"
) 
