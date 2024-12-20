# BuildCPP
Use a shell script to directly generate a standard C++ project directory structure in the current directory, recommended for use only in VSCode.

直接将buildcpp.sh放入~/bin，然后为buildcpp.sh增加可执行权限，然后创建一个软链接指向这个可执行脚本，随后将~/bin添加到PATH路径中

或者执行下面的脚本之后，就可以在任意目录执行buildcpp命令生成目录结构

```shell
#!/bin/bash

# Step 1: Clone the repository and setup the directory and file
cd /your_directory
git clone git@github.com:Scriptinfano/BuildCPP.git
cd BuildCPP
mkdir -p ~/bin  # 确保 ~/bin 目录存在
cp ./buildcpp.sh ~/bin/buildcpp.sh
cd ~/bin
chmod +x buildcpp.sh
ln -s $(realpath ./buildcpp.sh) ~/bin/buildcpp

# Step 2: Get the current user's default shell
USER_SHELL=$(basename "$SHELL")

# Step 3: Set the user's home directory
USER_HOME=~

# Step 4: The directory to add to PATH
TARGET_PATH="$USER_HOME/bin"

# Step 5: Modify the shell configuration file based on the user's shell type
if [[ "$USER_SHELL" == "bash" ]]; then
    CONFIG_FILE="$USER_HOME/.bash_profile"
    if [ ! -f "$CONFIG_FILE" ]; then
        CONFIG_FILE="$USER_HOME/.bashrc"
    fi
    # Check if ~/bin is already in PATH, if not add it
    if ! grep -q "$TARGET_PATH" "$CONFIG_FILE"; then
        echo "export PATH=\"$TARGET_PATH:\$PATH\"" >> "$CONFIG_FILE"
        echo "$TARGET_PATH has been added to PATH in $CONFIG_FILE."
    else
        echo "$TARGET_PATH is already in PATH in $CONFIG_FILE."
    fi
elif [[ "$USER_SHELL" == "zsh" ]]; then
    CONFIG_FILE="$USER_HOME/.zshrc"
    # Check if ~/bin is already in PATH, if not add it
    if ! grep -q "$TARGET_PATH" "$CONFIG_FILE"; then
        echo "export PATH=\"$TARGET_PATH:\$PATH\"" >> "$CONFIG_FILE"
        echo "$TARGET_PATH has been added to PATH in $CONFIG_FILE."
    else
        echo "$TARGET_PATH is already in PATH in $CONFIG_FILE."
    fi
else
    echo "Unrecognized shell: $USER_SHELL. Unable to modify PATH."
    exit 1
fi

# Step 6: Prompt user to reload the shell configuration
echo "Please run 'source $CONFIG_FILE' or restart your terminal to apply changes."

```
