%code top{
    #include <iostream>
    #include <assert.h>
    #include <stack>
    #include <cstring>
    #include "parser.h"
    extern Ast ast;
    int yylex();
    int yyerror( char const * );
    int paramNo = 0;
    std::stack<StmtNode*> whileStk;
    ArrayType* arrayType;

    #include<iostream>
}

%code requires {
    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"
}

%union {
    int itype;
    char* strtype;
    StmtNode* stmttype;
    ExprNode* exprtype;
    Type* type;
    SymbolEntry* se;
}

%start Program
%token <strtype> ID 
%token <itype> INTEGER FLOATNUM
%token IF ELSE
%token INT VOID FLOAT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON LSQUARE RSQUARE COMMA
%token ADD SUB MUL DIV OR AND NOT MOD
%token EQ GEQ LEQ NEQ GRA LES
%token ASSIGN PLUSASSIGN SUBASSIGN MULASSIGN DIVASSIGN
%token CONST WHILE BREAK CONTINUE RETURN

%nterm <stmttype> Stmts Stmt ExprStmt AssignStmt BlockStmt IfStmt ReturnStmt BlankStmt DeclStmt FuncDef FuncParam FuncParams ConstDef ConstDeclStmt ConstDefList VarDeclStmt VarDef VarDefList WhileStmt BreakStmt ContinueStmt
%nterm <exprtype> Exp UnaryExp AddExp Cond LOrExp PrimaryExp LVal RelExp LAndExp MulExp EqExp ConstExp ConstInitVal InitVal FuncParamsCall ArrayIndex FuncArrayIndex
%nterm <type> Type

%precedence THEN
%precedence ELSE
%%
Program
    : Stmts {
        ast.setRoot($1);
    }
    ;
Stmts
    : Stmt {$$=$1;}
    | Stmts Stmt{
        $$ = new SeqNode($1, $2);
    }
    ;
Stmt
    : AssignStmt {$$=$1;}
    | ExprStmt {$$=$1;}
    | BlockStmt {$$=$1;}
    | IfStmt {$$=$1;}
    | ReturnStmt {$$=$1;}
    | DeclStmt {$$=$1;}
    | FuncDef {$$=$1;}
    | BlankStmt {$$=$1;}
    | WhileStmt {$$=$1;}
    | BreakStmt {$$=$1;}
    | ContinueStmt {$$=$1;}
    ;
LVal
    : 
    ID {
        SymbolEntry* se;
        se = identifiers->lookup($1);
        $$ = new Id(se);
        delete []$1;
    }
    | ID ArrayIndex {
        SymbolEntry* se;
        se = identifiers->lookup($1);
        $$ = new Id(se, $2);
        delete []$1;
    }
    ;
ExprStmt
    : Exp SEMICOLON {
        $$ = new ExprStmt($1);
    }
    ;
AssignStmt
    :
    LVal ASSIGN Exp SEMICOLON {
        $$ = new AssignStmt($1, $3);
    }
    ;
BlankStmt
    : SEMICOLON {
        $$ = new BlankStmt();
    }
    ;
BlockStmt
    : LBRACE {identifiers = new SymbolTable(identifiers);} 
    Stmts RBRACE 
    {
        $$ = new CompoundStmt($3);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
    }
    | LBRACE RBRACE {
        $$ = new BlankStmt();
    }
    ;
IfStmt
    : IF LPAREN Cond RPAREN Stmt %prec THEN {
        $$ = new IfStmt($3, $5);
    }
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);
    }
    ;

ReturnStmt
    :
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
    }
    | RETURN SEMICOLON {
        $$ = new ReturnStmt();
    }
    ;

WhileStmt
    : WHILE LPAREN Cond RPAREN {
        StmtNode *whileNode = new WhileStmt($3);    
        whileStk.push(whileNode);
    }
    Stmt {  
        StmtNode *whileNode =whileStk.top();
        ((WhileStmt*)whileNode)->setStmt($6);//设置内部stmt语句
        $$=whileNode;
        whileStk.pop();
    }
    ;
