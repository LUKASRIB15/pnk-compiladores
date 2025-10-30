%{
  #include<stdio.h>
  float variables[26];

  int yylex();
  void yyerror (char *s){
    printf ("SYNTAX ERROR: %s\n",s);
  }
%}

%union {
  int integer;
  char string[100];
  float real;
}

%token MAIN_FUNCTION;
%token SCAN PRINT;
%token TYPE_INT;
%token <real> NUMBER;
%token <integer> VARIABLE;
%token <string> TEXT;

%token EQUAL INCREMENT DECREMENT;

%left '+' '-'
%left '*' '/'

%type <real> EXPRESSION;

%%

program: TYPE_INT MAIN_FUNCTION '(' ')' '{' start '}';

start: commands_list start | commands_list ;

commands_list: 
    TYPE_INT new_variables ';'                                     // int a; ou int a,b,c;
  | VARIABLE EQUAL EXPRESSION ';'          { variables[$1] = $3; } // a := 2 + 3;
  | VARIABLE INCREMENT NUMBER ';'          { variables[$1] += $3; } // a += 2;
  | VARIABLE DECREMENT NUMBER ';'          { variables[$1] -= $3; } // a -= 3;
  | TYPE_INT VARIABLE EQUAL EXPRESSION ';' { variables[$2] = $4; } // int a := 2 + 3;
  | TYPE_INT VARIABLE INCREMENT NUMBER ';' { variables[$2] += $4; } // int a += 2;
  | TYPE_INT VARIABLE DECREMENT NUMBER ';' { variables[$2] -= $4; } // int a -= 3;

  | PRINT '(' print_options ')' ';' // print(<print_options>);
  | SCAN '(' scan_options ')' ';'  // scan(<scan_options>);
  ;

print_options:
    print_options ',' EXPRESSION { printf("%.2f\n", $3); } 
  | EXPRESSION             { printf("%.2f\n", $1); } 
  | print_options ',' TEXT       { printf("%s\n", $3); } 
  | TEXT                   { printf("%s\n", $1); }
  ;

scan_options:
    VARIABLE { scanf("%f", &variables[$1]); }
  | scan_options ',' VARIABLE { scanf("%f", &variables[$3]); }

new_variables:
    VARIABLE               
  | new_variables ',' VARIABLE
  ;

EXPRESSION: EXPRESSION '+' EXPRESSION {$$ = $1 + $3;} 
          | EXPRESSION '*' EXPRESSION {$$ = $1 * $3;}
          | EXPRESSION '-' EXPRESSION {$$ = $1 - $3;}
          | EXPRESSION '/' EXPRESSION {$$ = $1 / $3;}
          | '(' EXPRESSION ')'        {$$ = $2;}
          | NUMBER                    {$$ = $1;}
          | VARIABLE                  {$$ = variables[$1];}
          ;
%%
#include "lex.yy.c"

int main(int argc, char *argv[]){
  FILE *arquivo;
  if (argc > 1) {
      arquivo = fopen(argv[1], "r");
      if (!arquivo) {
          printf("Erro ao abrir o arquivo %s\n", argv[1]);
          return 1;
      }
      yyin = arquivo;
      printf("=== Analise Léxica e Sintática do arquivo: %s ===\n\n", argv[1]);
  } else {
      printf("=== Analise Sintática (entrada padrao) ===\n");
      printf("Digite o codigo (Ctrl+D para finalizar):\n\n");
  }

  yyparse();

  yylex();

  if (argc > 1) fclose(arquivo);

  printf("\n=== Analise Léxica e Sintática Concluida ===\n");
  return 0;
}