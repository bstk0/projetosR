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

simple <- read_html("https://dataquestio.github.io/web-scraping-pages/simple.html")
simple

simple %>%
  html_nodes("p") %>%
  html_text()

simple1 <- read_html("https://www.python.org/");
#res = BeautifulSoup(html.read(),"html5lib");
simple1 %>%
  html_nodes("title")

fii1 <- read_html("https://fiis.com.br/xplg11/");

#test <- html_attr(fii1,".table")
test <- html_element(fii1,".table")
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