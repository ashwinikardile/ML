import random


def string_formation(string):
    for x in range(0, 3100):
        if random.uniform(0, 1) <= 0.1:
            string += "a"
        else:
            string += "b"
    return string


def character_count(c, string):
    char_count = string.count(c)
    char_count = float(char_count)
    prob_char_count = char_count / len(string)
    return prob_char_count


def main():
    string = ""
    dictionary = {0.08: 0, 0.09: 0, 0.10: 0, 0.11: 0, 0.12: 0}
    for x in range(0, 10000):
        string = string_formation(string)
        probability = character_count("a", string)
        if probability < 0.08 and probability < 0.09:
            dictionary[0.08] += 1
            dictionary[0.09] += 1
        elif probability > 0.08 and probability < 0.09:
            dictionary[0.09] += 1
        elif probability >= 0.09 and probability <= 0.11:
            dictionary[0.10] += 1
        elif probability > 0.11 and probability > 0.12:
            dictionary[0.11] += 1
            dictionary[0.12] += 1
        else:
            dictionary[0.12] += 1

    print("In %d of the simulations p(c = 'a') < 0.08." % dictionary[0.08])
    print("In %d of the simulations p(c = 'a') < 0.09." % dictionary[0.09])
    print("In %d of the simulations p(c = 'a') is in the interval [0.09, 0.11]." % dictionary[0.10])
    print("In %d of the simulations p(c = 'a') > 0.11." % dictionary[0.11])
    print("In %d of the simulations p(c = 'a') > 0.12." % dictionary[0.12])


main()
