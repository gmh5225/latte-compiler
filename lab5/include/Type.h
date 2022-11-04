#ifndef __TYPE_H__
#define __TYPE_H__
#include <vector>
#include <string>
#include "Ast.h"
#include "SymbolTable.h"

class Type
{
private:
    int kind;
protected:
    enum {INT, VOID, BOOL, FUNC};
public:
    Type(int kind) : kind(kind) {};
    virtual ~Type() {};
    virtual std::string toStr() = 0;
    bool isInt() const {return kind == INT;};
    bool isVoid() const {return kind == VOID;};
    bool isBool() const {return kind == BOOL;};
    bool isFunc() const {return kind == FUNC;};
};

class IntType : public Type
{
private:
    int size;
    bool constant;
public:
    IntType(int size,bool constant = false) : Type(Type::INT), size(size),constant(constant){};
    std::string toStr();
    bool isConst() const {return constant;};
};


class VoidType : public Type
{
public:
    VoidType() : Type(Type::VOID){};
    std::string toStr();
};

class FunctionType : public Type
{
private:
    Type *returnType;
    std::vector<Type*> paramsType;
    std::vector<SymbolEntry*> paramsSe;
public:
    FunctionType(Type* returnType, std::vector<Type*> paramsType, std::vector<SymbolEntry*> paramsSe) : 
    Type(Type::FUNC), returnType(returnType), paramsType(paramsType), paramsSe(paramsSe){};
    std::string toStr();
    std::vector<Type*> getParamsType() { return paramsType; };
};

class TypeSystem
{
private:
    static IntType commonInt;
    static VoidType commonVoid;
    static IntType commonBool;
    static IntType commonConstInt;
public:
    static Type *intType;
    static Type *voidType;
    static Type *boolType;
    static Type* constIntType;
};

#endif
