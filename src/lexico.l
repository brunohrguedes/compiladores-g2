%{
#include <stdio.h>
%}

%option noyywrap

whi while
if if
for for
id [a-zA-Z][a-zA-Z0-9]*
fl [0-9]*\.[0-9]+
integer [0-9]+
nl [ \t\n\r]+
c \/\/(.*)\n
cm "\/\*"[^\*]*\*+([^\/\*][^\*]*\*+)*\/
outro .

%%

{whi}       {printf("While\n");}
{if}        {printf("If\n");}
{for}       {printf("For\n");}
{id}        {printf("Identificador\n");}
{fl}        {printf("Float\n");}
{integer}   {printf("Inteiro\n");}
{nl}        {;}
{c}         {printf("Comentário\n");}
{cm}        {printf("Comentário multi-linha\n");}
{outro}     {printf("outro\n");}

%%

int main(int argc, char *argv[]) {
    FILE *file;

    if (argc != 2) {
        printf("Uso: %s arquivo.txt\n", argv[0]);
        return 1;
    }

    file = fopen(argv[1], "r");
    if (file == NULL) {
        printf("Não foi possível abrir o arquivo %s\n", argv[1]);
        return 1;
    }

    yyin = file;    // yyin é uma variável global definida pelo Flex para o arquivo de entrada

    yylex();        // Chama o scanner gerado pelo Flex

    fclose(file);   // Fecha o arquivo após a leitura

    return 0;
}