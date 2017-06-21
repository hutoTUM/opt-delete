# These are the only three external values to be set
LLVM_CONFIG_BIN ?= /usr/bin/llvm-config

# Setting some variables and commands for compilaten
CXX ?= g++
CXXFLAGS_LLVM = -fno-rtti -O3 -I`$(LLVM_CONFIG_BIN) --includedir`

LLVM_CONFIG_COMMAND = \
		`$(LLVM_CONFIG_BIN) --cxxflags --libs` \
		`$(LLVM_CONFIG_BIN) --ldflags`


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
