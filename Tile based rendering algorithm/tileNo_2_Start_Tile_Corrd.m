function [ x, y ] = tileNo_2_Start_Tile_Corrd( no_in )
% this function accepts tile number as input (range from 1 -> 300)
% this functuion generates the starting coordinate of each tile as output
% since we are working on res. of 320x240 that corresponds to 20x15 tiles

no = no_in - 1;
% tile width constant
tw = 20;

y = fix(no/tw)*16 + 1;
x = (no - (fix(no/tw)*tw))*16 + 1;

if(x == 0)
    x = 1; 
end
if(y == 0) 
    y = 1; 
end
end

