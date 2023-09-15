# 30.08.23
# - Meus FIIs por Setor ...

# Utilizando dados do TCC ...
pacotes <- c("seleniumPipes","RSelenium","rvest","openxlsx","XML",
             "dplyr","kableExtra","scales","lessR","tidyverse")
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

specify_decimal <- function(x, k) {
  trimws(format(round(x, k), nsmall=k))
}
#----
tccPath = "C://BISTERCO//MBA//TCC//"
# filename <- paste0("R-out_", format(Sys.Date(), "%d-%m-%Y"), ".html")
#filename <- "C://BISTERCO//MBA//TCC//R-out_30-08-2023.html"
filename <- paste(tccPath,"R-out_12-09-2023.html", sep = "")


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
csvPath <- 'CARTEIRA-2023-09-15.csv'
#dfSetorDeParaA <- read.df(csvPath, "csv", header = "true", inferSchema = "true", na.strings = "NA")
dfCarteira <- read.csv(csvPath)

# agregar por ação ... nao deu certo
# Group by count using R Base aggregate()
# agg_ACAO <- aggregate(dfCarteira$ACAO, dfCarteira$QTDE, dfCarteira$TOTAL.OP,
#                       by=list(dfCarteira$ACAO), FUN=length)

# agg_ACAO <- aggregate(dfCarteira$ACAO,
#                      by=list(dfCarteira$ACAO, dfCarteira$QTDE, dfCarteira$TOTAL.OP), FUN=length)

summary(dfCarteira)

rm(dfCarteira1)

dfCarteira1 <- select(dfCarteira, 'ACAO','QTDE','TOTAL_OP' ) 

dfCarteira1[dfCarteira1$ACAO == "HABT11",]
dfCarteira1[dfCarteira1$ACAO == "VSLH11",]

dfCarteira1$TOTAL_OP <- virgulaToValor(dfCarteira1$TOTAL_OP)

summary(dfCarteira1)

# library(dplyr)

dfCarteira2 <- dfCarteira1 %>% 
  group_by(ACAO) %>% 
  summarise(across(c(QTDE, TOTAL_OP), sum))


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

totalGeral <- sum(dfCarteira2$TOTAL_OP)
totalGeral

# Percentual das ações por valor
dfCarteira2 <- dfCarteira2 %>%
  mutate(percent = (TOTAL_OP/totalGeral)*100)

sum(dfCarteira2$percent)
dfCarteira2

#options(scipen=100, digits = 3)
options(digits = 3)

legenda <- paste(dfCarteira2$ACAO, specify_decimal(dfCarteira2$percent,2))
legenda
# nao ficou legal ...
pie( x = dfCarteira2$percent,
     labels = legenda,
     main = "CARTEIRA",
     lty = 2)

# Donut chart por Setor
# library(lessR)
PieChart(ACAO, y=percent, data = dfCarteira2,
         values_digits=2,
         main = NULL)

dfAcaoSetor <- select(tbls_datafe, 'Fundos', 'Setor')

dfCarteiraBKP <- dfCarteira2

tbls_datafe <- tbls_datafe[!is.na(tbls_datafe$Setor),]
tbls_datafe <- tbls_datafe[!is.na(tbls_datafe$Fundos),]

dfCarteira2 <- dfCarteira2[!is.na(dfCarteira2$ACAO),]

#dfCarteira2$Setor[match(tbls_datafe$Fundos,
#                        dfCarteira2$ACAO)] <- tbls_datafe$Setor

#tbls_datafe
# quase 
#dfCarteira2$Setor <- tbls_datafe[tbls_datafe$Fundos %in% dfCarteira2$ACAO,'Setor']

#dfCarteira2$Setor2 <- dfAcaoSetor[tbls_datafe$Fundos %in% dfCarteira2$ACAO,2]

#dfCarteira2 <- dfCarteiraBKP

dfCarteira2 <- dfCarteira2 %>%
  mutate(dfAcaoSetor[tbls_datafe$Fundos %in% dfCarteira2$ACAO,2])

View(dfCarteira2)
## Ajusta indefinidos - INICIO -----

# TestIndefinidos.R

# Carregar DE-PARA
csvPath <- paste(tccPath,'FII-SETOR-DE_PARA.csv', sep="")
dfSetorDePara <- read.csv(csvPath)

dfCarteira2 <- dfCarteira2 %>%
  left_join(., dfSetorDePara, by=c('ACAO'='Fundos')) %>%
  mutate(Setor = ifelse(!is.na(SetorNew), SetorNew, Setor)) %>%
  select(-SetorNew)

