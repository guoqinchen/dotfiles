# .zprofile — 登录 shell 配置
# 在 .zshrc 之前加载，适合屏幕设置、桌面环境初始化等

# .zshenv 设置的 ZDOTDIR 已确保找到正确的 .zshrc

# Python pip 用户安装路径（自动检测版本）
for pyver_path in "$HOME"/Library/Python/*/bin; do
  if [ -d "$pyver_path" ]; then
    path=("$pyver_path" $path)
  fi
done
