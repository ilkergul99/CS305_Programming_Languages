%{
#include <stdio.h>
void yyerror(const char *s) /* Called by yyparse on error */
{
 
}
%}
%token tSTRING tNUM tPRINT tGET tSET tFUNCTION tRETURN tIDENT tEQUALITY tIF tGT tLT tGEQ tLEQ tINC tDEC 
%token tADD tMINUS tMUL tDIV
%start main_product

%%
main_product:	'[' statements ']'
	      | '[' ']'
;

statements:	statement 
              | statement statements
;

statement:	set_stmt
              | if_stmt
              | print
              | increment
	      | decrement
              | return_stmt
              | expression
;

expression:	tNUM
	      | tSTRING
              | get_expr
              | function_declaration
	      | operator_app
	      | condition_app
;

set_stmt:	'[' tSET ',' tIDENT ',' expression ']'
;

if_stmt:	'[' tIF ',' condition_app ',' matched ']'
              | '[' tIF ',' condition_app ',' unmatched ']'
;

matched: 	'[' ']' '[' ']'
              | '[' statements ']' '[' ']'
	      |	'[' ']' '[' statements ']'
              |	'['statements ']' '[' statements ']'
;

unmatched: 	'[' ']'
	      | '[' statements ']'
;

print:		'[' tPRINT ',' '[' expression ']' ']'		
;

increment:	'[' tINC ',' tIDENT ']'
;

decrement:	'[' tDEC ',' tIDENT ']'
;

return_stmt:	'[' tRETURN ']'
              | '[' tRETURN ',' expression ']'
;

get_expr:	'[' tGET ',' getoptions ']'
;

getoptions:	tIDENT
              | tIDENT ',' '[' expressions ']'
	      | tIDENT ',' '[' ']'
;

expressions:	expression
	      | expression ',' expressions
;

function_declaration:	'[' tFUNCTION ',' '[' ']' ',' '[' statements ']' ']'
                      | '[' tFUNCTION ',' '[' identifier_list ']' ',' '[' ']' ']'
                      | '[' tFUNCTION ',' '[' identifier_list ']' ',' '[' statements ']' ']'
		      | '[' tFUNCTION ',' '[' ']' ',' '[' ']' ']'
;

identifier_list:	tIDENT
                      | tIDENT ',' identifier_list
;
                
operator_app:		'[' tADD ',' expression ',' expression ']'
              	      | '[' tMINUS ',' expression ',' expression ']'
                      | '[' tMUL ',' expression ',' expression ']'
                      | '[' tDIV ',' expression ',' expression ']'
;

condition_app:		'[' conditionslist ',' expression ',' expression ']'
;

conditionslist:		tGT
                      | tLT
                      | tGEQ
                      | tLEQ
                      | tEQUALITY
;

%%
int main()
{
  if(yyparse())
  {
    printf("ERROR\n");
    return 1;
  }
  else
  {
    printf("OK\n");
    return 0;
  }
}
