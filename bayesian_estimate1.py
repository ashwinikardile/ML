import math


def main():
    input_string = raw_input()
    posterior_probability(input_string)


def posterior_probability(input_string):
    likelihood = []
    posterior = []
    count_a = input_string.count('a')
    count_b = input_string.count('b')
    prior_list = [0.1, 0.3, 0.5, 0.7, 0.9]
    prior_prob = [0.9, 0.04, 0.03, 0.02, 0.01]
    for i in range (len(prior_list)):
        like = math.pow(prior_list[i], count_a) * math.pow((1 - prior_list[i]), count_b)
        likelihood.append(like)
    for j in range(len(likelihood)):
        posterior.append(prior_prob[j] * likelihood[j])
    sum_of_posterior = sum(posterior)
    for j in range(len(posterior)):
        posterior[j] = posterior[j] / sum_of_posterior
        print("p(m =",prior_list[j],"| data) = %.4f" % posterior[j])
    result = 0
    for j in range(len(posterior)):
        result += (posterior[j]*prior_list[j])
    print("p(c = 'a' | data) = %.4f" % result)


main()