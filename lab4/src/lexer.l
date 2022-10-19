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

    #ifdef ONLY_FOR_LEX
    #include <ostream>
    #include <fstream>
    using namespace std;
    extern FILE *yyin; 
    extern FILE *yyout;

    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);
    }
    #endif
%}

// 数据类型
INT "int"

// 变量和常量
DEC ([1-9][0-9]*|0)
HEX 0[Xx]([1-9a-fA-F][0-9a-fA-F]*|0)
OCT 0([1-7][0-7]*|0)
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)

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

%x BLOCKCOMMENT

%%
//数据类型
"int" {
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("INT\tint");
    #else
        return INT;
    #endif
}
"float" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("FLOAT\tfloat");
    #else
        return FLOAT;
    #endif
}

"void" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("VOID\tvoid");
    #else
        return VOID;
    #endif 
}
"if" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("IF\tif");
    #else
        return IF;
    #endif
};
"else" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ELSE\telse");
    #else
        return ELSE;
    #endif
};
"return" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RETURN\treturn");
    #else
        return RETURN;
    #endif
}
"const" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONST\tconst");
    #else
        return CONST;
    #endif
}
"while" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("WHILE\twhile");
    #else
        return WHILE;
    #endif
};
"break" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("BREAK\tbreak");
    #else
        return BREAK;
    #endif
};
"continue" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONTINUE\tcontinue");
    #else
        return CONTINUE;
    #endif
};

"=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ASSIGN\t=");
    #else
        return ASSIGN;
    #endif
}


"<" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LES\t<");
    #else
        return LES;
    #endif
}

">" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("g=GRA\t>");
    #else
        return GRA;
    #endif
}

"+" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ADD\t+");
    #else
        return ADD;
    #endif
}
";" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SEMICOLON\t;");
    #else
        return SEMICOLON;
    #endif
}
"(" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LPAREN\t(");
    #else
        return LPAREN;
    #endif
}
")" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RPAREN\t)");
    #else
    return RPAREN;
    #endif
}
"{" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LBRACE\t{");
    #else
        return LBRACE;
    #endif
}
"}" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RBRACE\t}");
    #else
        return RBRACE;
    #endif
}

{EOL} yylineno++;
{WHITE}
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

    yylex();
    return 0;
}
#endif