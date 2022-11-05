#ifndef __AST_H__
#define __AST_H__

#include <fstream>
#include "Type.h"

class SymbolEntry;

class Node
{
private:
    static int counter;
    int seq;
    Node* next;
public:
    Node();
    int getSeq() const {return seq;};
    virtual void output(int level) = 0;
    void setNext(Node* node);
    Node* getNext() {return next;}
};

class ExprNode : public Node
{
protected:
    SymbolEntry *symbolEntry;
    Type *type;
public:
    ExprNode(SymbolEntry *symbolEntry) : symbolEntry(symbolEntry){};
    SymbolEntry* getSymbolEntry() {return symbolEntry;};
    virtual int getValue() {return -1;};
    virtual Type* getType() {return type;};
};

class BinaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr1, *expr2;
public:
    enum {ADD, SUB, MUL, DIV, MOD, AND, OR, NOT, MINUS, EQ, GEQ, LEQ, NEQ, GRA, LES};
    BinaryExpr(SymbolEntry *se, int op, ExprNode*expr1, ExprNode*expr2) : ExprNode(se), op(op), expr1(expr1), expr2(expr2){};
    void output(int level);
    int getValue();
};

class UnaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr;
public:
    enum {NOT, SUB};
    UnaryExpr(SymbolEntry *se, int op, ExprNode*expr);
    void output(int level);
    int getValue();
    int getOp() const {return op;};
    void setType(Type* type) {this->type = type;}
};

class Constant : public ExprNode
{
public:
    Constant(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
    int getValue();
};

class Id : public ExprNode
{
public:
    Id(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
    int getValue();
};

class ConstId : public ExprNode
{
public:
    ConstId(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
};

class FuncParam : public ExprNode
{
public:
    FuncParam(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
};

class CallFunc : public ExprNode {
   private:
    ExprNode* param;
   public:
    CallFunc(SymbolEntry* se, ExprNode* param = nullptr);
    void output(int level);
};

class StmtNode : public Node
{};

class CompoundStmt : public StmtNode
{
private:
    StmtNode *stmt;
public:
    CompoundStmt(StmtNode *stmt) : stmt(stmt) {};
    void output(int level);
};

class SeqNode : public StmtNode
{
private:
    StmtNode *stmt1, *stmt2;
public:
    SeqNode(StmtNode *stmt1, StmtNode *stmt2) : stmt1(stmt1), stmt2(stmt2){};
    void output(int level);
};

class DeclStmt : public StmtNode
{
private:
    Id *id;
    ExprNode* expr;
public:
    DeclStmt(Id* id, ExprNode* expr = nullptr) : id(id) {
        if (expr) {
            this->expr = expr;
        }
    };
    void output(int level);
    Id* getId() {return id;};
};

class IfStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
public:
    IfStmt(ExprNode *cond, StmtNode *thenStmt) : cond(cond), thenStmt(thenStmt){};
    void output(int level);
};

class IfElseStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
    StmtNode *elseStmt;
public:
    IfElseStmt(ExprNode *cond, StmtNode *thenStmt, StmtNode *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) {};
    void output(int level);
};

class WhileStmt : public StmtNode {
private:
    ExprNode *cond;
    StmtNode *stmt;
public:
    WhileStmt(ExprNode* cond, StmtNode* stmt=nullptr) : cond(cond), stmt(stmt) {};
    void output(int level);
};

class BreakStmt : public StmtNode {
    private:
    StmtNode * whileStmt;
   public:
    BreakStmt(StmtNode* whileStmt){this->whileStmt=whileStmt;};
    void output(int level);
};

class ContinueStmt : public StmtNode {
private:
    StmtNode *whileStmt;
public:
    ContinueStmt(StmtNode* whileStmt){this->whileStmt=whileStmt;};
    void output(int level);
};

class ReturnStmt : public StmtNode
{
private:
    ExprNode *retValue;
public:
    ReturnStmt(ExprNode*retValue) : retValue(retValue) {};
    void output(int level);
};

class AssignStmt : public StmtNode
{
private:
    ExprNode *lval;
    ExprNode *expr;
public:
    AssignStmt(ExprNode *lval, ExprNode *expr) : lval(lval), expr(expr) {};
    void output(int level);
};

class ExprStmt : public StmtNode {
private:
    ExprNode* expr;
public:
    ExprStmt(ExprNode* expr) : expr(expr){};
    void output(int level);
};

class BlankStmt : public StmtNode {
   public:
    BlankStmt(){};
    void output(int level);
};

class FunctionDef : public StmtNode
{
private:
    SymbolEntry *se;
    DeclStmt *decl;
    StmtNode *stmt;
public:
    FunctionDef(SymbolEntry *se, DeclStmt *decl, StmtNode *stmt) : se(se), decl(decl), stmt(stmt){};
    void output(int level);
};

class Ast
{
private:
    Node* root;
public:
    Ast() {root = nullptr;}
    void setRoot(Node*n) {root = n;}
    void output();
};

#endif
