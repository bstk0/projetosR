#Versao Exemplo - 1.0
# Nova versao - edição direta no github
# Alteração no Linux
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

# functions - No SCRIPT (1.1) VER LINHAS 640 ... 643 ... 661 
# maps      - No SCRIPT (1.1) VER linhas 709 ...
# ~ summary (linha 719)
# map_dbl - 736, 740 .. 744
# map2 - dois inputs ( # rnorm - tem 3 parametros )
# pmap - n vetores ...( rnorm - tem 3 parametros )

tamanho_var <- list(7,9,11)
# linha 761 - ...
# linha 780 - ele colocou o nome do argumento esperado para não se preocupar com a sequencia

# 786 - passando o nome da função como variável string - rnorm e rpois na invoke_map 
# rnorm e rpois - nros aleatórios

