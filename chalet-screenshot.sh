#!/bin/bash

# chalet-screenshot - É um script que captura a tela usando imagemagick.
# Versão 1: Faz um print screen da tela inteira.
# Versão 2: Salva o print screen em um diretório específico.
# Versão 3: Recorta a imagem.
#
#
#
# Autor - Marcos Chalet
#

CORTAR=0

DIR_SALVAR=~/Imagens/capturas
NOME_PRINT=screenshot
EXTENCAO=png
INDICE=-1
LOCAL_CORTE=

AJUDA="
Uso: $(basename "$0") [OPÇÕES]

OPCÕES:
    -c, --cut MxN+B+H       Recorta recorta a área do print.
    -d, --dir ~/novo_dir    Especifica um diretório.
    -h, --help              Mostra esta tela de ajuda.
"

# Trantando as opções passadas na chamada do programa.
while test -n "$1"
do
    case "$1" in

        -c | --cut)
            shift
            CORTAR=1
            LOCAL_CORTE="$1"
        ;;

        -d | --dir)
            shift
            DIR_SALVAR="$1"
        ;;

        -h | --help)
            echo "$AJUDA"
            exit 0
        ;;

        *)
            echo "Entrada inválida: $1"
            echo "Ececute \"$(basename $0) -h\" para obter ajuda."
            exit 1
        ;;
    esac

    # Movendo a fila de comandos passados até ($n)
    shift
done

##### PEGANDO O ÍNDICE DO ULTIMO PRINT TIRADO #####

# Seleciona prints tirados
INDICE=$(ls -v -r "$DIR_SALVAR" | grep screenshot)

# Pego apenas os índices de todos os prints já tirados.
INDICE=$(echo "$INDICE" | grep -o '[0-9]*' | sed -z 's/\n/, /g')

# Pega o maior índice.
INDICE=$(echo "$INDICE" | cut -d , -f -1)

# Incrementa para unificar o nome e não substituir a imagem
INDICE=$((INDICE+1))

###################################################


# Tira o print-screen no local indicado.
import -window root "$DIR_SALVAR"/"$NOME_PRINT"_"$INDICE"."$EXTENCAO"

# Corta a imagem.
test "$CORTAR" = 1 && magick -extract "$LOCAL_CORTE"\
                                      "$DIR_SALVAR"/"$NOME_PRINT"_"$INDICE"."$EXTENCAO"\
                                      "$DIR_SALVAR"/"$NOME_PRINT"_"$INDICE"."$EXTENCAO"

