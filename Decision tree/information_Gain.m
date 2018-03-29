function [gain] = information_Gain(train_data,A, thr)
%INFORMATION_GAIN Summary of this function goes here
%   Detailed explanation goes here
    label = train_data(1 : end, end);
    default = histc(label(:),unique(label)); %check this def = histc(label(:),unique(label)) / size...
    default = default / size(label,1);

    rightTree = [];
    leftTree = [];
    right_count = 0;
    left_count = 0;
    ent = 0;
     for val = 1:size(default)
        %probability = nnz(label(:,:)== val)/row;
        %eval = ((-1)*probability)*(log(probability) / log(2));
        if default ~= 0
            eval = (-default(val) * (log(default(val)) / log(2)));
            ent = ent + eval;
        end
    end
    
    for i=1:size(train_data , 1)
        %disp(i)
        if train_data(i,A) >= thr
            rightTree = [rightTree train_data(i,end)];
        else
            leftTree = [leftTree train_data(i,end)];
        end
    end
    if isempty(rightTree)
        right_count = 0;
        rightTree(1) = 0;
    else
        right_count = size(rightTree,2);
        rightTree = histc(rightTree(:), unique(rightTree));
        rightTree = rightTree / right_count;
    end
    if isempty(leftTree)
        left_count = 0;
        leftTree(1) = 0;
    else
        left_count = size(leftTree,2);
        leftTree = histc(leftTree(:), unique(leftTree));
        leftTree = leftTree / left_count;
    end
    rval = 0;
    lval = 0;
    %---------------RightTree-----------------------------
    for i=1:size(rightTree,1)
        if rightTree ~=0
            r_ent = ((-1)*rightTree(i)*(log(rightTree(i)) / log(2)));
            rval = rval + r_ent;
        end
    end
    rval = (right_count/(right_count+left_count))*rval;
    %-----------------------LeftTree-----------------------
    for j=1:size(leftTree,1)
        if leftTree ~= 0
         	l_ent = ((-1)*leftTree(j)*(log(leftTree(j)) / log(2)));
            lval = lval + l_ent;
         end
     end
     lval = (left_count/(right_count+left_count))*lval;
     gain = ent - lval - rval;
    %disp(gain)
end

