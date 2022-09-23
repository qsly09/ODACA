function outputImagePath = warpRasterRIO(inputImagePath, imgPathLike, outputImagePath)
%CLIPRASTERRIOWARP is to use Python function to clip raster to same extent
%with same resolution
    try
        commandStr = sprintf('. $HOME/MyPython/conda/etc/profile.d/conda.sh; conda activate; rio warp %s %s --like %s; conda deactivate;',...
            inputImagePath, outputImagePath, imgPathLike);
        system(commandStr);
    catch
        outputImagePath = [];
        warning('Error: Clipping raster for %s \n', inputImagePath);
    end

end

