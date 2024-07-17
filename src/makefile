run:
	bison -d sintatico.y
	flex lexico.l
	gcc -o parser sintatico.tab.c lex.yy.c -lfl