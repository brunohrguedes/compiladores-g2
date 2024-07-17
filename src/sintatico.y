/* Verifica a sintaxe de programas segundo a GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h> 
%}
%token whi for_para if_se c cm
%token id fl integer outro

%%
/* Regras definindo a GLC e acoes correspondentes */
/* neste nosso exemplo quase todas as acoes estao vazias */
input: /* empty */ 
	| input line;
line: '\n'
	| programa '\n' { printf ("Programa sintaticamente correto!\n"); };
programa: '{' lista_cmds '}' {;};
lista_cmds: cmd {;}
	| cmd ';' lista_cmds {;}
	| bloco_repeticao {;}
	| condicional {;}
	| comentario {;}
	| outros {;};
cmd: id '=' exp {;};
exp: fl {;}
	| id {;}
	| integer {;}
	| exp exp '+' {;}
bloco_repeticao: repeticao '{' lista_cmds '}' {;};
repeticao: whi '(' exp ')' {;}
	| for_para '(' exp ')' {;};
condicional: if_se '(' exp ')' {;};
comentario: c | cm {;};
outros: outro {;};
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