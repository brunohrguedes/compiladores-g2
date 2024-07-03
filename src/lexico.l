 /* Declaraçõs do C e do scanner */
%{
#include <stdio.h>
%}

%option noyywrap

 /* Definições do Lex para as expressões regulares */
whi         while
if          if
for         for
id          [a-zA-Z][a-zA-Z0-9]*
fl          [+|-]?[0-9]*\.[0-9]+
integer     [+|-]?[0-9]+
nl          [ \t\n\r]+
c           \/\/(.*)\n
cm          "\/\*"[^\*]*\*+([^\/\*][^\*]*\*+)*\/
outro       .

 /* Definições de tokens, atribuições de expressões regulares e ações */
%%
{whi}       { printf("While\n");                    }
{if}        { printf("If\n");                       }
{for}       { printf("For\n");                      }
{id}        { printf("Identificador\n");            }
{fl}        { printf("Float\n");                    }
{integer}   { printf("Inteiro\n");                  }
{nl}        { ;                                     }
{c}         { printf("Comentário\n");               }
{cm}        { printf("Comentário multi-linha\n");   }
{outro}     { printf("Outro\n");                    }
%%

 /* Subrotinas em C */
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

    // yyin é uma variável global definida pelo Flex para o arquivo de entrada
    yyin = file;

    // Chama o scanner gerado pelo Flex
    yylex();

    // Fecha o arquivo após a leitura
    fclose(file);

    return 0;
}