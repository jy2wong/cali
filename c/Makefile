CC=clang
CCFLAGS=-g
DEBUG=

cali: lex.yy.c cali.tab.c remind.o
	$(CC) $(CCFLAGS) -c lex.yy.c 
	$(CC) $(CCFLAGS) -c cali.tab.c 
	$(CC) $(CCFLAGS) lex.yy.o cali.tab.o remind.o -o cali

tokenizer: tokenizer.c trie.o
	$(CC) $(CCFLAGS) -o tokenizer tokenizer.c trie.o 

remind.o: remind.c remind.h
	$(CC) $(CCFLAGS) -c remind.c

trie.o: trie/trie.c trie/trie.h
	$(CC) $(CCFLAGS) -c trie/trie.c

lex.yy.c: cali.l
	flex $(DEBUG) cali.l

cali.tab.c: cali.y
	bison $(DEBUG) -v -d cali.y

clean:
	rm lex.yy.c cali.tab.c cali.tab.h lex.yy.o cali.tab.o cali remind.o
