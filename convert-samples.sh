#!/usr/bin/env bash

echo "Creating POSTGRES DB schemas ..."
psql -U qgis -d inspire -f db.sql

echo "Moving to data folder ..."
cd /home/qgis/qgisgmlas/data

echo "Removing old SQLITE dbs ..."
rm -fr db/*.sqlite


echo "Converting samples ..."


l=(
    'inspire/BR/bioGeographicalRegion.gml:br:no'
# https://github.com/INSPIRE-MIF/qgis-ogr-gmlas/issues/1
#    'inspire/GE/geologicalunit.gml:ge:yes'
    'inspire/LC/lcvLandCoverDataset.gml:lc:yes'
    'inspire/LC/lcvLandCoverUnit.gml:lc:yes'
    'inspire/PS/cddaDesignatedArea.gml:ps:yes'
    'inspire/national/NL/cadastralparcel.gml:nl:auto'
    'inspire/national/NL/cadastralboundary.gml:nl:auto'
    'geology/AQD_UBA_oneOffering.xml:geology:auto'
    'geology/AQD_UBA_Sample_50.xml:geology:auto'
    'geology/AQD_UBA_SamplingPoint_50.xml:geology:no'
    'geology/AQD_UBA_Station_50.xml:geology:auto'
    'geology/BRGM_environmental_monitoring_facility_piezometer_50.xml:geology:auto'
    'geology/BRGM_raw_database_observation_waterml2_output.xml:geology:auto'
)

#CONFIGFILE=~/qgisgmlas/qgis-ogr-gmlas/gmlasconf-inspire.xml
CONFIGFILE=~/qgisgmlas/qgis-ogr-gmlas/gmlasconf-inspire-cleanunused.xml

for index in "${l[@]}" ; do
    KEY=$(echo $index | cut -f1 -d:)
    VALUE=$(echo $index | cut -f2 -d:)
    SWAPCOORDS=$(echo $index | cut -f3 -d:)
  echo "  $KEY > $VALUE ..."
  echo "    ... to sqlite format ..."
  ogr2ogr db/$VALUE.sqlite GMLAS:$KEY \
      -f sqlite -append -skipfailures \
      -nlt CONVERT_TO_LINEAR \
      -dsco spatialite=yes \
      -oo swap_coordinates=$SWAPCOORDS \
      -oo EXPOSE_METADATA_LAYERS=YES \
      -oo CONFIG_FILE=$CONFIGFILE

  echo "    ... to PostGIS format ..."
  aogr2ogr PG:'host=localhost user=qgis password=qgis dbname=inspire' \
      GMLAS:$KEY \
      -f PostgreSQL -skipfailures \
      -nlt CONVERT_TO_LINEAR \
      -lco OVERWRITE=YES -lco SCHEMA=$VALUE \
      -oo swap_coordinates=$SWAPCOORDS \
      -oo EXPOSE_METADATA_LAYERS=YES \
      -oo CONFIG_FILE=~/qgisgmlas/qgis-ogr-gmlas/gmlasconf-inspire.xml

done
echo "Done."



