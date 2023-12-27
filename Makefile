SHELL=/bin/sh

# List all *.cu/*.cpp/*.c files that are to be compiled (Change if needed)
# This glob only matches *.c, *.cpp and *.cu file in the folder src, nut not its subfolders. You can choose to use the ** to match all subfolders (i.e CXX=./src/**/*.c*)
CXX=./src/*.c*

# List all *.hu/*.hpp/*.h files that are to be used (Change if needed)
HXX=./src/*.h*

# Bear config file
BEAR=.bear-config.json

# compile_commands.json file
COMP=compile_commands.json

# Tidy settings
TIDY=.clang-tidy

# clang-tidy flags
TFLAGS=--checks=modern*,performance*,read*

# Format settings
FORM=.clang-format

# Bin Folder
BNF=./bin

# Debug executable program
DEBUG_EXE=./bin/debug.out

# Optimized/Release executable program
FINAL_EXE=./bin/program.out

# The clang compiler for C++ and CUDA (it uses the cuda compiler)
# For a pure C project, you should use clang instead of clang++
CC=clang++

# The warning and other common flags to use for clang. Edit/Remove according to your needs
CLANG_FLAGS=-Wall -Wextra -pedantic -std=c++20

# If compiling with CUDA, use this, and edit path if needed
CUDA_FLAGS=--cuda-gpu-arch=sm_75 --cuda-path=/usr/lib/cuda -L/usr/lib/cuda/lib64/ --define-macro CUDA_API_PER_THREAD_DEFAULT_STREAM=1 -lcudart

# Flags for linking additional libraries, if any
# Stuff like
# -lm     (shared library)
# -I./lib (source from folder)
LIB_FLAGS= 

# Combine all flags
FLAGS=$(CLANG_FLAGS) $(CUDA_FLAGS) $(LIB_FLAGS)

.PHONY:clean format build debug-build run flush-config

# The debug build command, using defined macro DEBUG
DBG_BUILD_CMD=$(CC) $(FLAGS) -g --define-macro DEBUG=1 -o $(DEBUG_EXE) $(CXX)


# Making the final optimized executable program, setting DEBUG=0
$(FINAL_EXE):$(CXX) $(HXX) $(BNF)
	$(CC) $(FLAGS) -O3 --define-macro DEBUG=0 -o $(FINAL_EXE) $(CXX)

# Making the debuggable executable program
$(DEBUG_EXE):$(CXX) $(HXX) $(BNF)
	$(DBG_BUILD_CMD)

# Make the output directory if it does not exist
$(BNF):
	mkdir $(BNF)

# Output the current clang-format configuration
$(FORM):
	clang-format --dump-config > $(FORM)

# Prepare the bear config file for the specific configuration that does not clash with clang's settings
$(BEAR): $(BNF)
	echo '{"compilation": null,"output": {"content":{"include_only_existing_source": true,"duplicate_filter_fields": "file"},"format": {"command_as_array": true,"drop_output_field": false}}}' > $(BEAR)

# Prepare `compile_commands.json` file from the present .bear-config file
$(COMP): $(BEAR)
	bear --config $(BEAR) -- $(DBG_BUILD_CMD)

# Prepare a clang-tidy config file 
$(TIDY):
	clang-tidy --checks=$(TFLAGS) --dump-config > $(TIDY)

# Remove all executables from the output directory
clean:
	rm -f ./bin/*.out

# Remove all config files
flush-config:
	rm -f .clang-tidy compile_commands.json

# Perform formatting using clang-format
format: $(FORM) $(CXX) $(HXX)
	clang-format -i $(CXX) $(HXX)

# See the analyzer output by calling clang-tidy
tidy: $(COMP) $(TIDY) $(CXX)
	clang-tidy --config-file=$(TIDY) $(CXX) $(HXX)

# Make the debug executable
debug:$(DEBUG_EXE)

# Make the release executable
build:$(FINAL_EXE)

# Run the release executable
run:$(FINAL_EXE)
	$(FINAL_EXE)