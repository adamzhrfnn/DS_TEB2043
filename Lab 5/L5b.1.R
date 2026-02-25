# Activity 1: Check whether a year is leap year or not

year <- as.integer(readline(prompt = "Input year: "))

if ((year %% 4 == 0 & year %% 100 != 0) | (year %% 400 == 0)) {
  print(paste(year, "is a leap year."))
} else {
  print(paste(year, "is not leap year."))
}
