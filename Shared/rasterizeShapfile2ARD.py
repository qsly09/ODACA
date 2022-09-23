import sys
import gdal
import ogr
from pathlib import Path

# Source code is at https://www.programcreek.com/python/example/101827/gdal.RasterizeLayer

def rasterize_shapefile_like(shpfile, model_raster_fname, outfile, dtype, options,
                             nodata_val=0):
    """
    Given a shapefile, rasterizes it so it has
    the exact same extent as the given model_raster

    `dtype` is a gdal type like gdal.GDT_Byte
    `options` should be a list that will be passed to GDALRasterizeLayers
        papszOptions, like ["ATTRIBUTE=vegetation","ALL_TOUCHED=TRUE"]
    """
    model_dataset = gdal.Open(model_raster_fname)
    shape_dataset = ogr.Open(shpfile)
    shape_layer = shape_dataset.GetLayer()
    mem_drv = gdal.GetDriverByName('GTiff')
    mem_raster = mem_drv.Create(
        outfile,
        model_dataset.RasterXSize,
        model_dataset.RasterYSize,
        1,
        dtype
    )
    mem_raster.SetProjection(model_dataset.GetProjection())
    mem_raster.SetGeoTransform(model_dataset.GetGeoTransform())
    mem_band = mem_raster.GetRasterBand(1)
    mem_band.Fill(nodata_val)
    mem_band.SetNoDataValue(nodata_val)

    # http://gdal.org/gdal__alg_8h.html#adfe5e5d287d6c184aab03acbfa567cb1
    # http://gis.stackexchange.com/questions/31568/gdal-rasterizelayer-doesnt-burn-all-polygons-to-raster
    err = gdal.RasterizeLayer(
        mem_raster,
        [1],
        shape_layer,
        None,
        None,
        [1],
        options
    )

    assert err == gdal.CE_None
    return mem_raster.ReadAsArray() 

if __name__ == '__main__':
    # shpfile = r'/lustre/scratch/qiu25856/DataMTBS/mtbs_perimeter_data_each_year/mtbs_yr2007.shp'
    # rasterlike = r'/lustre/scratch/qiu25856/COLDResults/CONUS_v2/h003v009/h003v009_extent.tif'
    # outfile = r'/lustre/scratch/qiu25856/test_h003v009_extent.tif'
    # how to use
    # python ./rasterizeShapfile2ARD.py '/lustre/scratch/qiu25856/DataMTBS/mtbs_perimeter_data_each_year/mtbs_yr2007.shp' '/lustre/scratch/qiu25856/COLDResults/CONUS_v2/h003v009/h003v009_extent.tif' '/lustre/scratch/qiu25856/test_h003v009_extent.tif' 'StartMonth' 'byte'
    
    shpfile = sys.argv[1]
    rasterlike = sys.argv[2]
    outfile = sys.argv[3]

    attri = sys.argv[4]
    # e.g., attri = 'StartMonth'
    gdt = sys.argv[5]
    #print(shpfile)
    if gdt == 'byte':
        gdal_gdt = gdal.GDT_Byte
    if gdt == 'uint16':
        gdal_gdt = gdal.GDT_UInt16
    if gdt == 'int16':
        gdal_gdt = gdal.GDT_Int16
    if gdt == 'uint32':
        gdal_gdt = gdal.GDT_UInt32
    if gdt == 'int32':
        gdal_gdt = gdal.GDT_Int32
    if gdt == 'float32':
        gdal_gdt = gdal.GDT_Float32
    if gdt == 'float64':
        gdal_gdt = gdal.GDT_Float64

    options = ['ATTRIBUTE=%s' % attri, 'ALL_TOUCHED=TRUE']
    # “ALL_TOUCHED”: May be set to TRUE to set all pixels touched by the line or polygons, not just those whose center is within the polygon or that are selected by brezenhams line algorithm. Defaults to FALSE.
    # e.g., options = ['ATTRIBUTE=StartMonth ALL_TOUCHED=TRUE']
    
    rasterize_shapefile_like(shpfile, rasterlike, outfile, gdal_gdt, options,
                             nodata_val=0)
    
