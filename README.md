# Trabalho do grupo 2 da disciplina Compiladores

## Integrantes:

- Bruno Helder Rodrigues Guedes - 15/0120338
- Gabriel Mendes Ciriatico Guimarães - 20/2033202
- Luís Henrique Araújo Martis - 22/1002058

## Instruções de uso:

### Utilização do Flex e Bison:

É necessário instalar os programas Flex e Bison para gerar compilar os arquivos correspondentes. Eles podem ser instalados utilizando os comandos:

```
sudo apt install bison
sudo apt install flex
```

Após a instalação, devemos compilar os arquivos _sintatico.y_ e _lexico.l_. Basta navegar até a pasta src

```
cd src
```

e executar:

```
bison -d sintatico.y
lex lexico.l
```

ou utilizar o makefile para executar esses comandos, com:

```
make
```

### Compilação:

Os arquivos gerados no passo anterior podem ser compilados utilizando o GCC, como demonstrado no comando a seguir:

```
gcc -o parser sintatico.tab.c lex.yy.c -lfl
```

### Execução:

Para executar o programa compilado no passo anterior, basta digitar o caminho do executável seguido do nome do arquivo a ser utilizado. Por exemplo:

```
./a.out teste.txt
```

###### Observação: ainda é necessário estar na pasta /src/ para executar o programa.
