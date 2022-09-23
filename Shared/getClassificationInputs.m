function [inputdata, inputname, objectid] = getClassificationInputs(changerecords, varargin)
%GETCLASSIFICATIONINPUTS is to get the inputdata of classification model
    
    %% setup default inputdata
    default_inputs.band            =  {'blue', 'green', 'red', 'nir', 'swir1', 'swir2', 'thermal'};
    default_inputs.coefficient    =  {'a0', 'c0', 'a1', 'b1', 'a2', 'b2', 'a3', 'b3', 'rmse'};
    default_inputs.model          =  {'pre_change_model', 'post_change_model'};
    default_inputs.change        =  {'doy', 'interval', 'change_magnitude', 'during_change_slope', 'during_change_rmse', 'frequency'};
    default_inputs.context        =  {'std_doy', 'std_interval', 'std_change_magnitude'};
    default_inputs.shape          =  {'area', 'cai', 'circle', 'contig', 'core', 'enn', 'frac', 'gyrate', 'ncore', 'para', 'perim', 'shape'};
    default_inputs.topography  =  {'elevation', 'slope', 'aspect', 'elevation_range'};

    %%  request the customized inputdata
    p = inputParser;
    addParameter(p, 'band', default_inputs.band);
    addParameter(p, 'coefficient', default_inputs.coefficient);
    addParameter(p, 'change', default_inputs.change);
    addParameter(p, 'model', default_inputs.model);
    addParameter(p, 'context', default_inputs.context);
    addParameter(p, 'shape', default_inputs.shape);
    addParameter(p, 'topography', default_inputs.topography);

    parse(p,varargin{:});
    band            =  p.Results.band;
