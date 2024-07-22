/* Declaraçõs do C e do scanner */
%{
#include "sintatico.tab.h"
%}

digito          [0-9]
numero          {digito}+
letra           [a-zA-Z]
identificador   {letra}+
espaco_branco   [ \t]+
nova_linha      .|\n

%%
"if"        {return SE;}
"else"      {return SENAO;}
"int"       {return INT;}
"void"      {return VOID;}
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
{numero} {return NUMERO;}
{identificador} {return IDENTIFICADOR;}
{nova_linha} {return yytext[0];}
{espaco_branco} {;}
%%

int yywrap() {
    return 1;
}