# Question 2: Store student record in a list with names, find highest, lowest, and average of exam score

# Create a named list of student exam scores
student_scores <- list(
  Robert = 59,
  Hemsworth = 71,
  Scarlett = 83,
  Evans = 68,
  Pratt = 65,
  Larson = 57,
  Holland = 62,
  Paul = 92,
  Simu = 92,
  Renner = 59
)

cat("\n=== Question 2 ===\n")
cat("Student Records:\n")
print(student_scores)

# Convert list to vector for calculations
score_vector <- unlist(student_scores)

# Find highest, lowest, and average
highest_score <- max(score_vector)
lowest_score <- min(score_vector)
average_score <- mean(score_vector)

# Find student(s) with highest and lowest score
student_highest <- names(which(score_vector == highest_score))
student_lowest <- names(which(score_vector == lowest_score))

cat("\nHighest Score:", highest_score, "\n")
cat("Lowest Score:", lowest_score, "\n")
cat("Average Score:", average_score, "\n")
cat("Student with highest score:", student_highest, "\n")
cat("Student with lowest score:", student_lowest, "\n")