%     band            =  {'blue', 'green', 'red', 'nir', 'swir1', 'swir2'}; % do not use the thermal band
    coefficient    =  p.Results.coefficient;
    change        =  p.Results.change;
    model        =  p.Results.model;
    context        =  p.Results.context;
    shape         = p.Results.shape;
    topography = p.Results.topography;

    %%
    input_bands = ismember(default_inputs.band, band); % 7 bands in total
    input_coeffs = ismember(default_inputs.coefficient, coefficient); % 9 coeffs in total a0 c0 a1 b1 a2 b2 a3 b3, and RMSE
    inModelCoeffs = input_bands.*input_coeffs';
    inModelCoeffs = inModelCoeffs(:)';

    inPreModel = ismember('pre_change_model', model);
    inPostModel = ismember('post_change_model', model);

    inDOY = ismember('doy', change);
    inInterval = ismember('interval', change);
    inChangeMag = ismember('change_magnitude', change);
    inDuringChange = ismember({ 'during_change_slope', 'during_change_rmse'}, change);
    inFrequency = ismember('frequency', change);

    inStdDOY =  ismember('std_doy', context);
    inStdInterval = ismember('std_interval', context);
    inStdChangeMag = ismember('std_change_magnitude', context);

    inShape = ismember(default_inputs.shape, shape);

    inTopography = ismember(default_inputs.topography, topography);

    inAll = [inDOY, inInterval, inChangeMag.*input_bands, inDuringChange, inFrequency, ... % change
        inPreModel.*inModelCoeffs, inPostModel.*inModelCoeffs, ... % coefficents and rmse of time series model
        inStdDOY, inStdInterval, inStdChangeMag, ... % context
        inShape, ... % shape
        inTopography]; % topography


    %% convert to inputdata 1-dimension array for each record
    inputdata = zeros(length(changerecords), sum(inAll));
    clear inputname;
    inputname(1, 1:sum(inAll)) = deal({'unknown'});
    if isfield(changerecords, 'ID')
        objectid = extractfield(changerecords, 'ID');
    else
        objectid = [];
    end
    i = 1; % starting index from 1
    if inDOY
        % data
        inputdata(:,i) =extractfield(changerecords, 'DOY');
        % name
        inputname(i) = {'change_doy'};
        i = i + 1;
    end
    if inInterval
        % data
        inputdata(:,i) = extractfield(changerecords, 'Interval');
        % name
        inputname(i) = {'change_interval_days'};
        % next index
        i = i + 1;
    end
    if inChangeMag && sum(input_bands) > 0
        % data
        inputs_tmp = [changerecords.CoeffsMag]';
        inputs_tmp(:, ~input_bands) = []; % which bands
        inputdata(:, i: i + size(inputs_tmp, 2) - 1 ) = inputs_tmp;
        % name
        inputname(i: i + size(inputs_tmp, 2) - 1) = getbandcoeffnames(default_inputs.band(input_bands), {'change_magnitude'});
        % next index
        i = i + size(inputs_tmp, 2) - 1 + 1;
        clear inputs_tmp;
    end
    if sum(inDuringChange) > 0 && sum(input_bands) > 0
        % data
        inputs_tmp = [changerecords.CoeffsDurCha];
        inputs_tmp = reshape(inputs_tmp(:), [length(inDuringChange).*length(input_bands), length(changerecords)] )';
        input_bands_durchange =  input_bands.*inDuringChange';
        input_bands_durchange = input_bands_durchange(:);
        inputs_tmp(:, ~input_bands_durchange) = []; % which bands
        inputdata(:, i: i + size(inputs_tmp, 2) - 1 ) = inputs_tmp;
        % name
        inputname(i: i + size(inputs_tmp, 2) - 1) = getbandcoeffnames(default_inputs.band(input_bands), {'during_change_slope', 'during_change_rmse'});
        % next index
        i = i + size(inputs_tmp, 2) - 1 + 1;
        clear input_bands_durchange inputs_tmp;
    end
    
    if inFrequency
        % data
        inputdata(:,i) = extractfield(changerecords, 'Frequency');
        % name
        inputname(i) = {'change_frequency'};
        % next index
        i = i + 1;
    end

    if inPreModel && sum(input_coeffs) > 0 && sum(input_bands) > 0
        % data for model coefficents
        inputs_tmp_coeffs = [changerecords.CoeffsPre];
        inputs_tmp_coeffs = reshape(inputs_tmp_coeffs(:), [(length(input_coeffs)-1).*length(input_bands), length(changerecords)] )';
        input_bands_coeffs =  input_bands.*input_coeffs(1:end-1)';
        inputs_tmp_coeffs(:, ~  input_bands_coeffs(:)) = []; % which bands
        inputdata(:, i: i + size(inputs_tmp_coeffs, 2) - 1 ) = inputs_tmp_coeffs;
        % name for model coefficents
        inputname(i: i + size(inputs_tmp_coeffs, 2) - 1) =  getbandcoeffnames(default_inputs.band(input_bands), default_inputs.coefficient(input_coeffs(1:end-1)), 'affix', 'pre-change-model');
        % next index
        i = i + size(inputs_tmp_coeffs, 2) - 1 + 1;

        % data for model rmse
        if input_coeffs(end)
            inputs_tmp_rmse = [changerecords.RMSEPre];
            inputs_tmp_rmse = reshape(inputs_tmp_rmse(:), [1.*length(input_bands), length(changerecords)] )';
            input_bands_rmse =  input_bands.*input_coeffs(end)';
            inputs_tmp_rmse(:, ~  input_bands_rmse(:)) = []; % which bands
            inputdata(:, i: i + size(inputs_tmp_rmse, 2) - 1 ) = inputs_tmp_rmse;
            % name for model rmse
            inputname(i: i + size(inputs_tmp_rmse, 2) - 1) =  getbandcoeffnames(default_inputs.band(input_bands), {'rmse'}, 'affix', 'pre-change-model');
            % next index
            i = i + size(inputs_tmp_rmse, 2) - 1 + 1;
        end
        clear inputs_tmp_coeffs inputs_tmp_rmse;
    end

    if inPostModel && sum(input_coeffs) > 0 && sum(input_bands) > 0
        % data for model coefficents
        inputs_tmp_coeffs = [changerecords.CoeffsPost];
        inputs_tmp_coeffs = reshape(inputs_tmp_coeffs(:), [(length(input_coeffs)-1).*length(input_bands), length(changerecords)] )';
        input_bands_coeffs =  input_bands.*input_coeffs(1:end-1)';
        inputs_tmp_coeffs(:, ~  input_bands_coeffs(:)) = []; % which bands
        inputdata(:, i: i + size(inputs_tmp_coeffs, 2) - 1 ) = inputs_tmp_coeffs;
        % name for model coefficents
        inputname(i: i + size(inputs_tmp_coeffs, 2) - 1) =  getbandcoeffnames(default_inputs.band(input_bands), default_inputs.coefficient(input_coeffs(1:end-1)), 'affix', 'post-change-model');
        % next index
        i = i + size(inputs_tmp_coeffs, 2) - 1 + 1;

        % data for model rmse
        if input_coeffs(end)
            inputs_tmp_rmse = [changerecords.RMSEPost];
            inputs_tmp_rmse = reshape(inputs_tmp_rmse(:), [1.*length(input_bands), length(changerecords)] )';
            inputs_tmp_rmse(:, ~  input_bands) = []; % which bands
            inputdata(:, i: i + size(inputs_tmp_rmse, 2) - 1 ) = inputs_tmp_rmse;
            % name for model rmse
            inputname(i: i + size(inputs_tmp_rmse, 2) - 1) =  getbandcoeffnames(default_inputs.band(input_bands), {'rmse'}, 'affix', 'post-change-model');
            i = i + size(inputs_tmp_rmse, 2) - 1 + 1;
        end
        clear inputs_tmp_coeffs inputs_tmp_rmse;
    end


    if inStdDOY
        % data
        inputdata(:,i) = [changerecords.StdDOY]';
        % name
        inputname(i) = {'std_change_doy'};
        % next index
        i = i + 1;
    end
    if inStdInterval
        % data
        inputdata(:,i) = [changerecords.StdInterval]';
        % name
        inputname(i) = {'std_change_interval'};
        % next index
        i = i + 1;
    end
    if inStdChangeMag && sum(input_bands) > 0
        % data
        inputs_tmp = [changerecords.StdCoeffsMag]';
        inputs_tmp(:, ~input_bands) = []; % which bands
        inputdata(:, i: i + size(inputs_tmp, 2) - 1 ) = inputs_tmp;
        % name
        inputname(i: i + size(inputs_tmp, 2) - 1) = getbandcoeffnames(default_inputs.band(input_bands), {'std_change_magnitude'});
        % next index
        i = i + size(inputs_tmp, 2) - 1 + 1;
    end

    if sum(inShape) > 0
        if inShape(1)
            % data
            inputdata(:, i) = extractfield(changerecords, 'area');
            % name
            inputname(i) = {'area'};
            % next index
            i = i + 1;
        end
        if inShape(2)
            % data
            inputdata(:, i) = extractfield(changerecords, 'cai');
            % name
            inputname(i) = {'cai'};
            % next index
            i = i + 1;
        end
        if inShape(3)
            % data
            inputdata(:, i) = extractfield(changerecords, 'circle');
            % name
            inputname(i) = {'circle'};
            % next index
            i = i + 1;
        end
        if inShape(4)
            % data
            inputdata(:, i) = extractfield(changerecords, 'contig');
            % name
            inputname(i) = {'contig'};
            % next index
            i = i + 1;
        end
        if inShape(5)
            % data
            inputdata(:, i) = extractfield(changerecords, 'core');
            % name
            inputname(i) = {'core'};
            % next index
            i = i + 1;
        end
        if inShape(6)
            % data
            inputdata(:, i) = extractfield(changerecords, 'enn');
            % name
            inputname(i) = {'enn'};
            % next index
            i = i + 1;
        end
        if inShape(7)
            % data
            inputdata(:, i) = extractfield(changerecords, 'frac');
            % name
            inputname(i) = {'frac'};
            % next index
            i = i + 1;
        end
        if inShape(8)
            % data
            inputdata(:, i) = extractfield(changerecords, 'gyrate');
            % name
            inputname(i) = {'gyrate'};
            % next index
            i = i + 1;
        end
        if inShape(9)
            % data
            inputdata(:, i) = extractfield(changerecords, 'ncore');
            % name
            inputname(i) = {'ncore'};
            % next index
            i = i + 1;
        end
        if inShape(10)
            % data
            inputdata(:, i) = extractfield(changerecords, 'para');
            % name
            inputname(i) = {'para'};
            % next index
            i = i + 1;
        end
        if inShape(11)
            % data
            inputdata(:, i) = extractfield(changerecords, 'perim');
            % name
            inputname(i) = {'perim'};
            % next index
            i = i + 1;
        end
        if inShape(12)
            % data
            inputdata(:, i) = extractfield(changerecords, 'shape');
            % name
            inputname(i) = {'shape'};
            % next index
            i = i + 1;
        end
    end

    if sum(inTopography) > 0
        if inTopography(1)
            try
                % data
                inputdata(:, i) = extractfield(changerecords, 'Elev');
            catch % support the array object, that was caused by the code of generating ODACA inputs
                tempdata = extractfield(changerecords, 'Elev');
                inputdata(:, i) = [tempdata{:}];
            end
            
            % name
            inputname(i) = {'elevation'};
            % next index
            i = i + 1;
        end
        if inTopography(2)
            try
                % data
                inputdata(:, i) = extractfield(changerecords, 'Slope');
            catch % support the array object, that was caused by the code of generating ODACA inputs
                tempdata = extractfield(changerecords, 'Slope');
                inputdata(:, i) = [tempdata{:}];
            end
            % name
            inputname(i) = {'slope'};
            % next index
            i = i + 1;
        end
        if inTopography(3)
            try
                % data
                inputdata(:, i) = extractfield(changerecords, 'Aspect');
            catch % support the array object, that was caused by the code of generating ODACA inputs
                tempdata = extractfield(changerecords, 'Aspect');
                inputdata(:, i) = [tempdata{:}];
            end
            % name
            inputname(i) = {'aspect'};
            % next index
            i = i + 1;
        end
        if inTopography(4)
            try
                % data
                inputdata(:, i) = extractfield(changerecords, 'RangElev');
            catch % support the array object, that was caused by the code of generating ODACA inputs
                tempdata = extractfield(changerecords, 'RangElev');
                inputdata(:, i) = [tempdata{:}];
            end
            % name
            inputname(i) = {'elevation_range'};
            % next index
            i = i + 1;
        end
    end
