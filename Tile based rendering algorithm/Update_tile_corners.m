function [ Tile_corners_out ] = Update_tile_corners( Tile_corners_current, Tile_corners_in )
% this function compares the tile corners and returns the "widest" one

% extracting the components of Tile_corners_current
tx_min_curr = Tile_corners_current(1);
tx_max_curr = Tile_corners_current(2); 
ty_min_curr = Tile_corners_current(3); 
ty_max_curr = Tile_corners_current(4); 

% extracting the components of Tile_corners_current
tx_min_in  = Tile_corners_in(1);
tx_max_in  = Tile_corners_in(2); 
ty_min_in  = Tile_corners_in(3); 
ty_max_in  = Tile_corners_in(4); 

% initialization
tx_min = tx_min_curr;
tx_max = tx_max_curr;
ty_min = ty_min_curr;
ty_max = ty_max_curr;

% update if condition is true
if(tx_min_in < tx_min_curr)
    tx_min = tx_min_in;
end

if(tx_max_in > tx_max_curr)
    tx_max = tx_max_in;
end

if(ty_min_in < ty_min_curr)
    ty_min = ty_min_in;
end

if(ty_max_in > ty_max_curr)
    ty_max = ty_max_in;
end

Tile_corners_out = [tx_min, tx_max, ty_min, ty_max];

end

