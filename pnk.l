%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  extern FILE *yyin;

  int line = 1;

%}

%x COMMENT

/* Definições */
NUMBER      [0-9]+\.?[0-9]*
VARIABLE    [A-Za-z_]+
TEXT        \".*\"  
IGNORE      [ \t\r]

%%
{IGNORE}+   { }
\n          { line++; }

    /* Tags de Início e Fim */

    /* A) Comentários */
#.*             { /* comentário de linha */ }
"<#"            { BEGIN(COMMENT); } 
<COMMENT>"#/>"  { BEGIN(INITIAL); } 
<COMMENT>\n     { line++; }
<COMMENT>.      { /* ignora dentro do comentário */ }

"main" { return MAIN_FUNCTION;}

    /* C) Operadores */
    /* - Operadores Lógicos */
">="        { printf("OPERADOR_LOGICO:                  %s\n", yytext); }
"<="        { printf("OPERADOR_LOGICO:                  %s\n", yytext); }
"=="        { printf("OPERADOR_LOGICO:                  %s\n", yytext); }
"!="        { printf("OPERADOR_LOGICO:                  %s\n", yytext); }
"or"        { printf("OPERADOR_LOGICO:                  %s\n", yytext); }
"and"       { printf("OPERADOR_LOGICO:                  %s\n", yytext); }
">"         { printf("OPERADOR_LOGICO:                  %s\n", yytext); }
"<"         { printf("OPERADOR_LOGICO:                  %s\n", yytext); }
"!"         { printf("OPERADOR_LOGICO:                  %s\n", yytext); }

    /* - Operadores para atribuições */

":="        { return EQUAL; }
"+="        { return INCREMENT; }
"-="        { return DECREMENT; }

    /* - Operadores aritméticos */

"+"         { return '+'; }
"*"         { return '*'; }
"-"         { return '-'; }
"/"         { return '/'; }

    /* D) Operação de leitura */

"scan"      { return SCAN;}

    /* E) Operação de escrita */
"print"     { return PRINT;}

    /* F) Operações de condição */
"if"        { printf("PALAVRA_RESERVADA_CONDICIONAL:    %s\n", yytext); }
"else"      { printf("PALAVRA_RESERVADA_CONDICIONAL:    %s\n", yytext); } 
"switch"    { printf("PALAVRA_RESERVADA_CONDICIONAL:    %s\n", yytext); } 
"case"      { printf("PALAVRA_RESERVADA_CONDICIONAL:    %s\n", yytext); } 

    /* G) Operações de repetição */
"for"       { printf("PALAVRA_RESERVADA_REPETIÇÃO:      %s\n", yytext); }
"while"     { printf("PALAVRA_RESERVADA_REPETIÇÃO:      %s\n", yytext); }
"do"        { printf("PALAVRA_RESERVADA_REPETIÇÃO:      %s\n", yytext); }

    /* H) Delimitadores */
"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
"["         { return '['; }
"]"         { return ']'; }

    /* I) Palavras reservadas */
"return"    { printf("RETURN:                           %s\n", yytext); }
"int"       { return TYPE_INT; }
"float"     { printf("TIPO_FLOAT:                       %s\n", yytext); }
"char"      { printf("TIPO_CHAR:                        %s\n", yytext); }
"string"    { printf("TIPO_STRING:                      %s\n", yytext); }
"bool"      { printf("TIPO_BOOLEAN:                     %s\n", yytext); }
"true"      { printf("TRUE_BOOLEAN:                     %s\n", yytext); }
"false"     { printf("FALSE_BOOLEAN:                    %s\n", yytext); }

    /* J) Caracteres especiais */
","         { return ','; }
";"         { return ';'; }
"\""        { printf("CARACTERE_ESPECIAL:               %s\n", yytext); }
"'"         { printf("CARACTERE_ESPECIAL:               %s\n", yytext); }

    /* B) Identificadores */
{VARIABLE}({VARIABLE}|{NUMBER})* {
                                    yylval.integer = *yytext - 'a';
                                    return VARIABLE;
                                 }
{NUMBER}                         {
                                    yylval.real = atof(yytext);
                                    return NUMBER;
                                 }
{TEXT}                           {
                                    strcpy(yylval.string, yytext);
                                    return TEXT;
                                 }
    /* Erro Léxico */
.           { printf("ERRO: Caractere nao reconhecido '%s' na linha %d\n", yytext, line); }
%%

