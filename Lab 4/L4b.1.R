# Question 1: Retirement Age Factor Analysis

# Create the age vector
age <- c(55,57,56,52,51,59,58,53,59,55,60,60,60,60,52,55,56,51,60,
         52,54,56,52,57,54,56,58,53,53,50,55,51,57,60,57,55,51,50,57,58)

# Convert to factor and display levels
age_factor <- factor(age)
cat("Levels of the age factor:\n")
print(levels(age_factor))

# Frequency table for individual ages
cat("\nFrequency table of Staff Age:\n")
age_table <- table(age_factor)
print(age_table)

# Divide the levels of factor into 5 ranges
age_ranges <- cut(age, breaks = c(49, 52, 54, 56, 58, 60),
                  labels = c("50-52", "52-54", "54-56", "56-58", "58-60"),
                  right = TRUE)

cat("\nFrequency table of Age Ranges:\n")
range_table <- table(age_ranges)
print(range_table)

# Conclusion / Insight
cat("\n--- Insight ---\n")
cat("From the frequency table, we can observe the distribution of retirement ages.\n")
cat("This helps identify which age ranges have the most retirements in Company A.\n")
