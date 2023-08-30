# Input
# Enter the first text: 'JCDS'
# Enter the second text: '0210'

# Output
# expected result: 'JC0210DS'

#input teks
first_text  = input("enter first text: ")
sec_text    = input("enter second text: ")

# potong text pertama
text_1  = first_text[:2]
text_2  = sec_text[2:]

# gabungkan text
result  = text_1 + sec_text + text_2

# output 
print("expected result: ", result)


