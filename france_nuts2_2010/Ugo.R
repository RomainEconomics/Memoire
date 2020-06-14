library(GADMTools)

carte_regions<- gadm_sf_loadCountries("FRA", level=1 )

régions <- listNames(carte_regions, level = 1)
poids_abandon <- c(15.4679041, 4.6790410, 4.5243619, 5.0915184, 0.4124774,
                   9.1776231, 3.9829853, 1.0827533 , 5.5039959, 15.4936839,
                   17.4142820, 4.2150039, 12.9543697)
DAT1 <- data.frame(régions, poids_abandon)
choropleth(carte_regions,DAT1,
           adm.join = "régions",
           value = "poids_abandon",
           breaks = "quantile",
           step = "4",
           palette="Reds",
           legend = "Abandonment",
           title="Abandonment by Regions")
#### Nous cherchons à obtenir le même résultat mais avec les 22 anciennes régions


##### Voici la solution que nous a soumis notre maitre de mémoire et comme vous pouvez le voir 
##### cette solution est bien plus compliqué et je ne comprends pas comment faire correspondre nos données

library(rgdal)
# Spatial extent (county polygons)
regs <- readOGR(dsn="france_nuts2_2010", layer="frareg2010")

# Simple map without any elaboration
plot(regs)

# Convert data format so as to make interpretable by the function ggplot
regsmap <- fortify(regs)
regsmap$idcont <- as.integer(regsmap$id)

# Plot data with ggplot to implement some aesthetics and visual manipulation
ggplot() + 
  geom_polygon(data = regsmap, aes(x=long, y=lat,fill=idcont, group=group), colour = "black") + 
  scale_fill_gradient(name = "Region ID", low = "yellow", high="red") +
  theme_void() + 
  expand_limits(x = regsmap$long, y = regsmap$lat) +
  coord_equal()


# Clear all environments
rm(list = ls(all.names = TRUE)) #clear all objects (including hidden ones)
gc() #free up memory and report the memory usage

# Packages for reading, writing, and manipulating spatial data
library(rgdal) #conatins the read/writeOGR for reading shapelies and read/writeRGDAL for
library(maptools) #Contains the overlay command
gpclibPermit() #Makes all of the function in the maptools package available to us
library(sp) #Contains some functions for spatial statistics

# Packages for data visualization and manipulation
library(ggplot2)
library(reshape2)
library(scales)
library(tidyverse)

# ================================================


# Set working directory
usrdir <- getwd()
setwd(usrdir)

# Spatial extent (county polygons)
regs <- readOGR(dsn="france_nuts2_2010", layer="frareg2010")
# Simple map without any elaboration
str(regs)
plot(regs)
# Convert data format so as to make interpretable by the function ggplot
regsmap <- fortify(regs)
regsmap$idcont <- as.integer(regsmap$id)

# Plot data with ggplot to implement some aesthetics and visual manipulation
ggplot() + 
  geom_polygon(data = regsmap, aes(x=long, y=lat,fill=idcont, group=group), colour = "black") + 
  scale_fill_gradient(name = "Region ID", low = "yellow", high="red") +
  theme_void() + 
  expand_limits(x = regsmap$long, y = regsmap$lat) +
  coord_equal()


map <- st_read("france_nuts2_2010", "frareg2010", quiet = TRUE)
dataregion <- select(D[-1,], Productivite, Poids_Disp, Disp_surface)
dataregion <- mutate(dataregion,NUTS_NAME = map$NUTS_NAME)


map_data <- inner_join(map, dataregion)
str(map_data)
ggplot(map_data)+geom_sf(aes(fill= Productivite))

ggplot(map_data)+geom_sf(aes(fill= Poids_Disp))

ggplot(map_data)+geom_sf(aes(fill= Disp_surface))



