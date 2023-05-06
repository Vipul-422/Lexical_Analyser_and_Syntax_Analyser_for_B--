all:
	lex BMM_Scanner.l; yacc -d BMM_Parser.y; cc lex.yy.c y.tab.c -o bmm;