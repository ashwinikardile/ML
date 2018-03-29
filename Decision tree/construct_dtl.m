function[tree,threshold,gain]=construct_dtl(examples,option,train_attributes,pruning_thr,max_label,tree,threshold,gain,index)
examples=double(examples);
T=double(examples(:,end));
u=unique(T);

if size(examples,1)<= pruning_thr
    distribution=zeros(max_label,1);
    T = examples(1:end,end); 
    for j=1:size(distribution,1)
        vec= find(T==j);
        probclass=size(vec,1)/size(T,1);
        distribution(j,1)=probclass;
    end
    [m,i]=max(distribution);
    tree(index)=i;
    threshold(index)=-1;
    gain(index)=-1;
elseif size(u,1)==1
    tree(index)=u;
    threshold(index)=-1;
    gain(index)=-1;
else
    [best_attri,best_thresh,best_gain]= chooseAttribute(examples, train_attributes,option);
    %disp(best_attri);
    %disp(best_thresh);
    %rightexample=[];
    %leftexample=[];
    cr=1;
    cl=1;
    tree(index)=best_attri;
    threshold(index)=best_thresh;
    gain(index)=best_gain;
    for i=1:size(examples,1)
       if examples(i,best_attri) >= best_thresh
            rightexample(cr,:)=examples(i,1:end);            
            cr = cr + 1;
       else            
            leftexample(cl,:) = examples(i,1:end);
            cl = cl + 1;
        end 
    end
    if exist('leftexample')
       [tree,threshold,gain]= construct_dtl(leftexample,option,train_attributes,pruning_thr,max_label,tree,threshold,gain,2*index);    
       
    else
        tree(2*index)=1;
        threshold(2*index)=-1;
        gain(2*index)=-1;
    end
    if exist('rightexample')
        [tree,threshold,gain] = construct_dtl(rightexample,option,train_attributes,pruning_thr,max_label,tree,threshold,gain,(2*index)+1);
    else
        tree((2*index)+1)=1;
        threshold((2*index)+1)=-1;
        gain((2*index)+1)=-1;
    end
    %[tree,threshold,gain]= dtl(leftexample,pruning_thr,option,attributes,nmax,tree,threshold,gain,2*index);    
    %[tree,threshold,gain] = dtl(rightexample,pruning_thr,option,attributes,nmax,tree,threshold,gain,(2*index)+1);
    
end
%disp(gain);
end