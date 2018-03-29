function [ ] = knn_classify( train_file, test_file, k)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    train_data = double(dlmread(train_file));
    all_train_data = double(train_data(:,end));
    train_data = double(train_data(:, 1:end-1));
    
    mean_train = mean(train_data);
    std_train = std(train_data, 1);
    %disp(mean_train);
    %disp(std_train);
    
    norm_train = normalization_data(train_data,mean_train,std_train);
    %disp(norm_train);
    
    k_classification()
    
    function[]= k_classification()
        
        test_data = double(dlmread(test_file));
        all_test_data = double(test_data(:,end));
        test_data = double(test_data(:, 1:end-1));
        
        norm_test = normalization_data(test_data,mean_train,std_train);
        %disp(norm_test);
        
        [test_row , test_col] = size(norm_test);
        
        average_accuracy = 0;
        accuracy = 0;
        for l=1:test_row
            dist = (norm_test(l,:)-norm_train).^2;
            dist = sqrt(sum(dist,2));
            data_mapping = [dist all_train_data];
            new_val = sortrows(data_mapping , 1);
            if k==1
                true_class = all_test_data(l);
                predicted_class = new_val(1,2);
                if true_class ~= predicted_class
                    accuracy = 0;
                else 
                    accuracy = 1;
                end
                average_accuracy = average_accuracy+accuracy;
                fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n',l-1,predicted_class,true_class,accuracy);
            else
                for i=1:k
                    e_val(i) = new_val(i,2);
                end
                true_class = all_test_data(l);
                if (length(unique(e_val)))==k||(length(unique(e_val)))==1
                    predicted_class = new_val(1,2);
                else
                    predicted_class = mode(e_val);
                end
                if true_class ~= predicted_class
                    accuracy = 0;
                else 
                    accuracy = 1;
                end
                average_accuracy = average_accuracy+accuracy;
                fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n',l-1,predicted_class,true_class,accuracy);
            end
        end
        classification_accuracy = average_accuracy / test_row;
        fprintf('classification accuracy=%.4f\n', classification_accuracy);
    end
    
    
end

