% top level for tile based rasterizer v 2.0
% color buffer resolution is assumed to be 320x240 pixels
% assuming tile size of 16x16 pixels
% so we have 20x15 tiles (300 tiles)
% depth testing is supported

clear;
% screen dimentions (x and y) used  
% Matlab understand 2d matrices as (rows, columns) >> (y_coord, x_coord)

% off-chip color buffer
extern_color_buffer = zeros(240,320,3);

% on-chip tile color buffer
tile_col_buff = zeros(16, 16, 3);

% projection planes
% left
l = -4;
% right
r = 4;
% bottom
b = -4;
% top
t = 4;
% near
n = 1; 
% n = 0.6;
% far
f = 10; 

% Cube vertices
% scaled
s = 1.7;
a1 = s*[-1, -1, -1];
a2 = s*[1, -1, -1];
a3 = s*[-1, -1, 1];
a4 = s*[1, -1, 1];
a5 = s*[-1, 1, -1];
a6 = s*[1, 1, -1];
a7 = s*[-1, 1, 1];
a8 = s*[1, 1, 1];

% Scan conversion
% color at each triangle vertex
ca1 = [1 0 0];
ca2 = [1 0 1];
ca3 = [0 0 0];
ca4 = [0 0 1];
ca5 = [1 1 0];
ca6 = [1 1 1];
ca7 = [0 1 0];
ca8 = [0 1 1];

% Loading all vertices into one column vector
vertex_list = [a1; a2; a3; a4; a5; a6; a7; a8];

% scaling transform parameters
sx = 1.0; sy = 1.0; sz = 1.0;
% rotation transform parameters
theta_x = 45.0; theta_y = 45.0; theta_z = 45.0;
% translation transform parameters
tx = 0.0; ty = 0.0; tz = 0.0;
%/////////////////////////////////////////////////////////////////////////
% applying transformations (Modelview transform)
% scaling trans
[vertex_list] = Scale_it(vertex_list, sx, sy, sz);
% rotation trans
[vertex_list] = rotate_Xaxis(vertex_list, theta_x);
[vertex_list] = rotate_Yaxis(vertex_list, theta_y);
[vertex_list] = rotate_Zaxis(vertex_list, theta_z);
% translation trans
[vertex_list] = Translate_it(vertex_list, tx, ty, tz);
%/////////////////////////////////////////////////////////////////////////
% applying projection transformation
% Orthographic proj
[vertex_list] = glOrtho(vertex_list, l, r, b, t, n, f);
% Viewport mapping transformation
[vertex_list] = viewport_map(vertex_list, 320, 240);
%/////////////////////////////////////////////////////////////////////////
% transformed vertices 
a1 = vertex_list(1, :);
a2 = vertex_list(2, :);
a3 = vertex_list(3, :);
a4 = vertex_list(4, :);
a5 = vertex_list(5, :);
a6 = vertex_list(6, :);
a7 = vertex_list(7, :);
a8 = vertex_list(8, :);
%/////////////////////////////////////////////////////////////////////////
% triangle setup
% buffer to hold transformed triangle coordinates
trans_ver_coord = [a1, a2, a3;    %t1
                   a4, a2, a3;    %t2
                   a5, a6, a7;    %t3
                   a8, a6, a7;    %t4
                   a7, a3, a4;    %t5
                   a7, a8, a4;    %t6
                   a5, a1, a2;    %t7
                   a5, a6, a2;    %t8
                   a8, a4, a2;    %t9
                   a8, a6, a2;    %t10
                   a7, a5, a1;    %t11
                   a7, a3, a1];   %t12         
% buffer to hold transformed triangles colors
trans_ver_col = [  ca1, ca2, ca3;    %t1
                   ca4, ca2, ca3;    %t2
                   ca5, ca6, ca7;    %t3
                   ca8, ca6, ca7;    %t4
                   ca7, ca3, ca4;    %t5
                   ca7, ca8, ca4;    %t6
                   ca5, ca1, ca2;    %t7
                   ca5, ca6, ca2;    %t8
                   ca8, ca4, ca2;    %t9
                   ca8, ca6, ca2;    %t10
                   ca7, ca5, ca1;    %t11
                   ca7, ca3, ca1];   %t12
%/////////////////////////////////////////////////////////////////////////
% these variables should be stored in external memory
NOfTriangles = 12;
% tile list variable, we have 20x15=300 tile, each tile can hold a maximun
% of "NOfTriangles = 12" triangle
tile_list = zeros(300, NOfTriangles);
% this variable will hold the current address of each tile list
tile_pointer = ones(300, 1);
% tile upper

% the order is >> Ubeta_x, Ubeta_y, Ugamma_x, Ugamma_y
Ubeta_gamma = zeros(NOfTriangles, 4);
% the order is >> x_x, x_y
X_vertex = zeros(NOfTriangles, 2);
% the order is >> x_z, y_z, z_z
Z_coord = zeros(NOfTriangles, 3);
% the order is x_RGB, y_RGB, z_RGB
Vertices_colors = zeros(NOfTriangles, 9);
% the order is xx_min, xx_max, yy_min, yy_max
Bounding_boxes = zeros(NOfTriangles, 4);
% the order is >> tile_x_min, tile_x_max, tile_y_min, tile_y_max
% this variable will be used by tiling scheduler
Max_Tile_corners = 333*ones(1, 4);

% tiling processor invocation, each loop iteration will generate one triangle info
for i=1:NOfTriangles
    [Ubeta_gamma(i, :), X_vertex(i, :), Z_coord(i, :), Vertices_colors(i, :), Bounding_boxes(i, :), Max_Tile_corners, tile_pointer, tile_list] = tiling_processor( trans_ver_coord(i, 1:3), trans_ver_coord(i, 4:6), trans_ver_coord(i, 7:9), trans_ver_col(i, 1:3), trans_ver_col(i, 4:6), trans_ver_col(i, 7:9), Max_Tile_corners, tile_pointer, tile_list, i);
end
% convert tile coordinates into tile number & generate list of tile to be
% scanned
[ tile_no_list, no_of_tiles ] = tile_coord_transform( Max_Tile_corners );

% tiling scheduler, each loop iteration will draw one tile
% raster core is embedded inside tiling scheduler
for i=1:no_of_tiles
% since Z-buffer is needed only once per tile it will be defined inside
% tiling scheduler only once
[ tile_col_buff ] = tiling_scheduler( Ubeta_gamma , X_vertex , Z_coord , Vertices_colors, tile_pointer, tile_list, tile_no_list(i), tile_col_buff );

% function to update the color buffer with the rendered tile
[ extern_color_buffer] = update_extern_Color_buffer( tile_col_buff, tile_no_list(i), extern_color_buffer );

% clearing tile color buffer (after each tile drawing iteration)
tile_col_buff = zeros(16, 16, 3);
end
% show tile boundries grid [Optional]
[extern_color_buffer] = show_tile_grid(extern_color_buffer);

extern_color_buffer = flipdim(extern_color_buffer ,1);
figure(1313)
imshow(extern_color_buffer)

