function [norm_data] = normalization_data(new_data,m_train,s_train)
    for i=size(new_data,1)
        for j=size(new_data,2)
            new_data(i,j)=(new_data(i,j) - m_train(j))/s_train(j);
        end
    end
    norm_data = new_data;
end

