library(omdbapi)

## Upload box office mojo data ##

boxOffice <- read.delim("mojo.txt", sep = "\n", header = FALSE)

## Process box office mojo data ##
boxOffice <- as.matrix(boxOffice)
boxOffice <- matrix(boxOffice, ncol = 8, byrow = TRUE)
boxOffice <- as.data.frame(boxOffice)
names(boxOffice) <- c("Rank", "Title", "Studio", "Worldwide", "Domestic", "Domestic.Percent",
                      "Overseas", "Overseas.Percent")

dollars <- function(x) {
  thousands <- rep(0, length(x))
  for(i in length(x)){
    thousands[i] <- length(which(strsplit(x[i], "")[[1]] == "k"))}
  
  x <- sub("\\$", "", x)
  x <- sub("\\,", "", x)
  x <- sub("k", "", x)
  
  x <- as.numeric(x)
  x[thousands > 0] <- x[thousands > 0]/1000
  x}

percent <- function(x) {
  x <- sub("\\%", "", x)
  x <- as.numeric(x)
  x}

boxOffice$Rank <- as.numeric(boxOffice$Rank)

boxOffice$Title <- as.character(boxOffice$Title)
boxOffice$Title <- gsub(" \\(.*?\\)", "", boxOffice$Title)
boxOffice$Title <- gsub(" in 3D", "", boxOffice$Title)

boxOffice$Worldwide <- dollars(as.character(boxOffice$Worldwide))
boxOffice$Domestic <- dollars(as.character(boxOffice$Domestic))
boxOffice$Overseas <- dollars(as.character(boxOffice$Overseas))

boxOffice$Domestic.Percent <- percent(as.character(boxOffice$Domestic.Percent))
boxOffice$Overseas.Percent <- percent(as.character(boxOffice$Overseas.Percent))


## Extract ratings data from OMDb ##

boxOffice$Genre <- NA
boxOffice$Metascore <- NA
boxOffice$imdbRating <- NA
boxOffice$imdbVotes <- NA
boxOffice$tomatoMeter <- NA
boxOffice$tomatoReviews <- NA
boxOffice$tomatoFresh <- NA
boxOffice$tomatoRotten <- NA
boxOffice$tomatoRating <- NA
boxOffice$tomatoUserMeter <- NA
boxOffice$tomatoUserRating <- NA
boxOffice$tomatoUserReviews <- NA
boxOffice$GoldenGlobes <- NA

for(i in 1:dim(boxOffice)[1]){
  results <- find_by_title(boxOffice$Title[i], year_of_release = 2016,
                           include_tomatoes = TRUE)
  if(class(results$Genre) == "NULL"){
    results <- find_by_title(boxOffice$Title[i], year_of_release = 2015,
                             include_tomatoes = TRUE)
    if(class(results$Genre) == "NULL"){next}}
  boxOffice$Genre[i] <- results$Genre
  boxOffice$Metascore[i] <- results$Metascore
  boxOffice$imdbRating[i] <- results$imdbRating
  boxOffice$imdbVotes[i] <- results$imdbVotes
  boxOffice$tomatoMeter[i] <- results$tomatoMeter
  boxOffice$tomatoReviews[i] <- results$tomatoReviews
  boxOffice$tomatoFresh[i] <- results$tomatoFresh
  boxOffice$tomatoRotten[i] <- results$tomatoRotten
  boxOffice$tomatoRating[i] <- results$tomatoRating
  boxOffice$tomatoUserMeter[i] <- results$tomatoUserMeter
  boxOffice$tomatoUserRating[i] <- results$tomatoUserRating
  boxOffice$tomatoUserReviews[i] <- results$tomatoUserReviews
  
  awards <- which(unlist(strsplit(results$Awards, split = " ")) == "Golden")
  if(length(awards) == 1){
    boxOffice$GoldenGlobes[i] <- "Winner / Nominee"}
  else{boxOffice$GoldenGlobes[i] <- "Other"}
}
  
# Manually fill in errors

errors <- which(is.na(boxOffice$Genre))
boxOffice$Title[errors]
errorIds <- c('tt3410834', 'tt4172430', 'tt2113658', 'tt4900716')

for(i in 1:length(errors)){
  results <- find_by_id(errorIds[i], include_tomatoes = TRUE)
  boxOffice$Genre[errors[i]] <- results$Genre
  boxOffice$Metascore[errors[i]] <- results$Metascore
  boxOffice$imdbRating[errors[i]] <- results$imdbRating
  boxOffice$imdbVotes[errors[i]] <- results$imdbVotes
  boxOffice$tomatoMeter[errors[i]] <- results$tomatoMeter
  boxOffice$tomatoReviews[errors[i]] <- results$tomatoReviews
  boxOffice$tomatoFresh[errors[i]] <- results$tomatoFresh
  boxOffice$tomatoRotten[errors[i]] <- results$tomatoRotten
  boxOffice$tomatoRating[errors[i]] <- results$tomatoRating
  boxOffice$tomatoUserMeter[errors[i]] <- results$tomatoUserMeter
  boxOffice$tomatoUserRating[errors[i]] <- results$tomatoUserRating
  boxOffice$tomatoUserReviews[errors[i]] <- results$tomatoUserReviews
  
  awards <- which(unlist(strsplit(results$Awards, split = " ")) == "Golden")
  if(length(awards) == 1){
    boxOffice$GoldenGlobes[i] <- "Winner / Nominee"}
  else{boxOffice$GoldenGlobes[i] <- "Other"}
  
}


## Split out genres ##

genreList <- unlist(strsplit(paste(boxOffice$Genre, sep=", "), ", "))
genres <- genreList[!duplicated(genreList)]

for(i in 1:nrow(boxOffice)) {
  for(j in 1:length(genres))
    boxOffice[i, genres[j]] <- length(grep(genres[j], boxOffice$Genre[i]))
}

boxOffice$Metascore <- as.numeric(boxOffice$Metascore)


## Export data ##

write.table(boxOffice, "export.txt", sep = "\t")
