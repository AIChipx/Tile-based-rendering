function [Ubeta_gamma, X_vertex, Z_coord, Vertices_colors, Bounding_boxes, Tile_corners_out, tile_pointer, tile_list] = tiling_processor( vx, vy, vz, cx, cy, cz, Tile_corners_in, tile_pointer, tile_list, Tri_index)
% the role of this module is to fetch triangle vertices & colors
% determine the affected tiles >> generate a tile list 
% determine the widest tile corners 

% and give the folowing as output
% Beta & Gamma >> Ubeta_x, Ubeta_y, Ugamma_x, Ugamma_y
% x-vertex [of triangle assuming triangle vertices as (x, y, z)] >> x_x, x_y
% Z-coordinate [of triangle vertices] >> x_z, y_z, z_z
% triangle vertices colors >> x_RGB, y_RGB, z_RGB
% bounding box edges >> xx_min, xx_max, yy_min, yy_max
% corner tiles >> tile_x_min, tile_x_max, tile_y_min, tile_y_max

x = fix(vx(1:2));
y = fix(vy(1:2));
z = fix(vz(1:2));

% defining bounding rectangle 
xx = [x(1) y(1) z(1)];
yy = [x(2) y(2) z(2)];
xx_min = min(xx);
xx_max = max(xx);
yy_min = min(yy);
yy_max = max(yy);

% Precomputed constants
e1 = y - x;
e2 = z - x;
[Ubeta] = (dot(e2,e2)*e1 - dot(e1,e2)*e2)/(dot(e1,e1)*dot(e2,e2) - dot(e1,e2)^2);
[Ugamma] = (dot(e1,e1)*e2 - dot(e1,e2)*e1)/(dot(e1,e1)*dot(e2,e2) - dot(e1,e2)^2);

% corner tiles (using tile coordinates representation)
% coordinates starts from 0 here
tile_x_min_curr = bitshift(xx_min, -4);
tile_x_max_curr = bitshift(xx_max, -4);
tile_y_min_curr = bitshift(yy_min, -4);
tile_y_max_curr = bitshift(yy_max, -4);
Tile_corners_current = [tile_x_min_curr, tile_x_max_curr, tile_y_min_curr, tile_y_max_curr];

% the order is >> Ubeta_x, Ubeta_y, Ugamma_x, Ugamma_y
Ubeta_gamma = [Ubeta(1) Ubeta(2) Ugamma(1) Ugamma(2)];
% the order is >> x_x, x_y
X_vertex = [vx(1) vx(2)];
% the order is >> x_z, y_z, z_z
Z_coord = [vx(3), vy(3), vz(3)];
% the order is x_RGB, y_RGB, z_RGB
Vertices_colors = [cx, cy, cz];
% the order is xx_min, xx_max, yy_min, yy_max
Bounding_boxes = [xx_min, xx_max, yy_min, yy_max];
% the order is >> tile_x_min, tile_x_max, tile_y_min, tile_y_max
% this variable "Tile_corners_out" will be updated dynamically to inform 
% the tiling scheduler about the boundries of tiles to be scanned

% the comparison MUST be done for "Update_tile_corners" function to operate
% correctly << software issue >>
if (Tile_corners_in == 333*ones(1, 4))
    Tile_corners_in = Tile_corners_current;
end
[Tile_corners_out] = Update_tile_corners(Tile_corners_current, Tile_corners_in);

% logginig the current triangle in the affected tile list
[ tile_pointer, tile_list ] = tri_tile_list_log( Tile_corners_current, tile_pointer, tile_list, Tri_index );

end