//break和continue要设置匹配的while
BreakStmt
    : BREAK SEMICOLON {
        $$ = new BreakStmt(whileStk.top());
    }
    ;
ContinueStmt
    : CONTINUE SEMICOLON {
        $$ = new ContinueStmt(whileStk.top());
    }
    ;

Exp
    :
    AddExp {$$ = $1;}
    ;
Cond
    :
    LOrExp {$$ = $1;}
    ;
PrimaryExp
    :
    LPAREN Exp RPAREN{
        $$ = $2;
    }
    |
    LVal {
        $$ = $1;
    }
    | INTEGER {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, $1);
        $$ = new Constant(se);
    }
    | ID LPAREN FuncParamsCall RPAREN {
        SymbolEntry* se;
        se = identifiers->lookup($1);
        $$ = new CallFunc(se, $3);
    }
    | ID LPAREN RPAREN {
        SymbolEntry* se;
        se = identifiers->lookup($1);
        $$ = new CallFunc(se);
    }
    ;

UnaryExp 
    : PrimaryExp {$$ = $1;}
    
    | ADD UnaryExp {$$ = $2;}
    
    | SUB UnaryExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new UnaryExpr(se, UnaryExpr::SUB, $2);
    }
    //注意NOT是Bool类型
    | NOT UnaryExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new UnaryExpr(se, UnaryExpr::NOT, $2);
    }
    ;
MulExp
    :
    UnaryExp {$$ = $1;}
    |
    MulExp MUL UnaryExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se,BinaryExpr::MUL,$1,$3);
    }
    |
    MulExp DIV UnaryExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se,BinaryExpr::DIV,$1,$3);
    }
    |
    MulExp MOD UnaryExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se,BinaryExpr::MOD,$1,$3);
    }
    ;
AddExp
    :
    MulExp {$$ = $1;}
    |
    AddExp ADD MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
    }
    |
    AddExp SUB MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
    }
    ;
RelExp  //大于小于
    :
    AddExp {$$ = $1;}
    |
    RelExp LES AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LES, $1, $3);
    }
    |
    RelExp LEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LEQ, $1, $3);
    }
    |
    RelExp GRA AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GRA, $1, $3);
    }
    |
    RelExp GEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GEQ, $1, $3);
    }
    ;
EqExp   //相等不相等
    :
    RelExp {$$ = $1;}
    |
    EqExp EQ RelExp {
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se,BinaryExpr::EQ,$1,$3);
    }
    |
    EqExp NEQ RelExp{
        SymbolEntry* se = new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel());
        $$ = new BinaryExpr(se,BinaryExpr::NEQ,$1,$3);
    }
    ;
LAndExp  
    :
    EqExp {$$ = $1;}
    |
    LAndExp AND EqExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;
LOrExp
    :
    LAndExp {$$ = $1;}
    |
    LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
    }
    ;

ConstExp
    :
    AddExp {$$ = $1;}
    ;
InitVal 
    : 
    Exp {$$ = $1;}
    ;
ConstInitVal
    :
    ConstExp{$$=$1;}
    ;
Type
    : INT {
        $$ = TypeSystem::intType;
    }
    | VOID {
        $$ = TypeSystem::voidType;
    }
    ;
DeclStmt
    :
    VarDeclStmt {$$ = $1;}
    | ConstDeclStmt {$$ = $1;}
    ;
VarDeclStmt
    : Type VarDefList SEMICOLON {$$ = $2;}
    ;
ConstDeclStmt
    :
    CONST Type ConstDefList SEMICOLON
    {
        $$ = $3;
    }
    ;
VarDefList
    : VarDefList COMMA VarDef {
        $$ = $1;
        $1->setNext($3);
    } 
    | VarDef {$$ = $1;}
    ;
ConstDefList
    :
    ConstDefList COMMA ConstDef{
        $$ = $1;
        $1->setNext($3);
    }
    |
    ConstDef{$$ = $1;}
    ;
