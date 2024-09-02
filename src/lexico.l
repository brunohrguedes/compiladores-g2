%{
#include "sintatico.tab.h"
%}
%option yylineno

digito          [0-9]
numero          {digito}+
letra           [a-zA-Z]
identificador   {letra}+
espaco_branco   [ \t]+
nova_linha      \n
outro           .

%%
"if"        {return SE;}
"else"      {return SENAO;}
"int"       { return INT; }
"void"      { return VOID; }
"while"     {return ENQUANTO;}
"return"    {return RETORNO;}
"+"         {return MAIS;}
"-"         {return MENOS;}
"*"         {return VEZES;}
"/"         {return DIVISAO;}
"<"         {return MENOR_QUE;}
"<="        {return MENOR_OU_IGUAL;}
">"         {return MAIOR_QUE;}
">="        {return MAIOR_OU_IGUAL;}
"=="        {return IGUAL_A;}
"!="        {return DIFERENTE_DE;}
"="         {return IGUAL;}
"("         {return ABRE_PARENTESES;}
")"         {return FECHA_PARENTESES;}
"["         {return ABRE_COLCHETES;}
"]"         {return FECHA_COLCHETES;}
"{"         {return ABRE_CHAVES;}
"}"         {return FECHA_CHAVES;}
";"         {return PONTO_E_VIRGULA;}
","         {return VIRGULA;}
{numero}    {return NUMERO;}
{identificador} {yylval.cadeia= (char *) strdup(yytext); return IDENTIFICADOR;}
{nova_linha}    {return NOVA_LINHA;}
{espaco_branco} {;}
{outro}         {printf("Caractere desconhecido: %s\n", yytext); return yytext[0];}
%%

int yywrap() {
    return 1;
}