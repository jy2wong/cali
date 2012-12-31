CC=clang
CCFLAGs=-g -Wall

cali: lex.yy.c cali.tab.c
	$(CC) $(CCFLAGS) lex.yy.c cali.tab.c -o cali

tokenizer: tokenizer.c trie.o
	$(CC) $(CCFLAGS) -o tokenizer tokenizer.c trie.o 

trie.o: trie/trie.c trie/trie.h
	$(CC) $(CCFLAGS) -c trie/trie.c

lex.yy.c: cali.l
	flex --debug cali.l

cali.tab.c: cali.y
	bison --verbose --debug -d cali.y

clean:
	rm trie.o tokenizer lex.yy.c cali.tab.c cali.tab.h cali
