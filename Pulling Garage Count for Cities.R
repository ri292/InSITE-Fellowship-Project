#Script to count number of garages in Boston, Philadelphia, and Washington DC using Google Maps Places API

#Setup & input information
#library(tidyverse)
setwd("C:/Users/riazu/Documents/InSITE")
library(RJSONIO)
api_key <- "key=" #enter Google Maps API key after =
website_stem <- "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
type <- "type=parking"
language <- "&language=en"
api_data <- NULL
latest_api_data <- NULL
page_token <- NULL
page_token_list <- data.frame(page_token=character(0),stringsAsFactors=FALSE)
page_token_counter <- 1
counter <- 0

#Boston characteristics
#location="&location=42.3601,-71.0589"
radius="&radius=500"
boston_location <- read.csv("boston_location.csv",stringsAsFactors=FALSE)

#Philadelphia characteristics
#location="&location=39.9526,-75.1652"
radius="&radius=500"
philadelphia_location <- read.csv("philadelphia_location.csv",stringsAsFactors=FALSE)

#Washington characteristics
#location="&location=38.9072,-77.0369"
radius="&radius=500"
washington_location <- read.csv("washington_location.csv",stringsAsFactors=FALSE)



##For every zip code in city

for (city in list(boston_location, philadelphia_location, washington_location)) {

counter <- 0

for (zipcode in city$Location) {

##Resets
api_data <- NULL
latest_api_data <- NULL
page_token <- NULL
location <- paste0("&location=",zipcode)


##Create API call website: website_stem, location, radius, api_key
first_website <- paste0(website_stem,type,language,location,radius,"&",api_key)
#first_website <- paste0(website_stem,type,language,"&location=",boston_location[zipcode,"Location"],radius,"&",api_key)

##Run first API call
api_data <- fromJSON(first_website)
Sys.sleep(2)

##Start counter: counter <- length(dataset$results)
counter <- counter + length(api_data$results)

##Create page_token <- dataset$next_page_token
page_token <- api_data$next_page_token
#page_token_list[page_token_counter + 1,page_token] <- page_token
#page_token_counter <- page_token_counter + 1


##Run while loop: if page_token != NULL then end
while (is.character(page_token)) {



##Create new API call website: website_stem, api_key, page_token
website <- paste0(website_stem,api_key,"&pagetoken=",page_token)

##Run new API call
latest_api_data <- fromJSON(website)

## Timer = 3 seconds
Sys.sleep(2)

##counter <- counter + length(dataset$results)
counter <- counter + length(latest_api_data$results)

##Update page_token <- dataset$next_page_token
#page_token <- NULL
page_token <- latest_api_data$next_page_token
#page_token_list[page_token_counter,page_token] <- page_token
#page_token_counter <- page_token_counter + 1

}

}
print(counter)

}