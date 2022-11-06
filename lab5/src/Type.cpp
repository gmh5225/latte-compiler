#include "Type.h"
#include <sstream>

IntType TypeSystem::commonInt = IntType(4);
VoidType TypeSystem::commonVoid = VoidType();
IntType TypeSystem::commonBool = IntType(1);
IntType TypeSystem::commonConstInt = IntType(32, true);

Type* TypeSystem::intType = &commonInt;
Type* TypeSystem::voidType = &commonVoid;
Type* TypeSystem::boolType = &commonBool;
Type* TypeSystem::constIntType = &commonConstInt;

std::string IntType::toStr()
{
    return "int";
}

std::string VoidType::toStr()
{
    return "void";
}

std::string FunctionType::toStr()
{
    std::ostringstream buffer;
    buffer << returnType->toStr() << "()";
    return buffer.str();
}

std::string ArrayType::toStr() {
    std::ostringstream buffer;
    buffer << "[" << ((ArrayType*)this)->getLength() << " ] ";
    return buffer.str();
}