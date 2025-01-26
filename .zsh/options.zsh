#####################
### 基础环境初始化
#####################

# 设置文件默认权限 (目录755 / 文件644)
umask 022

# 加载核心模块
zmodload zsh/zle       # 行编辑器 (快捷键支持)
zmodload zsh/complist  # 增强补全菜单
# 按需加载重型组件
zmodload zsh/zpty  # 直接加载模块

fpath+=$HOME/.zfunc
# 加载颜色模块并初始化
autoload -Uz colors
colors

# 初始化补全系统并指定缓存位置
autoload -Uz compinit
compinit -d "$HOME/.cache/zsh/zcompdump"

#####################
### 历史记录配置
#####################
HISTFILE="$HOME/.cache/zsh/.zhistory"
HISTSIZE=10000         # 内存记录数
SAVEHIST=10000         # 持久化记录数

# 历史记录行为 (合并重复选项)
setopt EXTENDED_HISTORY      # 记录时间戳和持续时间
setopt SHARE_HISTORY         # 跨终端共享
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY    # 实时追加
setopt HIST_IGNORE_ALL_DUPS  # 自动去重
setopt HIST_IGNORE_SPACE     # 忽略空格开头的命令
setopt HIST_REDUCE_BLANKS    # 删除多余空白

#####################
### 交互行为选项
#####################

# 启用选项
setopt AUTOCD             # 目录名自动跳转
setopt AUTO_PARAM_SLASH   # 补全目录加斜杠
setopt INTERACTIVE_COMMENTS  # 交互模式支持注释
setopt NO_BEEP            # 禁用提示音
setopt COMPLETE_IN_WORD   # 允许单词中间补全

# 禁用选项
unsetopt FLOWCONTROL      # 释放 Ctrl+S/Q 快捷键
unsetopt EQUALS           # 禁用 = 命令扩展

#####################
### 插件系统配置
#####################

# 自动建议配置
ZSH_AUTOSUGGEST_USE_ASYNC=1        # 异步加载提升性能
ZSH_AUTOSUGGEST_STARTEGY=(history completion)
# ZSH_AUTOSUGGEST_MANUAL_REBIND=1         # 手动绑定优化响应
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#D3D3D3,underline"  # 灰色下划线样式

# 语法高亮配置
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor regexp root line)
ZSH_HIGHLIGHT_MAXLENGTH=512  # 防止长命令卡顿

#####################
### 补全系统配置
#####################

# 通用补全设置
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # 智能大小写匹配
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}      # 继承 LS_COLORS
zstyle ':completion:*' group-name ''                       # 启用补全分组
zstyle ':completion:*:descriptions' format '[%d]'          # 分组标题格式


#####################
### 高级功能配置
#####################

# 路径编辑优化
WORDCHARS=${WORDCHARS//[\/]}  # 移除 / 作为单词分隔符
#
