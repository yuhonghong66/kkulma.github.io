####### solution 1 ########

urll <- 'http://www.amazon.com/Key-Industries-Washed-Denim-Sleeve/product-reviews/B009URT88Y/ref=dp_top_cm_cr_acr_txt?showViewpoints=1'
library(XML)
doc <- htmlParse(urll)
xpathSApply(doc,'//div[@class="reviewText"]',xmlValue)

sapiens_url <- "https://www.amazon.co.uk/Sapiens-Humankind-Yuval-Noah-Harari/dp/0099590085/ref=sr_1_1?s=books&ie=UTF8&qid=1488666948&sr=1-1&keywords=sapiens"

install.packages("XML")
library(XML)
install.packages("RCurl")
library(RCurl)
sapiens_data <- getURL(sapiens_url)
sapiens_url
sapiens_data
?htmlParse

sapiens_doc  <- htmlTreeParse(xmlRoot(sapiens_url), useInternalNodes = TRUE)

sapiens_doc

test <- xpathSApply(sapiens_doc,'//div[@class="reviewText"]',xmlValue)
str(test)


####### solution 2 ########
ls()

install.packages("pacman")
pacman::p_load(XML, dplyr, stringr, rvest, audio)

#Remove all white space
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

prod_code = "1846558239"
url <- paste0("https://www.amazon.co.uk/dp/", prod_code)
doc <- read_html(url)

#obtain the text in the node, remove "\n" from the text, and remove white space
prod <- html_nodes(doc, "#productTitle") %>% html_text() %>% gsub("\n", "", .) %>% trim()
prod


#Source funtion to Parse Amazon html pages for data
source("https://raw.githubusercontent.com/rjsaito/Just-R-Things/master/Text%20Mining/amazonscraper.R")

pages <- 10

reviews_all <- NULL
for(page_num in 1:pages){
  url <- paste0("http://www.amazon.co.uk/product-reviews/",prod_code,"/?pageNumber=", page_num)
  doc <- read_html(url)
  
  reviews <- amazon_scraper(doc, reviewer = F, delay = 2)
  reviews_all <- rbind(reviews_all, cbind(prod, reviews))
}

str(reviews_all)
 head(reviews_all)

str(reviews_all[1, ])

reviews_all[1, 8]


#### creating corpus ####
??corpus
pacman::p_load(tm, rvest, SnowballC, wordcloud)

??readTabular

m <- list(content = "comments")

          #heading = "title",
          #author = "author", format = "format", product = "prod",
          #topic = "topics", date = "date", stars = "stars", helpful = "helpful")

myReader <- readTabular(mapping = m)

final_reviews <- data.frame(comments = reviews_all$comments)
str(final_reviews)

final_reviews[904 , ]

ds <- DataframeSource(final_reviews)


??DataframeSource

sapiens_corpus <- VCorpus(ds)
sapiens_corpus[[104]]$content


## remove punctuation
sapiens_corpus = tm_map(sapiens_corpus, removePunctuation)
sapiens_corpus[[1]]$content


## remove numbers
sapiens_corpus = tm_map(sapiens_corpus, removeNumbers)

## LowerCase
sapiens_corpus = tm_map(sapiens_corpus, tolower)
corpus[[1]]$content


## remove stopwords and other words
myWords=c("format", "paperback", "kindle", "edit", "hardcov", "book", "read", "will", "just", "can", "much")
sapiens_corpus <- tm_map(sapiens_corpus, removeWords, c(stopwords("english"), myWords))
corpus[[1]]$content


## stemming
sapiens_corpus <- tm_map(sapiens_corpus, stemDocument) 
sapiens_corpus$content

# remove white spaces after stemming
sapiens_corpus <- tm_map(sapiens_corpus, stripWhitespace) 

# treat pre-processed documents as text documents
sapiens_corpus <- tm_map(sapiens_corpus, PlainTextDocument) 
corpus[[1]]$content

#turning into doc matrix
sapiens_dtm <- DocumentTermMatrix(sapiens_corpus)
sapiens_dtm
inspect(sapiens_dtm)


# displaying most frequent words
freq <- sort(colSums(as.matrix(sapiens_dtm)), decreasing=TRUE)   
head(freq, 20)  


## wordcloud

pal=brewer.pal(10, "Set1")

set.seed(100)
wordcloud(words = names(freq), freq = freq, max.words=250,
          random.order=FALSE,
          colors=pal)

png("LeanInWordcloud.png")
wordcloud(words = names(freq), freq = freq, max.words=250,
          random.order=FALSE,
          colors=pal)
dev.off()




