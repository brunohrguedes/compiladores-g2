%{
#define YYPARSER

#include <stdio.h> 
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern char *yytext;
extern int yylineno;
int yylex(void);
void yyerror (char *s);

typedef struct Simbolo {
    char categoria[100];
    char nome[100];
    char tipo[100];
    int usado;
    int linha;
    struct Simbolo* proximo;
} Simbolo;

Simbolo* tabelaGlobal = NULL;
Simbolo* tabelaLocal = NULL;
Simbolo* tabelaParaAdicionar = NULL;
int global = 1;
Simbolo* listaWarnings[300];
int indiceListaWarnings = 0;
int indiceInicioWarningsGlobais = 0;

void inserirSimbolo(char* nome, char* tipo, char* categoria, int linha) {
    Simbolo* novoSimbolo = (Simbolo*) malloc(sizeof(Simbolo));
    strcpy(novoSimbolo->nome, nome);
    strcpy(novoSimbolo->tipo, tipo);
    strcpy(novoSimbolo->categoria, categoria);
    novoSimbolo->linha = linha;
    novoSimbolo->proximo = NULL;
    
    if(categoria == "procedimento") {
        novoSimbolo->usado = 1;
        tabelaLocal = NULL;
    } else {
        novoSimbolo->usado = 0;
    }

    if (global == 1) {
        if (tabelaGlobal == NULL) {
            tabelaGlobal = novoSimbolo;
        } else {
            Simbolo* simboloAtual = tabelaGlobal;
            while (simboloAtual->proximo != NULL) {
                simboloAtual = simboloAtual->proximo;
            }
            simboloAtual->proximo = novoSimbolo;
        }
    } else {
        if (tabelaLocal == NULL) {
            tabelaLocal = novoSimbolo;
        } else {
            Simbolo* simboloAtual = tabelaLocal;
            while (simboloAtual->proximo != NULL) {
                simboloAtual = simboloAtual->proximo;
            }
            simboloAtual->proximo = novoSimbolo;
        }
    }
}

void erroSemantico(char* id, char* msg, int linha ) {
    fprintf(stderr, "Erro semântico: identificador %s %s\n", id, msg);
    fprintf(stderr, "Linha: %d\n", linha);
    exit(1);
}

Simbolo* procurarSimbolo(char* nome, Simbolo* tabela) {
    Simbolo* simboloAtual = tabela;
    while (simboloAtual != NULL) {
        if (strcmp(simboloAtual->nome, nome) == 0) {
            return simboloAtual;
        }
        simboloAtual = simboloAtual->proximo;
    }
    return NULL;
}

void imprimirTabela(Simbolo* tabela) {
    Simbolo* simboloAtual = tabela;
    printf("\nTabela de símbolos:\n");
    while (simboloAtual != NULL) {
        printf("Categoria: %s, Nome: %s, tipo: %s, usado: %s, Linha: %d\n", 
            simboloAtual->categoria, simboloAtual->nome, simboloAtual->tipo, simboloAtual->usado ? "Sim" : "Não", simboloAtual->linha);
        simboloAtual = simboloAtual->proximo;
    }
}

void declararIdentificador (char* nome, char* tipo, char* categoria, int linha) {
    Simbolo* simbolo = procurarSimbolo(nome, global ? tabelaGlobal : tabelaLocal);
    if (simbolo != NULL) {
        erroSemantico(nome, "já declarado", linha);
    } else {
        inserirSimbolo(nome, tipo, categoria, linha);
        printf("Identificador %sdeclarado: %s\n", global == 0 ? "local " : "", nome);
    }
}

void marcarComoUsado(char* nome, int linha) {
    Simbolo* simbolo = NULL;
    int local = 1;
    if ( global == 0) {
        simbolo = procurarSimbolo(nome, tabelaLocal);
    }
    if (simbolo == NULL) {
        local = 0;
        simbolo = procurarSimbolo(nome, tabelaGlobal);
    }

    if (simbolo == NULL) {
        erroSemantico(nome, "não declarado", linha);
    } else {
        simbolo->usado = 1;
        printf("Identificador %susado: %s\n", local ? "local " : "", nome);
    }
}

void adicionarWarnings(Simbolo* tabela) {
    Simbolo* simboloAtual = tabela;
    while (simboloAtual != NULL) {
        if(!simboloAtual->usado) {
            listaWarnings[indiceListaWarnings] = simboloAtual;
            indiceListaWarnings++;
        }
        simboloAtual = simboloAtual->proximo;
    }
}

void imprimirWarnings () {
    printf("\n");
    for(int i = 0; i < indiceListaWarnings; i++) {
        if(i < indiceInicioWarningsGlobais) {
            printf("Warning: Identificador local '%s' declarado mas não utilizado. Linha: %d\n", listaWarnings[i]->nome, listaWarnings[i]->linha);
        }
        else {
            printf("Warning: Identificador '%s' declarado mas não utilizado. Linha: %d\n", listaWarnings[i]->nome, listaWarnings[i]->linha);
        }
    }
    printf("\n");
}

%}

