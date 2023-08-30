# 30.08.23
# - Meus FIIs por Setor ...

# Utilizando dados do TCC ...
pacotes <- c("seleniumPipes","RSelenium","rvest","openxlsx","XML",
             "dplyr","kableExtra")
#pacotes <- c("rvest","tidyverse""writexl")


if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

# ---
virgulaToValor <- function(str) {
  novoValor <- gsub("[.]","",str)
  novoValor <- gsub("[,]",".",novoValor)
  novoValor <- as.numeric(novoValor)
  return(novoValor)
}

#----
# filename <- paste0("R-out_", format(Sys.Date(), "%d-%m-%Y"), ".html")
filename <- "C://BISTERCO//MBA//TCC//R-out_30-08-2023.html"
#filename <- "C:/BISTERCO/MBA/TCC/R-out_30-08-2023.html"
#filename <- "file:///C:/BISTERCO/MBA/TCC/R-out_30-08-2023.html"
#filename <- "C:\BISTERCO\MBA\TCC\R-out_30-08-2023.html"


fiife <- read_html(filename,encoding = "UTF-8")
tblsfe <- html_nodes(fiife, "table")
tblsfe[1]

tbls_lsfe <- fiife %>%
  html_nodes("table") %>%
  .[1] %>%
  html_table(fill = TRUE)

head(tbls_lsfe[[1]], 4)

str(tbls_lsfe)
head(tbls_lsfe[[1]], 4)

# verifica se é um dataframe
is.data.frame(tbls_lsfe[[1]])

# ajusta dataframe inicial (CORE)
tbls_datafe <- tbls_lsfe[[1]]

is.data.frame(tbls_datafe)

head(tbls_datafe, 4)

# LENDO MINHA CARTEIRA -------
# 
csvPath <- 'CARTEIRA-2023-08-30.csv'
#dfSetorDeParaA <- read.df(csvPath, "csv", header = "true", inferSchema = "true", na.strings = "NA")
dfCarteira <- read.csv(csvPath)

# agregar por ação ...
# Group by count using R Base aggregate()
agg_ACAO <- aggregate(dfCarteira$ACAO, dfCarteira$QTDE, dfCarteira$TOTAL.OP,
                      by=list(dfCarteira$ACAO), FUN=length)

agg_ACAO <- aggregate(dfCarteira$ACAO,
                      by=list(dfCarteira$ACAO, dfCarteira$QTDE, dfCarteira$TOTAL.OP), FUN=length)

#summarise(dfCarteira)

dfCarteira1[dfCarteira1$ACAO == "HABT11",]
dfCarteira1[dfCarteira1$ACAO == "VSLH11",]

dfCarteira1 <- select(dfCarteira, 'ACAO','QTDE','TOTAL.OP' ) 

dfCarteira1$TOTAL.OP <- virgulaToValor(dfCarteira1$TOTAL.OP)


library(dplyr)

dfCarteira2 <- dfCarteira1 %>% 
  group_by(ACAO) %>% 
  summarise(across(c(QTDE, TOTAL.OP), sum))


dfCarteira2[dfCarteira2$ACAO == "VSLH11",]

# sum(dfCarteira1$TOTAL.OP[dfCarteira1$ACAO == "HABT11",])

# Valor Atual da VSLH11
View(tbls_datafe[tbls_datafe$Fundos == "VSLH11",])
# 3.58 * 112 = 400,96

tbls_backup <- tbls_datafe

# preço atual da VSLH11
tbls_datafe %>% 
  filter(Fundos == "VSLH11") %>% 
  select_at(vars(`Preço Atual (R$)`))

totalGeral <- sum(dfCarteira2$TOTAL.OP)
totalGeral

# Percentual das ações por valor
dfCarteira2 <- dfCarteira2 %>%
  mutate(percent = (TOTAL.OP/totalGeral)*100)

sum(dfCarteira2$percent)

