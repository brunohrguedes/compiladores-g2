%{
#include <stdio.h> 
int yylex(void);
void yyerror (char *s);
%}

%token NUMERO IDENTIFICADOR NOVA_LINHA SE SENAO INT VOID MAIS MENOS VEZES DIVISAO
%token MENOR_QUE MAIOR_QUE MENOR_OU_IGUAL MAIOR_OU_IGUAL IGUAL_A DIFERENTE_DE 
%token IGUAL ABRE_PARENTESES FECHA_PARENTESES ABRE_COLCHETES FECHA_COLCHETES 
%token ABRE_CHAVES FECHA_CHAVES ENQUANTO RETORNO

%%
entrada: /* vazio */
    | entrada linha
;

linha: '\n'
    | programa '\n' { printf ("Programa sintaticamente correto!\n"); }
;

programa: ABRE_CHAVES lista_comandos FECHA_CHAVES
;

lista_comandos:	comando
    | comando ';' lista_comandos
;

comando: declaracao_variavel
    | declaracao_funcao
;

declaracao_variavel: especificar_tipo ' ' IDENTIFICADOR ';'
    | especificar_tipo ' ' IDENTIFICADOR ABRE_COLCHETES NUMERO FECHA_COLCHETES ';'
;

especificar_tipo: INT | VOID 
;

declaracao_funcao: especificar_tipo ' ' IDENTIFICADOR ABRE_PARENTESES parametros FECHA_PARENTESES declaracao_composta 
    | especificar_tipo ' ' IDENTIFICADOR ' ' ABRE_PARENTESES parametros FECHA_PARENTESES declaracao_composta 
;

parametros: lista_parametros
    | VOID
;

lista_parametros: lista_parametros ',' parametro
    | parametro 
;

parametro: especificar_tipo ' ' IDENTIFICADOR
    | especificar_tipo ' ' IDENTIFICADOR ABRE_COLCHETES FECHA_COLCHETES 
    | especificar_tipo ' ' IDENTIFICADOR ' ' ABRE_COLCHETES FECHA_COLCHETES 
;

declaracao_composta: ABRE_CHAVES declaracoes_locais lista_declaracoes FECHA_CHAVES 
;

declaracoes_locais: declaracoes_locais declaracao_variavel
    | /* vazio */
;

lista_declaracoes: lista_declaracoes declaracao
    | /* vazio */
;

declaracao: declaraco_expressao
    | declaracao_composta
    | declaracao_selecao
    | declaracao_iteracao
    | declaracao_retorno
;

declaraco_expressao: expressao ';' 
    | ';'
;

declaracao_selecao: SE ABRE_PARENTESES expressao FECHA_PARENTESES declaracao
    | SE ABRE_PARENTESES expressao FECHA_PARENTESES declaracao SENAO declaracao
;

declaracao_iteracao: ENQUANTO ABRE_PARENTESES expressao FECHA_PARENTESES declaracao
;

declaracao_retorno: RETORNO ';'
    | RETORNO expressao ';'
;

expressao: variavel IGUAL expressao
    | expressao_simples 
;

variavel: IDENTIFICADOR 
    | IDENTIFICADOR ABRE_COLCHETES expressao FECHA_COLCHETES 
;

expressao_simples: expressao_aditiva operacao_relacao expressao_aditiva 
    | expressao_aditiva 
;

operacao_relacao: MENOR_QUE 
    | MENOR_OU_IGUAL 
    | MAIOR_QUE 
    | MAIOR_OU_IGUAL 
    | IGUAL_A 
    | DIFERENTE_DE 
;

expressao_aditiva: expressao_aditiva operacao_soma termo 
    | termo 
;

operacao_soma: MAIS  
    | MENOS 
;

termo: termo operacao_multiplicacao fator 
    | fator 
;

operacao_multiplicacao: VEZES 
    | DIVISAO 
;

fator: ABRE_PARENTESES expressao FECHA_PARENTESES 
    | variavel 
    | chamada 
    | NUMERO 
;

chamada: IDENTIFICADOR ABRE_PARENTESES argumentos FECHA_PARENTESES 
;

argumentos: lista_argumentos 
    | /* vazio */ 
;

lista_argumentos: lista_argumentos ',' expressao 
    | expressao 
;

%%

int main () {
	yyparse ();
	return 0;
}

void yyerror (char *s) {
	printf ("Problema com a analise sintatica: %s\n", s);
}