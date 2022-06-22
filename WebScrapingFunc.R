##################################################################################
#                  INSTALAÇÃO E CARREGAMENTO DE PACOTES NECESSÁRIOS             #
##################################################################################
#Pacotes utilizados
pacotes <- c("rvest","tidyverse")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

# Se já instalou para análises anteriores, basta carregar o pacote

library("tidyverse")
library(rvest)

## -- FUNCTION 1
getFIIData <- function(str,vec) {
  print(length(str))
  print(nchar(str))
  len <- nchar(str)
  
  url <- paste("https://fiis.com.br/", str,"/", sep="")
  print(url)
  vec[1] <- url;
  
  fii1 <- read_html(url)
  
  fiiBody <- html_node(fii1, "body")
  tables <- html_nodes(fiiBody, 'table')
  table2 <- tables[2]
  
  print(str)
  vec[2] <- str;
  
  ult_dt_pagto <- html_nodes(table2, 'tbody td')[2]
  ult_dt_pagto_real <- html_text(ult_dt_pagto)
  print(ult_dt_pagto_real)
  vec[3] <- ult_dt_pagto_real
  
  ult_vl_pagto <- html_nodes(table2, 'tbody td')[5]
  ult_vl_pagto_real <- html_text(ult_vl_pagto)
  print(ult_vl_pagto_real)
  vec[4] <- ult_vl_pagto_real
  
  return(vec)
  
  # IDEIA - Colocar os dados em um dataframe
  # df <- c()
}

# FUNCIONOU !!!
#getFIIData('BCFF11')
#getFIIData('BRCO11')
#getFIIData('BTLG11')

# TESTE IN LOOPING - VECTOR - FUNCIONOU TBM !!
# siglas <- c("BTLG11","CPTS11","CVBI11","DEVA11","HCTR11","MCCI11","RECR11","TORD11","VSLH11","XPML11")
# siglas <- c("BTLG11","XPML11")

# ------
# >> 1. EXEC - Rodar a APIGetStockSigla ...
# ------
siglas <-data$sigla

# Apos rodar a APIGetStockSigla ... se algumas nao tiverem dados do mes pretendido ...
# 08.02 - RESTARAM APENAS AS ABAIXO:
#siglas <- c("BTLG11", "CPTS11", "CVBI11", "MCCI11", "VGIP11", "XPML11")

mylist <- list() #create an empty list
x <- 0
for(sigla in siglas) {
  x <- x+1
  vec <- numeric(4) #preallocate a numeric vector
  mylist[[x]] <- getFIIData(sigla, vec)
  #mylist[[x]] <- vec #put all vectors in the list
}

colnames(df) <- c("URL","SIGLA","DTPAGTO","VALOR")
df <- do.call("rbind",mylist) #combine all vectors into a matrix
write.csv(df,"FIIs.csv", row.names = FALSE)

# NEXT STEP : AGORA SERIA JUNTA API COM ESSE LOOPING
#
# TESTE OK : print(data$sigla[10])
# Apos rodar a APIGetStockSigla ...


