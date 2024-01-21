def minion_game(string):
    string = string.upper()
    kevin = vowel(string)
    stuart = consonant(string)
    
    if kevin == stuart:
        print('draw')
    elif kevin < stuart:
        print("Stuart win")
    else:
        print("Kevin win")
    
    
def vowel(string):
    index = 0
    total = len(string)
    sum = 0
    for i in string:
        if i in "AEIOU":
            sum = sum + total -index
        index += 1
    return sum

def consonant(string):
    index = 0
    total = len(string)
    sum = 0
    for i in string:
        if i not in "AEIOU":
            sum = sum + total - index
        index += 1
    return sum
    

if __name__ == '__main__':
    s = input("Enter a word: ")
    minion_game(s)