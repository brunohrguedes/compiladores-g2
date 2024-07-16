/* Verifica a sintaxe de programas segundo a GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h> 
%}
%token whi for if nl c cm
%token id fl integer outro

%%
/* Regras definindo a GLC e acoes correspondentes */
/* neste nosso exemplo quase todas as acoes estao vazias */
input: /* empty */ 
	| input line;
line: nl
	| programa nl { printf ("Programa sintaticamente correto!\n"); };
programa: '{' lista_cmds '}' {;};
lista_cmds: cmd {;}
	| cmd ';' lista_cmds	{;};
cmd: id '=' exp {;};
exp: fl {;}
	| id {;}
	| integer {;}
	| exp exp '+' {;};
repeticao: whi '(' exp ')' {;}
	| for {;};
condicional: if '(' exp ')' {;};
comentario: c | cm {;};
outros: outro {;};
%%

/* Called by yyparse on error */
void yyerror(s) {
	char *s;
	printf ("Problema com a analise sintatica!\n", s);
}

int main () {
	yyparse ();
}
