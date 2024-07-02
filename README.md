# Trabalho do grupo 2 da disciplina Compiladores

## Integrantes:

- Bruno Helder Rodrigues Guedes - 15/0120338
- Gabriel Mendes Ciriatico Guimarães - 20/2033202
-

## Instruções de uso:

### Utilização do Flex:

É necessário instalar o programa Flex para gerar o arquivo .c correspondente. Ele pode ser instalado utilizando o comando:

```
sudo apt install flex
```

Após a instalação, basta navegar até a pasta src:

```
cd src
```

e executar:

```
lex lexico.l
```

### Compilação do arquivo .c:

O arquivo *lex.yy.c* gerado no passo anterior pode ser compilado utilizando o GCC com a flag adequada, como demonstrado no comando a seguir:

```
gcc -lfl lex.yy.c
```

### Execução:

Para executar o programa compilado no passo anterior, basta digitar o caminho do executável seguido do nome do arquivo a ser utilizado. Por exemplo:

```
./a.out teste.txt
```

###### Observação: ainda é necessário estar na pasta /src/ para executar o programa.