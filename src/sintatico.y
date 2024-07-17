%{
#include <stdio.h> 
%}
%token NUMERO IDENTIFICADOR NOVA_LINHA IF ELSE INT VOID MAIS MENOS ABRE_CHAVES FECHA_CHAVES ABRE_COLCHETES FECHA_COLCHETES IGUAL ABRE_PARENTESES FECHA_PARENTESES

%%
input:    /* empty */
        | input line
;
line:     '\n'
        | programa '\n'  { printf ("Programa sintaticamente correto!\n"); }
;
programa:	ABRE_CHAVES lista_cmds FECHA_CHAVES	{;}
;
lista_cmds:	cmd				{;}
		| cmd ';' lista_cmds	{;}
;
cmd:	    declaracao_variavel | declaracao_funcao			{;}
;
declaracao_variavel: especificar_tipo ' ' IDENTIFICADOR {;} | especificar_tipo ' ' IDENTIFICADOR ABRE_COLCHETES NUMERO FECHA_COLCHETES {;}
;
declaracao_funcao: especificar_tipo ' ' IDENTIFICADOR ' ' ABRE_PARENTESES parametros FECHA_PARENTESES {;}
;
parametros: lista_parametros | VOID {;}
;
lista_parametros: parametro {;}
;
parametro: especificar_tipo ' ' IDENTIFICADOR | especificar_tipo ' ' IDENTIFICADOR ABRE_COLCHETES FECHA_COLCHETES {;}
;
especificar_tipo: INT | VOID {;}
;
%%

main () 
{
	yyparse ();
}
yyerror (s) /* Called by yyparse on error */
	char *s;
{
	printf ("Problema com a analise sintatica!\n", s);
}