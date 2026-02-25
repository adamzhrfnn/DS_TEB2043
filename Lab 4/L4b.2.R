# Question 2: Matrix Operations using V1

# Create vector V1
V1 <- c(2, 3, 1, 5, 4, 6, 8, 7, 9)

# Create Matrix-1 (3x3 matrix, filled by column by default)
Matrix1 <- matrix(V1, nrow = 3, ncol = 3)
cat("\nMatrix-1:\n")
print(Matrix1)

# Transpose Matrix-1 to create Matrix-2
Matrix2 <- t(Matrix1)
cat("\nMatrix-2 (Transpose of Matrix-1):\n")
print(Matrix2)

# Rename rows and columns for Matrix-1
rownames(Matrix1) <- c("Row1", "Row2", "Row3")
colnames(Matrix1) <- c("Col1", "Col2", "Col3")
cat("\nMatrix-1 with renamed rows and columns:\n")
print(Matrix1)

# Rename rows and columns for Matrix-2
rownames(Matrix2) <- c("Row1", "Row2", "Row3")
colnames(Matrix2) <- c("Col1", "Col2", "Col3")
cat("\nMatrix-2 with renamed rows and columns:\n")
print(Matrix2)

# Add the matrices
cat("\nAddition of Matrix-1 and Matrix-2:\n")
print(Matrix1 + Matrix2)

# Subtract the matrices
cat("\nSubtraction of Matrix-1 and Matrix-2:\n")
print(Matrix1 - Matrix2)

# Multiply the matrices (element-wise)
cat("\nMultiplication of Matrix-1 and Matrix-2 (element-wise):\n")
print(Matrix1 * Matrix2)

# Divide the matrices (element-wise)
cat("\nDivision of Matrix-1 by Matrix-2 (element-wise):\n")
print(Matrix1 / Matrix2)
