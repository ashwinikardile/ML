import random
import time




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
    start_time = time.time()
    string = string_formation(string)
    probability = character_count("a",string)
    print("p(c = 'a') = %.4f" % probability)
    end_time = time.time()
    print(end_time - start_time, "sec")


main()
