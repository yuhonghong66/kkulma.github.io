It's a very quick post on how to get a list of datasets available from within R with their basic description (what package they can be found in, number of observations and variables). It always takes me some time to find the right dataset to showcase whatever process or method I'm working with, so this was really to make my life easier. So! I'm going to scrape the table with a list of R datasets from [here](https://vincentarelbundock.github.io/Rdatasets/datasets.html) using `rvest` and `xml2` packages:

``` r
library(rvest)
library(xml2)
library(dplyr)

url <- "https://vincentarelbundock.github.io/Rdatasets/datasets.html"

r_datasets <- read_html(url) %>% # read url
    html_nodes("table") %>% # extract all the tables
   .[[2]] %>% # it's the second table we want
    html_table() # convert it to a usable format (data.frame)
```

As a result, we get a tidy data frame...

``` r
str(r_datasets)
```

    ## 'data.frame':    1072 obs. of  7 variables:
    ##  $ Package: chr  "datasets" "datasets" "datasets" "datasets" ...
    ##  $ Item   : chr  "AirPassengers" "BJsales" "BOD" "CO2" ...
    ##  $ Title  : chr  "Monthly Airline Passenger Numbers 1949-1960" "Sales Data with Leading Indicator" "Biochemical Oxygen Demand" "Carbon Dioxide Uptake in Grass Plants" ...
    ##  $ Rows   : int  144 150 6 237 6 4 72 84 98 50 ...
    ##  $ Cols   : int  2 2 2 2 2 4 2 2 2 5 ...
    ##  $ csv    : chr  "CSV" "CSV" "CSV" "CSV" ...
    ##  $ doc    : chr  "DOC" "DOC" "DOC" "DOC" ...

``` r
library(knitr)
r_datasets %>% 
  select(-c(csv, doc)) %>% 
  head() %>%
  kable()
```

| Package  | Item          | Title                                       |  Rows|  Cols|
|:---------|:--------------|:--------------------------------------------|-----:|-----:|
| datasets | AirPassengers | Monthly Airline Passenger Numbers 1949-1960 |   144|     2|
| datasets | BJsales       | Sales Data with Leading Indicator           |   150|     2|
| datasets | BOD           | Biochemical Oxygen Demand                   |     6|     2|
| datasets | CO2           | Carbon Dioxide Uptake in Grass Plants       |   237|     2|
| datasets | Formaldehyde  | Determination of Formaldehyde               |     6|     2|
| datasets | HairEyeColor  | Hair and Eye Color of Statistics Students   |     4|     4|

.. that we can filter freely, according to our needs:

``` r
r_datasets %>% filter(Rows >= 1000 & Cols >= 50) %>% kable()
```

| Package    | Item     | Title                                                                         |  Rows|  Cols| csv | doc |
|:-----------|:---------|:------------------------------------------------------------------------------|-----:|-----:|:----|:----|
| Ecdat      | Car      | Stated Preferences for Car Choice                                             |  4654|    70| CSV | DOC |
| psych      | epi      | Eysenck Personality Inventory (EPI) data for 3570 participants                |  3570|    57| CSV | DOC |
| psych      | msq      | 75 mood items from the Motivational State Questionnaire for 3896 participants |  3896|    92| CSV | DOC |
| mosaicData | HELPfull | Health Evaluation and Linkage to Primary Care                                 |  1472|   788| CSV | DOC |
| ISLR       | Caravan  | The Insurance Company (TIC) Benchmark                                         |  5822|    86| CSV | DOC |

``` r
r_datasets %>% filter(grepl("cat", Package)) %>% kable()
```

This totally maked my life easier, so hope it will help you, too!
