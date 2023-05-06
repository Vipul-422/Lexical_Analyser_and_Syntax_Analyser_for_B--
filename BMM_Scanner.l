%{

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"
FILE *lexout;
int flag = 0;

%}

%%
[A-Z][0-9]*#         {if(!flag) {yylval.str = strdup(yytext); return DOUBLE;} else {return NOTHING;}}
[A-Z][0-9]*\$        {if(!flag) {yylval.str = strdup(yytext); return STRING;} else {return NOTHING;}}
[A-Z][0-9]!          {if(!flag) {yylval.str = strdup(yytext); return FLOAT;} else {return NOTHING;}}
[A-Z][0-9]*               {if(!flag) {yylval.str = strdup(yytext); return INT;} else {return NOTHING;}}
[A-Z]\([A-Z0-9][,]*[A-Z0-9]*\)           {if(!flag) {return ARRAY_LIT;} else {return NOTHING;}}
FN[A-Z]                     {if(!flag) {return FNID;} else {return NOTHING;}}
[0-9]+                   {if(!flag) {yylval.num = atoi(yytext); return INT_LIT;} else {return NOTHING;}}
["].*["]       {if(!flag) {return STRING_LIT;} else {return NOTHING;}}
"([0-9]+\.[0-9]{7})"       {if(!flag) {return FLOAT_LIT;}  else {return NOTHING;}       }
"([0-9]+\.[0-9]{7})"       {if(!flag) {return DOUBLE_LIT;} else {return NOTHING;}}
[\(]                     {if(!flag) {return LEFT_PAREN;} else {return NOTHING;}}
[\)]                     {if(!flag) {return RIGHT_PAREN;} else {return NOTHING;}}
","                      {if(!flag) {return COMMA;} else { return NOTHING;}}
";"                      {if(!flag) {return SEMI;} else { return NOTHING;}}
"^"                      {if(!flag) {return EXP;} else { return NOTHING;}}
"*"                      {if(!flag) {return MUL;} else { return NOTHING;}}
"/"                      {if(!flag) {return DIV;} else { return NOTHING;}}
"+"                      {if(!flag) {return PLUS;} else { return NOTHING;}}
"-"                      {if(!flag) {return MINUS;} else { return NOTHING;}}
"="                      {if(!flag) {return EQ;} else { return NOTHING;}}
"<>"                     {if(!flag) {return NEQ;} else { return NOTHING;}}
"<"                      {if(!flag) {return LT;} else { return NOTHING;}}
">"                      {if(!flag) {return GT;} else { return NOTHING;}}
"<="                     {if(!flag) {return LTE;} else { return NOTHING;}}
">="                     {if(!flag) {return GTE;} else { return NOTHING;}}
"NOT"                    {if(!flag) {return NOT;} else { return NOTHING;}}
"AND"                    {if(!flag) {return AND;} else { return NOTHING;}}
"OR"                     {if(!flag) {return OR;} else { return NOTHING;}}
"XOR"                    {if(!flag) {return XOR;} else { return NOTHING;}}
"DATA"                   {if(!flag) {return DATA;} else { return NOTHING;}}
"DEF"                    {if(!flag) {return DEF;} else { return NOTHING;}}
"DIM"                    {if(!flag) {return DIM;} else { return NOTHING;}}
"END"                    {if(!flag) {return END;} else { return NOTHING;}}
"STOP"                   {if(!flag) {return STOP;} else { return NOTHING;}}
"FOR"                    {if(!flag) {return FOR;} else { return NOTHING;}}
"TO"                     {if(!flag) {return TO;} else { return NOTHING;}}
"STEP"                   {if(!flag) {return STEP;}      else { return NOTHING;}}
"NEXT"                   {if(!flag) {return NEXT;}      else { return NOTHING;}}
"GOSUB"                  {if(!flag) {return GOSUB;}     else { return NOTHING;}}
"GOTO"                   {if(!flag) {return GOTO;}   else { return NOTHING;}}
"IF"                     {if(!flag) {return IF;} else { return NOTHING;}}
"THEN"                   {if(!flag) {return THEN;}   else { return NOTHING;}}
"LET"                    {if(!flag) {return LET;}  else { return NOTHING;}}
"INPUT"                  {if(!flag) {return INPUT;}    else { return NOTHING;}}
"PRINT"                  {if(!flag) {return PRINT;}    else { return NOTHING;}}
"RETURN"                 {if(!flag) {return RETURN;}     else { return NOTHING;}}
"REM"                    {flag = 1; return REM;}
\n                       {flag = 0; return NEWLINE;}
[\s\t]+                   /* ignore whitespace */
.                        {if(flag) {return NOTHING;}}
%%
int yywrap(){
    return 1;
}