%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int prevLine = -1;
int temp;
char buffer[100];

void yyerror(const char *str)
{
    fprintf(stderr,"Error: %s\n",str);
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
|
statements
{
    yyerror("Expected an END at the end of the program");
}
|
{
    printf("Warning: Empty file\n");
}
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
    yyerror("Wrong program structure");
}
;

statement:
INT_LIT stat
{
    if(prevLine < $<num>1) {
        prevLine = $<num>1;
    }
    else if (prevLine == $<num>1) {

        temp = prevLine;
        char buffer[5], rev[5];
        int i=0;
        temp = prevLine;
        while(temp) {
            int rem = temp%10;
            buffer[i] = (char)(rem+'0');
            i++;
            temp /= 10;
        }
        buffer[i]='\0';
        for(int j=0; buffer[j]!='\0'; j++) {
            rev[j] = buffer[i-j-1];
        }
        rev[i]='\0';
        char expec[] = "Same line number at ";
        yyerror(strcat(expec, rev));
    }
    else {
        temp = prevLine = $<num>1;
        char buffer[5], rev[5];
        int i=0;
        temp = prevLine;
        while(temp) {
            int rem = temp%10;
            buffer[i] = (char)(rem+'0');
            i++;
            temp /= 10;
        }
        buffer[i]='\0';
        for(int j=0; buffer[j]!='\0'; j++) {
            rev[j] = buffer[i-j-1];
        }
        rev[i]='\0';
        char expec[] = "Previous line number is greater at ";
        yyerror(strcat(expec, rev));
    }
}
|
stat
{
    if(prevLine<0) {
        yyerror("Expected a line number on first line");
    }
    else {
        char buffer[5], rev[5];
        int i=0;
        temp = prevLine;
        while(temp) {
            int rem = temp%10;
            buffer[i] = (char)(rem+'0');
            i++;
            temp /= 10;
        }
        buffer[i]='\0';
        for(int j=0; buffer[j]!='\0'; j++) {
            rev[j] = buffer[i-j-1];
        }
        rev[i]='\0';
        char expec[] = "Expected a line number after line ";
        yyerror(strcat(expec, rev));
    }
}

stat:
INT
;

expr: 


%%