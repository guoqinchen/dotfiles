# ============================================================================
# .zshrc — 交互式 shell 配置（经由 ZDOTDIR 加载）
# 实际路径：~/.config/zsh/.zshrc
# ============================================================================

# 选项
# 注意: extended_glob 启用后,# 在命令参数中会被当作通配符
# 注释请写在命令上方而不是行尾(如: git push # 注释 → zsh: bad pattern)
setopt auto_cd extended_glob complete_in_word
setopt no_beep no_hist_beep no_list_beep
setopt hist_ignore_all_dups hist_reduce_blanks
setopt share_history hist_verify

# 历史
HISTSIZE=10000
SAVEHIST=5000
HISTFILE="$HOME/.zsh_history"

# 补全
autoload -Uz compinit
compinit -u
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# fnm (Node 版本管理)
FNM_PATH="/opt/homebrew/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "$(fnm env --shell zsh)"
fi

# mise (工具版本管理)
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# starship prompt
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bat 作为 man 和 help 的 pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME="Dracula"

# 别名
alias ll='ls -lah'
alias la='ls -la'
alias l='ls -l'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gbr='git branch'
alias tma='tmux attach -t'
alias tml='tmux list-sessions'
alias tmn='tmux new -s'
alias cat='bat -p'

# 编辑器
export EDITOR=nvim
export VISUAL=nvim

# 本地覆盖（不入仓）
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
