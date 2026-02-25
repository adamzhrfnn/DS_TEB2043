# Activity 3: Check Armstrong number of n digits

cat("Check whether an n digits number is Armstrong or not:\n")
cat("------------------------------------------------------\n")

num <- as.integer(readline(prompt = "Input an integer: "))

digits <- nchar(as.character(num))
temp <- num
sum <- 0

while (temp > 0) {
  digit <- temp %% 10
  sum <- sum + digit^3
  temp <- temp %/% 10
}

if (sum == num) {
  print(paste(num, "is an Armstrong number."))
} else {
  print(paste(num, "is not an Armstrong number."))
}

