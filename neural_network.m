function [ ] = neural_network( train_file, test_file, layers, units_per_layer, round)
    train_data = dlmread(train_file);
    %normalising the training data
    norm=max(train_data);
    nrm=max(norm);
    train_data=train_data/nrm;
    [row,col] = size(train_data);
    col = col - 1;
    %get the classes
    label = train_data(1 : end, end);
    label = label + 0.01;
    m = max(label);
    train_data=train_data(:,1:end-1);
    number_of_classes = m*nrm;
    %initializing weight matrix
    %weight_matrix = zeros(number_of_classes, col+1);
    weight_matrix = -0.05 + (0.05-(-0.05))*rand(number_of_classes, col+1);
    %adding bias
    ib=zeros(size(train_data,1),1);
    ib=ib+1;
    train_data=horzcat(train_data,ib);
    learning_rate = 1;
    r=0;
    
    %hidden_weight_matrix = zeros(units_per_layer, col);
    hidden_weight_matrix = -0.05 + (0.05-(-0.05))*rand(units_per_layer, col);
    hb=zeros(units_per_layer, 1);
    hb = hb + 1;
    hidden_weight_matrix = horzcat(hidden_weight_matrix, hb);
    output_weight = zeros(number_of_classes, units_per_layer+1);
    
    if layers==2
        while r < round
            for i=1:row
                val = label(i);
                target_matrix = zeros(m*nrm, 1);
                target_matrix(int16(val*nrm) , 1) = 1;
                out_product = weight_matrix*(transpose(train_data(i, 1:end)));

                for j=1:size(out_product, 1)
                    out_product(j) = 1 / (1 + exp((-1)*(out_product(j))));
                end
                for j=1:size(out_product)
                    delta(j, 1) = (out_product(j) - target_matrix(j))*out_product(j)*(1-out_product(j));
                end
                for j=1:size(weight_matrix, 1)
                    for k=1:size(weight_matrix, 2)
                        weight_matrix(j,k) = weight_matrix(j,k)-(learning_rate*delta(j)*train_data(i, k));
                    end
                end
            end
            learning_rate = learning_rate * 0.98;
            r = r + 1;
        end
    else
        while r < round
            for i=1:row
                val = label(i);
                target_matrix = zeros(m*nrm, 1);
                target_matrix(int16(val*nrm) , 1) = 1;
                %hidden layer
                hidden_layer_out = hidden_weight_matrix*transpose(train_data(i, 1:end));
                for j=1:size(hidden_layer_out, 1)
                    hidden_layer_out(j) = 1 / (1 + exp((-1)*(hidden_layer_out(j))));
                end
                hidden_layer_out = vertcat(hidden_layer_out, 1);
                %output layer
                new_output = output_weight*hidden_layer_out;
                for j=1:size(new_output, 1)
                   new_output(j) =  1 / (1 + exp((-1)*(new_output(j))));
                end
                for j=1:size(new_output, 1)
                    delta(j, 1) = (new_output(j) - target_matrix(j))*new_output(j)*(1-new_output(j));
                end
                for j=1:size(output_weight, 1)
                    for k=1:size(output_weight, 2)
                        output_weight(j,k) = output_weight(j,k)-(learning_rate*delta(j)*hidden_layer_out(k,1));
                    end
                end
                %hidden layer delta calculation
                for j=1:size(hidden_layer_out, 1)
                    summation = 0;
                    for k=1:size(output_weight, 1)
                        summation_value = delta(k)*output_weight(k,j);
                        summation = summation + summation_value;
                    end
                    hidden_layer_delta(j,1) = summation*(hidden_layer_out(j)*(1-hidden_layer_out(j)));
                end
                for el=1:size(hidden_weight_matrix,1)
                    for elem=1:size(hidden_weight_matrix,2)
                        hidden_weight_matrix(el,elem) = hidden_weight_matrix(el,elem)-(learning_rate*hidden_layer_delta(el)*train_data(i, elem));
                    end
                end
            end
            learning_rate = learning_rate * 0.98;
            r = r + 1;
        end
    end
  
    neural_networks_testing()
    
    function [] = neural_networks_testing()
        test_data = dlmread(test_file);
        accuracy = 0;
        average_accuracy = 0;
        %normalising test data
        normal=max(test_data);
        nm=max(normal);
        test_data=test_data/nm;
        [test_row,test_col] = size(test_data);
        test_col = test_col - 1;
        %test classes
        test_label = test_data(1 : end, end);
        test_data=test_data(:,1:end-1);
        
        ib_test=zeros(size(test_data,1),1);
        ib_test=ib_test+1;
        test_data=horzcat(test_data,ib_test);
        
        if layers == 2
            %call function for layer2
            layer2_classification()
        else
            %call a function for layer>2
            layers_classification()
        end
        
        function [] = layer2_classification()
            for ii=1:test_row
                out_prod = weight_matrix*(transpose(test_data(ii, 1:end)));
                for ele=1:size(out_prod, 1)
                    out_prod(ele) = 1 / (1 + exp((-1)*(out_prod(ele))));
                end
                [out_max,index] = max(out_prod);
                tie_count = 0;
                for count=1:size(out_prod, 1)
                    if out_max == out_prod(count)
                        tie_count = tie_count + 1;
                    end
                end
                tar=int16(test_label(ii)*nm);
                if index-1 == tar
                    accuracy = 1;
                elseif tie_count > 1
                    accuracy = 1/tie_count;
                else
                    accuracy = 0;
                end
                average_accuracy = average_accuracy + accuracy;
                fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n',ii-1,index-1,tar,accuracy);
            end
        end
        
        function [] = layers_classification()
            for iii=1:test_row
                hidden_out = hidden_weight_matrix*transpose(test_data(iii, 1:end));
                for jj=1:size(hidden_out, 1)
                    hidden_out(jj) = 1 / (1 + exp((-1)*(hidden_out(jj))));
                end
                hidden_out = vertcat(hidden_out, 1);
                new_out = output_weight*hidden_out;
                for kk=1:size(new_out, 1)
                    new_out(kk) = 1 / (1 + exp((-1)*(new_out(kk))));
                end
                [out_max,index] = max(new_out);
                
                tie_count = 0;
                for count=1:size(new_out, 1)
                    if out_max == new_out(count)
                        tie_count = tie_count + 1;
                    end
                end
                tar=int16(test_label(iii)*nm);
                %disp(tar);
                if index-1 == tar
                    accuracy = 1;
                    %disp(accuracy);
                elseif tie_count > 1
                    accuracy = 1/tie_count;
                else
                    accuracy = 0;
                end
                average_accuracy = average_accuracy + accuracy;
                fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n',iii-1,index-1,tar,accuracy);
            end
        end
        classification_accuracy = average_accuracy / test_row;
        fprintf('classification accuracy=%.4f\n', classification_accuracy);
    end
end


