#!/bin/bash

# 获取当前目录
current_dotfile_dir=$(pwd)

# 定义函数来设置脚本
setup_scripts() {
    echo "Setting up scripts from $current_dotfile_dir/scripts to $HOME/.local/bin"

    # 遍历脚本目录中的所有文件
    for script in "$current_dotfile_dir/scripts"/*; do
        if [ -f "$script" ]; then
            script_name="${script##*/}"
            echo "Script full path: $script"
            echo "Script name: $script_name"
            ln -sf "$script" "$HOME/.local/bin/$script_name"
        fi
    done
}

# 检查脚本参数是否包含 'scripts'
for arg in "$@"; do
    if [ "$arg" == "scripts" ]; then
        setup_scripts
        exit 0
    fi
done

echo "Usage: $0 [options] scripts"
