# Activity 2: Display the cube of numbers up to a given integer

n <- as.integer(readline(prompt = "Input an integer: "))

for (i in 1:n) {
  print(paste("Number is:", i, "and cube of the", i, "is :", i^3))
}
