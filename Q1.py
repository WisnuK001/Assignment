# Input
# Enter the four digit number: 4567

# Output
# total: 22
# reverse: 7654




# Input 4 digit number
num = input ('enter four digit number: ')

# periksa len dalam num
if len(num) != 4 or not num.isdigit():
    print('Invalid. enter four digit number: ')

# hitung jumlah digit
else:
    total   = 0
    for digit in num:
        total = sum(int(digit) for digit in num)

#membalik num
reverse = num[:: -1]

#output
print("total: ", total)
print("reverse: ", reverse)
