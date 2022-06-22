#get data
# from : https://stackoverflow.com/questions/46069322/r-api-call-for-json-data-and-converting-to-dataframe

# req <- 
#   httr::POST("https://api2.elasticgrid.com/api/v1/analytics/vendor/partnerengagement/advanced/all",
#              httr::add_headers(
#                "Authorization" = "Bearer <long string>"
#              ),
#              body = "VendorId=80&TimeFrame=AddMonths(-3)&Language=en-US",encode="json"
#   );

req <- 
  httr::GET("https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_movin",
             httr::add_headers(
               "Authorization" = "Bearer ax0zd8ura0er8934helfahf390uy43wa..."
             ));

#Convert to char
char <- rawToChar(req$content)

#Convert to df 
df <- jsonlite::fromJSON(char)

#df.id[1]._stock_movin_stock[1].stock_movin_valor;

# JA FEITO NO PROJETOR - APIGetAVGDASH.R (Ubuntu e GitHub

#aggregate(df$valor, by=list(Stock=df$stock_id), FUN=sum)

library(dplyr)
df %>% 
  group_by(stock_id) %>% 
  summarise(Valor = sum(valor))


## IMPORTANTE
df <- transform(df, soma= qtde * valor);


#Trazendo a Sigla
res <- 
  httr::GET("https://x8ki-letl-twmt.n7.xano.io/api:c3d5C6VM/stock_ob_name",
            httr::add_headers(
              "Authorization" = "Bearer ax0zd8ura0er8934helfahf390uy43wa..."
            ));

data = jsonlite::fromJSON(rawToChar(res$content));
names(data)


#renomear coluna para stock_id
names(data)[names(data) == "id"] <- "stock_id"


#JUNTAR SIGLA
#left Joing
dffull <- merge(x = df, y = data, by = "stock_id", all.y = TRUE)


# library(ggplot2)
# ggplot(dffull, aes(x="", y=soma, fill=sigla)) +geom_bar(width = 1, stat = "identity") +
#   coord_polar("y", start=0) +theme_void()


#COM PERCENTUAL
# install.packages("dplyr")
# install.packages("scales")
#library(dplyr)

df_sum <- dffull[,c("sigla","soma")]

sum_total <- sum(df_sum$soma)

# Data transformation - esta fazendo por count
# dfp <- df_sum %>% 
#   group_by(sigla) %>% # Variable to be transformed
#   count() %>% 
#   ungroup() %>% 
#   mutate(perc = `n` / sum(`n`)) %>% 
#   arrange(perc) %>%
#   mutate(labels = scales::percent(perc))

dfa <- aggregate(df_sum$soma, by=list(df_sum$sigla), FUN=sum)

dfa <- transform(dfa, perc= x * 100/sum_total);
#dfa <- transform(dfa, labels= scales::percent(perc));

#Renomeia para fazer usar no grafico
names(dfa)[names(dfa) == "Group.1"] <- "sigla"

#1
# ggplot(dfp, aes(x = "", y = perc, fill = sigla)) +
#   geom_col() +
#   geom_text(aes(label = labels),
#             position = position_stack(vjust = 0.5)) +
#   coord_polar(theta = "y")

#2
# ggplot(dfa, aes(x = "", y = perc, fill = sigla)) +
#   geom_col() +
#   geom_label(aes(label = labels),
#              position = position_stack(vjust = 0.5),
#              show.legend = FALSE) +
#   coord_polar(theta = "y")

#3 - MELHOR
# Donut chart
library(lessR)
PieChart(sigla, y=perc, data = dfa,
         values_digits=2,
            main = NULL)

#4 - validando
#> sum(df_sum$soma)
#[1] 40684.74

#aggregate(df_sum$soma, by=list(df_sum$sigla), FUN=sum)

#sum( df_sum[which(df_sum$sigla == 'DEVA11'), 2])

# https://www.4devs.com.br/calculadora_regra_tres_simples

