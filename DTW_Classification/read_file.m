function [out_class,object_id,data_length,vec1,vec2 ] = read_file( input_file )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    file_id = fopen(input_file);
    t_data = fgetl(file_id);
    flag = 0;
    i=0;
    column_list = [];
    object_list = [];
    out_class = 0;
    index = 1;
    cnt = 0;
    while ischar(t_data)
        cnt = cnt + 1;
        t_data = fgetl(file_id);
        if t_data == -1
            continue;
        end
        if (contains(t_data,'-------------------------------------------------')== 1)
           flag = 0;
        end
        if (contains(t_data,'object')== 1)
            i=i+1;
            id = i;
            n_data = split(t_data);
            %disp(n_data(3))
            ob_id = n_data(3);
            object_list(id) = str2double(ob_id);
        end
        if (contains(t_data,'class') == 1)
            new_data = strsplit(t_data,' ');
            out_class = str2double(new_data(3));
            column_list(id) = out_class;
        end    
        if flag == 1
            if size(strsplit(string(t_data))) == [1, 3]
                out = strsplit(string(t_data));
                col_vec1(id,index) = double(out(2));
                col_vec2(id,index) = double(out(3));
                index = index + 1;
            end
        end
        if (contains(t_data,'dominant hand trajectory:')==1)
            index = 1;
            flag = 1;
        end
    end
    fclose(file_id);
    data_length = id;
    out_class = column_list;
    object_id = object_list;
    vec1 = col_vec1;
    vec2 = col_vec2;
end

