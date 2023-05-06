%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int prevLine = -1;
char buffer[100];

void yyerror(const char *str)
{
    fprintf(stderr,"%s\n",str);
}

main()
{
    freopen("test.txt", "r", stdin);
    yyparse();
}
%}

%token INT_LIT STRING_LIT FLOAT_LIT DOUBLE_LIT DOUBLE INT STRING FLOAT LEFT_PAREN RIGHT_PAREN COMMA SEMI EXP MUL DIV PLUS MINUS EQ NEQ LT GT LTE GTE NOT AND OR XOR DATA DEF DIM END STOP FOR TO STEP NEXT GOSUB GOTO IF THEN LET INPUT PRINT RETURN
%union {
    int num;
    char* str;
}


%%
program: statements endstatement
|
endstatement
;

endstatement:
INT_LIT END
|
END
{
    yyerror("Expected a line number before END on last line");
}
;

statements: 
statements statement
|
statement
|
error '\n'
{
    yyerrok;
    yyerror("");
}
;

statement:
INT_LIT stat;
{
    prevLine = $<num>1;
}
|
stat
{
    if(prevLine<0) {
        yyerror("Expected a line number on first line");
    }
    else {
        sprintf(buffer, "%d", prevLine);
        yyerror(strcat("Expected a line number on line ", buffer));
    }
}

stat:
INT
;
%%