# Load necessary libraries
# install.packages(c("dplyr", "stringr", "lubridate")) # Uncomment if not installed
library(dplyr)
library(stringr)
library(lubridate)

# 1. Load the data
# We use sep = "|" because the file uses pipes. 
# We strip.white = TRUE to remove initial leading/trailing spaces during import.
raw_data <- read.csv("UncleanDataset.csv", 
                     sep = "|", 
                     header = TRUE, 
                     strip.white = TRUE, 
                     stringsAsFactors = FALSE,
                     comment.char = "")

# 2. Clean Column Names
# Remove trailing commas from the last column name and trim whitespace
colnames(raw_data) <- colnames(raw_data) %>%
  str_remove_all(",") %>%
  str_trim() %>%
  str_replace_all(" ", "_")

# 3. Clean the Data Rows
clean_df <- raw_data %>%
  # Apply whitespace trimming to all character columns
  mutate(across(where(is.character), str_trim)) %>%
  
  # Remove trailing commas and dots from the last column (Total_Payments)
  mutate(Total_Payments = str_remove_all(Total_Payments, "[,.]+")) %>%
  
  # A. Standardize Gender (Example: Male -> M, Female -> F)
  mutate(Gender = case_when(
    tolower(Gender) %in% c("m", "male") ~ "M",
    tolower(Gender) %in% c("f", "female") ~ "F",
    TRUE ~ Gender # Keeps original if it doesn't match
  )) %>%
  
  # B. Standardize Total_Payments (Remove '$' and convert to numeric)
  mutate(Total_Payments = str_remove(Total_Payments, "\\$"),
         Total_Payments = as.numeric(Total_Payments)) %>%
  
  # C. Standardize Date Format (Change to dd/mm/yyyy)
  # First parse the current YYYY-MM-DD format, then reformat it
  mutate(Enrollment_Date = ymd(Enrollment_Date),
         Enrollment_Date = format(Enrollment_Date, "%d/%m/%Y")) %>%
  
  # D. Fix Truncated Course Names (Optional cleanup based on your data)
  mutate(Course = case_when(
    Course == "Machine Learnin" ~ "Machine Learning",
    Course == "Web Developmen" ~ "Web Development",
    TRUE ~ Course
  ))

# 4. Handle Missing Values
# Replacing "NA" strings created by formatting back to actual R NA values
clean_df[clean_df == "NA" | clean_df == ""] <- NA

# 5. Save the Cleaned Dataset
write.csv(clean_df, "Cleaned_UncleanDataset.csv", row.names = FALSE)

# Print Summary to Console
cat("Cleaning Complete!\n")
cat("Original Rows:", nrow(raw_data), "\n")
cat("Cleaned file saved as: Cleaned_UncleanDataset.csv\n\n")
print(head(clean_df))