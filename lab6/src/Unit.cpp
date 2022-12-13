#include "Unit.h"
#include "Type.h"
extern FILE* yyout;

void Unit::insertFunc(Function *f)
{
    func_list.push_back(f);
}

void Unit::removeFunc(Function *func)
{
    func_list.erase(std::find(func_list.begin(), func_list.end(), func));
}

void Unit::insertGlobal(SymbolEntry* se) {
    global_list.push_back(se);
}

void Unit::insertLibfunc(SymbolEntry* se) {
    auto it = std::find(libfunc_list.begin(), libfunc_list.end(), se);
    if (it == libfunc_list.end()) {
        libfunc_list.push_back(se);
    }
}

void Unit::output() const
{
    for (auto se : libfunc_list) {
        FunctionType* type = (FunctionType*)(se->getType());
        Type *ret = type->getRetType();
        std::vector<Type*> params = type->getParamsType();
        fprintf(yyout, "declare %s %s(", ret->toStr().c_str(), se->toStr().c_str());
        for (auto it = params.begin(); it != params.end(); it++) {
            fprintf(yyout, "%s", (*it)->toStr().c_str());
            if((it+1) != params.end())
                fprintf(yyout, ", ");
        }
        fprintf(yyout, ")\n");
    }
    for (auto se : global_list) {
        fprintf(yyout, "%s = global %s %d, align 4\n", se->toStr().c_str(), se->getType()->toStr().c_str(), ((IdentifierSymbolEntry*)se)->getValue());
    }
    for (auto &func : func_list)
        func->output();
}

Unit::~Unit()
{
    for(auto &func:func_list)
        delete func;
}
