/* Declaraçõs do C e do scanner */
%{
#include <stdio.h>
#include "sintatico.tab.h"
%}

digito [0-9]
numero {digito}+
letra [a-zA-Z]
identificador {letra}+
espaco_branco [ \t]+
nova_linha .|\n

%option noyywrap
%%
"if" {return IF;}
"else" {return ELSE;}
"int" {return INT;}
"void" {return VOID;}
"+" {return MAIS;}
"-" {return MENOS;}
"{" {return ABRE_CHAVES;}
"}" {return FECHA_CHAVES;}
"[" {return ABRE_COLCHETES;}
"]" {return FECHA_COLCHETES;}
"(" {return ABRE_PARENTESES;}
")" {return FECHA_PARENTESES;}
"=" {return IGUAL;}
{numero} {return NUMERO;}
{identificador} {return IDENTIFICADOR;}
{nova_linha} {return yytext[0];}
{espaco_branco} {;}
%%
