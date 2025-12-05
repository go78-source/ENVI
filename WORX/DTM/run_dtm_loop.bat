@echo off
setlocal ENABLEDELAYEDEXPANSION

set INPUT=C:\LIDAR\CampFire_2018\smrf_classified
set OUTPUT=C:\LIDAR\CampFire_2018\DTM_tiles
set JSON="C:\LIDAR\CampFire_2018\smrf_classified\dtm_single.json"

if not exist "%OUTPUT%" mkdir "%OUTPUT%"

echo ==========================================
echo RUNNING DTM GENERATION LOOP
echo ==========================================

for %%F in (%INPUT%\*.laz) do (
    echo Processing %%F
    set BASE=%%~nF
    pdal pipeline "%JSON%" --readers.las.filename="%%F" --writers.gdal.filename="%OUTPUT%\!BASE!_DTM.tif"
)

echo ==========================================
echo DONE — CHECK THE DTM_tiles FOLDER
echo ==========================================

pause
