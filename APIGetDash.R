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

jdata <-
  GET('https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_movin_media')

jdata
#View(jdata)
jdata_text <- content(jdata, "text")

get_jdata <- fromJSON(jdata_text, flatten = TRUE)
get_jdata_df <- as.data.frame(get_jdata)

View(get_jdata_df)

# # TESTE - Dividendo BARI11
# get_jdata_df[["sigla"]][[1]]
# #ultimo dividendo
# get_jdata_df[[6]][[1]][["valor"]]
# #qtde de acoes
# get_jdata_df[[7]][[1]][["stock_movin_qtde"]]
# #valor medio
# get_jdata_df[[8]][[1]][["stock_movin_valor"]]

# GERANDO DATA FRAME
# nrow(get_jdata_df)
cols = 6
rows <- nrow(get_jdata_df)

out_matrix <- matrix(ncol = cols, nrow = rows)

for (i in 1:nrow(get_jdata_df)) {
  out_matrix[i, 1] <- get_jdata_df[["sigla"]][[i]]
  out_matrix[i, 2] <- get_jdata_df[[6]][[i]][["valor"]]
  out_matrix[i, 3] <- get_jdata_df[[7]][[i]][["stock_movin_qtde"]]
  out_matrix[i, 4] <-
    (get_jdata_df[[6]][[i]][["valor"]] * get_jdata_df[[7]][[i]][["stock_movin_qtde"]])
  out_matrix[i, 5] <- get_jdata_df[[8]][[i]][["stock_movin_valor"]]
  out_matrix[i, 6] <-
    ((get_jdata_df[[6]][[i]][["valor"]] * 100) / get_jdata_df[[8]][[i]][["stock_movin_valor"]])
}

out_matrix
out_df <- data.frame(out_matrix)

novos_nomes <- c("SIGLA",
                 "ULT_DIVID",
                 "QTDE",
                 "VL_TOT_DIV",
                 "VL_MEDIO_ACAO",
                 "%")

names(out_df) <- novos_nomes

View(out_df)

# Obtem diretorio aberto - para verificar formato.
# directory <- getwd()
# directory

# EXPORT TO CSV
write.csv(out_df, '/home/rodrigo/Documents/Dash.csv', row.names = FALSE)

# CALCULO NO APPGYVER
# FORMAT_LOCALIZED_DECIMAL(
#  (( repeated.current._stock_last_divid[0].valor * 100)/
#     repeated.current._stock_movin_of_stock[0].stock_movin_valor)
#  , "fi-FI", 3)
