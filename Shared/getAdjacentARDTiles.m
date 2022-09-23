function hv_names = getAdjacentARDTiles(n_hv_in)
%% getAdjacentARDTiles is to get all the Landsat ARD tiles with 3 by 3 tiles, including its self tile
%
% Last update on Jan. 14, 2022
%
%

    if ischar(n_hv_in) % if inputing single string variable, and then we will convert to cell arrays
        n_hv_in = {n_hv_in};
    end
    
    % Loop each one of the Landsat ARD tiles
    hv_names = [];
    for i = 1: length(n_hv_in)
        n_hv = n_hv_in{i};
        % 3-by-3 Landsat ARD Tiles to get training samples and proportion; if not enough, search more samples from neighbors
        obj_hv = TilesLandsatARD(str2num(n_hv(2:4)),str2num(n_hv(6:end)));
        [neibr_h, neibr_v, ~] = getNeighbors(obj_hv); % the all ards are used will be not repreated next time
        % current tile ...
        hv_names = [hv_names; {n_hv}]; % add the self ard tile in the cell array
        % neighbor tiles ...
        for i_hv_name = 1: length(neibr_h)
            hv_names = [hv_names ; ...
                {['h',num2str(neibr_h(i_hv_name),'%03d') ,'v', num2str(neibr_v(i_hv_name), '%03d')]}];
        end
    end
    
    % remove Duplicates from Cell Array
    hv_names = unique(hv_names); 
    
    % only cover CONUS
    hv_names = hv_names(ismember(hv_names, odacasets.ARDTilesCONUS));
end