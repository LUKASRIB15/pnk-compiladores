# Compilação do analisador léxico

all: pnk.l
	@echo "--- Compilando analisador léxico PNK ---"
	flex -i pnk.l
	gcc lex.yy.c -o pnk -lfl
	./pnk main.pnk
	@echo "--- Compilação concluída ---"