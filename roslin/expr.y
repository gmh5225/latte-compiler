%{
/*****************
expr.y
YACC file
返回简单表达式的值
*****************/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex ();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token ADD
%token SUB
%token MUL
%token DIV
%token NUM

%left ADD SUB
%left MUL DIV
%right UMINUS

%%

// 简单表达式以;结束，忽略回车\n
lines   :	lines expr ';' { printf("%f\n", $2); }
		|	lines ';'
		|
		;

expr    :   expr ADD expr { $$ = $1 + $3; }
		|	expr SUB expr { $$ = $1 - $3; }
		|	expr MUL expr { $$ = $1 * $3; }
		|	expr DIV expr { $$ = $1 / $3; }
		|	'(' expr')'   { $$ = $2; }
		|	SUB expr %prec UMINUS { $$ = -$2; }
		|	NUM { $$ = $1; }
		;

%%

// programs section

int yylex()
{
	// place your token retrieving code here

	int t;
	while (1) {
		t = getchar();
        // 识别空格、回车和换行
		if (t == ' ' || t == '\t' || t == '\n') {
			//do nothing
		} 
        // 识别多位十进制整数
        else if (isdigit(t)) {
			yylval = 0;
			while (isdigit(t)) {
				yylval = yylval * 10 + t - '0';
				t = getchar();
			}
            // 将多余的字符放回缓冲区，下一次仍会读入
			ungetc(t , stdin);
			return NUM;
		} 
        else if (t == '+') {
            return ADD;
        }
        else if (t == '-') {
            return SUB;
        }
        else if (t == '*') {
            return MUL;
        }
        else if (t == '/') {
            return DIV;
        }
        else {
			return t;
		}
	}
}

int main(void) {
	yyin = stdin ;
	do {
		yyparse();
	} while (!feof(yyin));
	return 0;
}

void yyerror(const char* s) {
	fprintf (stderr , "Parse error : %s\n", s );
	exit (1);
}
