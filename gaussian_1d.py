import math
import sys


def main():
    filename = raw_input()
    my_file = open(filename, "r")
    hash_map = {}
    label_list = []
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

    number_of_unique_labels = len(hash_map)
    label_list.sort()
    for i in range(0, number_of_unique_labels):
        for column in range(0, len(hash_map[label_list[i]][0]) - 1):
            sum_of_columns = 0
            for row in range(0, len(hash_map[label_list[i]])):
                sum_of_columns = sum_of_columns + (hash_map[label_list[i]][row][column])
            mean = sum_of_columns / len(hash_map[label_list[i]])
            number_of_samples = len(hash_map[label_list[i]])
            if number_of_samples == 1:
                print("Class %d, dimension %d, mean = %.2f, variance = 0.00" % (
                    label_list[i], column + 1, mean))
            else:
                summation = 0
                for row in hash_map[label_list[i]]:
                    summation = summation + math.pow((row[column] - mean), 2)
                sigma = math.sqrt(summation / (number_of_samples - 1))
                variance = math.pow(sigma, 2)
                print("Class %d, dimension %d, mean = %.2f, variance = %.2f" % (
                    label_list[i], column + 1, mean, variance))


main()
