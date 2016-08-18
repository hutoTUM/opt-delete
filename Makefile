# These are the only three external values to be set
LLVM_SRC_PATH ?= $$HOME/build/llvm

# Setting some variables and commands for compilaten
LLVM_BUILD_PATH = $(LLVM_SRC_PATH)/Release
LLVM_BIN_PATH = $(LLVM_BUILD_PATH)/bin
LLVM_INCLUDES = -I$(LLVM_SRC_PATH)/include -I$(LLVM_BUILD_PATH)/include

CXX = g++
CXXFLAGS_LLVM = -fno-rtti -O3 $(LLVM_INCLUDES)

LLVM_CONFIG_COMMAND = \
		`$(LLVM_BIN_PATH)/llvm-config --cxxflags --libs` \
		`$(LLVM_BIN_PATH)/llvm-config --ldflags`


all: bin/libDeleteOpt.so


bin/libDeleteOpt.so: \
		bin/delete.o
	$(CXX) -std=c++11 $(CXXFLAGS_LLVM) -shared $(LLVM_CONFIG_COMMAND) $^ -o $@


bin/%.o: lib/%.cpp
	$(CXX) -c -fPIC -std=c++11 $(CXXFLAGS_LLVM) $(LLVM_CONFIG_COMMAND) $^ -o $@


.PHONY: clean
clean:
	@ rm -rf bin
	@ git checkout bin/.gitignore

.PHONY: format
format:
	clang-format -i $(wildcard **/*.cpp) $(wildcard **/*.c) $(wildcard **/*.h)