VarDef
    : ID {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        $$ = new DeclStmt(new Id(se));
        delete []$1;
    }
    //赋予初值的情况
    | ID ASSIGN InitVal {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        ((IdentifierSymbolEntry*)se)->setValue($3->getValue());
        $$ = new DeclStmt(new Id(se), $3);
        se = identifiers->lookup($1);
        $$ = new AssignStmt(new Id(se), $3);
        delete []$1;
    }
    | ID ArrayIndex {
        SymbolEntry* se;
        ExprNode* temp = $2;
        Type* type = new ArrayType(TypeSystem::intType, temp->getValue());
        arrayType = (ArrayType*)type;
        se = new IdentifierSymbolEntry(type, $1, identifiers->getLevel());
        int *p = new int[type->getSize()];//设置整型空间 即长度*大小
        ((IdentifierSymbolEntry*)se)->setArrayValue(p);
        identifiers->install($1, se);
        $$ = new DeclStmt(new Id(se));
        delete []$1;
    }
    ;

ConstDef
    : ID ASSIGN ConstInitVal {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry(TypeSystem::constIntType, $1, identifiers->getLevel());
        ((IdentifierSymbolEntry*)se)->setConst();
         identifiers->install($1, se);
        ((IdentifierSymbolEntry*)se)->setValue($3->getValue());
        $$ = new DeclStmt(new Id(se), $3);
        se = identifiers->lookup($1);
        $$ = new AssignStmt(new Id(se), $3);
        delete []$1;
    }
    ;

FuncDef
    :
    Type ID {
        identifiers = new SymbolTable(identifiers);
        paramNo = 0;    //标记参数的id
    }
    LPAREN FuncParams RPAREN {
        Type* funcType;
        std::vector<Type*> vecType;
        std::vector<SymbolEntry*> vecSe;
        DeclStmt* temp = (DeclStmt*)$5;
        while(temp){
            vecType.push_back(temp->getId()->getSymbolEntry()->getType());
            vecSe.push_back(temp->getId()->getSymbolEntry());
            temp = (DeclStmt*)(temp->getNext());
        }
        //输入参数类型和符号表项
        funcType = new FunctionType($1, vecType, vecSe);
        SymbolEntry* se = new IdentifierSymbolEntry(funcType, $2, identifiers->getPrev()->getLevel());
        identifiers->getPrev()->install($2, se);
        $<se>$ = se; //下面使用
    }
    BlockStmt {
        $$ = new FunctionDef($<se>7, (DeclStmt*)$5, $8);
        SymbolTable* top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    ;
FuncParams
    : FuncParams COMMA FuncParam {
        $$ = $1;
        $$->setNext($3);    //连接参数
    }
    | FuncParam {
        $$ = $1;
    }
    ;
FuncParam
    : Type ID {
        SymbolEntry* se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel(), paramNo++);
        identifiers->install($2, se);
        $$ = new DeclStmt(new Id(se));
    }
    | Type ID FuncArrayIndex {
        SymbolEntry* se;
        ExprNode* temp = $3;
        Type* arr = new ArrayType(TypeSystem::intType, temp->getValue());
        se = new IdentifierSymbolEntry(arr, $2, identifiers->getLevel(), paramNo++);
        identifiers->install($2, se);
        $$ = new DeclStmt(new Id(se));
        delete []$2;
    }
    | %empty {$$ = nullptr;}
    ;
FuncParamsCall
    : 
    Exp {$$ = $1;}
    | FuncParamsCall COMMA Exp {
        $$ = $1;
        $$->setNext($3);//参数从左到右建立 next
    }
    ;
ArrayIndex
    : LSQUARE ConstExp RSQUARE {
        $$ = $2;
    }
    ;
FuncArrayIndex
    : LSQUARE RSQUARE {
        $$ = new ExprNode(nullptr);
    }
    | LSQUARE Exp RSQUARE {
        $$ = $2;
    }
    ;

%%

int yyerror(char const* message)
{
    std::cerr<<message<<std::endl;
    return -1;
}
