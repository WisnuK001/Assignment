# Input
# Enter the sample string: 'purwa, dhika'

# Output
# expected result: 'dhiwa purka'





# Input sample string 'purwa, dhika'

stringOne, stringTwo = input("enter the sample stringOne: ").split(", ", 2)

# Output
print(f'expected result: {stringTwo[:3]}{stringOne[-2:]}, {stringOne[:3]}{stringTwo[-2:]}')