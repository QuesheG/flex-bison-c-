%option noyywrap
%x C_COMMENT

%{
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    #include "parser.tab.h"
    #include "structs.h"

    //enum{ELSE, IF, INT, RETURN, VOID, WHILE, ADD, SUB, MULT, DIV, LT, LE, GT, GE, EQ, NEQ, ASOP, SEMCOL, COMMA, LPAR, RPAR, LBRA, RBRA, LCUR, RCUR, ID, STR, NUM};    

    int line_count = 1;
%}

letter [a-zA-Z]
digit [0-9]

%%

"else"              {strcpy(yylval.name, yytext); return ELSE; }
"if"                {strcpy(yylval.name, yytext); return IF; }
"int"               {strcpy(yylval.name, yytext); return INT; }
"return"            {strcpy(yylval.name, yytext); return RETURN; }
"void"              {strcpy(yylval.name, yytext); return VOID; }
"while"             {strcpy(yylval.name, yytext); return WHILE; }
"+"                 {strcpy(yylval.name, yytext); return ADD; }
"-"                 {strcpy(yylval.name, yytext); return SUB; }
"*"                 {strcpy(yylval.name, yytext); return MULT;}
\n                  {line_count++;}
"/"                 {strcpy(yylval.name, yytext); return DIV; }
"<"                 {strcpy(yylval.name, yytext); return LT; }
"<="                {strcpy(yylval.name, yytext); return LE; }
">"                 {strcpy(yylval.name, yytext); return GT; }
">="                {strcpy(yylval.name, yytext); return GE; }
"=="                {strcpy(yylval.name, yytext); return EQ; }
"!="                {strcpy(yylval.name, yytext); return NEQ; }
"="                 {strcpy(yylval.name, yytext); return ASOP; }
";"                 {strcpy(yylval.name, yytext); return SEMCOL; }
","                 {strcpy(yylval.name, yytext); return COMMA; }
"("                 {strcpy(yylval.name, yytext); return LPAR; }
")"                 {strcpy(yylval.name, yytext); return RPAR; }
"["                 {strcpy(yylval.name, yytext); return LBRA; }
"]"                 {strcpy(yylval.name, yytext); return RBRA; }
"{"                 {strcpy(yylval.name, yytext); return LCUR; }
"}"                 {strcpy(yylval.name, yytext); return RCUR; }
"/*"                {BEGIN(C_COMMENT);}
<C_COMMENT>"*/"     {BEGIN(INITIAL);}
<C_COMMENT>\n       {line_count++;}
<C_COMMENT>.        {;}
<C_COMMENT><<EOF>>  {yyterminate();}
{digit}+            {yylval.num = atoi(yytext); return NUM; }
{letter}+           {yylval.smblptr = new_node(lis, yytext); return ID; }
[ \t]               {;}
.                   {printf("Invalid input '%s' at line %d.\n", yytext, line_count);}


%%