end

function bandcoeffnames = getbandcoeffnames(bandnames, coeffnames, varargin)
        p = inputParser;
        addParameter(p, 'affix', '');
        parse(p,varargin{:});
        affixname  =  p.Results.affix;

        bandcoeffnames = [];
        for j = 1: length(bandnames)
            for k = 1: length(coeffnames)
                if isempty(affixname)
                    bandcoeffnames = [bandcoeffnames; {[bandnames{j}, '_', coeffnames{k}]}];
                else
                    bandcoeffnames = [bandcoeffnames; {[affixname, '_', bandnames{j}, '_', coeffnames{k}]}];
                end
            end
        end
end

% %     inputdata = [inDOY, inInterval, inMag.*input_bands, ...
% %         inModelPre.*inModelCoeffs, inRMSEPre.*input_bands, inModelPost.*inModelCoeffs, inRMSEPost.*input_bands,...
% %         inElev, inSlope, inAspect, inElevRng...
% %         inStdDOY,...
% %         inStdInterval, ...
% %         inStdCoeffsMag.*input_bands,...
% %         inArea, inRatioAreaPerimeter, inConvexArea, inFilledArea,...
% %         inEccentricity, inMajorAxisLength, inMinorAxisLength, inOrientation,...
% %         inSolidity];
% % 
% %     
% %      feature_names ={'DOY', 'Interval', ...
% %         'Magnitude (Blue)', 'Magnitude (Green)', 'Magnitude (Red)', ...
% %         'Magnitude (NIR)', 'Magnitude (SWIR1)', 'Magnitude (SWIR2)', 'Magnitude (Thermal)', ...
% %         'Pre-model_a0 (Blue)', 'Pre-model_c0 (Blue)', ...
% %         'Pre-model_a1 (Blue)', 'Pre-model_b1 (Blue)', ...
% %         'Pre-model_a2 (Blue)', 'Pre-model_b2 (Blue)', ...
% %         'Pre-model_a3 (Blue)', 'Pre-model_b3 (Blue)',...
% %         'Pre-model_a0 (Green)', 'Pre-model_c0 (Green)', ...
% %         'Pre-model_a1 (Green)', 'Pre-model_b1 (Green)', ...
% %         'Pre-model_a2 (Green)', 'Pre-model_b2 (Green)', ...
% %         'Pre-model_a3 (Green)', 'Pre-model_b3 (Green)',...
% %         'Pre-model_a0 (Red)', 'Pre-model_c0 (Red)', ...
% %         'Pre-model_a1 (Red)', 'Pre-model_b1 (Red)', ...
% %         'Pre-model_a2 (Red)', 'Pre-model_b2 (Red)', ...
% %         'Pre-model_a3 (Red)', 'Pre-model_b3 (Red)',...
% %         'Pre-model_a0 (NIR)', 'Pre-model_c0 (NIR)', ...
% %         'Pre-model_a1 (NIR)', 'Pre-model_b1 (NIR)', ...
% %         'Pre-model_a2 (NIR)', 'Pre-model_b2 (NIR)', ...
% %         'Pre-model_a3 (NIR)', 'Pre-model_b3 (NIR)',...
% %         'Pre-model_a0 (SWIR1)', 'Pre-model_c0 (SWIR1)', ...
% %         'Pre-model_a1 (SWIR1)', 'Pre-model_b1 (SWIR1)', ...
% %         'Pre-model_a2 (SWIR1)', 'Pre-model_b2 (SWIR1)', ...
% %         'Pre-model_a3 (SWIR1)', 'Pre-model_b3 (SWIR1)',...
% %         'Pre-model_a0 (SWIR2)', 'Pre-model_c0 (SWIR2)', ...
% %         'Pre-model_a1 (SWIR2)', 'Pre-model_b1 (SWIR2)', ...
% %         'Pre-model_a2 (SWIR2)', 'Pre-model_b2 (SWIR2)', ...
% %         'Pre-model_a3 (SWIR2)', 'Pre-model_b3 (SWIR2)',...
% %         'Pre-model_a0 (Thermal)', 'Pre-model_c0 (Thermal)', ...
% %         'Pre-model_a1 (Thermal)', 'Pre-model_b1 (Thermal)', ...
% %         'Pre-model_a2 (Thermal)', 'Pre-model_b2 (Thermal)', ...
% %         'Pre-model_a3 (Thermal)', 'Pre-model_b3 (Thermal)',...
% %         'Pre-model_RMSE (Blue)', 'Pre-model_RMSE (Green)', ...
% %         'Pre-model_RMSE (Red)', 'Pre-model_RMSE (NIR)', ...
% %         'Pre-model_RMSE (SWIR1)', 'Pre-model_RMSE (SWIR2)', ...
% %         'Pre-model_RMSE (Thermal)',...
% %         'Post-model_a0 (Blue)', 'Post-model_c0 (Blue)', ...
% %         'Post-model_a1 (Blue)', 'Post-model_b1 (Blue)', ...
% %         'Post-model_a2 (Blue)', 'Post-model_b2 (Blue)', ...
% %         'Post-model_a3 (Blue)', 'Post-model_b3 (Blue)',...
% %         'Post-model_a0 (Green)', 'Post-model_c0 (Green)', ...
% %         'Post-model_a1 (Green)', 'Post-model_b1 (Green)', ...
% %         'Post-model_a2 (Green)', 'Post-model_b2 (Green)', ...
% %         'Post-model_a3 (Green)', 'Post-model_b3 (Green)',...
% %         'Post-model_a0 (Red)', 'Post-model_c0 (Red)', ...
% %         'Post-model_a1 (Red)', 'Post-model_b1 (Red)', ...
% %         'Post-model_a2 (Red)', 'Post-model_b2 (Red)', ...
% %         'Post-model_a3 (Red)', 'Post-model_b3 (Red)',...
% %         'Post-model_a0 (NIR)', 'Post-model_c0 (NIR)', ...
% %         'Post-model_a1 (NIR)', 'Post-model_b1 (NIR)', ...
% %         'Post-model_a2 (NIR)', 'Post-model_b2 (NIR)', ...
% %         'Post-model_a3 (NIR)', 'Post-model_b3 (NIR)',...
% %         'Post-model_a0 (SWIR1)', 'Post-model_c0 (SWIR1)', ...
% %         'Post-model_a1 (SWIR1)', 'Post-model_b1 (SWIR1)', ...
% %         'Post-model_a2 (SWIR1)', 'Post-model_b2 (SWIR1)', ...
% %         'Post-model_a3 (SWIR1)', 'Post-model_b3 (SWIR1)',...
% %         'Post-model_a0 (SWIR2)', 'Post-model_c0 (SWIR2)', ...
% %         'Post-model_a1 (SWIR2)', 'Post-model_b1 (SWIR2)', ...
% %         'Post-model_a2 (SWIR2)', 'Post-model_b2 (SWIR2)', ...
% %         'Post-model_a3 (SWIR2)', 'Post-model_b3 (SWIR2)',...
% %         'Post-model_a0 (Thermal)', 'Post-model_c0 (Thermal)', ...
% %         'Post-model_a1 (Thermal)', 'Post-model_b1 (Thermal)', ...
% %         'Post-model_a2 (Thermal)', 'Post-model_b2 (Thermal)', ...
% %         'Post-model_a3 (Thermal)', 'Post-model_b3 (Thermal)',...
% %         'Post-model_RMSE (Blue)', 'Post-model_RMSE (Green)', ...
% %         'Post-model_RMSE (Red)', 'Post-model_RMSE (NIR)', ...
% %         'Post-model_RMSE (SWIR1)', 'Post-model_RMSE (SWIR2)', ...
% %         'Post-model_RMSE (Thermal)',...
% %         'Elevation', 'Slope', 'Aspect','ElevationRange',...
% %         'StdDOY', 'StdInterval',...
% %         'StdMagnitude (Blue)', 'StdMagnitude (Green)', 'StdMagnitude (Red)', ...
% %         'StdMagnitude (NIR)', 'StdMagnitude (SWIR1)', 'StdMagnitude (SWIR2)', 'StdMagnitude (Thermal)', ...
% %         'Area', 'RatioAreaPerimeter','ConvexArea', 'FilledArea',...
% %         'Eccentricity', 'MajorAxisLength', 'MinorAxisLength', 'Orientation',...
% %         'Solidity'};