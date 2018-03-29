import math


hash_map = {}
label_list = []
prob_list = []
test_label_list = []
dictionary_mean = {}
dictionary_std = {}
weight_dict = {}
mean_dict = {}
std_dev_dict = {}
normal_distribution_dict ={}
bin_dict = {}


def gaussian():
    for i in label_list:
        for column in range(0, len(hash_map[i][0]) - 1):
            sum_of_columns = 0
            for row in range(0, len(hash_map[i])):
                sum_of_columns = sum_of_columns + (hash_map[i][row][column])
            mean = sum_of_columns / float(len(hash_map[i]))
            number_of_samples = len(hash_map[i])
            if number_of_samples == 1:
                print("Class %d, attribute %d, mean = %.2f, std = %.2f" % (i, column + 1, mean, std_dev))
            else:
                summation = 0
                for row in hash_map[i]:
                    summation = summation + math.pow((row[column] - mean), 2)
                sigma = math.sqrt(summation / float((number_of_samples - 1)))
                variance = math.pow(sigma, 2)
                if variance < 0.0001:
                    variance = 0.0001
                    std_dev = math.sqrt(variance)
                else:
                    std_dev = math.sqrt(variance)
                if i in dictionary_mean:
                    dictionary_mean[i][column] = mean
                    dictionary_std[i][column] = std_dev
                else:
                    dictionary_mean[i] = {column: mean}
                    dictionary_std[i] = {column: std_dev}
            print("Class %d, attribute %d, mean = %.2f, std = %.2f" % (i, column, mean, std_dev))


def gaussian_classification(t_list, accuracy_count):
    row_number = 0
    for row in t_list:
        posterior_dictionary = {}
        index = 0
        for i in label_list:
            for column in range(0, len(hash_map[i][0])-1):
                if dictionary_std[i][column] < 0.01:
                    dictionary_std[i][column] = 0.01
                normal_distribution = (math.pow(math.e, (((-1)*math.pow((row[column] - dictionary_mean[i][column]), 2))/float((2*dictionary_std[i][column]*dictionary_std[i][column])))))/float((math.sqrt(2*math.pi)*dictionary_std[i][column]))
                if i in posterior_dictionary:
                    posterior_dictionary[i] = posterior_dictionary[i] * normal_distribution
                else:
                    posterior_dictionary[i] = normal_distribution * prob_list[index]
            index = index + 1
        for label in posterior_dictionary:
            if posterior_dictionary[label] > maximum:
                classification = label
                maximum = posterior_dictionary[label]
        probability = posterior_dictionary[classification]
        sum = 0
        for key in posterior_dictionary:
            sum = sum + posterior_dictionary[key]
        probability = probability/float(sum)
        if row[-1] == classification:
            accuracy = 1
        else:
            accuracy = 0
        accuracy_count += accuracy
        row_number += 1
        print("ID=%5d, predicted=%3d, probability=%.4lf, true=%3d, accuracy=%4.2f" % (row_number-1, classification, probability, row[-1], accuracy))
    return accuracy_count


def mixture_of_gaussian(number_of_gaussian):

    for label in hash_map:
        numerator = 0
        denominator = 0
        for column in range(0, len(hash_map[label][0]) - 1):
            small = 9999
            large = 0
            for row in hash_map[label]:
                if row[column] > large:
                    large = row[column]
                if row[column] < small:
                    small = row[column]
            g = (large - small) / float(number_of_gaussian)
            for weight in range(0, number_of_gaussian):
                if label in weight_dict:
                    if column in weight_dict[label]:
                        if weight in weight_dict[label][column]:
                            weight_dict[label][column][weight] = 1 / float(number_of_gaussian)
                            mean_dict[label][column][weight] = small + weight*g + g/2
                            std_dev_dict[label][column][weight] = 1
                        else:
                            weight_dict[label][column][weight] = 1 / float(number_of_gaussian)
                            mean_dict[label][column][weight] = small + weight * g + g / float(2)
                            std_dev_dict[label][column][weight] = 1
                    else:
                        col = {}
                        col[weight] = 1 / float(number_of_gaussian)
                        weight_dict[label][column] = col
                        mean_d = {}
                        mean_d[weight] = small + weight * g + g / float(2)
                        mean_dict[label][column] = mean_d
                        std = {}
                        std[weight] = 1
                        std_dev_dict[label][column] = std
                else:
                    dict = {}
                    dict[weight] = 1 / float(number_of_gaussian)
                    col_dict = {}
                    col_dict[column] = dict
                    weight_dict[label] = col_dict
                    mean_d1 ={}
                    mean_d1[weight] = small + weight * g + g / float(2)
                    mean_d2 = {}
                    mean_d2[column] = mean_d1
                    mean_dict[label] = mean_d2
                    std_d1 = {}
                    std_d1[weight] = 1
                    std_d2 = {}
                    std_d2[column] = std_d1
                    std_dev_dict[label] = std_d2
    for x in range(0, 50):
        expectation(hash_map, number_of_gaussian)
        maximisation(hash_map, number_of_gaussian)

    for label in hash_map:
        for column in range(0, len(hash_map[label][0])-1):
            for gauss_element in range(0, number_of_gaussian):
                if std_dev_dict[label][column][gauss_element] < 0.01:
                    std_dev_dict[label][column][gauss_element] = 0.01
                print("Class %d, attribute %d, Gaussian %d, mean = %.2f, std = %.2f" % (label, column, gauss_element, mean_dict[label][column][gauss_element], std_dev_dict[label][column][gauss_element]))


