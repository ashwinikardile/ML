function [] = pca_power( training_file,test_file, M,iterations )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    train_data = dlmread(training_file);
    train_data = double(train_data(:,1:end-1));
    [row,column] = size(train_data);
    
    for d=1:M
        cov_output = cov(train_data,1);
        power_out = power_method(cov_output,iterations);
        fprintf('Eigenvector %3d\n' , d);
        for x=1:size(power_out,1)
            fprintf('%3d: %.4f\n',x,power_out(x));
        end
        projection_matrix(: , d) = power_out;
        for i=1:row
            out_val = transpose(power_out)*transpose(train_data(i,1:end))*power_out;
            train_data(i,1:end) = train_data(i,1:end) - transpose(out_val);
        end
    end
    
    projection_matrix = transpose(projection_matrix);
    
    classification();
    
    function[power_out] = power_method(cov_output,iterations)
        b = randi([0,1],1,column);
        %b = [1,1,1,1,1,1,1,1];
        b_transpose = transpose(b);
        for j=1:iterations
            b_transpose = (cov_output*b_transpose)/norm(cov_output*b_transpose);
        end
        power_out = b_transpose;
    end

    function [] = classification()
        test_data = dlmread(test_file);
        test_data = double(test_data(:,1:end-1));
        [test_row , test_column] = size(test_data);
        for j=1:test_row
            test_out_val = projection_matrix*transpose(test_data(j,1:end));
            fprintf('Test object %3d\n',j-1);
            out_size = size(test_out_val,1);
            for k=1:out_size
                fprintf('%3d: %.4f\n',k,test_out_val(k));
            end
        end        
    end
end

