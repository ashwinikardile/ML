function [ mean_mat ] = compute_mean( in_data, k )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    for m=1:k
        input_group = in_data(:,end) == m;
        group_val = in_data(input_group,:);
        mean_mat(m,:) = mean(group_val);
    end
end