def expectation(hash_map, number_of_gaussian):
    for label in hash_map:
        for column in range(0, len(hash_map[label][0])-1):
            for row in range(0, len(hash_map[label])):
                summation = 0.0
                for gaussian_element in range(0, number_of_gaussian):
                    if(std_dev_dict[label][column][ gaussian_element] < 0.01):
                        std_dev_dict[label][column][gaussian_element] = 0.01
                    normal_gaussian = (math.pow(math.e, (((-1)*math.pow((hash_map[label][row][column] - mean_dict[label][column][gaussian_element]), 2))/float((2*std_dev_dict[label][column][gaussian_element]*std_dev_dict[label][column][gaussian_element])))))/float((math.sqrt(2*math.pi)*std_dev_dict[label][column][gaussian_element]))
                    normal_gaussian *= weight_dict[label][column][gaussian_element]
                    summation += normal_gaussian
                    if label in normal_distribution_dict:
                        if column in normal_distribution_dict[label]:
                            if row in normal_distribution_dict[label][column]:
                                if gaussian_element in normal_distribution_dict[label][column][row]:
                                    normal_distribution_dict[label][column][row][gaussian_element] = normal_gaussian
                                else :
                                    normal_distribution_dict[label][column][row][gaussian_element] = normal_gaussian
                            else:
                                normal_dict = {}
                                normal_dict[gaussian_element] = normal_gaussian
                                normal_distribution_dict[label][column][row] = normal_dict

                        else:
                            normal_dict1 = {}
                            normal_dict1[gaussian_element] = normal_gaussian
                            normal_dict2 = {}
                            normal_dict2[row] = normal_dict1
                            normal_distribution_dict[label][column] = normal_dict2

                    else:
                        normal_dict3 = {}
                        normal_dict3[gaussian_element] = normal_gaussian
                        normal_dict4 = {}
                        normal_dict4[row] = normal_dict3
                        normal_dict5 = {}
                        normal_dict5[column] = normal_dict4
                        normal_distribution_dict[label] = normal_dict5

                for gaussian_ele in range(0, number_of_gaussian):
                    normal_distribution_dict[label][column][row][gaussian_ele] = float(normal_distribution_dict[label][column][row][gaussian_ele] / float(summation))


def maximisation(hash_map, number_of_gaussian):
    for label in hash_map:
        for column in range(0, len(hash_map[label][0])-1):
            for gauss in range(0, number_of_gaussian):
                numerator = 0
                denominator = 0
                for row in range(0, len(hash_map[label])):
                    numerator += normal_distribution_dict[label][column][row][gauss] * hash_map[label][row][column]
                    denominator += normal_distribution_dict[label][column][row][gauss]
                mean_dict[label][column][gauss] = numerator /float(denominator)
            for gauss in range(0, number_of_gaussian):
                numerator = 0
                denominator = 0
                for row in range(0, len(hash_map[label])):
                    numerator += normal_distribution_dict[label][column][row][gauss]*(math.pow((hash_map[label][row][column] - mean_dict[label][column][gauss]), 2))
                    denominator += normal_distribution_dict[label][column][row][gauss]
                std_dev_dict[label][column][gauss] = math.sqrt(numerator /float(denominator))
            denominator = 0
            for gauss_element in range(0,number_of_gaussian):
                for row in range(0, len(hash_map[label])):
                    denominator += normal_distribution_dict[label][column][row][gauss_element]
            for gauss_element in range(0,number_of_gaussian):
                numerator = 0
                for row in range(0, len(hash_map[label])):
                    numerator += normal_distribution_dict[label][column][row][gauss_element]
                weight_dict[label][column][gauss_element] = numerator / float(denominator)


