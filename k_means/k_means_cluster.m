function [ ] = k_means_cluster( input_file, k, iterations )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    input_data = double(dlmread(input_file));
    input_data = double(input_data(:, 1:end-1));
    [test_row, test_col] = size(input_data);
    
    for i=1:test_row
        cluster_vec(i)= datasample(1:k,1,'Replace',true);
    end
       
    cluster_vec = transpose(cluster_vec);
    input_data = horzcat(input_data,cluster_vec);
    mean_mat = compute_mean(input_data, k);
    mean_matrix = mean_mat(:,1:end-1);
    %disp(mean_matrix)
    %disp(size(mean_matrix))
    error_val = compute_error(input_data,mean_matrix);
    fprintf('After initialization: error = %.4f\n', error_val);
    
    for j=1:iterations 
        input_data = input_data(:,1:end-1);
        %disp(size(input_data))
        for d=1:test_row
            dist = (input_data(d,:)-mean_matrix).^2;
            dist = sqrt(sum(dist,2));
            [val , index] = min(dist);
            cluster_vec(d) = index;          
        end
        input_data = horzcat(input_data,cluster_vec);
        mean_mat = [];
        mean_mat = compute_mean(input_data, k);
        mean_matrix = mean_mat(:,1:end-1);
        %disp(mean_matrix)
        error_val = compute_error(input_data,mean_matrix);
        fprintf('After iteration %.d: error = %.4f\n',j, error_val);
    end
end

