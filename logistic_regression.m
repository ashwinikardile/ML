function [ ] = logistic_regression( train_file, degree, test_file )
    train_data = dlmread(train_file);
    [row,col] = size(train_data);
    weight_matrix = zeros(col, 1);
    col = col-1;
    phi_matrix = zeros(row, (degree*col)+1);
    y_matrix = zeros(row,1);
    prev_e = 0;
    
    for i = 1:row
        x = 2;
        phi_matrix(i, 1) = 1; 
        for j = 2:col+1
            if degree == 1
                for k = 1:degree
                    phi_matrix(i, j) = train_data(i, j-1)^(k);
                end
            else     
                for k = 1:degree
                    phi_matrix(i, x) = train_data(i, j-1)^(k);
                    x = x+1;
                end
            end
            
        end 
    end
    
    label = train_data(1 : end, end);
    label(label > 1) = 0;
    if degree == 2
        weight_matrix = zeros(size(phi_matrix, 2), 1);
    end
    while true
        for i=1:row
            y_matrix(i, 1) = transpose(weight_matrix) * transpose(phi_matrix(i, 1:end));
            y_matrix(i, 1) = 1 / (1 + exp((-1) * y_matrix(i, 1)));
        end
        delta_E = transpose(phi_matrix)*(y_matrix - label);
        
        R = zeros(row, row);
        
        for i = 1:row
            R(i, i)= y_matrix(i, 1)* (1 - y_matrix(i, 1));
        end
        new_weight_matrix = weight_matrix - (pinv(transpose(phi_matrix)* R * phi_matrix)) * delta_E;
        
        diff_weight = new_weight_matrix - weight_matrix;
        weight_matrix = new_weight_matrix;
        
        diff_e = abs(sum(delta_E) - prev_e);
        prev_e = sum(delta_E);
        
        if ((abs(sum(diff_weight)) < 0.001) || (diff_e < 0.001))
            break
        end
        
    end
    for i = 1:size(new_weight_matrix, 1)
        fprintf('w%d=%.4f\n',i, new_weight_matrix(i,1));
    end
 
    logistic_test()
    
    function [] = logistic_test()
        test_data = dlmread(test_file);
        accuracy = 0;
        average_accuracy = 0;
        [test_row, test_col] = size(test_data);
        test_col = test_col - 1;
        test_phi_matrix = zeros(test_row, (degree*test_col)+1);
        test_y_matrix = zeros(test_row, 1);
        
        for ii = 1:test_row
            x_value = 2;
            test_phi_matrix(ii, 1) = 1;
            for jj = 2:test_col+1
                if degree == 1
                    for degree_var = 1:degree
                        test_phi_matrix(ii, jj) = test_data(ii ,jj-1)^(degree_var);
                    end
                else
                    for degree_var = 1:degree
                        test_phi_matrix(ii, x_value) = test_data(ii ,jj-1)^(degree_var);
                        x_value = x_value + 1;
                    end
                end
            end
        end
        
        test_label = test_data(1:end , end);
        test_label (test_label > 1) = 0;
        
        for ii = 1:test_row
            test_y_matrix(ii , 1) = transpose(new_weight_matrix) * transpose(test_phi_matrix(ii, 1:end));
            test_y_matrix(ii, 1) = 1.0 / (1 + exp((-1)*test_y_matrix(ii, 1)));
        end
        
        for ii = 1:test_row
            if ((transpose(new_weight_matrix)*transpose(test_phi_matrix(ii, 1:end))> 0)) && ((test_y_matrix(ii, 1) > 0.5))
                predicted = 1;
                if predicted == test_label(ii, 1) 
                    accuracy = 1;
                else
                    accuracy = 0;
                end
                
            elseif ((transpose(new_weight_matrix)*transpose(test_phi_matrix(ii, 1:end)) < 0) && (1 - test_y_matrix(ii, 1)) > 0.5)
                predicted = 0;
                test_y_matrix(ii, 1) = 1 - test_y_matrix(ii, 1);
                if predicted == test_label(ii, 1)
                    accuracy = 1;
                else
                    accuracy = 0;
                end
            else 
                predicted = 1;                    
                accuracy = 0.5;
            end
            average_accuracy = average_accuracy + accuracy;
            classification_accuracy = average_accuracy / test_row;
            fprintf('ID=%5d, predicted=%3d, probability = %.4f, true=%3d, accuracy=%4.2f\n', ii-1, predicted, test_y_matrix(ii,1) , test_label(ii, 1), accuracy);
        end
        fprintf('classification accuracy=%.4f\n', classification_accuracy);
    end
end

