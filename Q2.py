#Question 2

# Input
# Enter the coordinate of point A: 2, 5
# Enter the coordinate of point B: 3, 7

# Output
# slope: 2
# distance: 2.236

import math

x1, y1  = input("enter the coordinate of point A: ").split(",")
x2, y2  = input("enter the coordinate of point B: ").split(",")

x1, x2, y1, y2 = int(x1), int(x2), int(y1), int(y2)
slope = int((y2-y1)/(x2-x1))
distance = math.sqrt((x2-x1)**2 + (y2-y1)**2)

print(f'''
    slope: {slope}
    distance:{round(distance, 3)}'''
)