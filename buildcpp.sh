##########################################################################
# File Name: build.sh
# Author: maverick
# mail: scripterMonster@protonmail.com
# Created Time: 五 12/ 6 11:50:16 2024
#########################################################################
#!/bin/zsh

# 创建目录结构
mkdir -p .vscode bin include log res scripts src build
mkdir -p src/impl

# 创建必要的文件
touch log/log.txt
touch .vscode/c_cpp_properties.json
touch .vscode/launch.json
touch .vscode/settings.json
touch .vscode/tasks.json
touch .gitignore
touch CMakeLists.txt

# 对.vscode的四个文件进行配置
cat > .vscode/c_cpp_properties.json <<\EOL
{
    "configurations": [
        {
            "name": "", //TODO 配置的名字需要自己填写
            "includePath": [
                "${workspaceFolder}/include/" //TODO 根据需要调整include文件夹的位置
            ],
            "defines": [], //TODO 宏定义相关配置 
            "compilerPath": "", //TODO 根据需要填写编译器的路径
            "cStandard": "c17",
            "cppStandard": "c++17",
            "intelliSenseMode": "${default}", // 这里会根据平台自动选择对应的值
        }
    ]
}
EOL

cat > .vscode/launch.json <<\EOL
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/bin/main", // TODO 此处根据实际可执行文件的位置调整
            "args": [], // TODO 根据需要配置main函数的参数
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "preLaunchTask": "build project",
            "MIMode": "", // TODO 根据平台填写对应的MIMode，如果是linux平台则填写gdb，如果是mac平台则填写lldb
            "miDebuggerPath": "",  // TODO 此处需要根据调试器的实际路径做调整，如果是mac平台则不需要填写，删除配置
            "internalConsoleOptions": "openOnSessionStart"
        }
    ]
}
EOL

cat > .vscode/tasks.json <<\EOL
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build project",
            "type": "shell",
            "command": "./scripts/build.sh",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": [],
            "detail": "Build the project using the build.sh script"
        }
    ]
}
EOL

# 在.gitignore中添加常见忽略规则
cat > .gitignore <<\EOL
# 编译生成文件
build/
bin/
log/log.txt

# IDE 配置文件
.vscode/
EOL

# 在CMakeLists.txt中添加基本的CMake配置
cat > CMakeLists.txt <<\EOL
# 要求的CMake最小版本
cmake_minimum_required(VERSION 3.10)

# 项目名称
project(MyCppProject)

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 23)

# 关闭编译器的返回值优化
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-elide-constructors")

# 添加调试信息，再生成的目标文件中添加符号表，以便调试器可以解析变量名称和函数调用等信息
set(CMAKE_BUILD_TYPE Debug)
# 定义路径
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include)
set(IMPL_DIR ${CMAKE_SOURCE_DIR}/src/impl)
set(BIN_DIR ${CMAKE_SOURCE_DIR}/bin)

# 设置全局可执行文件输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR})

# 包含头文件路径
include_directories(${INCLUDE_DIR})

# 获取 src/impl 目录下的所有 .cpp 文件
file(GLOB IMPL_FILES "${IMPL_DIR}/*.cpp")

# 获取 src 目录下的所有 .cpp 文件（主程序文件，包含 main 函数）
file(GLOB SRC_FILES "${CMAKE_SOURCE_DIR}/src/*.cpp")

# 为每个 src/*.cpp 创建一个可执行文件
foreach(CPP_FILE ${SRC_FILES})
    # 获取文件名（不含路径和扩展名）
    get_filename_component(EXE_NAME ${CPP_FILE} NAME_WE)
    
    # 添加可执行文件，将 IMPL_FILES 作为公共依赖链接到所有可执行文件
    add_executable(${EXE_NAME} ${CPP_FILE} ${IMPL_FILES})

    # 可选：为每个目标设置单独的输出目录
    set_target_properties(${EXE_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}
    )
endforeach()
EOL

# 创建一个简单的main.cpp
cat > src/main.cpp <<\EOL
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOL

# 创建一个脚本文件，用于重新编译并运行
cat > scripts/rebuild_and_run.sh <<\EOL
#!/bin/bash
# 请在项目的根目录下执行此文件
# 删除旧的构建文件
rm -rf ./build/* ./bin/*

# 重新生成构建文件。-S用于指定源代码目录（Source Directory），也就是包含 CMakeLists.txt 文件的目录，这是告诉 CMake 去哪里找构建配置文件；-B ./build 表示生成的构建文件将存储在 build 子目录中成构建文件
cmake -S ./ -B ./build

# 编译
cmake --build ./build

# 运行可执行文件
if [ -f "./bin/MyCppExecutable" ]; then
    echo "Running the program:"
    bin/MyCppExecutable
else
    echo "Build failed. Executable not found."
fi

EOL

cat > scripts/build.sh <<\EOL
#!/bin/bash
# 请在项目的根目录下执行此文件
# 删除旧的构建文件
rm -rf ./build/* ./bin/*

# 重新生成构建文件
cmake -S ./ -B ./build

# 编译
cmake --build ./build
EOL

# 赋予脚本执行权限
chmod +x scripts/rebuild_and_run.sh
chmod +x scripts/build.sh

# 初始化git仓库
git init .

# 打印成功消息
echo "C++ 项目目录结构已生成！"

