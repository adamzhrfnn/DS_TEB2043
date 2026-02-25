# Question 1: Store 20 exam scores, count grades, check pass/fail

# Input vector of 20 exam scores
scores <- c(33, 24, 54, 94, 16, 89, 60, 6, 77, 61, 13, 44, 26, 24, 73, 73, 90, 39, 90, 54)

# Count number of students based on grade
grade_A <- sum(scores >= 90 & scores <= 100)  # 90-100
grade_B <- sum(scores >= 80 & scores <= 89)   # 80-89
grade_C <- sum(scores >= 70 & scores <= 79)   # 70-79
grade_D <- sum(scores >= 60 & scores <= 69)   # 60-69
grade_E <- sum(scores >= 50 & scores <= 59)   # 50-59
grade_F <- sum(scores <= 49)                   # <=49

cat("=== Question 1 ===\n")
cat("Exam Scores:", scores, "\n\n")

cat("Grade Distribution:\n")
cat("Grade A (90-100):", grade_A, "students\n")
cat("Grade B (80-89):", grade_B, "students\n")
cat("Grade C (70-79):", grade_C, "students\n")
cat("Grade D (60-69):", grade_D, "students\n")
cat("Grade E (50-59):", grade_E, "students\n")
cat("Grade F (<=49):", grade_F, "students\n\n")

# Check whether each student pass the exam (>49) or not. Return TRUE or FALSE.
pass_status <- scores > 49
cat("Pass Status (>49):\n")
print(pass_status)
cat("\n")