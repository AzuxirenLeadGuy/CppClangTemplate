# Config files for development in clang and VS Code

This repository is a template for a simple project in C/C++/CUDA, using most of the amazing support of clang toolchain. 

## Requirements

This repository is prepared for a linux machine. Windows users can make use of WSL. Docker is also a great alternatives for everyone.

- **clang compiler and tools**: Setup clang and related tools like clang-tidy and clang-format. You can get it from the [official repository releases](https://github.com/llvm/llvm-project/releases), or check out the [official website](https://clang.llvm.org).
  - Needless to say, if you wish for CUDA C++ Development, you will need to setup the [Nvidia CUDA Toolkit](https://developer.nvidia.com/cuda-downloads).
- **Text editor using clangd** : Any text editor that uses the [clangd Language Server](https://clangd.llvm.org). Check out the [list of editors supported](https://clangd.llvm.org/installation#editor-plugins).
  - It is recommended to use **[VS Code](https://code.visualstudio.com)** or **[VS Codium](https://vscodium.com)** for this repository. 
  - Install the [clangd extension](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd) for intellisense with C/C++.
  - Install the [Code LLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb) extension for debugging.
  - For Debugging with Nsight for Nvidia CUDA, you will need the [Nsight extension](https://marketplace.visualstudio.com/items?itemName=NVIDIA.nsight-vscode-edition).
- **Make**: The project is setup using Makefile, so [GNU make](https://www.gnu.org/software/make/) is required.
- **Bear**: [Bear](https://github.com/rizsotto/Bear) is a tool to generate `compiler_commands.json` file, which is used by the clangd LSP to compile the project with your custom commands.

The Makefile contains the necessary commands for all the basic tasks. The repository also contains a `tasks.json` and a `launch.json` for usage from VS Code.

Also, remember to edit the makefile to point to your required source code, header files and include directory for your setting.

---
1. Run the clang-tidy analyzer, generating the `compile_commands.json` file, and allowing the clangd lsp to provide intellisense in your project correctly.
> make tidy

---
The following commands in this Makefile are included:

2. Building the optimized executable
> make build

---

3. Running the executable
> make run

---

4. Building the debuggable executable
> make debug

---

5. Format the project
> make format

---

6. Delete the executables
> make clean

---
7. Delete the config files
> make flush

---