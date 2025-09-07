%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  extern FILE *yyin;

  int line = 1;

  char* remover_aspas(char* s){
      
    int tam=strlen(s);

    if(tam<2){
        char *scopy = malloc(1);
        if (scopy) scopy[0]='\0';
        return scopy;
    }

    char *scopy = malloc(tam-1);

    strncpy(scopy, s+1, tam-2);
    scopy[tam-2] = '\0';

    return scopy;
  }
%}

%x COMMENT

/* Definições */
NUM     [0-9]+
LETRA   [A-Za-z_]+
SIMB    [-+*/=]
IGNORE  [ \n\t\r]

%%
{IGNORE}+   { }
\n          { line++; }

    /* A) Comentários */
#.*             { /* comentário de linha */ }
"<#"            { BEGIN(COMMENT); } 
<COMMENT>"#/>"  { BEGIN(INITIAL); } 
<COMMENT>\n     { line++; }
<COMMENT>.      { /* ignora dentro do comentário */ }

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

":="        { printf("OPERADOR_ATRIBUICAO:              %s\n", yytext); }
"+="        { printf("OPERADOR_ATRIBUICAO:              %s\n", yytext); }
"-="        { printf("OPERADOR_ATRIBUICAO:              %s\n", yytext); }

    /* - Operadores aritméticos */

"+"         { printf("OPERADOR_ARITMETICO:              %s\n", yytext); }
"*"         { printf("OPERADOR_ARITMETICO:              %s\n", yytext); }
"-"         { printf("OPERADOR_ARITMETICO:              %s\n", yytext); }
"/"         { printf("OPERADOR_ARITMETICO:              %s\n", yytext); }

    /* D) Operação de leitura */

"read"      { printf("OPERADOR_INPUT:                   %s\n", yytext);}

    /* E) Operação de escrita */
"write"     { printf("OPERADOR_OUTPUT:                  %s\n", yytext);}

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
"("         { printf("DELIMITADOR:                      %s\n", yytext); }
")"         { printf("DELIMITADOR:                      %s\n", yytext); }
"{"         { printf("DELIMITADOR:                      %s\n", yytext); }
"}"         { printf("DELIMITADOR:                      %s\n", yytext); }
"["         { printf("DELIMITADOR:                      %s\n", yytext); }
"]"         { printf("DELIMITADOR:                      %s\n", yytext); }

    /* I) Palavras reservadas */
"return"    { printf("RETURN:                           %s\n", yytext); }
"int"       { printf("TIPO_INT:                         %s\n", yytext); }
"float"     { printf("TIPO_FLOAT:                       %s\n", yytext); }
"char"      { printf("TIPO_CHAR:                        %s\n", yytext); }
"string"    { printf("TIPO_STRING:                      %s\n", yytext); }
"bool"      { printf("TIPO_BOOLEAN:                     %s\n", yytext); }
"true"      { printf("TRUE_BOOLEAN:                     %s\n", yytext); }
"false"     { printf("FALSE_BOOLEAN:                    %s\n", yytext); }

    /* J) Caracteres especiais */
","         { printf("CARACTERE_ESPECIAL:               %s\n", yytext); }
";"         { printf("CARACTERE_ESPECIAL:               %s\n", yytext); }
"\""        { printf("CARACTERE_ESPECIAL:               %s\n", yytext); }
"'"         { printf("CARACTERE_ESPECIAL:               %s\n", yytext); }

    /* B) Identificadores */
{LETRA}({LETRA}|{NUM})*  { printf("ID:                               %s\n", yytext); }
{NUM}+\.{NUM}           { printf("PONTO_FLUTUANTE:                  %s\n", yytext); }
{NUM}+                  { printf("INTEIRO:                          %s\n", yytext);}

\"([^"\n])*\"   {
    char* stringSemAspas=remover_aspas(yytext);
    printf("STRING:                           %s\n", stringSemAspas); 
    free(stringSemAspas);
}

'([^'\n])'      { 
    char* stringSemAspas=remover_aspas(yytext);
    printf("CHAR:                             %s\n", stringSemAspas); 
    free(stringSemAspas);
}


    /* Erro Léxico */
.           { printf("ERRO: Caractere nao reconhecido '%s' na linha %d\n", yytext, line); }
%%

int main(int argc, char *argv[]){
    FILE *arquivo;
    if (argc > 1) {
        arquivo = fopen(argv[1], "r");
        if (!arquivo) {
            printf("Erro ao abrir o arquivo %s\n", argv[1]);
            return 1;
        }
        yyin = arquivo;
        printf("=== Analise Lexica do arquivo: %s ===\n\n", argv[1]);
    } else {
        printf("=== Analise Lexica (entrada padrao) ===\n");
        printf("Digite o codigo (Ctrl+D para finalizar):\n\n");
    }

    yylex();

    if (argc > 1) fclose(arquivo);

    printf("\n=== Analise Lexica Concluida ===\n");
    return 0;
}
