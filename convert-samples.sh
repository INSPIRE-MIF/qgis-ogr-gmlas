#!/usr/bin/env bash

cd /home/qgis/qgisgmlas/data

echo "Removing old dbs ..."
rm -fr db/*.sqlite


echo "Converting samples to sqlite and PostGIS format ..."

l=(
    'inspire/BR/bioGeographicalRegion.gml::BR'
    'inspire/GE/geologicalunit.gml::GE'
    'inspire/LC/lcvLandCoverDataset.gml::LC'
    'inspire/LC/lcvLandCoverUnit.gml::LC'
    'inspire/PS/cddaDesignatedArea.gml::PS'
)

for index in "${l[@]}" ; do
    KEY="${index%%::*}"
    VALUE="${index##*::}"
  echo "  $KEY > $VALUE ..."
  ogr2ogr db/$VALUE.sqlite GMLAS:$KEY \
      -f sqlite -skipfailures -dsco spatialite=yes \
      -oo EXPOSE_METADATA_LAYERS=YES
  ogr2ogr PG:'host=localhost user=qgis password=qgis dbname=inspire' \
      GMLAS:$KEY \
      -f PostgreSQL -skipfailures \
      -lco OVERWRITE=YES -lco SCHEMA=$VALUE -oo EXPOSE_METADATA_LAYERS=YES

done
echo "Done."



