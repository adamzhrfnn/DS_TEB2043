# Question 3: Append Chemistry and Physics scores, count failures, find highest/best scores

cat("\n\n=== Question 3 ===\n")

# Append Chemistry and Physics scores to the student record
student_scores$Robert <- list(ExamScore = 59, Chemistry = 59, Physics = 89)
student_scores$Hemsworth <- list(ExamScore = 71, Chemistry = 71, Physics = 86)
student_scores$Scarlett <- list(ExamScore = 83, Chemistry = 83, Physics = 65)
student_scores$Evans <- list(ExamScore = 68, Chemistry = 68, Physics = 52)
student_scores$Pratt <- list(ExamScore = 65, Chemistry = 65, Physics = 60)
student_scores$Larson <- list(ExamScore = 57, Chemistry = 57, Physics = 67)
student_scores$Holland <- list(ExamScore = 62, Chemistry = 62, Physics = 40)
student_scores$Paul <- list(ExamScore = 92, Chemistry = 92, Physics = 77)
student_scores$Simu <- list(ExamScore = 92, Chemistry = 92, Physics = 90)
student_scores$Renner <- list(ExamScore = 59, Chemistry = 59, Physics = 61)

cat("Updated Student Records (with Chemistry & Physics):\n")
print(student_scores)

# Extract Chemistry and Physics scores into vectors
chemistry_scores <- sapply(student_scores, function(x) x$Chemistry)
physics_scores <- sapply(student_scores, function(x) x$Physics)
student_names <- names(student_scores)

# Count students who fail Chemistry (<=49)
fail_chemistry <- student_names[chemistry_scores <= 49]
cat("\nStudents who failed Chemistry (<=49):", 
    if(length(fail_chemistry) == 0) "None" else fail_chemistry, "\n")
cat("Number of students who failed Chemistry:", length(fail_chemistry), "\n")

# Count students who fail Physics (<=49)
fail_physics <- student_names[physics_scores <= 49]
cat("\nStudents who failed Physics (<=49):", 
    if(length(fail_physics) == 0) "None" else fail_physics, "\n")
cat("Number of students who failed Physics:", length(fail_physics), "\n")

# Find who got the highest/best score for Chemistry
best_chemistry <- max(chemistry_scores)
best_chemistry_student <- student_names[which(chemistry_scores == best_chemistry)]
cat("\nHighest Chemistry Score:", best_chemistry, "\n")
cat("Student with highest Chemistry score:", best_chemistry_student, "\n")

# Find who got the highest/best score for Physics
best_physics <- max(physics_scores)
best_physics_student <- student_names[which(physics_scores == best_physics)]
cat("\nHighest Physics Score:", best_physics, "\n")
cat("Student with highest Physics score:", best_physics_student, "\n")