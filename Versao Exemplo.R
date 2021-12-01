#Versao Exemplo - 1.0
# Nova versao - edição direta no github
#Funcoes que estao no script (1.1)

## -- FUNCTION 1
atualizar <- function(historico) {
  atual <- ((historico + 17)/2)
  return(atual)
}


atualizar(1)
atualizar(2)
atualizar(3)
atualizar(4)

#vetor como parametro
atualizar_hoje <- c(1:15)
atualizar(atualizar_hoje)

## -- FUNCTION 2
ajustar <- function(valor1, valor2) {
  ajuste <- ((valor1 + 180)/(valor2 - 60))
  return(ajuste)
}

ajustar(100,80)
ajustar(200,80)
ajustar(200,100)

## -- if, else if e else

valor <- 1000000000

if (valor >= 1000000) {
  "numero grande"
} else {
  "numero pequeno"
}

# if - 2
valor <- 650000

if (valor >= 1000000) {
  "numero grande"
} else if (valor >= 500000 & valor < 1000000) {
  "numero intermediario"
} else {
  "numero pequeno"
}

# NO SCRIPT (1.1) VER LINHAS 640 ... 643 ... 661 
