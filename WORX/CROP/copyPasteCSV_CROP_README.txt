This script is edited to match input / output raw .laz files -> match only LAZs in defined AOI.
Unfortunately I just could not get PDAL's crop.polygon or any other function like that to work properly.
I couldnt land the geojson / WKT format no matter how hard I tried. Trying to figure out CRS mismatches / reprojections in QGIS was hell when trying to solve from a .shp -> gpkg / geojson / wkt.
Initally the solution was to just match the CRS and define a simple XY bounding box around the AOI in PDAL but no matter what I would get zero points returned.
instead of trying to troubleshoot a pipeline for 10 hours just use this unless you actually know what ur doing. i am a noob.

This solution took 15 minutes. 
original shapefile, tile index gpkg from AWS metadata from project.
Select by location where index overlays the AOI
Export as CSV, remove category headers, insert path into script.
ezpz
