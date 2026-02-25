# Question 3: Arrays

# Array 1: 4 columns, 2 rows, 3 tables
Array1 <- array(1:24, dim = c(2, 4, 3))
cat("\nArray1\n")
print(Array1)

# Array 2: 2 columns, 3 rows, 5 tables
Array2 <- array(25:54, dim = c(3, 2, 5))
cat("\nArray2\n")
print(Array2)

# Print the second row of the second matrix of the first array
cat("\n\"The second row of the second matrix of the array:\"\n")
print(Array1[2, , 2])

# Print the element in the 3rd row and 3rd column of the first matrix of the second array
cat("\"The element in the 3rd row and 3rd column of the 1st matrix:\"\n")
print(Array2[3, 2, 1])