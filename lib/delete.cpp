#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"

namespace {

static llvm::cl::opt<std::string> EncapsulatedFunction(
    "deletefunction",
    llvm::cl::desc("Name of the function to be deleted"),
    llvm::cl::Required);

struct DeleteDefinition : public llvm::FunctionPass {
  static char ID;
  DeleteDefinition() : FunctionPass(ID) {}

  bool runOnFunction(llvm::Function &F) override {
    if (F.getName() == EncapsulatedFunction) {
      F.deleteBody();
      // This function was modified
      return true;
    }
    // Leave everything else untouched
    return false;
  }
};
} // namespace

char DeleteDefinition::ID = 0;
static llvm::RegisterPass<DeleteDefinition>
    X("deletedefinition", "Delete the definition of a function", false, false);
