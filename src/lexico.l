/* Declaraçõs do C e do scanner */
%{
#include "sintatico.tab.h"
%}

/* Definições do Lex para as expressões regulares */
whi         while
if_se       if
for_para    for
id          [a-zA-Z][a-zA-Z0-9]*
fl          [+|-]?[0-9]*\.[0-9]+
integer     [+|-]?[0-9]+
c           \/\/(.*)\n
cm          "\/\*"[^\*]*\*+([^\/\*][^\*]*\*+)*\/
outro       .

/* Definições de tokens, atribuições de expressões regulares e ações */
%%
{whi}       { return whi; }
{if_se}     { return if_se; }
{for_para}  { return for_para; }
{id}        { return id; }
{fl}        { return fl; }
{integer}   { return integer; }
{c}         { return c; }
{cm}        { return cm; }
{outro}     { return outro; }
%%

int yywrap() {
  return 1;
}
