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
    'inspire/national/NL/cadastralparcel.gml::NL'
    'inspire/national/NL/building.gml::NL'
    'inspire/national/NL/cadastralboundary.gml::NL'
)

for index in "${l[@]}" ; do
    KEY="${index%%::*}"
    VALUE="${index##*::}"
  echo "  $KEY > $VALUE ..."
  ogr2ogr db/$VALUE.sqlite GMLAS:$KEY \
      -f sqlite -append -skipfailures -nlt CONVERT_TO_LINEAR -oo swap_coordinates=no -dsco spatialite=yes \
      -oo EXPOSE_METADATA_LAYERS=YES
  ogr2ogr PG:'host=localhost user=qgis password=qgis dbname=inspire' \
      GMLAS:$KEY \
      -f PostgreSQL -skipfailures -nlt CONVERT_TO_LINEAR \
      -lco OVERWRITE=YES -lco SCHEMA=$VALUE -oo EXPOSE_METADATA_LAYERS=YES

done
echo "Done."



