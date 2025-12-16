---
title: 'Yosemite National Park'
author: "Brian Hughes"
date: "12/08/25"
output: html_document
---

### Instructions

**For each question below, show code.** Once you've completed things, don't forget to turn-in the rendered document (print as PDF).

A few tips:

-   Don't forget to knit your document frequently!
-   Don't forget to install packages and load them using `library()`.
-   Don't forget to use `?` or `help()` if you're unsure about a function
-   **EXPLAIN WHAT YOUR RESULTS MEAN!** Think about the numbers and visualizations and explain, in words, what they mean.
-   Make sure you label all axes and legends and add a title to your plots and maps.
-   **NAME YOUR CHUNKS!**

**30 points total**

So far we have been working with **thematic maps** in class (eg choropleth maps). These maps show the distribution of a single attribute in space (or relationships among several attributes), and are used for display or analysis. In this assignment we will create **reference maps**, these maps are used to display the location of features, and are often used for navigation. A great example of reference maps (and one that you might already be familiar with) are [US National Park Service (NPS) Maps](https://www.nps.gov/carto/app/#!/parks).

**In this assignment you will work with data from the [NPS GIS Portal](https://public-nps.opendata.arcgis.com/) to create three reference maps for a national park of your choice. Maps in R are infinitely customizable, the goal of this assignment is for you to explore different map themes and aesthetics to get a feel for map customization. You may use `ggplot2`, `tmap`, or any other R mapping package to create your maps.**

### Set-up (5 points)

**2. Set your working directory below and load all of the packages you will need for creating your maps.**

```{r setup}
knitr::opts_knit$set(root.dir = "C:/Users/Brian/Downloads/lab05/lab05")
library(sf)
library(ggplot2)
library(dplyr)
library(tmap)
library(ggspatial)
#Set my working directory and loaded all the packages that will be required for the labs completion.
```

2.  Now you will need to download and import your data. I have provided you with a shapefile of NPS park boundaries but you will need to download some additional shape files to create your reference maps. You can find all available shapefiles for a park by searching for the park name on the [NPS Data Portal](https://public-nps.opendata.arcgis.com/). For instance the search below will produce all the available files for Canyonlands National Park:

![search for Canyonlands shapefiles](Screenshot_2021-02-15%20National%20Park%20Service.png)

**You must use 2 additional shapefiles for your maps. One of these shapefiles should be a line feature (eg trails) the other shapefile should be a point feature (eg points of interest).**

**Import all of your shapefiles into `R`, check their projections. Reproject your shapefiles if you need to.**

```{r shape import}
yosem_boundary <- st_read("C:/Users/Brian/Downloads/lab05/lab05/data/YOSE_BND_ParkBoundary_7098462487663422295")
shuttle_routes <- st_read("C:/Users/Brian/Downloads/lab05/lab05/data/Yosemite_National_Park_-_Shuttle_Routes_-_Open_Data")
AQ_sensors <- st_read("C:/Users/Brian/Downloads/lab05/lab05/data/YOSE_AIR_Air_Quality_Sensors")
print("park Boundary CRS:")
st_crs(yosem_boundary)
print("Shuttle Routes CRS:")
st_crs(shuttle_routes)
print("Air Quality Sensors:")
st_crs(AQ_sensors)
#Imported the boundaries, shuttle routes, and air quality sensors of Yosemite National Park. I then used the st_crs command to ensure that all three shapefiles were the same projection.
```

### Map 1: Park Reference Map (5 points)

**3. Create a reference map for the full extent of the park. This map must include the park boundary and at least two additional shapefiles from the [NPS Data Portal](https://public-nps.opendata.arcgis.com/). One of these shapefiles should be a line feature (eg trails) the other shape file should be a point feature (eg points of interest). Your map should also include a title, legend, scale bar, and north arrow.** Hint: If you are using tmap, the elements `tm_lines` and `tm_symbols` allow you to add point and line features to your map.

```{r map 1}
ggplot() +
  geom_sf(data = yosem_boundary, 
          fill = "#e8f4e8",        
          color = "#2d5016",        
          linewidth = 1.5,
          alpha = 0.3) +

  #Added park boundary data to the map and set its symbology.
  
  geom_sf(data = shuttle_routes,
          color = "#d62728",        
          linewidth = 1.2) +
  
  #Added shuttle route data to the map and set its symbology.
 
  geom_sf(data = AQ_sensors,
          color = "#1f77b4",        
          size = 2.25,
          shape = 17) +            
  
  #Added air quality sensor data to the map and set its symbology.
  
  labs(title = "Yosemite National Park Reference Map",
       subtitle = "Shuttle Routes and Air Quality Monitoring Stations") +
  
  annotation_north_arrow(location = "br",           
                         which_north = "true",
                         pad_x = unit(0.1, "in"),
                         pad_y = unit(0.1, "in"),
                         style = north_arrow_fancy_orienteering) +
  
  annotation_scale(location = "bl",                
                   width_hint = 0.3,                
                   pad_x = unit(0.2, "in"),
                   pad_y = unit(0.05, "in")) +
  
  theme_minimal() +
  theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        axis.text = element_text(size = 6),
        panel.grid.major = element_line(color = "gray90"),
        panel.background = element_rect(fill = "white"))

#Addition of titles and labeling to the map along with reference elements, the scale bar and north arrow. Final step to set thematic options for the map.

```

### Map 2: Site Reference Map (5 points)

**4. Create a reference map for a specific site in the park. This could be your favorite trail, a specific camp ground, a point of interest, or any other park location that you want to highlight. Make sure that you choose a bounding box for your map with an extent that fully contains the site that you are highlighting. Your site map should include at least 2 point, line, or polygon features that highlight important site characteristics. For instance if you were creating a map of Old Faithful, you could highlight the geyser location and the trail system surrounding the geyser, you might also show the nearby lodge. Your map should also include text labels highlighting key features (eg Old Faithful), a title, legend, scale bar, and north arrow.**

```{r map 2}
yosem_floodplain <- st_read("C:/Users/Brian/Downloads/lab05/lab05/data/Floodplain_Polygons")
yosem_trails <- st_read("C:/Users/Brian/Downloads/lab05/lab05/data/Yosemite_National_Park_-_Trails_-_Open_Data")

#Imported data for floodplains and trails within Yosemite.

floodplain_bbox <- st_bbox(yosem_floodplain)
floodplain_buffered <- st_buffer(yosem_floodplain, dist = 2000)  # 2000 meter buffer
site_bbox <- st_bbox(floodplain_buffered)

#Created a bounding box around the floodplain and then applied a buffer of 2000 meters around said bounding box. This buffered bounding box was then set as the bounding box for the site.

site_boundary <- st_crop(yosem_boundary, site_bbox)
site_trails <- st_crop(yosem_trails, site_bbox)

#Narrows visbility of feature class to the bounding box.

ggplot() +
  # Add park boundary for context
  geom_sf(data = site_boundary, 
          fill = "#e8f4e8",
          color = "#2d5016",
          linewidth = 1.5,
          alpha = 0.3) +
  
  geom_sf(data = yosem_floodplain,
          aes(fill = "Floodplain Zone"),
          color = "#1E90FF",
          linewidth = 0.2,
          alpha = 0.5) +
  
  geom_sf(data = site_trails,
          aes(color = "Trails"),
          linewidth = 0.2) +
  
  #Adds in park boundary, floodplain, and trail data to the map along with the basic symbology.
  
  scale_fill_manual(name = "Hazard Areas",
                    values = c("Floodplain Zone" = "#6CA6CD")) +
  scale_color_manual(name = "Trail System",
                     values = c("Trails" = "#B22222")) +

  #Symbology for the legend representing trails and floodplains.
  
  labs(title = "Yosemite Floodplain Area",
       subtitle = "Trails Within Flood-Prone Zones") +
  
  annotation_north_arrow(location = "br",
                         which_north = "true",
                         pad_x = unit(0.2, "in"),
                         pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering) +
  
  annotation_scale(location = "bl",
                   width_hint = 0.25,
                   pad_x = unit(0.2, "in"),
                   pad_y = unit(0.04, "in")) +
                    
  theme_minimal() +
  theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 11, hjust = 0.5),
        legend.position = "right",
        legend.title = element_text(face = "bold"),
        legend.text = element_text(size = 9),
        axis.text = element_text(size = 9),
        panel.grid.major = element_line(color = "gray90"),
        panel.background = element_rect(fill = "white"))

#Addition of titles and labeling to the map along with reference elements, the scale bar and north arrow. Final step to set thematic options for the map.
```

### Map 3: Interactive Map (5 points)

**5. Convert your park reference map (Map 1) to an interactive map using `tmap`, `mapview`, or `leaflet`. This map does not need to include a legend compass, scale bar, or title.**

```{r interactive map}
tmap_mode("view")

#Sets the mode of the map to be interactive.

tm_shape(yosem_boundary) +
  tm_borders(col = "#2d5016", lwd = 2) +
  tm_fill(col = "#e8f4e8", alpha = 0.3) +
tm_shape(shuttle_routes) +
  tm_lines(col = "#d62728", lwd = 3) +
tm_shape(AQ_sensors) +
  tm_dots(col = "#1f77b4", size = 0.3, border.col = "#1f77b4", border.lwd = 2)

#Adding data and setting the symbology for the map.
```

## 3. QGIS

Make a map that is the same as your map in QGIS.

<img src="Map1lab5.png" width="600"/>

## 4. Reflection (3 points)

When conducting data analysis, you as a researcher not only have to demonstrate your technical skills but consider your choices and their impacts. Reflecting on data analysis helps you document your process, what worked, what didn't, and how you might improve. At the end of each class assignment you will asked to write a sort reflection.

For this reflection keep in mind the principles of feminist data visualization

-   Rethink binaries
-   Embrace Pluralism
-   Examine power and aspire to empower
-   Consider context and subjectivity
-   Represent uncertainty
-   Legitimize embodiment and affect
-   Make labor visible

and please respond to the the following prompts:

**1. How did you choose the symbology for your maps?**

For this assignment I chose my symbologies for the map based off of what I thought would be the simplest to interpret as the audience would be the general public attending national parks, the vast majority of which will not have cartographic knowledge. Both air and water are elements commonly associated with the color blue so I chose to symbolize them in that color. I then chose red as it contrasts effectively against blue, clearly differentiating the trails and shuttle stops from the air quality sensors and floodplains. Additionally, I chose to symbolize the border with a dark green as this should always be done with a very dark color as to show it's part of the background information on the map and not the primary feature being showcased. I think after considering the principles of feminist data visualization that I could have made more conscious choices with my symbology, for example my color choice of red and blue is very basic and fits with traditional binaries.

**3. Have a look at the [NPS map symbol library](https://www.nps.gov/maps/tools/symbol-library/) choose one symbol and describe how you would re-draw or re-lable the symbol. You can answer this question by inserting a photo of a re-drawn symbol.**

<img src="lab5symbol.png" width="600"/>

I would have used this symbol at parts of the trail shapefile to determine which trails are meant for bikes and which ones are not.

Kint your file and submit the html on CANVAS.
