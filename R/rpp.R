library(leaflet)
library(rgdal)
library(rgeos)
library(scales)
library(jsonlite)
library(httr)
library(noncensus)
library(htmltools)

# Get the data (need to put your BEA_API_TOKEN in .Renviron ---------------

response <- GET("http://bea.gov/api/data/",
                query=list(
                  UserID=Sys.getenv("BEA_API_TOKEN"),
                  method="GetData",
                  datasetname="RegionalData",
                  KeyCode="RPPALL_MI",
                  Year="2013",
                  ResultFormat="json"
                ))
dat <- fromJSON(content(response, as="text"))
dat <- dat$BEAAPI$Results$Data
dat$X2013 <- as.numeric(dat$DataValue)

# Cleanup the data a bit --------------------------------------------------

dat$GeoName <- gsub(" \\(Metropolitan Statistical Area\\)", "", dat$GeoName)
dat$GeoFips <- sprintf("%05d", as.numeric(dat$GeoFips))

# We need to translate census county codes to FIPS for the map ------------

data(counties)
xlate <- data.frame(fipscounty=sprintf("%s%s", counties$state_fips,
                                       counties$county_fips),
                    cbsa=counties$CBSA,
                    stringsAsFactors=FALSE)
dat <- merge(dat[,c(1,2,8)], xlate[,c("cbsa", "fipscounty")],
             by.x="GeoFips", by.y="cbsa")

# Use existing TopoJSON map files -----------------------------------------

URL <- "http://bl.ocks.org/mbostock/raw/4090846/us.json"
fil <- basename(URL)
if (!file.exists(fil)) download.file(URL, fil)

states <- readOGR(fil, "states", stringsAsFactors=FALSE)
county <- readOGR(fil, "counties", stringsAsFactors=FALSE)

rpp_counties <- subset(county, id %in% dat$fipscounty)
rpp_counties <- merge(rpp_counties, dat, by.x="id", by.y="fipscounty", all.x=TRUE)

# Setup color scale -------------------------------------------------------

pal <- colorBin("BrBG", range(rpp_counties$X2013), bins=5)
rpp_counties$color <- pal(rpp_counties$X2013)

# make the map ------------------------------------------------------------

leaflet() %>%
  addProviderTiles("Acetate.terrain") %>%
  addPolygons(data=rpp_counties, weight=0.25,
              fillColor=~color, color="black", fillOpacity=1,
              popup=~sprintf("In %s, <span style='font-weight:700'>%s</span> has the purchasing power of $100.00.",
                             htmlEscape(GeoName),
                             htmlEscape(dollar(X2013)))) %>%
  addPolygons(data=states, weight=0.5, fillColor="white", fillOpacity=0, fill=FALSE, color="#525252") %>%
  addLegend(position="bottomright", pal=pal, values=rpp_counties$X2013, labFormat=labelFormat("$"), opacity = 1) %>%
  setView(-74.0059, 40.7127, 6) %>% htmlwidgets::saveWidget("~/Dropbox/homeshare/rpp.html")
