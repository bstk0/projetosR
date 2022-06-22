##################################################################################
#                  INSTALAÇÃO E CARREGAMENTO DE PACOTES NECESSÁRIOS             #
##################################################################################
#Pacotes utilizados
pacotes <- c("curl","httr","jsonlite","lubridate","dplyr")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}


library(httr)
library(jsonlite)

#url <- 'https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_div_avg'
#url <- 'https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_movim_media'

convertToDF <- function(resp) {
  
  jdata_text <- content(resp, "text")
  get_jdata <- fromJSON(jdata_text, flatten = TRUE)
  get_jdata_df <- as.data.frame(get_jdata)
  
  return(get_jdata_df) 
}

getQtdeTotalAcoes <- function(df, p_id, p_ano, p_mes) {
  test <- filter(df, stock_id == p_id & (ano < p_ano |(ano == p_ano & mes <= p_mes )))
  #filter(df_sum, stock_id == 49 & (ano < 2022 |(ano == 2022 & mes <= 1 ))) %>%
  return(sum(test$qtdeTotal));
}

getValorDiv <- function(df, p_id, p_anomes) {
  test <- filter(df_div, ano_mes == p_anomes & stock_id == p_id )
  return(test$valor)
}

validaNullNUmber <- function(val) {
  val <- ifelse(is.na(val) | is.null(val), as.numeric(0), as.numeric(val))
  val <- ifelse(length(val) == 0, 0, val)  
  return(val)
}

#---
# SIGLAS
jsiglas <- GET('https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_ob_name')
df_siglas <- convertToDF(jsiglas)


#---
# MOVIMENTO
jmovin <- GET('https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_movin')
df_movin <- convertToDF(jmovin)

# Somatoria por mes

#crio uma coluna mes_ano
library(lubridate)
ano <- year(df_movin$data)
#View(ano)
df_movin <- transform(df_movin, ano= year(df_movin$data));
df_movin <- transform(df_movin, mes= month(df_movin$data));

#aggregate(x$Frequency, by=list(Category=x$Category), FUN=sum)
# multiple grouping columns

#df_sum <- df_movin

library(dplyr)
df_sum <- df_movin %>% 
  group_by(ano, mes, stock_id) %>% 
  summarise(qtdeTotal = sum(qtde))

#validando ...
#starwars %>% filter(mass > mean(mass, na.rm = TRUE))
#filter(starwars, hair_color == "none" & eye_color == "black")

filter(df_sum, ano == 2022 & mes == 1 )

#sum(df_sum$qtdeTotal) %>%
#%df_sum %>%
#test <- filter(df_sum, stock_id == 49 & (ano < 2022 |(ano == 2022 & mes <= 1 )))
#filter(df_sum, stock_id == 49 & (ano < 2022 |(ano == 2022 & mes <= 1 ))) %>%
#sum(test$qtdeTotal)

#TESTES
#test1 <- getQtdeTotalAcoes(df_sum, p_id = 49,p_ano = 2022, p_mes = 1)
#test1 <- getQtdeTotalAcoes(df_sum, p_id = 2,p_ano = 2021, p_mes = 8)

##---
# DIVIDENDOS
jdata <-
  GET('https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_divid')

df_div <- convertToDF(jdata)

#test <- filter(df_div, ano_mes == '202201' & stock_id == 49 )
#test2 <- getValorDiv(df_div, p_id = 2, p_anomes = '202110')

##---

#montando saida TESTE ....

#totalAcoes <- getQtdeTotalAcoes(df_sum, p_id = 45,p_ano = 2022, p_mes = 5)
#valorDiv <- getValorDiv(df_div, p_id = 45, p_anomes = '202205')
#total1 <- totalAcoes * valorDiv  

#---
# SAIDA FINAL POR MES

#tab = data.frame(x = 1:3, y=2:4, z=3:5)
#for (A in rows(tab)) {
#  print(A$x + A$y * A$z)
#} 

#---
# SAIDA FINAL
  
mylist <- list()
for (i in 1:dim(df_siglas)[1]) {
 vec <- numeric(4)
 print(df_siglas$sigla[i])
 print(df_siglas$id[i])
 t2 <- getQtdeTotalAcoes(df_sum, p_id = df_siglas$id[i],p_ano = 2022, p_mes = 6) #QTDE
 t3 <- getValorDiv(df_div, p_id = df_siglas$id[i], p_anomes = '202206')          #DIV
 #t2 <- ifelse(is.null(t2), 0, t2)
 t2 <- validaNullNUmber(t2)
 t3 <- validaNullNUmber(t3)
 tot <- t2 * t3
 vec[1] <- df_siglas$sigla[i]
 vec[2] <- t2
 vec[3] <- t3
 vec[4] <- as.numeric(tot)
 mylist[[i]] <- vec
}

df_list <- do.call(rbind.data.frame, mylist)
#df_list <- data.frame(matrix(unlist(mylist), nrow=length(mylist), byrow=TRUE))
colnames(df_list) <- c("SIGLA","QTDE","VALOR","TOTAL")
#as.numeric(df_list$TOTAL)
sum(as.numeric(df_list$TOTAL))

#TESTE
is.null(df_list$VALOR[5])
is.na(df_list$VALOR[5])



#View(get_jdata_df)

# # # TESTE - Dividendo BARI11
# # get_jdata_df[["sigla"]][[1]]
# # #ultimo dividendo
# # get_jdata_df[[6]][[1]][["valor"]]
# # #qtde de acoes
# # get_jdata_df[[7]][[1]][["stock_movin_qtde"]]
# # #valor medio
# # get_jdata_df[[8]][[1]][["stock_movin_valor"]]
# 
# # GERANDO DATA FRAME
# # nrow(get_jdata_df)
# cols = 4
# rows <- nrow(get_jdata_df)
# 
# out_matrix <- matrix(ncol = cols, nrow = rows)
# 
# for (i in 1:nrow(get_jdata_df)) {
#   out_matrix[i, 1] <- get_jdata_df[["sigla"]][[i]]
#   out_matrix[i, 2] <- get_jdata_df[[6]][[i]][["stock_divid_valor"]]
#   out_matrix[i, 3] <- get_jdata_df[[7]][[i]][["stock_movin_valor"]]
#   out_matrix[i, 4] <-
#     ((get_jdata_df[[6]][[i]][["stock_divid_valor"]] * 100) / get_jdata_df[[7]][[i]][["stock_movin_valor"]])
# }
# 
# out_matrix
# out_df <- data.frame(out_matrix)
# 
# # CABEÇALHO
# novos_nomes <- c("SIGLA",
#                  "VL_MED_DIVID",
#                  "VL_MEDIO_ACAO",
#                  "%")
# 
# names(out_df) <- novos_nomes
# View(out_df)

# Obtem diretorio aberto - para verificar formato.
# directory <- getwd()
# directory

# EXPORT TO CSV
# write.csv(out_df, '/home/rodrigo/Documents/Dash_AVG_DIV.csv', row.names = FALSE)

# CALCULO NO APPGYVER
# FORMAT_LOCALIZED_DECIMAL(
#  (( repeated.current._stock_last_divid[0].valor * 100)/
#     repeated.current._stock_movin_of_stock[0].stock_movin_valor)
#  , "fi-FI", 3)
