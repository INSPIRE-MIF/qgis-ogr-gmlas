#!/usr/bin/env bash

cd /home/qgis/qgisgmlas/data

echo "Removing old dbs ..."
rm -fr db/*.sqlite


echo "Converting samples to sqlite format ..."

l=(
    'inspire/BR/bioGeographicalRegion.gml::BR.sqlite'
    'inspire/GE/geologicalunit.gml::GE.sqlite'
    'inspire/LC/lcvLandCoverDataset.gml::LC.sqlite'
    'inspire/LC/lcvLandCoverUnit.gml::LC.sqlite'
    'inspire/PS/cddaDesignatedArea.gml::PS.sqlite'

)

for index in "${l[@]}" ; do
    KEY="${index%%::*}"
    VALUE="${index##*::}"
  echo "  $KEY > $VALUE ..."
  ogr2ogr db/$VALUE GMLAS:$KEY \
      -f sqlite -dsco spatialite=yes  -oo EXPOSE_METADATA_LAYERS=YES
done
echo "Done."



