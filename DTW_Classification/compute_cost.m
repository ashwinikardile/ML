function [cost_matrix_out] = compute_cost(x1,x2,y1,y2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    dist1 = (x1-x2)^2;
    dist2 = (y1-y2)^2;
    cost_matrix_out = sqrt(dist1 + dist2);
end

