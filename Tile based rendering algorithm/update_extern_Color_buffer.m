function [ extern_color_buffer] = update_extern_Color_buffer( tile_col_buff, tile_no, extern_color_buffer )
% this function takes as input 
% > the rendered tile color buffer
% > tile number (range from 1 -> 300)
% > the complete full 320x240 color buffer
% and gives as output the updated full 320x240 color buffer


[Px, Py] = tileNo_2_Start_Tile_Corrd(tile_no);

k = 0;
w = 0;
for j=Py:(Py+15)
    k = k + 1;
    for i=Px:(Px+15)
        w = w + 1;
        extern_color_buffer(j, i, :) = tile_col_buff(k, w, :);
    end
    w = 0;
end
end