%union{
	char *cadeia;
    char *tipo;
}

%token NUMERO SE INT VOID SENAO MAIS MENOS VEZES DIVISAO
%token MENOR_QUE MAIOR_QUE MENOR_OU_IGUAL MAIOR_OU_IGUAL IGUAL_A DIFERENTE_DE 
%token IGUAL ABRE_PARENTESES FECHA_PARENTESES ABRE_COLCHETES FECHA_COLCHETES 
%token ABRE_CHAVES FECHA_CHAVES ENQUANTO RETORNO PONTO_E_VIRGULA NOVA_LINHA
%token VIRGULA

%token <cadeia> IDENTIFICADOR
%type <tipo> especificar_tipo

%nonassoc MENOR_QUE_SENAO
%nonassoc SENAO

%%
entrada: %empty
    | entrada linha
;

linha: NOVA_LINHA
    | programa NOVA_LINHA 
;

programa: lista_comandos
;

lista_comandos:	comando PONTO_E_VIRGULA lista_comandos
    | comando
;

comando: declaracao_variavel
    | declaracao_funcao
;

declaracao_variavel: especificar_tipo IDENTIFICADOR PONTO_E_VIRGULA {
    declararIdentificador($2, $1, "variavel", yylineno);
}
    | especificar_tipo IDENTIFICADOR ABRE_COLCHETES NUMERO FECHA_COLCHETES PONTO_E_VIRGULA {
    declararIdentificador($2, $1, "variavel", yylineno);
}
;

especificar_tipo: INT {
    $$ = strdup("int");
}
| VOID {
    $$ = strdup("void");
}
;


declaracao_funcao: especificar_tipo IDENTIFICADOR {
    declararIdentificador($2, $1, "procedimento", yylineno);
    global = 0;
} ABRE_PARENTESES parametros FECHA_PARENTESES declaracao_composta {
    adicionarWarnings(tabelaLocal);
    global = 1;
}
;

parametros: lista_parametros
    | VOID
    | %empty
;

lista_parametros: lista_parametros VIRGULA parametro
    | parametro 
;

parametro: especificar_tipo IDENTIFICADOR {
    declararIdentificador($2, $1, "variavel", yylineno);
}
    | especificar_tipo IDENTIFICADOR ABRE_COLCHETES FECHA_COLCHETES {
    declararIdentificador($2, $1, "variavel", yylineno);
}
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

variavel: IDENTIFICADOR {
    marcarComoUsado($1, yylineno);
}
    | IDENTIFICADOR ABRE_COLCHETES expressao FECHA_COLCHETES {
    marcarComoUsado($1, yylineno);
}
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

chamada: IDENTIFICADOR {
    marcarComoUsado($1, yylineno);
} ABRE_PARENTESES argumentos FECHA_PARENTESES 
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
        fprintf(stderr, "Arquivo %s aberto com sucesso.\n\n", argv[1]);
    }
    yyparse();
    imprimirTabela(tabelaGlobal);
    indiceInicioWarningsGlobais = indiceListaWarnings;
    adicionarWarnings(tabelaGlobal);
    imprimirWarnings();
    printf ("Programa sintaticamente correto!\n");
    printf ("Programa semanticamente correto!\n");
    fclose(yyin);
	return 0;
}

void yyerror(char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
    fprintf(stderr, "Token inesperado: %s\n", yytext);
    fprintf(stderr, "Linha: %d\n", yylineno);
    exit(1);
}