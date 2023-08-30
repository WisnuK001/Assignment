# Input
# Enter the first text: 'joGjaKARTa'
# Enter the second text: 'PurWAdhiKA'

# Output
# expected result: 'jPKdaA'

# input 
text_1  = input(" enter first text: ")
text_2  = input("enter second text: ")

# bagi kata
kata_1  = f'{text_1[0]}{text_2[0]}'
kata_2  = f'{text_1[5]}{text_2[5]}'
kata_3  = f'{text_1[9]}{text_2[9]}'
# bagaimana cara menggabungkan kata_3 kata_2 dan kata_1 
# output
print(f'expected result: ', kata_1+kata_2+kata_3)
