# Load necessary libraries
library(httr)
library(jsonlite)
library(readr)
library(base64enc) # for encoding credentials
library(tidyverse)

# Read the article IDs from the CSV file
file_path <- "ItemIDs.csv"  # Adjust the path if necessary
article_ids_df <- read_csv(file_path)

# Extract the article IDs from the dataframe
article_ids <- article_ids_df$ItemIDs

# Define the base URL for Figshare API
base_url <- "https://stats.figshare.com/lboro/breakdown/total/downloads/article"

# Define your username and password
username <- username  # Replace with your actual username
password <- password  # Replace with your actual password

# Combine the username and password and encode them
credentials <- paste(username, password, sep = ":")
encoded_credentials <- base64encode(charToRaw(credentials))

# Function to get geolocation data for a single article ID
get_geolocation <- function(article_id) {
  url <- paste0(base_url, "/", article_id)
  response <- GET(url, add_headers(Authorization = paste("Basic", encoded_credentials)))
  print(response)
  
  if (status_code(response) == 200) {
    content <- content(response, as = "text")
    json_data <- fromJSON(content, flatten = TRUE)
    return(json_data)
  } else {
    warning(paste("Failed to get data for article ID:", article_id))
    return(NULL)
  }
}

# Initialize an empty list to store aggregated results
aggregated_data <- list()

# Loop through each element in geolocation_data
for (i in seq_along(geolocation_data)) {
  breakdown_total <- geolocation_data[[i]]$breakdown$total
  
  # Loop through each country in the breakdown_total
  for (country in names(breakdown_total)) {
    if (is.list(breakdown_total[[country]])) {
      # Check if the country already exists in aggregated_data
      if (country %in% names(aggregated_data)) {
        # Add counts to existing entries
        for (location in names(breakdown_total[[country]])) {
          if (location != "total") {
            aggregated_data[[country]][[location]] <- aggregated_data[[country]][[location]] + breakdown_total[[country]][[location]]
          }
        }
        # Update total count
        aggregated_data[[country]]$total <- aggregated_data[[country]]$total + breakdown_total[[country]]$total
      } else {
        # Initialize country entry if it doesn't exist
        aggregated_data[[country]] <- list()
        for (location in names(breakdown_total[[country]])) {
          if (location != "total") {
            aggregated_data[[country]][[location]] <- breakdown_total[[country]][[location]]
          }
        }
        # Initialize total count
        aggregated_data[[country]]$total <- breakdown_total[[country]]$total
      }
    }
  }
}

# Convert aggregated_data to a dataframe
country_data <- map_df(names(aggregated_data), ~ {
  country <- .x
  downloads <- aggregated_data[[.x]]$total
  tibble(country = country, total_downloads = downloads)
})

# Print the summarized dataframe
print(country_data)
