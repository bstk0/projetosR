#Get API Restful
if (!('httr' %in% installed.packages())) {
  install.packages('httr')
}

if (!('jsonlite' %in% installed.packages())) {
  install.packages('jsonlite')
}

library(httr)
library(jsonlite)

jdata <- GET('https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_ob_name')

jdata
#View(jdata)
jdata_text <- content(jdata, "text")

get_jdata <- fromJSON(jdata_text, flatten = TRUE)
get_jdata_df <- as.data.frame(get_jdata)

View(get_jdata_df)

for(i in 1:nrow(get_jdata_df)) {
  #row <- get_jdata_df[i,]
  #print(row['sigla'])
  print(get_jdata_df[i,'sigla'])
}