# 0.000001 perfect value
#
# The bigger the amount of 0 there is
# the more is computational power required, 
# because the recursio continues, until
# the statement is met
CLOSE_RANGE = 0.000001

# It compares xn+1 and xn, to determine
# how close the values are together.
# If they are close enough, it
# returns true
def checker(val, num):
    # to determine the closeness of the range
    # we gotta ignore the negative decimal values.
    # So, we just get both positiv, and negative, and 
    # then compare both
    l = val - num
    l2 = num - val

    return abs(l) < CLOSE_RANGE or abs(l2) < CLOSE_RANGE


def square_root(num):
    # s = num / 2, is basically
    # as mentioned prior, a starting point.
    # s is in this case xn
    s = num / 2

    # l is our xn+1, and because we havent
    # started calculating yet, it is set to 0
    l = 0
    
    # recursive function
    while True:
        # checks whether or not
        # xn multiplied by itself, 
        # equals the number
        if checker(s*s, num):
            print(s) # print the result
            break
        else:
            # else, it sets the xn to a new value
            # and then checks again
            l = num / s
            if checker(l*l, num):
                print(l)
                break
            else:
                # if that didnt work
                # it uses the formula from the Babylonians
                # and sets xn to that value, to re-start the 
                # function
                s = (s+l)/2

square_root(64)  # 8.000000000000101