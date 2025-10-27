# Compilação do analisador léxico e sintático

all: pnk.l pnk.y
	@echo "--- Compilando analisador léxico + sintático PNK ---"
	flex -i pnk.l
	bison pnk.y
	gcc pnk.tab.c -o pnk -lfl
	./pnk main.pnk
	@echo "--- Compilação concluída ---"