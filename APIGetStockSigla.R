#Get API Restful
if (!('curl' %in% installed.packages())) {
  install.packages("curl")
}
if (!('httr' %in% installed.packages())) {
  install.packages('httr')
}

if (!('jsonlite' %in% installed.packages())) {
  install.packages('jsonlite')
}

library(httr)
library(jsonlite)

res <-
  GET('https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_ob_name')

res
data = fromJSON(rawToChar(res$content))
names(data)

data$sigla
length(data$sigla)
print(data$sigla[10])