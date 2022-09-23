classdef TilesLandsatARD
    %TILESLANDSATARD is to provide Landsat ARD tiles's h and v
    
    properties
        % h: 0 - 32  labeling 1 - 33
        % v: 0 - 21  labeling 1 - 22
        tiles = zeros(22,33, 'logical');
    end
    
    methods
        function obj = TilesLandsatARD(h,v)
            %TILESLANDSATARD Construct an instance of this class
            obj.tiles(v+1,h+1) = 1;
        end
        
        function [h, v, obj,isexpd] = getNeighbors(obj)
            %getNeighbors is to extract neighbor tiles
            neighbors = imdilate(obj.tiles,true(3));
            [v, h] = find(neighbors&~obj.tiles); % exclude themselves
            h = h-1;
            v = v-1;
            
            obj.tiles = neighbors; % update the current central
            
            % have no more data available
            if sum(neighbors(:)) == size(neighbors,1)*size(neighbors,2)
                isexpd = 0; % full
            else
                isexpd = 1; % cannot be expanded any more
            end
            
        end
        
        function [h,v] = getCentrals(obj)
            [v, h] = find(obj.tiles);
            h = h-1;
            v = v-1;
        end
    end
end

