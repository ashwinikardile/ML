function [ ] = linear_regression( filename, degree, lambda )
    M = dlmread(filename);
    row = size(M, 1);
    phi = zeros(row, degree+1);
    for i = 1:row 
        for j = 1:degree+1
            phi(i, j) = M(i, 1)^(j-1);
        end
    end
    if lambda == 0
        w = (inv(transpose(phi)*phi))*(transpose(phi)) *(M(:, 2));
    else
        w = inv(lambda*eye(degree+1)+ transpose(phi) * phi) * (transpose(phi)) *(M(:, 2));
    end
    for i = 1:size(w,1)
        fprintf('w%d=%.4f\n',i-1,w(i,1));
    end
    if degree == 1
        fprintf('w2=%.4f\n',0);
    end
end

