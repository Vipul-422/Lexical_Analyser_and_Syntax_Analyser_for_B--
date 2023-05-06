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

%token INT_LIT STRING_LIT FLOAT_LIT DOUBLE_LIT ARRAY_LIT DOUBLE INT STRING FLOAT LEFT_PAREN RIGHT_PAREN COMMA SEMI EXP MUL DIV PLUS MINUS EQ NEQ LT GT LTE GTE NOT AND OR XOR DATA DEF FNID DIM END STOP FOR TO STEP NEXT GOSUB GOTO IF THEN LET INPUT PRINT RETURN
%union {
    int num;
    char* str;
}
%left EQ NEQ LT GT LTE GTE
%left PLUS MINUS
%left MUL DIV
%left EXP
%left LEFT_PAREN RIGHT_PAREN



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
DATA values
|
DEF FNID EQ expr
|
DIM array
|
for
|
NEXT INT_LIT
|
GOSUB INT_LIT
|
GOTO INT_LIT
|
IF booleanexprs THEN INT_LIT
|
LET letstate
|
INPUT values
|
PRINT print_expr


;

print_expr:
print_expr expr delimiter
|
expr delimiter
;

delimiter:
COMMA|SEMI
;

letstate:
expr EQ expr
;

for:
FOR INT_LIT EQ expr TO expr STEP expr
|
FOR INT_LIT EQ expr TO expr
;

array:
array COMMA ARRAY_LIT
|
ARRAY_LIT
;

values:
values COMMA value
|
value
;

booleanexprs:
booleanexprs logop booleanexprs
|
booleanexpr
;

booleanexpr:
expr relop expr
|
expr
|
LEFT_PAREN booleanexpr RIGHT_PAREN
;

expr:
expr op expr
|
value
|
MINUS expr
|
LEFT_PAREN expr RIGHT_PAREN
;


op:
EXP|MINUS|MUL|DIV|PLUS
;

relop:
EQ|NEQ|LT|GT|LTE|GTE
;

logop:
AND|OR|XOR
;




value:
INT_LIT
|
DOUBLE_LIT
|
FLOAT_LIT
|
ARRAY_LIT
|
INT
|
STRING
|
DOUBLE
|
FLOAT
;


%%