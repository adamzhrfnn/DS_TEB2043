library(dplyr)
library(stringr)
library(lubridate)
library(purrr)

# 1. DATA INGESTION & PRE-PROCESSING
raw_content <- readLines("UncleanDataset.csv", warn = FALSE, encoding = "latin1") %>%
  iconv(from = "latin1", to = "UTF-8", sub = "") %>%
  trimws() %>%
  .[nzchar(.)] 

target_cols <- c("Student_ID", "First_Name", "Last_Name", "Age", "Gender", "Course", "Enrollment_Date", "Total_Payments")

# 2. SEPARATE & PARSE HYBRID FORMATS
process_rows <- function(lines) {
  # Logic to split by pipe if pipe exists, otherwise split by comma
  map_df(lines, function(line) {
    if (str_detect(line, fixed("|"))) {
      # Handle pipe-delimited
      fields <- str_split(str_split(line, ",")[[1]][1], fixed("|"))[[1]] %>% trimws()
    } else {
      # Handle comma-delimited
      fields <- read.csv(text = line, header = FALSE, stringsAsFactors = FALSE, colClasses = "character") %>% as.character()
    }
    length(fields) <- 8
    setNames(as.list(fields), target_cols)
  })
}

df_raw <- process_rows(raw_content[-1]) %>%
  mutate(across(everything(), ~na_if(trimws(.x), "")))

# 3. CONSOLIDATED CLEANING PIPELINE
df_refined <- df_raw %>%
  # Fix Mixed Gender/Age (e.g., "M 25")
  mutate(
    Age = if_else(str_detect(Gender, "^[MFmf]\\s+\\d+$"), str_extract(Gender, "\\d+"), Age),
    Gender = if_else(str_detect(Gender, "^[MFmf]\\s+\\d+$"), str_sub(trimws(Gender), 1, 1), Gender)
  ) %>%
  # Name Fixes
  mutate(
    Last_Name = if_else(trimws(First_Name) == trimws(Last_Name), NA_character_, Last_Name),
    split_f = if_else(is.na(Last_Name) & str_detect(First_Name, "\\s+"), str_split_i(First_Name, "\\s+", 1), First_Name),
    split_l = if_else(is.na(Last_Name) & str_detect(First_Name, "\\s+"), str_split_i(First_Name, "\\s+", 2), Last_Name),
    First_Name = str_to_title(trimws(split_f)),
    Last_Name = str_to_title(trimws(split_l))
  ) %>%
  select(-starts_with("split_")) %>%
  # Numeric & Date Conversions
  mutate(
    Student_ID = as.integer(gsub("[^0-9]", "", Student_ID)),
    Age = as.integer(gsub("[^0-9]", "", Age)),
    Age = if_else(Age >= 15 & Age <= 70, Age, NA_integer_),
    Gender = case_when(toupper(Gender) %in% c("M", "F") ~ toupper(Gender), TRUE ~ NA_character_),
    Total_Payments = as.numeric(gsub("[^0-9.]", "", Total_Payments)),
    Enrollment_Date = parse_date_time(Enrollment_Date, orders = c("Ymd", "dmy", "dmY", "d-b-y", "d-b-Y"), quiet = TRUE) %>% as.Date(),
    Enrollment_Date = if_else(year(Enrollment_Date) %in% 2000:year(Sys.Date()), Enrollment_Date, as.Date(NA))
  ) %>%
  # Standardize Course Names
  mutate(Course = case_when(
    str_detect(tolower(Course), "^machine learn") ~ "Machine Learning",
    str_detect(tolower(Course), "^web dev") ~ "Web Development",
    str_detect(tolower(Course), "^data sci") ~ "Data Science",
    str_detect(tolower(Course), "^data anal") ~ "Data Analysis",
    str_detect(tolower(Course), "^cyber") ~ "Cyber Security",
    Course == "4" ~ NA_character_,
    TRUE ~ trimws(Course)
  ))

# 4. REMOVE GARBAGE & DUPLICATES
df_clean <- df_refined %>%
  filter(!if_all(c(Student_ID, First_Name, Last_Name, Age, Total_Payments), is.na)) %>%
  distinct() %>%
  group_by(Student_ID) %>%
  slice(1) %>%
  ungroup()

# 5. ID ASSIGNMENT & OUTLIER HANDLING
if (any(is.na(df_clean$Student_ID))) {
  next_id <- max(df_clean$Student_ID, na.rm = TRUE) + 1
  df_clean$Student_ID[is.na(df_clean$Student_ID)] <- seq(next_id, length.out = sum(is.na(df_clean$Student_ID)))
}

# Normalize Payments and Capping (Condensed Logic)
target_median <- median(df_clean$Total_Payments[df_clean$Course %in% c("Data Science", "Machine Learning")], na.rm = TRUE)

df_clean <- df_clean %>%
  group_by(Course) %>%
  mutate(
    grp_med = median(Total_Payments, na.rm = TRUE),
    # Scale down if median is over 5000 (currency scale fix)
    Total_Payments = if_else(grp_med > 5000 & !is.na(Total_Payments), Total_Payments * (target_median / min(Total_Payments, na.rm = TRUE)), Total_Payments),
    # Outlier Capping
    c_limit = mean(Total_Payments, na.rm = TRUE) + (3 * sd(Total_Payments, na.rm = TRUE)),
    Total_Payments = if_else(Total_Payments > c_limit, median(Total_Payments[Total_Payments <= c_limit], na.rm = TRUE), Total_Payments)
  ) %>%
  ungroup() %>%
  select(-grp_med, -c_limit)

# 6. FINAL IMPUTATION
calc_mode <- function(v) {
  v <- v[!is.na(v)]
  if (length(v) == 0) return(NA)
  ux <- unique(v)
  ux[which.max(tabulate(match(v, ux)))]
}

df_final <- df_clean %>%
  mutate(
    Age = replace_na(Age, as.integer(round(mean(Age, na.rm = TRUE)))),
    Gender = replace_na(Gender, calc_mode(Gender)),
    Course = replace_na(Course, calc_mode(Course)),
    Enrollment_Date = replace_na(Enrollment_Date, median(Enrollment_Date, na.rm = TRUE)),
    Total_Payments = replace_na(Total_Payments, median(Total_Payments, na.rm = TRUE))
  ) %>%
  arrange(Student_ID)

# 7. EXPORT
write.csv(df_final, "CleanedDataset_v2.csv", row.names = FALSE)

