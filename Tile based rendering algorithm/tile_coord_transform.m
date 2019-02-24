function [ tile_no_list, no_of_tiles ] = tile_coord_transform( Max_Tile_corners )
%this function transforms tile coordinate input into tile number list
%also gives as output the total number of tiles
%input tile coordinates is assumed to start from zero

tile_x_min = Max_Tile_corners(1);
tile_x_max = Max_Tile_corners(2);
tile_y_min = Max_Tile_corners(3);
tile_y_max = Max_Tile_corners(4);

no_of_tiles = (tile_x_max - tile_x_min + 1)*(tile_y_max - tile_y_min + 1);
tile_no_list = zeros(no_of_tiles, 1);

k = 0;
for j=tile_y_min:tile_y_max
    for i=tile_x_min:tile_x_max
        k = k + 1;
        tile_no_list(k) = i + 20*j + 1;
        % note here tile numbers will start from 1 -> 300 
    end
end


end

