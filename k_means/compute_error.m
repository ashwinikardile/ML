function [ error_val ] = compute_error( in_data,m_matrix )
%COMPUTE_ERROR Summary of this function goes here
%   Detailed explanation goes here
    error_sum = 0;
    X_data = in_data(:,1:end-1);
    [X_row , X_col] = size(X_data); 
    for x = 1:X_row
        n_data = in_data(x, end);
        dist = compute_dist(); 
        error_sum = error_sum + dist;
    end
    error_val = error_sum;
    
    function[distance] = compute_dist()
        distance = (X_data(x,:)-m_matrix(n_data,:)).^2;
        distance = sqrt(sum(distance,2)); 
    end

end

