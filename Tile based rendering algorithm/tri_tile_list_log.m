function [ tile_pointer, tile_list ] = tri_tile_list_log( Tile_corners_current, tile_pointer, tile_list, Tri_index )
%this function log the given triangle in the affected tile list

tile_x_min = Tile_corners_current(1);
tile_x_max = Tile_corners_current(2);
tile_y_min = Tile_corners_current(3);
tile_y_max = Tile_corners_current(4);

for j=tile_y_min:tile_y_max
    for i=tile_x_min:tile_x_max
        % note here tile numbers will start from 1 -> 300 
        tile_no = i + 20*j + 1;
        tile_list(tile_no, tile_pointer(tile_no)) = Tri_index;
        tile_pointer(tile_no) = tile_pointer(tile_no) + 1;
    end
end


end

