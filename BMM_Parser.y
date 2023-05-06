%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int prevLine = -1;
int array;
int temp;
char buffer[100];
int gosub[10000];
int returns=0;
int gosubs=0;
int forflag=0;

void yyerror(const char *str)
{
    fprintf(stderr,"Error: %s\nAfter %d\n",str, prevLine);
    exit(-1);
}

main()
{
    for(int i=0; i<10000; i++) {
        gosub[i]=0;
    }
    freopen("test.txt", "r", stdin);
    yyparse();
    for(int i=0; i<10000; i++) {
        if(gosub[i]==1) {
            gosubs++;
        }
    }
    if(gosubs>returns) {
        for(int i=0; i<10000; i++) {
            if(gosub[i]==1) {
                printf("Return statement might not be present for Subroutine on %d\n", i);
            }
        }
    }
    else if(gosubs<returns) {
        yyerror("Extra return statements are present");
    }
}
%}

%token NEWLINE REM NOTHING INT_LIT STRING_LIT FLOAT_LIT DOUBLE_LIT ARRAY_LIT DOUBLE INT STRING FLOAT LEFT_PAREN RIGHT_PAREN COMMA SEMI EXP MUL DIV PLUS MINUS EQ NEQ LT GT LTE GTE NOT AND OR XOR DATA DEF FNID DIM END STOP FOR TO STEP NEXT GOSUB GOTO IF THEN LET INPUT PRINT RETURN
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
INT_LIT stat NEWLINE
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
stat NEWLINE
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
REM comment
|
DATA values
|
DEF FNID EQ expr
|
DEF
{
    yyerror("Expected identifier or expression");
}
|
DIM array
|
DIM comment
{
    yyerror("Array not declared properly");
}
|
for
|
NEXT INT
{
    
    if(forflag<=0) {
        yyerror("Unexpected NEXT statement");
    }
    forflag--;
}
|
NEXT comment
{
    yyerror("Expected an integer variable");
}
|
GOSUB INT_LIT
{
    gosub[$<num>2] = 1;
}
|
GOSUB comment
{
    yyerror("Expected an integer literal");
}
|
GOTO INT_LIT
|
GOTO comment
{
    yyerror("Expected an integer literal");
}
|
IF booleanexprs THEN INT_LIT
|
IF THEN INT_LIT
{
    yyerror("Expected a boolean expression");
}
|
IF booleanexprs 
{
    yyerror("Expected a THEN");
}
|
IF booleanexprs THEN comment
{
    yyerror("Expected an integer literal");
}
|
LET letstate
|
INPUT inputs
|
PRINT print_expr
|
RETURN
{
    returns++;
}
|
STOP
|
error
{
    yyerror("WRONG INSTRUCTION");
}
;
inputs: INT | DOUBLE | FLOAT | ARRAY_LIT | STRING |
error
{
    yyerrok;
    yyerror("Expected to be a varname");
}
;

comment: comment NOTHING
|
NOTHING
|

;

print_expr:
exprs
{
    yyerror("Expected a delimiter ;");
}
|
exprs delimiter
|
print_expr exprs delimiter
|
error
{
    yyerror("Unexpected error");
}
;
exprs:
prinexpr | STRING_LIT | STRING;

prinexpr:
prinexpr op prinexpr
|
MINUS prinexpr
|
LEFT_PAREN prinexpr RIGHT_PAREN
|
INT|DOUBLE|FLOAT
;

delimiter:
COMMA|SEMI
;

letstate:
expr EQ expr
|
STRING EQ STRING_LIT
|
error
{
    yyerrok;
    yyerror("Wrong assignment");
}
;

for:
FOR INT EQ expr TO expr STEP expr
{
    forflag++;
}
|
FOR INT EQ expr TO expr
{
    forflag++;
}
;

array:
array COMMA ARRAY_LIT
|
ARRAY_LIT
;

values:
values COMMA valuelit
|
valuelit
|
error
{
    yyerrok;
    yyerror("Expected literals");
}
;
valuelit: INT_LIT | STRING_LIT | DOUBLE_LIT | FLOAT_LIT;

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
|
NOT booleanexpr
|
strings relop strings
;

strings : STRING | STRING_LIT;

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
DOUBLE
|
FLOAT
;

%%