function record_pixels = convertChangeObjects2Pixels(record_objs, varargin)
%CONVERTCHANGEOBJECTS2PIXELS 
    if isempty(record_objs)
        record_pixels = [];
        return;
    end
    p = inputParser;
    addParameter(p, 'train', false); % designed for training samples
    addParameter(p, 'proportion', false); % designed for sampled map for estimating proportion
    addParameter(p, 'number', false); % designed for computing number of pixel samples
    parse(p,varargin{:});
    train=p.Results.train;
    proportion=p.Results.proportion;
    number = p.Results.number;
    
    record_pixels = [];
    cell_tmp = num2cell(extractfield(record_objs, 'PixelIdxList'));
    totalnum = length(cell_tmp);
    [record_pixels(1: totalnum).PixelIdxList] = cell_tmp{:};
    if ~number
    %     record_objs = rmfield(record_objs, 'PixelIdxList');

        cell_tmp = num2cell(extractfield(record_objs, 'DOY'));
        [record_pixels(1:end).DOY] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'DOY');

        cell_tmp = num2cell(reshape(extractfield(record_objs, 'CoeffsMag'), 7, totalnum), 1);
        [record_pixels(1:end).CoeffsMag] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'CoeffsMag');

        cell_tmp = num2cell(reshape(extractfield(record_objs, 'CoeffsPre'), 8, 7, totalnum), [1,2]);
        [record_pixels(1:end).CoeffsPre] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'CoeffsPre');

        cell_tmp = num2cell(extractfield(record_objs, 'TstartPre'));
        [record_pixels(1:end).TstartPre] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'TstartPre');

        cell_tmp = num2cell(extractfield(record_objs, 'TendPre'));
        [record_pixels(1:end).TendPre] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'TendPre');

        cell_tmp = num2cell(reshape(extractfield(record_objs, 'RMSEPre'), 7, totalnum), 1);
        [record_pixels(1:end).RMSEPre] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'RMSEPre');

        cell_tmp = num2cell(reshape(extractfield(record_objs, 'CoeffsDurCha'), 2, 7, totalnum), [1, 2]);
        [record_pixels(1:end).CoeffsDurCha] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'CoeffsDurCha');

        cell_tmp = num2cell(reshape(extractfield(record_objs, 'CoeffsPost'), 8, 7, totalnum), [1,2]);
        [record_pixels(1:end).CoeffsPost] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'CoeffsPost');

        cell_tmp = num2cell(extractfield(record_objs, 'TstartPost'));
        [record_pixels(1:end).TstartPost] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'TstartPost');

        cell_tmp = num2cell(extractfield(record_objs, 'TendPost'));
        [record_pixels(1:end).TendPost] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'TendPost');

        cell_tmp = num2cell(reshape(extractfield(record_objs, 'RMSEPost'), 7, totalnum), 1);
        [record_pixels(1:end).RMSEPost] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'RMSEPost');

        cell_tmp = num2cell(extractfield(record_objs, 'Interval'));
        [record_pixels(1:end).Interval] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'Interval');

        cell_tmp = num2cell(extractfield(record_objs, 'Frequency'));
        [record_pixels(1:end).Frequency] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'Frequency');

        cell_tmp = num2cell(extractfield(record_objs, 'Elev'));
        [record_pixels(1:end).Elev] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'Elev');

        cell_tmp = num2cell(extractfield(record_objs, 'Slope'));
        [record_pixels(1:end).Slope] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'Slope');

        cell_tmp = num2cell(extractfield(record_objs, 'Aspect'));
        [record_pixels(1:end).Aspect] = cell_tmp{:};
        record_objs = rmfield(record_objs, 'Aspect');
    end

    i_start = 1;
    for i = 1: length(record_objs)
        record_obj = record_objs(i);
        record_obj.Area = length(record_obj.PixelIdxList); % back to Area
        
        if ~number % not to count pixel samples
%             cell_tmp = num2cell(repmat(record_obj.Year,1, record_obj.Area));
%             [record_pixels(i_start: i_start + record_obj.Area - 1).Year] = cell_tmp{:};

            cell_tmp = num2cell(repmat(record_obj.ID,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).ID] = cell_tmp{:};

            % share same texture features in a same object
            cell_tmp = num2cell(repmat(record_obj.RangElev,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).RangElev] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.StdDOY,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).StdDOY] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.StdInterval,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).StdInterval] = cell_tmp{:};
            cell_tmp = (repmat(num2cell(record_obj.StdCoeffsMag,1),1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).StdCoeffsMag] = cell_tmp{:};

            % shape index
            cell_tmp = num2cell(repmat(record_obj.area,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).area] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.cai,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).cai] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.circle,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).circle] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.contig,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).contig] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.core,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).core] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.enn,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).enn] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.frac,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).frac] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.gyrate,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).gyrate] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.ncore,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).ncore] = cell_tmp{:};
            cell_tmp = num2cell(repmat(record_obj.para,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).para] = cell_tmp{:};  
            cell_tmp = num2cell(repmat(record_obj.perim,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).perim] = cell_tmp{:};  
            cell_tmp = num2cell(repmat(record_obj.shape,1, record_obj.Area));
            [record_pixels(i_start: i_start + record_obj.Area - 1).shape] = cell_tmp{:}; 
            
            if proportion % we do this here because the num2cell does not work to bacth processing
                cell_tmp = num2cell(record_obj.PixelIdxListDownSampled);
                [record_pixels(i_start: i_start + record_obj.Area - 1).PixelIdxListDownSampled] = cell_tmp{:}; 
            end
        end
        if train || number % we do this here because the num2cell does not work to bacth processing
            cell_tmp = num2cell(record_obj.PixelIdxListSample);
            [record_pixels(i_start: i_start + record_obj.Area - 1).PixelIdxListSample] = cell_tmp{:}; 
        end
        
        i_start = i_start + record_obj.Area; % update to next index 
    end
    
    if number
        record_pixels([record_pixels(:).PixelIdxListSample] == 0) = [];
    end
    
    if train
        record_pixels([record_pixels(:).PixelIdxListSample] == 0) = [];
        record_pixels = rmfield(record_pixels, 'PixelIdxListSample');
    end
end