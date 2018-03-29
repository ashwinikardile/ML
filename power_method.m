function [ power_out ] = power_method( A,iterations )
%POWER_METHOD Summary of this function goes here
%   Detailed explanation goes here
    %power_out = [];
    val = size(A,1);
    b = zeros(1,val)+1;
    b = transpose(b);
    for k=1:iterations
        b = (A*b)/norm(A*b);
        %power_out(:,iterations-k+1) = b;
    end
   %disp(power_out)
   power_out = b;
end

