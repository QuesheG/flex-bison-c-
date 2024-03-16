# flex-bison-c-
Flex + Bison naive implementation for a compiler of a c like language (c-)

# How to run
In order to run this properly, first you need the [Flex (Fast Lexical Analyzer)](https://en.wikipedia.org/wiki/Flex_(lexical_analyser_generator)) and the [Bison](https://www.gnu.org/software/bison/) software to generate the right files
To run, simply type:
```bash
bison -d parser
flex lexer.l
gcc parser.tab.c lex.yy.c structs.c
```
# Usage
Now run the newly made .exe with a .c- file (the language description can be found (sadly i only found it in portugues) alongside the files in this repo) and get a AST (Abstract Syntax Tree), useful for translating the program to assembly using much more complex concepts that i couldn't cover.
