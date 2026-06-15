

########################### variable assignment ######################
a <- 1 + 2
# a = 1 + 2
a <- 110   # R overrides the previous variable
A <- 10    # R is case-sensitive!

########################### data types ######################

######### numeric: a number ##########
mynumeric1 <- 0.4
mynumeric2 <- 12

######### logic: TRUE/FALSE #########
mylogic1 <- T
mylogic1 <- TRUE
mylogic2 <- FALSE # or F

######### character: a text #########
mycha1 <- "LA Best"   # both single/double quote work
mycha2 <- 'LA Best'


########################### data structures ######################

######### vector ##########
# a 1-D collection of the SAME type

ages <- c(23, 31, 19, 45)
class(ages) # numeric

active <- c(TRUE, FALSE, T, TRUE)
class(active) # logical

race <- c("White", "Asian", "Hispanic", "Black")
class(race) # character

# Indexing — R uses 1-based indexing!
ages[1] # 23 (first element)
ages[c(1,3)] # 23 19 (first and third)
ages[2:4]

####### factor: categorical variables #######
race_f <- factor(race)
levels(race_f) # alphabetical order


######### list: mixed-type ##########
# Lists can hold anything — different types, even other lists
person <- list( name = "Alice", age = 23, scores = c(88, 92, 76) )

person$name # "Alice" (dollar-sign access)
person[["age"]] # 23 (double-bracket access)
person$scores[2] # 92


######################### data.frames ####################
# A data frame is R's version of a spreadsheet — rows are observations,
# columns are variables. Every column is a vector of the same type,
# but different columns can have different types.
# This is the workhorse of data analysis in R.

##### mtcars (Motor Trend cars)
data(mtcars)

# explore the data
head(mtcars) # first 6 rows
dim(mtcars) # rows × columns
str(mtcars) # structure: types + sample values
summary(mtcars) # quick stats for every column


# grab a column
mtcars$mpg
mtcars[, "mpg"]
mtcars[, 1]

mtcars[, c("mpg", "cyl", "hp")] # multiple columns

# grab rows
mtcars[1, ] # first row
mtcars[1:3, ] # first 3 rows
mtcars[mtcars$mpg > 25, ] # cars with >25 mpg

# row and column select
mtcars[mtcars$cyl == 4, c("mpg", "hp")]

# add a column
mtcars$kpl <- mtcars$mpg * 0.425   # km per litre

# remove a column
mtcars$kpl <- NULL

# rename one column
names(mtcars)[names(mtcars) == "mpg"] <- "miles_per_gallon"

###################### dplyr pipeline #############
install.packages("dplyr")
library(dplyr) # load package

# filter() — keep rows
cyl4 <- filter(mtcars, cyl == 4) # filter rows with cyl=4
# Multiple conditions — use comma (AND) or | (OR)
cyl4_mpg25 <- filter(mtcars, cyl == 4, mpg > 25)
cyl4_or_mpg25 <- filter(mtcars, cyl == 4 | mpg > 25)

# select() — keep columns
# pick only the columns we care about
subdata1 <- select(mtcars, mpg, cyl, hp, wt)

# drop a column with minus sign
subdata2 <- select(mtcars, -qsec, -vs)

# mutate() — add / change columns
# create a new column: kpl (km per litre) from mpg

data3 <- mutate(mtcars, kpl = mpg * 0.425) # create a new dataset with additional kpl col
mtcars$kpl <- mtcars$mpg * 0.425 # add to mtcars

mtcars %>%
  mutate(kpl = mpg * 0.425)  %>%
  mutate(cyl_f = factor(cyl)) %>%
  select(mpg, cyl_f, kpl) %>%
  head()


# Note: You may have seen %>% in older tutorials (from the magrittr package).
# The native pipe |> was added in R 4.1 and behaves identically for most use cases.
# Either is fine; |> is the modern default.

# rename columns
# rename(new_name = old_name)
mtcars %>%
  rename(miles_per_gallon = mpg)

# rename multiple
mtcars %>%
  rename(
  miles_per_gallon = mpg,
  horsepower  = hp
    )

## arrange() — sort rows
# Sort by mpg, ascending (default)
mtcars |>
  arrange(mpg) |>
  head()

# Descending: wrap with desc()
mtcars |>
  arrange(desc(mpg)) |>
  head()


# summarise() + group_by() — aggregate
# Average mpg across all cars
mtcars  %>%
  summarise(avg_mpg = mean(mpg))
# Average mpg BY cylinder group — this is the power combo
mtcars %>%
  group_by(cyl) %>%
  summarise( avg_mpg = mean(mpg),
             count = n()
            )


# Full pipeline: which automatic cars have the best efficiency?
best_auto <- mtcars |>
  filter(am == 1) |> # automatic only
  select(mpg, cyl, hp, wt) |> # keep relevant columns
  mutate(kpl = round(mpg * 0.425, 1)) |> # add kpl
  arrange(desc(mpg))

best_auto

############################# plotting #########################
##### basic plotting #####
# Histogram: distribution of mpg
hist(mtcars$mpg,
     main = "Distribution of fuel efficiency",
     xlab = "Miles per gallon",
     col = "steelblue",
     breaks = 10)

# Scatter plot: weight vs mpg
plot(mtcars$wt, mtcars$mpg,
     main = "Weight vs MPG",
     xlab = "Weight (1000 lbs)",
     ylab = "Miles per gallon",
     pch = 19,
     col = "steelblue")

# Boxplot: mpg by cylinder count
boxplot(mpg ~ cyl, data = mtcars,
        main = "MPG by cylinders",
        xlab = "Cylinders",
        ylab = "MPG",
        col = c("#9FE1CB", "#5DCAA5", "#1D9E75")
        )

###################### ggplot #################
install.packages("ggplot2")
library(ggplot2)

# ggplot works in layers: data → aesthetics → geometry
ggplot(mtcars,
       aes(x = wt, y = mpg, color = factor(cyl))
       ) +
  geom_point(size = 3) +
  labs( title = "Car weight vs fuel efficiency",
        x = "Weight (1000 lbs)",
        y = "Miles per gallon",
        color = "Cylinders"
        ) +
  theme_minimal()












