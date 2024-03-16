%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "structs.h"
    #define YYDEBUG 1
    extern FILE * yyin;
    extern int line_count;
    extern int yylex();
    void yyerror(char* s);
    Node *temp;
    Node *root;
    Node *parent;
%}

%union {
    char name[32];
    struct node *smblptr;
    struct Node *astptr;
    int num;
}

%token<name> ELSE IF INT RETURN VOID WHILE ADD SUB MULT DIV LT LE GT GE EQ NEQ ASOP SEMCOL COMMA LPAR RPAR LBRA RBRA LCUR RCUR
%token<num> NUM
%token<smblptr> ID
%token EMPTY
%left ADD SUB
%left MULT DIV

%type<astptr> program declare_list declare var_declare type_specifier fun_declare params param_list param
%type<astptr> comp_declare local_declare statement_list statement expression_declare select_declare iter_declare return_declare
%type<astptr> expression var simple_expression relation sum_expression sum term mult factor activation args arg_list

%start program


%%

program             : declare_list
                    {
                        add_child(root, $1);
                    }
                    ;

declare_list        : declare_list declare
                    {
                        parent = create_node("declare_list");
                        add_child(parent, $1);
                        add_child(parent, $2);
                        $$ = parent;
                    }
                    | declare
                    {
                        parent = create_node("declare_list");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

declare             : var_declare
                    {
                        parent = create_node("declare");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | fun_declare
                    {
                        parent = create_node("declare");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

var_declare         : type_specifier ID SEMCOL
                    {
                        parent = create_node("var_declare");
                        add_child(parent, $1);
                        temp =create_node($2->lexeme);
                        add_child(parent, temp);
                        temp =create_node($3);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    | type_specifier ID LBRA NUM RBRA SEMCOL
                    {
                        parent = create_node("var_declare");
                        add_child(parent, $1);
                        temp =create_node($2->lexeme);
                        add_child(parent, temp);
                        temp =create_node($3);
                        add_child(parent, temp);
                        char str[32];
                        sprintf(str, "%d", $4);
                        temp =create_node(str);
                        add_child(parent, temp);
                        temp =create_node($5);
                        add_child(parent, temp);
                        temp =create_node($6);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

type_specifier      : INT  
                    {
                        parent = create_node("type_specifier");
                        temp =create_node($1);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    | VOID
                    {
                        parent = create_node("type_specifier");
                        temp =create_node($1);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

fun_declare         : type_specifier ID LPAR params RPAR comp_declare
                    {
                        parent = create_node("fun_declare");
                        add_child(parent, $1);
                        temp = create_node($2->lexeme);
                        add_child(parent, temp);
                        temp = create_node($3);
                        add_child(parent, temp);
                        add_child(parent, $4);
                        temp = create_node($5);
                        add_child(parent, temp);
                        add_child(parent, $6);
                        $$ = parent;
                    }
                    ;

params              : param_list
                    {
                        parent = create_node("params");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | VOID 
                    {
                        parent = create_node("type_specifier");
                        temp =create_node($1);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

param_list          : param_list COMMA param
                    {
                        parent = create_node("param_list");
                        add_child(parent, $1);
                        temp = create_node($2);
                        add_child(parent, temp);
                        add_child(parent, $3);
                        $$ = parent;
                    }
                    | param
                    {
                        parent = create_node("param_list");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

param               : type_specifier ID
                    {
                        parent = create_node("param");
                        add_child(parent, $1);
                        temp = create_node($2->lexeme);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    | type_specifier ID LBRA RBRA
                    {
                        parent = create_node("param");
                        add_child(parent, $1);
                        temp = create_node($2->lexeme);
                        add_child(parent, temp);
                        temp = create_node($3);
                        add_child(parent, temp);
                        temp = create_node($4);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

comp_declare        : LCUR local_declare statement_list RCUR
                    {
                        parent = create_node("comp_declare");
                        temp = create_node($1);
                        add_child(parent, $2);
                        add_child(parent, $3);
                        temp = create_node($4);
                        $$ = parent;
                    }
                    ;

local_declare       : local_declare var_declare
                    {
                        parent = create_node("local_declare");
                        add_child(parent, $1);
                        add_child(parent, $2);
                        $$ = parent;
                    } 
                    | var_declare
                    {
                        parent = create_node("local_declare");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | EMPTY {$$ = NULL;}
                    ;

statement_list      : statement_list statement
                    {
                        parent = create_node("statement_list");
                        add_child(parent, $1);
                        add_child(parent, $2);
                        $$ = parent;
                    }
                    | statement
                    {
                        parent = create_node("statement_list");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | EMPTY {$$ = NULL;}
                    ;

statement           : expression_declare
                    {
                        parent = create_node("statement");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | comp_declare
                    {
                        parent = create_node("statement");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | select_declare
                    {
                        parent = create_node("statement");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | iter_declare
                    {
                        parent = create_node("statement");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | return_declare
                    {
                        parent = create_node("statement");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

expression_declare  : expression SEMCOL
                    {
                        parent = create_node("expression_declare");
                        add_child(parent, $1);
                        temp = create_node($2);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    | SEMCOL
                    {
                        parent = create_node("expression_declare");
                        temp = create_node($1);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

select_declare      : IF LPAR expression RPAR LCUR statement_list RCUR
                    {
                        parent = create_node("select_declare");
                        temp = create_node($1);
                        add_child(parent, temp);
                        temp = create_node($2);
                        add_child(parent, temp);
                        add_child(parent, $3);
                        temp = create_node($4);
                        add_child(parent, temp);
                        temp = create_node($5);
                        add_child(parent, temp);
                        add_child(parent, $6);
                        temp = create_node($7);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    | IF LPAR expression RPAR LCUR statement_list RCUR ELSE LCUR statement_list RCUR
                    {
                        parent = create_node("select_declare");
                        temp = create_node($1);
                        add_child(parent, temp);
                        temp = create_node($2);
                        add_child(parent, temp);
                        add_child(parent, $3);
                        temp = create_node($4);
                        add_child(parent, temp);
                        temp = create_node($5);
                        add_child(parent, temp);
                        add_child(parent, $6);
                        temp = create_node($7);
                        add_child(parent, temp);
                        temp = create_node($8);
                        add_child(parent, $10);
                        temp = create_node($9);
                        temp = create_node($11);
                        $$ = parent;
                    }
                    ;

iter_declare        : WHILE LPAR expression RPAR LCUR statement_list RCUR 
                    {
                        parent = create_node("iter_declare");
                        temp = create_node($1);
                        add_child(parent, temp);
                        temp = create_node($2);
                        add_child(parent, temp);
                        add_child(parent, $3);
                        temp = create_node($4);
                        add_child(parent, temp);
                        temp = create_node($5);
                        add_child(parent, temp);
                        add_child(parent, $6);
                        temp = create_node($7);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

return_declare      : RETURN SEMCOL
                    {
                        parent = create_node("return_declare");
                        temp = create_node($1);
                        add_child(parent, temp);
                        temp = create_node($2);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    | RETURN expression SEMCOL
                    {
                        parent = create_node("return_declare");
                        temp = create_node($1);
                        add_child(parent, temp);
                        add_child(parent, $2);
                        temp = create_node($3);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

expression          : var ASOP expression
                    {
                        parent = create_node("expression");
                        add_child(parent, $1);
                        temp = create_node($2);
                        add_child(parent, temp);
                        add_child(parent, $3);
                        $$ = parent;
                    }
                    | simple_expression
                    {
                        parent = create_node("expression");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

var                 : ID 
                    {
                        parent = create_node("var");
                        temp =create_node($1->lexeme);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    | ID LBRA expression RBRA
                    {
                        parent = create_node("var");
                        temp = create_node($1->lexeme);
                        add_child(parent, temp);
                        temp = create_node($2);
                        add_child(parent, temp);
                        add_child(parent, $3);
                        temp = create_node($4);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

simple_expression   : sum_expression relation sum_expression
                    {
                        parent = create_node("simple_expression");
                        add_child(parent, $1);
                        add_child(parent, $2);
                        add_child(parent, $3);
                        $$ = parent;
                    }
                    | sum_expression
                    {
                        parent = create_node("simple_expression");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

relation            : LT {parent = create_node("relation"); temp = create_node($1); add_child(parent, temp); $$ = parent;}
                    | LE {parent = create_node("relation"); temp = create_node($1); add_child(parent, temp); $$ = parent;}
                    | GT {parent = create_node("relation"); temp = create_node($1); add_child(parent, temp); $$ = parent;}
                    | GE {parent = create_node("relation"); temp = create_node($1); add_child(parent, temp); $$ = parent;}
                    | EQ {parent = create_node("relation"); temp = create_node($1); add_child(parent, temp); $$ = parent;}
                    | NEQ{parent = create_node("relation"); temp = create_node($1); add_child(parent, temp); $$ = parent;}
                    ;

sum_expression      : sum_expression sum term
                    {
                        parent = create_node("sum_expression");
                        add_child(parent, $1);
                        add_child(parent, $2);
                        add_child(parent, $3);
                        $$ = parent;
                    }
                    | term
                    {
                        parent = create_node("sum_expression");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

sum                 : ADD{parent = create_node("sum"); temp = create_node($1); add_child(parent, temp); $$ = parent;}
                    | SUB{parent = create_node("sum"); temp = create_node($1); add_child(parent, temp); $$ = parent;}
                    ;

term                : term mult factor
                    {
                        parent = create_node("term");
                        add_child(parent, $1);
                        add_child(parent, $2);
                        add_child(parent, $3);
                        $$ = parent;
                    }
                    | factor
                    {
                        parent = create_node("term");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

mult                : MULT{parent = create_node("mult"); $$ = parent; temp = create_node($1); add_child(parent, temp);}
                    | DIV {parent = create_node("mult"); $$ = parent; temp = create_node($1); add_child(parent, temp);}
                    ;

factor              : LPAR expression RPAR
                    {
                        parent = create_node("factor");
                        temp = create_node($1);
                        add_child(parent, temp);
                        add_child(parent, $2);
                        temp = create_node($3);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    | var
                    {
                        parent = create_node("factor");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | activation
                    {
                        parent = create_node("factor");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | NUM
                    {
                        parent = create_node("factor");
                        char str[32];
                        sprintf(str, "%d", $1);
                        temp =create_node(str);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

activation          : ID LPAR args RPAR
                    {
                        parent = create_node("activation");
                        temp =create_node($1->lexeme);
                        add_child(parent, temp);
                        temp = create_node($2);
                        add_child(parent, temp);
                        add_child(parent, $3);
                        temp = create_node($4);
                        add_child(parent, temp);
                        $$ = parent;
                    }
                    ;

args                : arg_list
                    {
                        parent = create_node("args");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    | EMPTY {$$ = NULL;}
                    ;

arg_list            : arg_list COMMA expression
                    {
                        parent = create_node("arg_list");
                        add_child(parent, $1);
                        temp = create_node($2);
                        add_child(parent, $3);
                        $$ = parent;
                    }
                    | expression
                    {
                        parent = create_node("arg_list");
                        add_child(parent, $1);
                        $$ = parent;
                    }
                    ;

%%

int main(int argc,char *argv[]){
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE* file = fopen(argv[1], "r");
    if (!file) {
        printf("Could not open file: %s\n", argv[1]);
        return 1;
    }

    root = create_node("program");
    yyin = file;
    lis = create_list();
    yyparse();

    print_tree(root, 0);

    return 0;
}

void yyerror(char* s){
    fprintf(stderr, "ERROR %s at line %d\n", s, line_count);
}