# .zprofile — 登录 shell 配置
# 在 .zshrc 之前加载，适合屏幕设置、桌面环境初始化等

# .zshenv 设置的 ZDOTDIR 已确保找到正确的 .zshrc

# Python pip 用户安装路径
if command -v python3 &>/dev/null; then
  export PATH="$HOME/Library/Python/3.12/bin:$PATH"
fi

# Go 用户安装
if [ -d "$HOME/go/bin" ]; then
  path=("$HOME/go/bin" $path)
fi
