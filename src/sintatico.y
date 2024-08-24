%{
#define YYPARSER

#include <stdio.h> 

extern FILE *yyin;
extern char *yytext;
extern int yylineno;
int yylex(void);
void yyerror (char *s);
%}

%token NUMERO IDENTIFICADOR SE SENAO INT VOID MAIS MENOS VEZES DIVISAO
%token MENOR_QUE MAIOR_QUE MENOR_OU_IGUAL MAIOR_OU_IGUAL IGUAL_A DIFERENTE_DE 
%token IGUAL ABRE_PARENTESES FECHA_PARENTESES ABRE_COLCHETES FECHA_COLCHETES 
%token ABRE_CHAVES FECHA_CHAVES ENQUANTO RETORNO PONTO_E_VIRGULA NOVA_LINHA
%token VIRGULA

%nonassoc MENOR_QUE_SENAO
%nonassoc SENAO

%%
entrada: %empty
    | entrada linha
;

linha: NOVA_LINHA
    | programa NOVA_LINHA { printf ("Programa sintaticamente correto!\n"); }
;

programa: lista_comandos
;

lista_comandos:	comando PONTO_E_VIRGULA lista_comandos
    | comando
;

comando: declaracao_variavel
    | declaracao_funcao
;

declaracao_variavel: especificar_tipo IDENTIFICADOR PONTO_E_VIRGULA
    | especificar_tipo IDENTIFICADOR ABRE_COLCHETES NUMERO FECHA_COLCHETES PONTO_E_VIRGULA
;

especificar_tipo: INT | VOID 
;

declaracao_funcao: especificar_tipo IDENTIFICADOR ABRE_PARENTESES parametros FECHA_PARENTESES declaracao_composta
;

parametros: lista_parametros
    | VOID
;

lista_parametros: lista_parametros VIRGULA parametro
    | parametro 
;

parametro: especificar_tipo IDENTIFICADOR
    | especificar_tipo IDENTIFICADOR ABRE_COLCHETES FECHA_COLCHETES
;

declaracao_composta: ABRE_CHAVES declaracoes_locais lista_declaracoes FECHA_CHAVES 
;

declaracoes_locais: declaracoes_locais declaracao_variavel
    | %empty
;

lista_declaracoes: lista_declaracoes declaracao
    | %empty
;

declaracao: declaraco_expressao
    | declaracao_composta
    | declaracao_selecao
    | declaracao_iteracao
    | declaracao_retorno
;

declaraco_expressao: expressao PONTO_E_VIRGULA 
    | PONTO_E_VIRGULA
;

declaracao_selecao: SE ABRE_PARENTESES expressao FECHA_PARENTESES declaracao %prec MENOR_QUE_SENAO
    | SE ABRE_PARENTESES expressao FECHA_PARENTESES declaracao SENAO declaracao
;

declaracao_iteracao: ENQUANTO ABRE_PARENTESES expressao FECHA_PARENTESES declaracao
;

declaracao_retorno: RETORNO PONTO_E_VIRGULA
    | RETORNO expressao PONTO_E_VIRGULA
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
    | %empty 
;

lista_argumentos: lista_argumentos VIRGULA expressao 
    | expressao 
;

%%

int main (int argc, char *argv[]) {
    int c;
    if (argc != 2) {
        printf("Uso: %s arquivo.txt\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        fprintf(stderr, "Erro ao abrir o arquivo %s.\n", argv[1]);
        return 1;
    } else {
        fprintf(stderr, "Arquivo %s aberto com sucesso.\n", argv[1]);
    }
    yyparse();
    fclose(yyin);
	return 0;
}

void yyerror(char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
    fprintf(stderr, "Token inesperado: %s\n", yytext);
    fprintf(stderr, "Linha: %d\n", yylineno);
}