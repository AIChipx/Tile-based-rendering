function [ extern_color_buffer ] = show_tile_grid( extern_color_buffer )
% tile res. 16x16 pixels
for j=1:240
    for i=1:320
        x = i/16-fix(i/16);
        y = j/16-fix(j/16);
        if(x == 0 || y == 0)
            extern_color_buffer(j,i,:) = [0.3 0.5 0.5];
        end
    end
end
end

