function [ ] = dtw_classify(train_file,test_file)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    [train_class, train_object,train_data_length,train_col_vec1,train_col_vec2] = read_file(train_file);
    [test_class, test_object,test_data_length,test_col_vec1,test_col_vec2] = read_file(test_file);
   
    average_accuracy = 0 ;
    for ele = 1:test_data_length
        test_col1 = test_col_vec1(ele,1:end);
        test_col2 = test_col_vec2(ele,1:end);
        test_col1 = transpose(test_col1);
        test_col2 = transpose(test_col2);
        
        test_sequence = horzcat(test_col1,test_col2);
        test_sequence(all(test_sequence==0 , 2),:) = [];
        %disp(test_sequence);
        test_seq_size = size(test_sequence,1);
        %disp(train_data_length);
        for l = 1:train_data_length
            train_col1 = train_col_vec1(l,1:end);
            train_col2 = train_col_vec2(l,1:end);
            train_col1 = transpose(train_col1);
            train_col2 = transpose(train_col2);
            
            train_sequence = horzcat(train_col1,train_col2);
            train_sequence(all(train_sequence==0 ,2),:) = [];
            train_seq_size = size(train_sequence,1);
            
            cost_matrix = zeros(train_seq_size,test_seq_size);
            cost_matrix(1,1) = compute_cost(train_sequence(1,1),test_sequence(1,1),train_sequence(1,2),test_sequence(1,2));
            %disp(cost_matrix(1,1));
            for i=2:train_seq_size
                cost_matrix(i,1) = cost_matrix(i-1,1) + compute_cost(train_sequence(i,1),test_sequence(1,1),train_sequence(i,2),test_sequence(1,2));
            end
            
            for j=2:test_seq_size
                cost_matrix(1,j) = cost_matrix(1,j-1) + compute_cost(train_sequence(1,1),test_sequence(j,1),train_sequence(1,2),test_sequence(j,2));
            end
            
            for i=2:train_seq_size
                for j=2:test_seq_size
                    cost_matrix(i,j) = min([cost_matrix(i-1,j),cost_matrix(i,j-1),cost_matrix(i-1,j-1)])+compute_cost(train_sequence(i,1),test_sequence(j,1),train_sequence(i,2),test_sequence(j,2));
                end
            end
            %disp(cost_matrix);
            output(l,1) = cost_matrix(train_seq_size,test_seq_size);
            %disp(l);
            output(l,2) = train_class(l);
        end
        true_class = test_class(ele);
        new_output = sortrows(output , 1);
        predicted_class = new_output(1,2);
        
        if predicted_class == true_class
            accuracy = 1;
        else
            accuracy = 0;
        end
        average_accuracy = average_accuracy+accuracy;
        fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f, distance = %.2f\n',ele,predicted_class,true_class,accuracy,new_output(1,1));
    end
    classification_accuracy = average_accuracy / test_data_length;
    fprintf('classification accuracy=%.4f\n', classification_accuracy);
end

