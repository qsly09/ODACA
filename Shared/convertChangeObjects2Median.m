function record_objs = convertChangeObjects2Median(record_objs, varargin)
%CONVERTCHANGEOBJECTS2MEDIAN is to convert change object to object with
%median value
    p = inputParser;
    addParameter(p, 'proportion', false); % designed for sampled map for estimating proportion
    parse(p,varargin{:});
    proportion=p.Results.proportion;
    for i = 1: length(record_objs)
        record_objs(i).DOY = median([record_objs(i).DOY]);
            
        record_objs(i).CoeffsMag = median([record_objs(i).CoeffsMag],2);
        record_objs(i).CoeffsPre = median([record_objs(i).CoeffsPre],3);
        record_objs(i).RMSEPre = median([record_objs(i).RMSEPre],2);
        record_objs(i).CoeffsDurCha = median([record_objs(i).CoeffsDurCha],3);
        record_objs(i).CoeffsPost = median([record_objs(i).CoeffsPost],3);
        record_objs(i).RMSEPost = median([record_objs(i).RMSEPost],2);
        record_objs(i).Interval = median([record_objs(i).Interval]);
        record_objs(i).Elev = median([record_objs(i).Elev]);
        record_objs(i).Slope = median([record_objs(i).Slope]);
        record_objs(i).Aspect = median([record_objs(i).Aspect]);
        record_objs(i).Frequency = median([record_objs(i).Frequency]);
        
        
        if proportion % we do this here because the num2cell does not work to bacth processing
            record_objs(i).NumSamples = sum([record_objs(i).PixelIdxListDownSampled]);
        end
    end
    
end

