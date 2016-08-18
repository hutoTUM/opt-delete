#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"

namespace {

static llvm::cl::opt<std::string> DeletedFunction(
    "deletefunction", llvm::cl::desc("Name of the function to be deleted"),
    llvm::cl::Required);

struct DeleteDefinition : public llvm::ModulePass {
  static char ID;
  DeleteDefinition() : llvm::ModulePass(ID) {
    /* empty constructor, just call the parent's one */
  }

  bool runOnModule(llvm::Module& M) override {
    llvm::Function* func = M.getFunction(DeletedFunction);

    if (func) {
      func->deleteBody();
      // This function was modified
      return true;
    }
    // Leave everything else untouched
    return false;
  }
};
}  // namespace


// Finally register the new pass
char DeleteDefinition::ID = 0;
static llvm::RegisterPass<DeleteDefinition> X(
    "deletedefinition", "Delete the definition of a function",
    false,  // walks CFG without modifying it?
    false   // is only analysis?
    );
