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

# 26.01 - INICIO - capturando dividendos ...

fii1 <- read_html("https://fiis.com.br/xpml11/");

fiiBody <- html_node(fii1, "body")
divs <- html_nodes(fiiBody, 'div')
#table2 <- tables[2]

divs1 <- html_nodes(divs, 'div.table__linha')

divs1[]

divs2 <- html_text(divs1)

divs2[1:5]
divs2[6:10]

# 26.01 - INICIO - capturando dividendos ...
# 26.01 - pegando valorização 12 meses - inicio
spans <- html_nodes(fiiBody, 'span')

spans[39]
spans[[39]]
#spans1 <- html_nodes(spans, 'span.variation up')
spans1 <- spans %>% 
  html_nodes(xpath = "//span[@class='variation up']") %>% 
  html_text()

spans1[[1]]
#html_text(spans1[[1]])
# 26.01 - pegando valorização 12 meses - fim


tbls_ls <- divs1 %>%
  html_nodes("div") %>%
  .[1] %>%
  html_table(fill = TRUE)

str(divs1)
head(divs1[[1]])


#test <- html_attr(fii1,".table")
test <- html_element(fii1,".table")
#test
test1 <- html_element(fii1,".yieldChart__table__body")
test2 <- html_element(test1,".yieldChart__table__bloco")
test3 <- html_element(test2,".table__linha")


tbls_ls <- test3 %>%
  html_nodes("table") %>%
  .[1] %>%
  html_table(fill = TRUE)

tbls_ls <- test2 %>% 
  read_html() %>% 
  html_nodes("div.table__linha") %>% 
  html_text()

tbls_ls <- test2 %>% 
  html_nodes(xpath = "//div[@class='table__linha']") %>% 
  html_table()

tbls_ls <- teste2 %>% 
  html_nodes(xpath = "//div[@class='table__linha']") %>%
  html_table(fill = TRUE)

tbls_ls <- teste2 %>% 
  read_html() %>% 
  html_nodes(xpath = "//div[@class='table__linha']") %>% 
  html_text()


fii1[[1]]

str(tbls_ls[[]])
head(tbls_ls[[1]])
tbls_ls[[1]]
head(tbls_ls[[1]], 4)
test3 <- html_element(test2,".table__linha")

test2 <- xml_nodes(".table__linha")
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