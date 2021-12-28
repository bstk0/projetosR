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

fii1 <- read_html("https://fiis.com.br/deva11/");

#test <- html_attr(fii1,".table")
#test <- html_element(fii1,".table")
#test

#fii1 %>%
#  html_node("body")

#fii1 %>%
#  html_node('.last-revenues--table') 


fiiBody <- html_node(fii1, "body")
#fiiBody
#fiiBody[7]
#map(fiiBody, 7)
#View(fiiBody)
#xml_child(fiiBody, 7)

#fouds <- html_node(fiiBody, '.dataTable no-footer')
#fouds

table_html <- html_node(fiiBody, 'table')
table <- html_text(table_html)
#table

itens <- table_html %>%
  html_nodes(".item") 

#View(itens)
#html_text(itens)

#chegamos na tag com o valor do último dividendo
itens[2] %>% 
  html_node(".value")

tables <- html_nodes(fiiBody, 'table')
table2 <- tables[2]

ult_dt_pagto <- html_nodes(table2, 'tbody td')[2]
ult_dt_pagto

ult_vl_pagto <- html_nodes(table2, 'tbody td')[5]
ult_vl_pagto