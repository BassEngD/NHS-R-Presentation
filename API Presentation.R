# Using APIs and stuff

# APIs use HTTP requests just like requesting a website.
# You tell the server you want a webpage, it sends it to you.
# 
# R uses a library called httr to control sending and recieving HTTP requests
library(httr)

# The command you will use the most for APIs is GET()
# This command will save the reply from the server as an object. Let's look at Google.com

webpage.raw <- GET(url="www.google.com")

# status_code is a http response status code, like 404. 200 is a success.
# headers hold information about the server's reply
# the original request you sent is in 'request', which is helpful to check you used the right url.
# the actual reply, the webpage, is inside content.
# Content is in machine code, and needs converting to be readbale.
# This is done with another command from httr: content()

webpage.decoded <- content(webpage.raw, "text")

# We can't look at the webpage in R, but we could extract values from the HTML.

# Let's use GET to download some information from the NHS' Organisation Data Service (ODS)
# Website: https://digital.nhs.uk/services/organisation-data-service

# The API gives the url of the 'Endpoint', the address to send requests to the server.
url <- "https://directory.spineservices.nhs.uk/ORD/2-0-0/organisations?"

API.raw <- GET(url = url)

# Note the status_code of 406. This means something was wrong with the request.

API.decoded <- content(API.raw)

# The error message says "Supplied query must include some query parameters"
# You can do this by adding them to the url, like so

url <- "https://directory.spineservices.nhs.uk/ORD/2-0-0/organisations?PostCode=B15"
API.raw <- GET(url = url)
API.decoded <- content(API.raw)

# The decoded reply is a list of 20 organisations from the B15 postcode.
# Only 20 results come back because that is the default limit for the server.
# We can set more parameters to get more of them back, but setting the url each time gets cumbersome.
# the GET command can include the parameters as a list

parameters <- list(PostCode="B15",
                   Limit=100)

url <- "https://directory.spineservices.nhs.uk/ORD/2-0-0/organisations?"
API.raw <- GET(url = url, query = parameters)
API.decoded <- content(API.raw)

# This makes a list of lists, but a more useful format is to use fromJSON().
# This is from the library jsonlite.
library(jsonlite)
API.decoded <- fromJSON(content(API.raw, 'text'))

# Each API has its own rules, parameters and formats. Many use JSON like this one,
# but you may also find XML, CSV and others.

# It is possible to use a loop in R to keep gathering more and more data from an API.
# I've made a script that gets every NHS Trust organisation code,
# its address and if it is active or inactive.
# The script ran for ~30 minutes on my home computer and has 28286 records.
# Data in R can be saved as a .csv file and then imported into SQL.
# I am still looking into methods to have SQL Server use APIs directly.
