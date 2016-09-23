# Consumption and use of GML complex features like INSPIRE harmonised data (vector), GeoSciML within QGIS

## Testing QGIS




## Testing GDAL

* How-to check GMLAS driver is available in GDAL?

```
gdalinfo --format GMLAS
```

* How-to list GML file feature types?

```
ogrinfo -ro GMLAS:cddaDesignatedArea.gml
INFO: Open of `GMLAS:cddaDesignatedArea.gml'
      using driver `GMLAS' successful.
1: DesignatedArea (Unknown (any), Point)
2: DesignatedArea_metaDataProperty (None)
3: DesignatedArea_name (None)
4: DesignatedArea_legalFoundationDocument_CI_Citation_alternateTitle (None)
5: DesignatedArea_legalFoundationDocument_CI_Citation_date (None)
6: DesignatedArea_legalFoundationDocument_CI_Citation_identifier (None)
7: DesignatedArea_legalFoundationDocument_CI_Citation_citedResponsibleParty (None)
...
```

* How-to display GML file content?
```
ogrinfo -ro -al GMLAS:cddaDesignatedArea.gml
```

* How-to display layer metadata? 

```
ogrinfo -ro -al GMLAS:cddaDesignatedArea.gml \
                              -oo EXPOSE_METADATA_LAYERS=YES

```


* How-to convert from GML to spatialite? 

```
ogr2ogr cdda.sqlite GMLAS:cddaDesignatedArea.gml \
      -f sqlite -dsco spatialite=yes  -oo EXPOSE_METADATA_LAYERS=YES
```

* How-to convert from GML to PostGIS? 

```
ogr2ogr PG:'host=localhost user=qgis password=qgis dbname=inspire' GMLAS:cddaDesignatedArea.gml \
      -f PostgreSQL -dsco spatialite=yes  -oo EXPOSE_METADATA_LAYERS=YES
```


* How-to convert from GML to spatialite using python? 

```
from osgeo import gdal
src_ds = gdal.OpenEx( 'GMLAS:cddaDesignatedArea.gml', \
                             open_options = ['EXPOSE_METADATA_LAYERS=YES'])
gdal.VectorTranslate('gmlas_test1.sqlite',  \
                               src_ds, \
                               format = 'SQLite', \
                               datasetCreationOptions = ['SPATIALITE=YES'] )
```




# Testing with the virtual box

This virtual box runs Ubuntu and is provided to test GML Application Schema support in QGIS and GDAL/OGR.

Software are installed in ```/home/qgis/qgisgmlas/sourcecode``` folder.

Username and password are ```qgis```/```qgis```.

## Sample datasets

Sample datasets are provided in ```/home/qgis/qgisgmlas/data``` folder.

```
├── db
│   ├── biogeographicalregion.sqlite
│   ├── cdda.sqlite
│   ├── geologicalunit.sqlite
│   ├── lcv.sqlite
│   └── mappedfeature.sqlite
├── geosciml
│   └── mappedfeature.gml
├── inspire
│   ├── biogeographicalregion
│   │   ├── bioGeographicalRegion.gfs
│   │   ├── bioGeographicalRegion.gml
│   │   └── INSPIRE_DataSpecification_BR_v3.0.pdf
│   ├── geologicalunit
│   │   └── geologicalunit.gml
│   ├── landcover
│   │   ├── INSPIRE_DataSpecification_LC_v3.0.pdf
│   │   ├── lcvLandCoverDataset.gml
│   │   ├── lcvLandCoverUnit.gfs
│   │   ├── lcvLandCoverUnit.gml
│   │   └── lcv.sqlite-journal
│   └── protectedsites
│       ├── cddaDesignatedArea.gfs
│       ├── cddaDesignatedArea.gml
│       └── INSPIRE_DataSpecification_PS_v3.2.pdf
└── testing
    └── array_type_test.sqlite
```

A script is provided for conversion ```convert-samples.sh```.

## Versions

### v20160923

* Samples conversion script

### v20160919

* QGIS3 with array support 
* GDAL GMLAS driver basic support
* Sample datasets for landcover, protected sites, biogeographical region


### v20160901

* Initial release with QGIS3 and GDAL2 build
