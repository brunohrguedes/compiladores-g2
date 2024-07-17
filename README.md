# Trabalho do grupo 2 da disciplina Compiladores

## Integrantes:

- Bruno Helder Rodrigues Guedes - 15/0120338
- Gabriel Mendes Ciriatico Guimarães - 20/2033202
- Luís Henrique Araújo Martis - 22/1002058

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
bison -d sintatico.y
```

### Compilação do arquivo .c:

O arquivo _lex.yy.c_ gerado no passo anterior pode ser compilado utilizando o GCC com a flag adequada, como demonstrado no comando a seguir:

```
gcc -lfl lex.yy.c sintatico.tab.c
```

### Execução:

Para executar o programa compilado no passo anterior, basta digitar o caminho do executável a ser utilizado. Por exemplo:

```
./a.out
```

###### Observação: ainda é necessário estar na pasta /src/ para executar o programa.
