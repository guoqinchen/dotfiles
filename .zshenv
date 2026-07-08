# .zshenv — 非交互 shell 环境（先于 .zshrc 加载）
# 仅放置所有 shell 类型都需要的 PATH 设置

# ZDOTDIR — 引导 zsh 到 .config/zsh 找 .zshrc
export ZDOTDIR="$HOME/.config/zsh"

# Homebrew (Apple Silicon)
if [ -d /opt/homebrew/bin ]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fi

# Local bin
if [ -d "$HOME/.local/bin" ]; then
  path=("$HOME/.local/bin" $path)
fi

export PATH="$PATH"
