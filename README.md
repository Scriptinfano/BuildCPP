# BuildCPP
Use a shell script to directly generate a standard C++ project directory structure in the current directory, recommended for use only in VSCode.

直接将buildcpp.sh放入~/bin，然后为buildcpp.sh增加可执行权限，然后创建一个软链接指向这个可执行脚本，随后将~/bin添加到PATH路径中

```shell
cd /your_directory
git clone git@github.com:Scriptinfano/BuildCPP.git
cd BuildCPP
mkdir ~/bin
cp ./buildcpp.sh ~/bin/buildcpp.sh
cd ~/bin
chmod +x buildcpp.sh
ln -s $(realpath ./buildcpp.sh) $(pwd)/buildcpp
```
