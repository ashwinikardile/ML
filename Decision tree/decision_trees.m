function[]= decision_trees(training_file,test_file,option,pruning_thr)
    examples = load(training_file);
    test_data = load(test_file);
    train_data = double(examples(:,end));
    examples = double(examples(:,1:end));
 
    train_attributes=zeros(size(examples,2)-1,1);
    train_attributes=train_attributes+1;
    for i=1:size(train_attributes,1)
        train_attributes(i,1)=train_attributes(i,1)*i; 
    end

    max_label=max(train_data);
    
    if isequal(option,'forest3')
       option='randomized'; 
       tree1=[];
       threshold1=[];
       gain1=[] ;
       tree2=[];
       threshold2=[];
       gain2=[] ;
       tree3=[];
       threshold3=[];
       gain3=[] ;
       
       [tree1,threshold1,gain1]=construct_dtl(examples,option,train_attributes,pruning_thr,max_label,tree1,threshold1,gain1,1); 
       [tree2,threshold2,gain2]=construct_dtl(examples,option,train_attributes,pruning_thr,max_label,tree2,threshold2,gain2,1);
       [tree3,threshold3,gain3]=construct_dtl(examples,option,train_attributes,pruning_thr,max_label,tree3,threshold3,gain3,1);
       
       for i=1:size(tree1,2)
            fprintf('tree=%2d, node=%3d, feature=%2d, thr=%6.2f, gain=%f\n',0,i,tree1(:,i)-1,threshold1(:,i),gain1(:,i)); 
       end
       for i=1:size(tree2,2)
            fprintf('tree=%2d, node=%3d, feature=%2d, thr=%6.2f, gain=%f\n',1,i,tree2(:,i)-1,threshold2(:,i),gain2(:,i)); 
       end
       for i=1:size(tree3,2)
            fprintf('tree=%2d, node=%3d, feature=%2d, thr=%6.2f, gain=%f\n',2,i,tree3(:,i)-1,threshold3(:,i),gain3(:,i)); 
       end
       avg_acc=0;
        for x=1:size(test_data,1)
            index=1;
            flag=1;
            while flag==1
                attr=tree1(index);
                thr=threshold1(index);
                ga=gain1(index);
                if thr==-1 & ga==-1
                    data_1=attr;
                    flag=0;
                else
                    if (test_data(x,attr))>=thr
                        index=(2*index)+1;
                    else
                        index=(2*index);
                    end
                end
            end
            index=1;
            flag=1;
            while flag==1
                attr=tree2(index);
                thr=threshold2(index);
                ga=gain2(index);
                if thr==-1 & ga==-1
                    data_2=attr;
                    flag=0;
                else
                    if (test_data(x,attr))>=thr
                        index=(2*index)+1;
                    else
                        index=(2*index);
                    end
                end
            end
            index=1;
            flag=1;
            while flag==1
                attr=tree3(index);
                thr=threshold3(index);
                ga=gain3(index);
                if thr==-1 & ga==-1
                    data_3=attr;
                    flag=0;
                else
                    if (test_data(x,attr))>=thr
                        index=(2*index)+1;
                    else
                        index=(2*index);
                    end
                end
            end
            
            T_target=test_data(x,end);
            
            data_1=int16(data_1);
            data_2=int16(data_2);
            data_3=int16(data_3);
            atr1data=zeros(1,max_label+1);
            atr1data(data_1+1)=1;
            atr2data=zeros(1,max_label+1);
            atr2data(data_2+1)=1;
            atr3data=zeros(1,max_label+1);
            atr3data(data_3+1)=1;
            
            summation=atr1data+atr2data+atr3data;
            summation=summation/3;
            
            [new_max,i_index]=max(summation);
            if (i_index-1)== T_target
                accuracy=1;
            else
                accuracy=0;
            end
            
            avg_acc=avg_acc+accuracy;
            fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n',x,i_index-1,T_target,accuracy);
        end
    disp(tree1);
    disp(tree2);
    disp(tree3);
    fprintf('classification accuracy=%6.4f\n',avg_acc/size(test_data,1));
    else    
        tree=[];
        threshold=[];
        gain=[];
        [tree,threshold,gain]=construct_dtl(examples,option,train_attributes,pruning_thr,max_label,tree,threshold,gain,1);   
        for i=1:size(tree,2)
            fprintf('tree=%2d, node=%3d, feature=%2d, thr=%6.2f, gain=%f\n',0,i,tree(:,i)-1,threshold(:,i),gain(:,i)); 
        end
        avg_acc=0;
        for x=1:size(test_data,1)
            index=1;
            flag=1;
            while flag==1
                attr=tree(index);
                thr=threshold(index);
                ga=gain(index);
                if thr==-1 & ga==-1
                    T_target=test_data(x,end);
                    if attr==T_target
                        accuracy=1;
                    else
                        accuracy=0;
                    end
                    avg_acc=avg_acc+accuracy;
                    fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n',x,attr,T_target,accuracy);
                    flag=0;
                else
                    if (test_data(x,attr))>=thr
                        index=(2*index)+1;
                    else
                        index=(2*index);
                    end
                end
            end
        end
        disp(tree)
        fprintf('classification accuracy=%6.4f\n',avg_acc/size(test_data,1));
    end
end

