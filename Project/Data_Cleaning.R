# 1. Setup - Install and load necessary libraries
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("janitor")) install.packages("janitor")
library(tidyverse)
library(janitor)
library(lubridate)

# 2. READ AND UNIFY DELIMITERS
# Because the file mixes pipes and commas, we read it as text lines first.
raw_lines <- readLines("UncleanDataset.csv")

clean_lines <- raw_lines %>%
  str_replace_all("\\|", ",") %>% # Replace pipes with commas 
  str_replace_all(",+", ",") %>%  # Collapse multiple commas into one [cite: 4, 11]
  str_replace_all(",$", "")       # Remove trailing commas at end of lines [cite: 6, 8]

# Convert the cleaned text lines into a data frame
df <- read_csv(paste(clean_lines, collapse = "\n"), show_col_types = FALSE)

# 3. INITIAL CLEANING WITH JANITOR
df_clean <- df %>%
  clean_names() %>%            # Standardize column names (e.g., total_payments) [cite: 1]
  remove_empty(which = c("rows", "cols")) %>% # Remove completely blank rows/cols [cite: 242]
  distinct()                   # Remove exact duplicate rows [cite: 39-46, 154]

# 4. DATA TRANSFORMATION AND FORMATTING
df_clean <- df_clean %>%
  mutate(
    # Clean Payments: Remove $, £, ?, and commas, then convert to numeric 
    total_payments = as.numeric(str_remove_all(total_payments, "[\\$,£\\? ]")),
    
    # Clean Age: Extract only digits (removes '*' or extra text) [cite: 83, 243, 248]
    age = as.numeric(str_extract(age, "\\d+")),
    
    # Clean Gender: Standardize to single character 'M' or 'F' [cite: 3, 243, 245]
    gender = toupper(str_sub(str_trim(gender), 1, 1)),
    
    # Standardize Dates: Handle multiple formats (YYYY-MM-DD and DD-Mon-YY) [cite: 3, 243, 249]
    enrollment_date = parse_date_time(enrollment_date, orders = c("ymd", "dmy", "d-b-y")),
    
    # Fix Truncated Course Names [cite: 5, 12, 19, 250]
    course = case_when(
      str_detect(course, "Machine") ~ "Machine Learning",
      str_detect(course, "Web Devel") ~ "Web Development",
      str_detect(course, "Data Sci|Data Ana") ~ "Data Science",
      str_detect(course, "Cyber") ~ "Cyber Security",
      TRUE ~ course
    )
  )

# 5. REMOVING OUTLIERS
# Removing extreme ages (e.g., age 4 or 78) and extreme payments [cite: 248, 252]
df_final <- df_clean %>%
  filter(
    age >= 16 & age <= 65,      # Filter out non-student ages like 4 or 78 [cite: 248, 252]
    total_payments < 1000000,   # Remove extreme payment outliers [cite: 249, 253]
    !is.na(student_id)          # Ensure Student_ID exists
  )

# 6. EXPORT CLEAN DATA
write_csv(df_final, "CleanDataset.csv")

print("Data cleaning complete! 'CleanDataset.csv' is ready.")

