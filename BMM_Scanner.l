%{

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"
FILE *lexout;
int flag = 0;

%}

%%
"[A-Z][0-9]*(?=#)"         {if(!flag) {yylval.str = strdup(yytext); return DOUBLE;}}
"[A-Z][0-9]*(?=\$)"        {if(!flag) {yylval.str = strdup(yytext); return STRING;}}
"[A-Z][0-9]*(?=!)"          {if(!flag) {yylval.str = strdup(yytext); return FLOAT;}}
[A-Z][0-9]*               {if(!flag) {yylval.str = strdup(yytext); return INT;}}
[0-9]+                   {if(!flag) {yylval.num = atoi(yytext); return INT_LIT;}}
"(\"[a-zA-Z0-9]*\")"       {if(!flag) {return STRING_LIT;}}
"([0-9]+\.[0-9]{7})"       {if(!flag) {return FLOAT_LIT;}        }
"([0-9]+\.[0-9]{7})"       {if(!flag) {return DOUBLE_LIT;}}
[\(]                     {if(!flag) {return LEFT_PAREN;}}
[\)]                     {if(!flag) {return RIGHT_PAREN;}}
","                      {if(!flag) {return COMMA;}}
";"                      {if(!flag) {return SEMI;}}
"^"                      {if(!flag) {return EXP;}}
"*"                      {if(!flag) {return MUL;}}
"/"                      {if(!flag) {return DIV;}}
"+"                      {if(!flag) {return PLUS;}}
"-"                      {if(!flag) {return MINUS;}}
"="                      {if(!flag) {return EQ;}}
"<>"                     {if(!flag) {return NEQ;}}
"<"                      {if(!flag) {return LT;}}
">"                      {if(!flag) {return GT;}}
"<="                     {if(!flag) {return LTE;}}
">="                     {if(!flag) {return GTE;}}
"NOT"                    {if(!flag) {return NOT;}}
"AND"                    {if(!flag) {return AND;}}
"OR"                     {if(!flag) {return OR;}}
"XOR"                    {if(!flag) {return XOR;}}
"DATA"                   {if(!flag) {return DATA;}}
"DEF"                    {if(!flag) {return DEF;}}
"DIM"                    {if(!flag) {return DIM;}}
"END"                    {if(!flag) {return END;}}
"STOP"                   {if(!flag) {return STOP;}}
"FOR"                    {if(!flag) {return FOR;}}
"TO"                     {if(!flag) {return TO;}}
"STEP"                   {if(!flag) {return STEP;}     }
"NEXT"                   {if(!flag) {return NEXT;}     }
"GOSUB"                  {if(!flag) {return GOSUB;}    }
"GOTO"                   {if(!flag) {return GOTO;}  }
"IF"                     {if(!flag) {return IF;}}
"THEN"                   {if(!flag) {return THEN;}  }
"LET"                    {if(!flag) {return LET;} }
"INPUT"                  {if(!flag) {return INPUT;}   }
"PRINT"                  {if(!flag) {return PRINT;}   }
"RETURN"                 {if(!flag) {return RETURN;}    }
"REM"                    {flag = 1;}
\n                       {if(flag) {flag = 0;}}
[\s\t]+                   /* ignore whitespace */

%%
int yywrap(){
    return 1;
}