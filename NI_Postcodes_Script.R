# the working directory for this project is "C:/Users/akhil/Documents/DataScience-CA-2"

# import NIPostcodes csv file to R
library(readr)
NIPostcodes <- read_csv("NIPostcodes.csv")

# load the data into the dataframe
NI_Postcodes <- data.frame(NIPostcodes)
View(NI_Postcodes)

#--------
# STEP A
#--------
# to count the total number of rows
nrow(NI_Postcodes)

# to show the structure of dataset
str(NI_Postcodes)

# to display first 10 rows of dataset
head(NI_Postcodes, 10)

#--------
# STEP B
#--------
# Adding column TITLES for the dataset
column_names = c("Organisation Name", "Sub-building Name", "Building Name", "Number", "Primary Thorfare",
                 "Alt Thorfare", "Secondary Thorfare", "Locality", "Townland", "Town", "County", "Postcode",
                 "x-coordinates", "y-coordinates", "Primary Key")

colnames(NI_Postcodes) <- column_names
head(NI_Postcodes, 5)


#----------------
# STEP C
#----------------
# Remove the missing values in the dataset
new_NI_Postcodes <- na.omit(NI_Postcodes)
new_NI_Postcodes
# all the rows are deleted, and there will be nothing left. So it is better to replace them with identifier 'NA'
# In R, if we load the dataset into a datarame, we already get the missing values with identifier 'NA'.
# there is no need of replacement

# If I had used "read.csv" while reading the file, it would not read missing values as 'NA'.
# I used "read_csv" to read the file. So, it had read the missing values as 'NA' automatically.

#-----------------
# STEP D
#-----------------
# we create a dataframe and load the values of sum of NA's in each column in dataset using "sapply()"
na_sum <- data.frame(sapply(NI_Postcodes, function(y) sum(length(which(is.na(y))))))
# display the result
na_sum

# we create a dataframe and load the values of mean of NA's in each column in dataset using "sapply()"
na_mean <- data.frame(sapply(NI_Postcodes, function(y) mean(is.na(y))))
na_mean

#--------------
# STEP E
#--------------
# Modifying the county attribute to a factor
NI_Postcodes$County <- as.factor(NI_Postcodes$County)
# now show the structure
str(NI_Postcodes)

#---------------
# STEP F
#---------------
# to move the column "Primary Key" to first of dataset
# first install a package "dplyr"
install.packages("dplyr")
library(dplyr)

NI_Postcodes <- NI_Postcodes %>% select(`Primary Key`, everything())
head(NI_Postcodes, 5)
str(NI_Postcodes)
#-----------------
# STEP G
#-----------------
# to copy the required fields having the town as LIMAVADY 
# and saving it as a csv file named "Limavady"
Limavady_data <- data.frame(NI_Postcodes$Locality, NI_Postcodes$Townland, NI_Postcodes$Town) %>% filter(
  NI_Postcodes$Town == "LIMAVADY")
Limavady_data
write.csv(Limavady_data, "Limavady.csv")

#-----------------
# STEP H
#-----------------
# Saving the cleaned NI_postcodes as a csv file
write.csv(NI_Postcodes, "CleanNIPostcodeData.csv")