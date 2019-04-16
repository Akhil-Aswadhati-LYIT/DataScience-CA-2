
# the working directory for this project is "C:/Users/akhil/Documents/DataScience-CA-2"

# all the crime data files are placed into one folder and its path is provided in "folder_path" below.

#--------------
# STEP A
#--------------
# path to folder that holds multiple .csv files
folder_path <- "C:/Users/akhil/Documents/DataScience-CA-2/Ni Crime Data CSV files/"

# create list of all .csv files in folder
file_list <- list.files(path = folder_path, pattern = "*.csv") 
file_list
# read in each .csv file in file_list and create a data frame with the same name as the csv file
for (i in 1:length(file_list))
{
  assign(file_list[i], 
         read.csv(paste(folder_path, file_list[i], sep=''))
  )
}

# Every csv file has the same format if we view it, so we can combine them into a single dataset
# load the combined datasets into a dataframe with name AllNICrimeData
AllNICrimeData <- rbind.data.frame(`2015-01-northern-ireland-street.csv`, `2015-02-northern-ireland-street.csv`, 
                                   `2015-03-northern-ireland-street.csv`, `2015-04-northern-ireland-street.csv`, 
                                   `2015-05-northern-ireland-street.csv`, `2015-06-northern-ireland-street.csv`, 
                                   `2015-07-northern-ireland-street.csv`, `2015-08-northern-ireland-street.csv`, 
                                   `2015-09-northern-ireland-street.csv`, `2015-10-northern-ireland-street.csv`, 
                                   `2015-11-northern-ireland-street.csv`, `2015-12-northern-ireland-street.csv`,
                                   `2016-01-northern-ireland-street.csv`, `2016-02-northern-ireland-street.csv`, 
                                   `2016-03-northern-ireland-street.csv`, `2016-04-northern-ireland-street.csv`,
                                   `2016-05-northern-ireland-street.csv`, `2016-06-northern-ireland-street.csv`,
                                   `2016-07-northern-ireland-street.csv`, `2016-08-northern-ireland-street.csv`,
                                   `2016-09-northern-ireland-street.csv`, `2016-10-northern-ireland-street.csv`,
                                   `2016-11-northern-ireland-street.csv`, `2016-12-northern-ireland-street.csv`,
                                   `2017-01-northern-ireland-street.csv`, `2017-02-northern-ireland-street.csv`,
                                   `2017-03-northern-ireland-street.csv`, `2017-04-northern-ireland-street.csv`,
                                   `2017-05-northern-ireland-street.csv`, `2017-06-northern-ireland-street.csv`,
                                   `2017-07-northern-ireland-street.csv`, `2017-08-northern-ireland-street.csv`,
                                   `2017-09-northern-ireland-street.csv`, `2017-10-northern-ireland-street.csv`,
                                   `2017-11-northern-ireland-street.csv`, `2017-12-northern-ireland-street.csv`)

# Display the combined dataset
AllNICrimeData
str(AllNICrimeData)

# Save the combined dataset as a csv file in working directory
write.csv(AllNICrimeData, "AllNICrimeData.csv")

# Count the number of rows in dataset
NROW(AllNICrimeData)

#----------------
# STEP B
#----------------
# Remove the required columns in the dataset and create a modified dataframe
AllNICrimeData <- data.frame(AllNICrimeData$Month, AllNICrimeData$Longitude, AllNICrimeData$Latitude,
                             AllNICrimeData$Location, AllNICrimeData$Crime.type)
head(AllNICrimeData, 5) # to show the first 5 rows

# show the structure of modified dataframe
str(AllNICrimeData)

#---------------
# STEP C
#---------------
# Factorise the crime type attribute and then show structure again
AllNICrimeData$AllNICrimeData.Crime.type <- as.factor(AllNICrimeData$AllNICrimeData.Crime.type)
str(AllNICrimeData)

#----------------
# STEP D
#----------------
# Modifying the Location column, so that it does'nt contain "On or near" part of the string
head(AllNICrimeData, 5)
AllNICrimeData$AllNICrimeData.Location <- gsub("On or near ", "", 
                                               AllNICrimeData$AllNICrimeData.Location)
head(AllNICrimeData, 5)


# there are some empty fields in location column now
# Replacing the empty fields with NA
AllNICrimeData$AllNICrimeData.Location[AllNICrimeData$AllNICrimeData.Location == ""] <- NA
sum(is.na(AllNICrimeData$AllNICrimeData.Location)) # Sum of NA's in location column
head(AllNICrimeData, 5)

#-----------------
# STEP E
#-----------------
# making a subset from the source dataset without NA values
newdata_subset <- subset(AllNICrimeData, !is.na(AllNICrimeData.Location))
newdata_subset

# Selecting a random sample of size 1000 from the newly created dataset
random_crime_sample <- data.frame(newdata_subset[sample(nrow(newdata_subset), 1000), ])
View(random_crime_sample)

library(dplyr)
# Convert the location attributes in random crime sample to upper case
random_crime_sample$AllNICrimeData.Location <- toupper(random_crime_sample$AllNICrimeData.Location)

# creating a new dataset that contains postcode and primary thorfare information from NIPostcodes dataset
new_ds <- NI_Postcodes[, c(6, 13)]
head(new_ds, 5)

# deleting the duplicate values in primary thorfare column
new_ds <- new_ds[!duplicated(new_ds$`Primary Thorfare`),]
# column names for new dataset
colnames(new_ds) <- c("Primary Thorfare", "Postcode")
str(new_ds)

# add a new column to the random crime sample dataset and place the values as NA
random_crime_sample$Postcode <-NA
head(random_crime_sample, 5)

# add the values for postcode column by matching the location with primary thorfare in new_ds
random_crime_sample$Postcode <- new_ds$Postcode[match(random_crime_sample$AllNICrimeData.Location, 
                                                      new_ds$`Primary Thorfare`)]
#Structure of random set
str(random_crime_sample)
# number of rows
NROW(random_crime_sample)
View(random_crime_sample)

#--------------
# STEP F
#--------------
# we already appended the postcodes to the random sample set above
# Now we will Save the modified random crime sample data frame as random_crime_sample.csv.
write.csv(random_crime_sample, "random_crime_sample.csv")


str(random_crime_sample)

#--------------
# STEP G
#--------------
updated_random_sample <- data.frame(random_crime_sample)
colnames(updated_random_sample) <- c("Month", "Longitude", "Latitude", "Location", "Crime.type", "Postcode")
head(updated_random_sample, 3)

chart_data <- updated_random_sample
# Sort chart_data w.r.t Postcode and crime type
chart_data <- chart_data[order(chart_data$Postcode == "BT1", chart_data$Crime.type), ]
chart_data

# create a new chart dataset that contains postcode = "BT1"
new_chart <- filter(chart_data, grepl('BT1', Postcode))
new_chart
new_chart[order(new_chart$Postcode == 'BT1', new_chart$Crime.type), ]
str(new_chart)

# Summary of crime type as per postcode and location

crime_type <- data.frame(new_chart$Crime.type)
library(plyr)
crime_type <- ddply(crime_type, .(new_chart$Crime.type), nrow)
colnames(crime_type) <- c("Crime_type", "Count")
crime_type

#---------------
# STEP H
#---------------

CrimeData <- table(chart_data$Crime.type)
barplot(CrimeData, main = "Crime Type Frequency", xlab = "Crime Type", ylab = "Frequency", col = "red", border = "black",
        density = 1000)