def mixture_classification(t_list, accuracy_count, number_of_gaussian):
    row_number = 0
    for row in t_list:
        index = 0
        posterior_dictionary = {}
        for label in label_list:
            product = 1
            for column in range(0, len(hash_map[label][0])-1):
                sum = 0
                for gaussian_element in range(0, number_of_gaussian):
                    if std_dev_dict[label][column][gaussian_element] < 0.01:
                        std_dev_dict[label][column][gaussian_element] = 0.01
                    normal_distribution = (math.pow(math.e, (((-1) * math.pow((row[column] - mean_dict[label][column][gaussian_element]), 2)) / (2 * std_dev_dict[label][column][gaussian_element] * std_dev_dict[label][column][gaussian_element])))) / (math.sqrt(2 * math.pi) * std_dev_dict[label][column][gaussian_element])
                    sum += (normal_distribution * weight_dict[label][column][gaussian_element])
                product *= sum
            posterior_dictionary[label] = product * prob_list[index]
            index = index + 1
        maximum = -9999
        for i in posterior_dictionary:
            if posterior_dictionary[i] > maximum:
                classification = i
                maximum = posterior_dictionary[i]
        probability = posterior_dictionary[classification]
        sum = 0
        for key in posterior_dictionary:
            sum = sum + posterior_dictionary[key]
        probability = probability /float(sum)
        if row[-1] == classification:
            accuracy = 1
        else:
            accuracy = 0
        accuracy_count += accuracy
        row_number += 1
        print("ID=%5d, predicted=%3d, probability=%.4lf, true=%3d, accuracy=%4.2f" % (row_number - 1, classification, probability, row[-1], accuracy))
    return accuracy_count


def binning(number_of_bins):
    bin_list = []
    for label in hash_map:
        for col in range(0, len(hash_map[label_list[0]][0])-1):
            small = 99999
            large = 0
            for row in hash_map[label]:
                if row[col] > large:
                    large = row[col]
                if row[col] < small:
                    small = row[col]
            range_of_bins = (large - small) / float(number_of_bins-3)
            bin_list.append([col])
            for equal_width_bin in range(2, number_of_bins - 1):
                bin_list[col].append([small - (equal_width_bin-2) * range_of_bins +(range_of_bins / 2.0), (small + equal_width_bin -2+1) * range_of_bins +(range_of_bins / 2.0)])
            bin_list.insert(-1, [small - (equal_width_bin-2)* range_of_bins +(range_of_bins / 2.0), 10000000000])
            bin_list.insert(0, [10000000000, small - (range_of_bins / 2.0)])
            bin_list.insert(1, [small - (range_of_bins / 2.0), small + (range_of_bins / 2.0)])
            for bin1 in range(0, number_of_bins):
                if label in bin_dict:
                    if col in bin_dict[label]:
                        if bin1 in bin_dict[label][col]:
                            bin_dict[label][col][bin1] = bin_list

                        else:
                            bin_dict[label][col][bin1] = bin_list
                    else:
                        col_d = {}
                        col_d[bin1] = bin_list
                        bin_dict[label][col] = col_d
                else:
                    dict1 = {}
                    dict1[bin1] = bin_list
                    dict2 = {}
                    dict2[col] = dict1
                    bin_dict[label] = dict2
            print(bin_dict)

def prob_of_class(total_rows):
    for i in hash_map:
        probability_of_class = len(hash_map[i]) / float(total_rows)
        prob_list.append(probability_of_class)


def main():
    string = raw_input()
    if string.find("histogram") > -1:
        flag  = 0
    elif string.find("gaussian") > -1:
        flag =1
    else :
        flag =2
    string_list = string.split(" ")
    total_rows = 0
    filename = string_list[1]
    my_file = open(filename, "r")
    for data in my_file:
        str_list = data.split(" ")
        data_list = list(filter(None, str_list))
        data_list = list(map(float, data_list))
        length = len(data_list)
        if data_list[length - 1] in hash_map:
            hash_map[data_list[length - 1]].append(data_list)
        else:
            hash_map[data_list[length - 1]] = [data_list]
            label_list.append(data_list[length - 1])
        total_rows += 1
    label_list.sort()

    test_file = string_list[2]
    test = open(test_file, "r")
    t_list = []
    for line in test:
        test_list = line.split(" ")
        test_data_list = list(filter(None, test_list))
        test_data_list = list(map(float, test_data_list))
        t_list.append(test_data_list)

    prob_of_class(total_rows)

    if flag == 0:
        number_of_bins = string_list[-1]
        binning(int(number_of_bins))

    elif flag == 1:
        gaussian()
        accuracy_count = 0
        accuracy_count = gaussian_classification(t_list, accuracy_count)
        print("classification accuracy = %6.4f" % (accuracy_count / float((len(t_list)))))

    elif flag ==2:
        number_of_gaussian = string_list[-1]
        mixture_of_gaussian(int(number_of_gaussian))
        accuracy_count = 0
        accuracy_count = mixture_classification(t_list, accuracy_count, int(number_of_gaussian))
        print("classification accuracy = %6.4f" % (accuracy_count / float((len(t_list)))))


main()
