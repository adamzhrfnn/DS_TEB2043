# Load the Used Car dataset into a data frame
df <- read.csv("UserCarData.csv")

# Standardize column names: convert to lowercase and replace special characters 
# with underscores (e.g., "State or Province" becomes "state_or_province")
names(df) <- tolower(gsub("[^a-zA-Z0-9]", "_", names(df)))

cat("===== DATASET STRUCTURE =====\n")
# Inspect the internal structure (data types: int, chr, num)
str(df)

cat("\n===== SUMMARY STATISTICS =====\n")
# Generate descriptive statistics for prices, year, and mileage
summary(df)

# Print the total dimensions of the dataset
cat("\nRows:", nrow(df), "| Columns:", ncol(df), "\n")

cat("\n===== MISSING VALUES =====\n")
# Check for null or missing values across all columns
missing <- colSums(is.na(df))
if (any(missing > 0)) {
  print(missing[missing > 0])
} else {
  cat("No missing values found in the dataset.\n")
}

# ==========================================
# Visualizations
# ==========================================

# Configure plotting layout: set a 2x2 grid to display 4 charts together.
# 'mar' increases margins for label readability.
par(mfrow = c(2, 2), mar = c(6, 4, 4, 2))

# 1. Price by Fuel Type (Boxplot)
# Purpose: Analyzes how the type of fuel (Diesel vs Petrol) affects car pricing.
boxplot(selling_price ~ fuel, data = df,
        main = "Selling Price by Fuel Type",
        xlab = "Fuel Type", ylab = "Price",
        col = c("#64B5F6", "#81C784", "#FFD54F", "#FF8A65"),
        las = 1, outline = FALSE) # Outliers hidden for better scale

# 2. Year vs Selling Price (Scatterplot)
# Purpose: Visualizes price depreciation over time.
plot(df$year, df$selling_price,
     main = "Year vs Selling Price (Depreciation)",
     xlab = "Year of Manufacture", ylab = "Selling Price",
     col = adjustcolor("#FF9800", alpha.f = 0.3), 
     pch = 16)

# 3. Top 10 Car Brands (Bar Chart)
# Purpose: Identifies which brands have the most listings in the market.
brand_counts <- sort(table(df$name), decreasing = TRUE)
barplot(brand_counts[1:10],
        main = "Top 10 Brands by Frequency",
        ylab = "Number of Listings",
        col = "#A5D6A7", border = "#2E7D32",
        las = 2, cex.names = 0.7)

# 4. KM Driven vs Selling Price (Scatterplot)
# Purpose: Examines how mileage (usage) impacts the car's resale value.
plot(df$km_driven, df$selling_price,
     main = "KM Driven vs Selling Price",
     xlab = "Kilometers Driven", ylab = "Selling Price",
     col = adjustcolor("#E91E63", alpha.f = 0.3), 
     pch = 16)

# Reset graphical parameters back to system defaults
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

# ==========================================
# Market Insights
# ==========================================

cat("\n===== TOP 5 MOST EXPENSIVE CARS =====\n")
# Sort the data frame in descending order based on selling price
top5_cars <- df[order(-df$selling_price), ]
print(head(top5_cars[, c("name", "year", "selling_price", "fuel", "transmission")], 5))

cat("\n===== AVERAGE PRICE BY TRANSMISSION =====\n")
# Calculate average price for Manual vs Automatic cars
aggregate(selling_price ~ transmission, data = df, mean)