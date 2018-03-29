function [ ] = svd_power( data_file,M,iterations )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    data = double(dlmread(data_file)); 
    %[row, column] = size(data);
    data_new = data*transpose(data);
    data_transpose_V = transpose(data)*data;
    
    matrix_u = [];
    data_transpose_U = data*transpose(data);
    for i=1:M
        power_out_U = power_method(data_transpose_U,iterations);
        matrix_u(:,i) = power_out_U;
        for j=1:size(data_transpose_U,1)
            out = transpose(power_out_U)*transpose(data_transpose_U(j,1:end))*power_out_U;
            data_transpose_U(j,1:end) = data_transpose_U(j,1:end) -transpose(out);
            %disp(matrix_u)
        end
    end
    
    fprintf('Matrix U: ');
    for i=1:size(matrix_u,1)
        fprintf('\n Row  %d:' , i);
        for j=1:size(matrix_u,2)
            fprintf('%8.4f',matrix_u(i,j));
        end
    end
    fprintf('\n');
    
    matrix_s = zeros(M,M);
    for i=1:M
        for j=1:M
            if(i==j)
                %matrix_s(i,j) = sqrt(transpose(matrix_u(:,j))*cov(data_new,1)*matrix_u(:,j));
                matrix_s(i,j) = sqrt(transpose(matrix_u(:,j))*data_new*matrix_u(:,j));
            end
        end
    end
    
    fprintf('Matrix S: ');
    for i=1:size(matrix_s,1)
        fprintf('\n Row  %d:' , i);
        for j=1:size(matrix_s,2)
            fprintf('%8.4f',matrix_s(i,j));
        end
    end
    fprintf('\n');
    
    matrix_v = [];
    for k=1:M
        power_out_V = power_method(data_transpose_V,iterations);
        matrix_v(:,k) = power_out_V;
        %disp(power_out_V)
        for j=1:size(data_transpose_V,1)
            out_v = transpose(power_out_V)*transpose(data_transpose_V(j,1:end))*power_out_V;
            data_transpose_V(j,1:end) = data_transpose_V(j,1:end) -transpose(out_v);
            %disp(matrix_v)
        end
    end
    
    fprintf('Matrix V: ');
    for i=1:size(matrix_v,1)
        fprintf('\n Row  %d:' , i);
        for j=1:size(matrix_v,2)
            fprintf('%8.4f',matrix_v(i,j));
        end
    end
    
    recon_matrix = matrix_u*matrix_s*transpose(matrix_v);
    %recon_matrix = recon_matrix(:,1:M);
    %disp('Reconstruction Matrix')
    %disp(recon_matrix);
    fprintf('\n Reconstruction (U*S*V''):');
    for i=1:size(recon_matrix)
        fprintf('\n Row  %d:' , i);
        for j=1:size(recon_matrix,2)
            fprintf('%8.4f',recon_matrix(i,j));
        end
    end
    fprintf('\n');
end

