function outputImagePath = rasterizeShapfilePyGDAL(inputShapfilePath, imgPathLike, outputImagePath, attriLabel, gdt)
%CLIPRASTERRIOWARP is to use Python function to clip raster to same extent
%with same resolution
% # python ./rasterizeShapfile2ARD.py '/lustre/scratch/qiu25856/DataMTBS/mtbs_perimeter_data_each_year/mtbs_yr2007.shp' '/lustre/scratch/qiu25856/COLDResults/CONUS_v2/h003v009/h003v009_extent.tif' '/lustre/scratch/qiu25856/test1_h003v009_extent.tif' 'StartMonth' 'int16'
% attriLabel: field name in shp
% set for gdt, here
%   if gdt == 'byte':
%         gdal_gdt = gdal.GDT_Byte
%     if gdt == 'uint16':
%         gdal_gdt = gdal.GDT_UInt16
%     if gdt == 'int16':
%         gdal_gdt = gdal.GDT_Int16
%     if gdt == 'uint32':
%         gdal_gdt = gdal.GDT_UInt32
%     if gdt == 'int32':
%         gdal_gdt = gdal.GDT_Int32
%     if gdt == 'float32':
%         gdal_gdt = gdal.GDT_Float32
%     if gdt == 'float64':
%         gdal_gdt = gdal.GDT_Float64
 
    try
        commandStr = sprintf('. $HOME/MyPython/conda/etc/profile.d/conda.sh; conda activate; python %s/rasterizeShapfile2ARD.py %s %s %s %s %s; conda deactivate;',...
            fileparts(mfilename('fullpath')), ....% absolute path
            inputShapfilePath, imgPathLike, outputImagePath, attriLabel, gdt);
        system(commandStr);
    catch
        warning('Error: Rasterizing shapfile for %s \n', outputImagePath);
        outputImagePath = [];
    end

end

