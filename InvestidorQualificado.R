# Investidor Qualificado

# Carregar DE-PARA
# C:\BISTERCO\MBA\projetos1R
pPath = "C://BISTERCO//MBA//projetos1R//"
csvPath <- 'investidor_qualificado.csv'
# dfIQ <- read.df(csvPath, "csv", header = "true", inferSchema = "true", na.strings = "NA")
# dfSetorDePara <- read.csv(csvPath)
# rm(dfSetorDePara)
filename <- paste(pPath,csvPath, sep = "")
xIQ <- read.table(filename, sep="\t", header=TRUE)

is.data.frame(xIQ)

# Fundos do data_frame principal que são IQ
dfFIQ <- tbls_datafe[tbls_datafe$Fundos %in% xIQ$Ticker,]
count(dfFIQ)
# 54
View(dfFIQ)
# ---
# retirando os NAs ... existentes
xIQ1 <- xIQ[xIQ$Público.Alvo != 'N/A',]
# 59
dfFIQ1 <- tbls_datafe[tbls_datafe$Fundos %in% xIQ1$Ticker,]
count(dfFIQ1)
# 44
View(dfFIQ1)
# ---
# removendo do dataframe principal
tbls_datafe <- tbls_datafe[!(tbls_datafe$Fundos %in% xIQ1$Ticker),]
# de 408 para 364 ... 
