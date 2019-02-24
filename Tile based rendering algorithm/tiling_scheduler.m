function [ internal_color_buffer ] = tiling_scheduler( Ubeta_gamma , X_vertex , Z_coord , Vertices_colors, tile_pointer, tile_list, tile_no, internal_color_buffer )
% the function of this module is to read "Max_Tile_corners" 
% for each tile read the "tile_list" fetch triangle data, and feed them to
% the rasterization core
% default on-chip memory resolution is 16x16 pixels for tile color buffer & z-buffer

% on-chip Z-buffer 
% this buffer will be used, updated and returned by "Tri_raster_core" for
% single tile only
internal_z_buffer = 255*ones(16,16,3);

% the range 1 >> 300 
tile_number = tile_no;

[Px, Py] = tileNo_2_Start_Tile_Corrd(tile_number);

% computing number of triangles in the given tile
No_of_tri = tile_pointer(tile_number)-1;
for i=1:No_of_tri
    % fetching triangle index from the tile list
    k = tile_list(tile_number, i);
    [ internal_color_buffer, internal_z_buffer ] = Tri_raster_core( Ubeta_gamma(k, :) , X_vertex(k, :) , Z_coord(k, :) , Vertices_colors(k, :), internal_color_buffer, internal_z_buffer,Px, Py );
end


end

