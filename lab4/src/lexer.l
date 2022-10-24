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

	int id_num = 0;
	char id_list[100][20];
    
    

    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO =s;
        char lineno[10];
        sprintf(lineno, "%d", yylineno);
        DEBUG_INFO.append(lineno);
        DEBUG_INFO.append("\n");
        fputs(DEBUG_INFO.c_str(), yyout);
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
        DEBUG_FOR_LAB4("INT\t\t\tint\t\t\t");
    #else
        return INT;
    #endif
}
"float" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("FLOAT\t\tfloat\t\t");
    #else
        return FLOAT;
    #endif
}

"void" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("VOID\t\t\tvoid\t\t\t");
    #else
        return VOID;
    #endif 
}
"if" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("IF\t\t\tif\t\t\t");
    #else
        return IF;
    #endif
};
"else" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ELSE\t\telse\t\t");
    #else
        return ELSE;
    #endif
};
"return" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RETURN\t\treturn\t\t");
    #else
        return RETURN;
    #endif
}
"const" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONST\t\tconst\t\t");
    #else
        return CONST;
    #endif
}
"while" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("WHILE\t\twhile\t\t");
    #else
        return WHILE;
    #endif
};
"break" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("BREAK\t\tbreak\t\t");
    #else
        return BREAK;
    #endif
};
"continue" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONTINUE\tcontinue\t");
    #else
        return CONTINUE;
    #endif
};

"=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ASSIGN\t\t=\t\t\t");
    #else
        return ASSIGN;
    #endif
}
"==" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("EQ\t\t\t==\t\t\t");
    #else
        return EQ;
    #endif
}
">=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("GEQ\t\t>=\t\t\t");
    #else
        return GEQ;
    #endif
}
"<=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LEQ\t\t\t<=\t\t\t");
    #else
        return LEQ;
    #endif
}
"!=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("NEQ\t\t\t!=\t\t\t");
    #else
        return NEQ;
    #endif
}
"+=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("PLUSASSIGN\t+=\t\t\t");
    #else
        return PLUSASSIGN;
    #endif
}
"-=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MINUASSIGN\t-=\t\t\t");
    #else
        return MINUASSIGN;
    #endif
}
"*=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MULASSIGN\t*=\t\t\t");
    #else 
        return MULASSIGN;
    #endif
}
"/=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DIVASSIGN\t/=\t\t\t");
    #else
        return DIVASSIGN;
    #endif
}

"<" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LES\t\t\t<\t\t\t");
    #else
        return LES;
    #endif
}

">" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("g=GRA\t\t\t>\t\t\t");
    #else
        return GRA;
    #endif
}

"+" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ADD\t\t\t+\t\t\t");
    #else
        return ADD;
    #endif
}
"-" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MINUS\t\t\t-\t\t\t");
    #else
        return MINUS;
    #endif
}
"*" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MUL\t\t\t*\t\t\t");
    #else
        return MUL;
    #endif
}
"/" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DIV\t\t\t/\t\t\t");
    #else
        return DIV;
    #endif
}

"&&" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("AND\t\t\t&&\t\t\t");
    #else
        return AND;
    #endif
}
"||" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("OR\t\t\t||\t\t\t");
    #else
        return OR;
    #endif
}
"!" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("NOT\t\t\t!\t\t\t");
    #else
        return NOT;
    #endif
}

";" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SEMICOLON\t;\t\t\t");
    #else
        return SEMICOLON;
    #endif
}
"(" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LPAREN\t\t(\t\t\t");
    #else
        return LPAREN;
    #endif
}
")" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RPAREN\t\t)\t\t\t");
    #else
    return RPAREN;
    #endif
}
"{" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LBRACE\t\t{\t\t\t");
    #else
        return LBRACE;
    #endif
}
"}" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RBRACE\t\t}\t\t\t");
    #else
        return RBRACE;
    #endif
}

{DEC} {
    #ifdef ONLY_FOR_LEX
        // string s = "DEC\t\t\t";
        // s.append(yytext);
        // s.append("\t\t\t");
        // DEBUG_FOR_LAB4(s);
        fprintf(yyout, "%-12s%-12s%-12d\n", "DEC", yytext, yylineno);
    #else
        return DEC;
    #endif
}

{HEX} {
    #ifdef ONLY_FOR_LEX
        char *endptr = NULL;
        int t = strtol(yytext, &endptr, 16);
        // sprintf(yytext, "HEX\t\t\t%d\t\t\t", t);
        // DEBUG_FOR_LAB4(yytext);
        fprintf(yyout, "%-12s%-12d%-12d\n", "HEX", t, yylineno);
    #else
        return HEX;
    #endif
}

{OCT} {
    #ifdef ONLY_FOR_LEX
        char *endptr = NULL;
        int t = strtol(yytext, &endptr, 8);
        // sprintf(yytext, "OCT\t\t\t%d\t\t\t", t);
        // DEBUG_FOR_LAB4(yytext);
        fprintf(yyout, "%-12s%-12d%-12d\n", "OCT", t, yylineno);
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
        // string s = "ID\t\t\t";
        // s.append(yytext);
        // s.append("\t\t\t");
        // DEBUG_FOR_LAB4(s); 
        fprintf(yyout, "%-12s%-12s%-12d\n", "ID", yytext, yylineno);
    #else
        return ID;
    #endif
}

{EOL} yylineno++;
{WHITE}

{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}
{commentlinebegin} {BEGIN COMMENTLINE;}
<COMMENTLINE>{commentlineelement} {}
<COMMENTLINE>{commentlineend} {BEGIN INITIAL;}

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

    std::string title="token\t\tlexeme\t\tlineno\n";
    fputs(title.c_str(), yyout);
    yylex();
    return 0;
}
#endif
