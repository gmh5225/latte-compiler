%option noyywrap
%{
    /*
    * You will need to comment this line in lab5.
    */
    #define ONLY_FOR_LEX
    
    #ifdef ONLY_FOR_LEX
    #else
    #define YYSTYPE void *
    #include "parser.h"
    #endif

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #include <string>
    #include <math.h>
    #include <vector>

    #ifdef ONLY_FOR_LEX
    #include <ostream>
    #include <fstream>
    using namespace std;
    extern FILE *yyin; 
    extern FILE *yyout;

    int base = 0;
    int offset = 0;
    int tmplineno = 0;
	int id_num = 0;
	char id_list[100][20];
    char *scope[100];

    void DEBUG_FOR_LAB4(string tok, string val){
        if(tmplineno != yylineno) {
            tmplineno = yylineno;
            offset = base;
        }
        if(tok == "ID") {
            if(base == 0) {
                scope[0] = yytext;
            }
            fprintf(yyout, "%-12s%-12s%-12d%-12d%-12p\n", tok.c_str(), val.c_str(), yylineno, offset, scope[base]);
        }
        else {
            fprintf(yyout, "%-12s%-12s%-12d%-12d\n", tok.c_str(), val.c_str(), yylineno, offset);
        }
        offset += val.length();
    }
    #endif
%}

    // 数据类型
INT "int"
FLOAT "float"

    // 变量和常量，包括十进制浮点数
DEC (([1-9][0-9]*|0)(\.[0-9]+)?)
HEX (0[Xx](([1-9a-fA-F][0-9a-fA-F]*)|0))
OCT (0(([1-7][0-7]*)|0))
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t ]

FORMATCHAR [\r\n\t ]+

    // 语句
CONST "const"
VOID "void"
IF "if"
ELSE "else"
WHILE "while"
BREAK "break"
CONTINUE "continue"
RETURN "return"

    // 表达式、关系、逻辑运算
EQ "=="
GEQ ">="
LEQ "<="
NEQ "!="
ASSIGN "="
PLUSASSIGN "+="
MINUSASSIGN "-="
MULASSIGN "*="
DIVASSIGN "/="
GRA ">"
LES "<"
PLUS "+"
MINUS "-"
MUL "*"
DIV "/"
MOD "%"
AND "&&"
OR "||"
NOT "!"

LPAREN "("
RPAREN ")"
LBRACE "{"
RBRACE "}"
SEMICOLON ";"

    // 注释
commentbegin "/*"
commentelement .|\n
commentend "*/"
%x COMMENT
commentlinebegin "//"
commentlineelement .
commentlineend \n
%x COMMENTLINE

%%
    // 数据类型
"int" {
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("INT", "int");
    #else
        return INT;
    #endif
}
"float" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("FLOAT", "float");
    #else
        return FLOAT;
    #endif
}

"void" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("VOID", "void");
    #else
        return VOID;
    #endif 
}
"if" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("IF", "if");
    #else
        return IF;
    #endif
};
"else" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ELSE", "else");
    #else
        return ELSE;
    #endif
};
"return" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RETURN", "return");
    #else
        return RETURN;
    #endif
}
"const" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONST", "const");
    #else
        return CONST;
    #endif
}
"while" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("WHILE", "while");
    #else
        return WHILE;
    #endif
};
"break" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("BREAK", "break");
    #else
        return BREAK;
    #endif
};
"continue" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONTINUE", "continue");
    #else
        return CONTINUE;
    #endif
};

"=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ASSIGN", "=");
    #else
        return ASSIGN;
    #endif
}
"==" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("EQ", "==");
    #else
        return EQ;
    #endif
}
">=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("GEQ", ">=");
    #else
        return GEQ;
    #endif
}
"<=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LEQ", "<=");
    #else
        return LEQ;
    #endif
}
"!=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("NEQ", "!=");
    #else
        return NEQ;
    #endif
}
"+=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("PLUSASSIGN", "+=");
    #else
        return PLUSASSIGN;
    #endif
}
"-=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MINUASSIGN", "-=");
    #else
        return MINUASSIGN;
    #endif
}
"*=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MULASSIGN", "*=");
    #else 
        return MULASSIGN;
    #endif
}
"/=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DIVASSIGN", "/=");
    #else
        return DIVASSIGN;
    #endif
}

"<" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LES", "<");
    #else
        return LES;
    #endif
}

">" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("GRA", ">");
    #else
        return GRA;
    #endif
}

"+" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ADD", "+");
    #else
        return ADD;
    #endif
}
"-" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MINUS", "-");
    #else
        return MINUS;
    #endif
}
"*" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MUL", "*");
    #else
        return MUL;
    #endif
}
"/" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DIV", "/");
    #else
        return DIV;
    #endif
}

"&&" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("AND", "&&");
    #else
        return AND;
    #endif
}
"||" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("OR", "||");
    #else
        return OR;
    #endif
}
"!" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("NOT", "!");
    #else
        return NOT;
    #endif
}

";" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SEMICOLON", ";");
    #else
        return SEMICOLON;
    #endif
}
"(" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LPAREN", "(");
    #else
        return LPAREN;
    #endif
}
")" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RPAREN", ")");
    #else
    return RPAREN;
    #endif
}
"{" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LBRACE", "{");
        base++;
        scope[base] = yytext;
    #else
        return LBRACE;
    #endif
}
"}" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RBRACE", "}");
        base--;
    #else
        return RBRACE;
    #endif
}
"[" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LSQUARE", "[");
    #else
        return LSQUARE;
    #endif
}
"]" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RSQUARE", "]");
    #else
        return RSQUARE;
    #endif
}

{DEC} {
    #ifdef ONLY_FOR_LEX
        if(tmplineno != yylineno) {
            offset = base;
        }
        int t = atoi(yytext);
        float f = atof(yytext);
        if((t - f) != 0) {
            fprintf(yyout, "%-12s%-12f%-12d%-12d\n", "DEC", f, yylineno, offset);
        }
        else {
            fprintf(yyout, "%-12s%-12d%-12d%-12d\n", "DEC", t, yylineno, offset);
        }
        offset += strlen(yytext);
    #else
        return DEC;
    #endif
}

{HEX} {
    #ifdef ONLY_FOR_LEX
        if(tmplineno != yylineno) {
            offset = base;
        }
        char *endptr = NULL;
        int t = strtol(yytext, &endptr, 16);
        fprintf(yyout, "%-12s%-12d%-12d%-12d\n", "HEX", t, yylineno, offset);
        offset += strlen(yytext);
    #else
        return HEX;
    #endif
}

{OCT} {
    #ifdef ONLY_FOR_LEX
        if(tmplineno != yylineno) {
            offset = base;
        }
        char *endptr = NULL;
        int t = strtol(yytext, &endptr, 8);
        fprintf(yyout, "%-12s%-12d%-12d%-12d\n", "OCT", t, yylineno, offset);
        offset += strlen(yytext);
    #else
        return OCT;
    #endif
}

{ID} {
    #ifdef ONLY_FOR_LEX
	    int id_match = 0;
	    int id = 0;
	    for (int i = 0; i < id_num; i++) {
		    if (strcmp(yytext, id_list[i])==0) {
			    id_match = 1;
	    		id = i;
		    	break;
		    }
	    }
	    if (!id_match) {
	    	id = id_num;
	    	strcpy(id_list[id], yytext);
	    	id_num++;
	    }
        DEBUG_FOR_LAB4("ID", yytext);
    #else
        return ID;
    #endif
}

{EOL} yylineno++;
{WHITE} offset++;

{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {if(!strcmp(yytext, "\n")) yylineno++;}
<COMMENT>{commentend} {BEGIN INITIAL;}
{commentlinebegin} {BEGIN COMMENTLINE;}
<COMMENTLINE>{commentlineelement} {}
<COMMENTLINE>{commentlineend} {yylineno++; BEGIN INITIAL;}

%%

#ifdef ONLY_FOR_LEX
int main(int argc, char **argv){
    if(argc != 5){
        fprintf(stderr, "Argument Not Enough");
        exit(EXIT_FAILURE);
    }

    if(!(yyin = fopen(argv[1], "r"))){
        fprintf(stderr, "No such file or directory: %s", argv[1]);
        exit(EXIT_FAILURE);
    }

    if(!(yyout = fopen(argv[3], "w"))){
        fprintf(stderr, "No such file or directory: %s", argv[3]);
        exit(EXIT_FAILURE);
    }

    std::string title="token\t\tlexeme\t\tlineno\t\toffset\t\tpointer_to_scope\n";
    fputs(title.c_str(), yyout);
    yylex();
    return 0;
}
#endif