## Ajusta indefinidos - FIM -----

# dfCarteira2 ficou como base ...
View(dfCarteira2)

dfCarteiraSetor <- dfCarteira2 %>% 
  group_by(Setor) %>% 
  summarise(across(c(QTDE, TOTAL_OP), sum)) %>%
  mutate(percent = (TOTAL_OP/totalGeral)*100)

sum(dfCarteiraSetor$percent)
sum(dfCarteiraSetor$TOTAL_OP)

# funcionou - grafico pizza por setor 
PieChart(x = Setor, y=percent, data = dfCarteiraSetor,
         values_digits=2,
         main = NULL)

## VALOR PAGO X VALOR ATUAL - INICIO -----
head(tbls_datafe)
dfAcaoValor <- select(tbls_datafe, 'Fundos', `Preço Atual (R$)`)
View(dfAcaoValor)
#dfAcaoValor <- dfAcaoValor[!is.na(dfAcaoValor$`Preço Atual (R$)`),]

# remove NAs
dfAcaoValor <- dfAcaoValor[dfAcaoValor$`Preço Atual (R$)` != "N/A",]

# mudar virgula-ponto ...
dfAcaoValor$precoAtual <- virgulaToValor(dfAcaoValor$`Preço Atual (R$)`)


# op. 1  ---------------------------
#dfCarteira2 <- dfCarteira2 %>%
#  left_join(., dfSetorDePara, by=c('ACAO'='Fundos')) %>%
#  mutate(Setor = ifelse(!is.na(SetorNew), SetorNew, Setor)) %>%
#  select(-SetorNew)

# op. 2  ---------------------------
dfCarteira2 <- dfCarteira2 %>%
  mutate(dfAcaoValor[dfAcaoValor$Fundos %in% dfCarteira2$ACAO,3])

#dfCarteira2 <- dfCarteira2 %>%
#  mudate(precoAtual = dfAcaoValor$precoAtual)
#  mutate(totalAtual = dfAcaoValor$precoAtual * dfCarteira2$)

dfCarteira2$totalAtual <- dfCarteira2$precoAtual * dfCarteira2$QTDE

sum(dfCarteira2$TOTAL.OP)
sum(dfCarteira2$totalAtual)

dif <- sum(dfCarteira2$totalAtual) - sum(dfCarteira2$TOTAL.OP)

percDesv <- 100-(sum(dfCarteira2$totalAtual) * 100)/sum(dfCarteira2$TOTAL.OP)
percDesv

proventos <- 11800 # REAL 10294.36

difProv <- sum(dfCarteira2$totalAtual) - sum(dfCarteira2$TOTAL.OP) + proventos
difProv

atualProv <- sum(dfCarteira2$totalAtual) + proventos

valor <- c(sum(dfCarteira2$TOTAL_OP),sum(dfCarteira2$totalAtual),atualProv)
legen <- c("1.Total Op.","2.Total Atual","3.Total Atual + Dividentos")

dfGraph <- data.frame(legen, valor)

# grafico
# library("tidyverse")
ggplot(data=dfGraph, aes(x=legen, y=valor)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_hline(data = dfGraph %>% filter(legen == "1.Total Op."), aes(yintercept = valor)) +
  geom_text(aes(label=valor), vjust=1.6, color="white", size=3.5)+
  xlab("Totais") +
  ylab("Valores") +
  ggtitle("Total Investido x Total Atual x Total Atual + Dividendos") +
  theme_minimal()

# grafico 2
h <- dfGraph$valor[1]
# H <- c(30, 35, 7, 12)
# M <- paste("Issue", seq_along(H))
H2 <- rbind(pmin(valor, h), pmax(valor-h, 0))
barplot(H2, names.arg=legen, xlab="Totais", ylab="Valores", col=gray(c(.7, .8)),
        main="Total Movimentado",  border=NA) # las=2,
bp <- barplot(valor, col=NA, yaxt='n', las=1, cex.names = 1.5, add=T)
text(x=bp, y=valor, labels=round(valor,0), pos=3, xpd=NA)
abline(h=h, col="red", lty=2)

dfCarteiraBKP <- dfCarteira2
dfCarteira2$valorizacao <- ((dfCarteira2$totalAtual*100)/dfCarteira2$TOTAL.OP)-100;

write.csv(dfCarteira2, "dfCarteira2.csv", row.names=TRUE)

## VALOR PAGO X VALOR ATUAL - FIM -----
