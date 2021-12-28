#install.packages("rvest")
if (!('rvest' %in% installed.packages())) {
  install.packages('rvest')
}

#install.packages("tidyverse")
if (!('tidyverse' %in% installed.packages())) {
  install.packages('tidyverse')
}

# Se já instalou para análises anteriores, basta carregar o pacote

library("tidyverse")
library(rvest)

## -- FUNCTION 1
getFIIData <- function(str) {
  print(length(str))
  print(nchar(str))
  len <- nchar(str)
  
  url <- paste("https://fiis.com.br/", str,"/", sep="")
  print(url)
  
  fii1 <- read_html(url)
  
  fiiBody <- html_node(fii1, "body")
  tables <- html_nodes(fiiBody, 'table')
  table2 <- tables[2]
  
  ult_dt_pagto <- html_nodes(table2, 'tbody td')[2]
  ult_dt_pagto_real <- html_text(ult_dt_pagto)
  print(ult_dt_pagto_real)
  
  ult_vl_pagto <- html_nodes(table2, 'tbody td')[5]
  ult_vl_pagto_real <- html_text(ult_vl_pagto)
  print(ult_vl_pagto_real)
  
  #return(atual)
}

# FUNCIONOU !!!
#getFIIData('BCFF11')
#getFIIData('BRCO11')
getFIIData('BTLG11')
