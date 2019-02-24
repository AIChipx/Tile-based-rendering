function [ internal_color_buffer, internal_z_buffer ] = Tri_raster_core( Ubeta_gamma , X_vertex , Z_coord , Vertices_colors, internal_color_buffer, internal_z_buffer,Px, Py )
% Z- buffer is supported
% colored scan conversion based on barycentric coordinates
% here we interpolate depth value as well as color values
% depth value will be read and interpolated

% exctracting the required data
ubeta = Ubeta_gamma(1:2);
ugamma = Ubeta_gamma(3:4);
x = X_vertex;
x_z = Z_coord(1);
y_z = Z_coord(2);
z_z = Z_coord(3);
cx = Vertices_colors(1:3);
cy = Vertices_colors(4:6);
cz = Vertices_colors(7:9);

k = 0;
w = 0;

for j=Py:(Py+15)
    k = k + 1;
    for i=Px:(Px+15)
        w = w + 1;
        % variable parameters
        f = [i j] - x(1:2);
        Beta = dot(ubeta,f);
        Gamma = dot(ugamma,f);
        Alpha = 1 - Beta - Gamma;
        
        if(Alpha>=0 && Beta>=0 && Gamma >=0)
             depth = Alpha*x_z + Beta*y_z + Gamma*z_z;
             if(depth < internal_z_buffer(k,w))
                tempc = (Alpha * cx) + (Beta * cy) + (Gamma * cz);
                internal_color_buffer(k,w,1) = tempc(1);
                internal_color_buffer(k,w,2) = tempc(2);
                internal_color_buffer(k,w,3) = tempc(3);
                 internal_z_buffer(k,w) = depth;
             end
        end
    end
    w = 0;
end
end

