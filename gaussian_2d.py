import math
import sys


def main():
    with open(sys.argv[1], 'r') as my_file:
        hash_map = {}
        label_list = []
        for data in my_file:
            str_list = data.split(" ")
            data_list = list(filter(None, str_list))
            data_list = list(map(float, data_list))
            length = len(data_list)
            if data_list[length - 1] in hash_map:
                value = data_list[0:2]
                hash_map[data_list[length - 1]].append(value)
            else:
                value = data_list[0:2]
                hash_map[data_list[length - 1]] = [value]
                label_list.append(data_list[length - 1])

        number_of_unique_labels = len(hash_map)
        label_list.sort()
        for i in range(0, number_of_unique_labels):
            number_of_samples = len(hash_map[label_list[i]])
            for column in range(0, len(hash_map[label_list[i]][0]) - 1):
                sum_of_columns = 0
                sum_of_rows = 0
                for row in range(0, len(hash_map[label_list[i]])):
                    sum_of_columns = sum_of_columns + (hash_map[label_list[i]][row][column])
                    sum_of_rows = sum_of_rows + (hash_map[label_list[i]][row][1])
                mean = sum_of_columns / len(hash_map[label_list[i]])
                mean2 = sum_of_rows / len(hash_map[label_list[i]])
                if number_of_samples == 1:
                    print("Class %d, mean = [%.2f, %.2f], sigma = [0.00, 0.00, 0.00, 0.00]" % (
                    label_list[i], mean, mean2))

                else:
                    sigma_sum = 0
                    sigma_sum1 = 0
                    cov_sum = 0
                    for row in hash_map[label_list[i]]:
                        sigma_sum = sigma_sum + math.pow((row[column] - mean), 2)
                        sigma_sum1 = sigma_sum1 + math.pow((row[1] - mean2), 2)
                        std_dev = math.sqrt((sigma_sum / (number_of_samples - 1)))
                        std_dev1 = math.sqrt((sigma_sum1 / (number_of_samples - 1)))
                    variance = math.pow(std_dev , 2)
                    variance1 = math.pow(std_dev1 , 2)
                    for k in hash_map[label_list[i]]:
                        cov_sum = cov_sum + ((k[column] - mean) * (k[1] - mean2))
                        cov = cov_sum / (number_of_samples - 1)
                print("Class %d, mean = [%.2f, %.2f], sigma = [%.2f, %.2f, %.2f, %.2f]" % (
                    label_list[i], mean, mean2, variance,cov, cov, variance1))


main()
