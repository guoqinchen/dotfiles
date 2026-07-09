#!/bin/bash
# basic-smoke.sh — dotfiles 部署烟雾测试
# 验证关键 symlink 是否正确部署
# 用法: ./test/basic-smoke.sh

set -eu

PASS=0
FAIL=0

check() {
  local desc="$1" path="$2" expected="$3"
  if [ -L "$path" ]; then
    local target
    target=$(readlink "$path")
    if echo "$target" | grep -q "$expected"; then
      echo "  ✅ PASS: $desc"
      PASS=$((PASS + 1))
    else
      echo "  ❌ FAIL: $desc — 目标不匹配 (指向 $target, 期望 $expected)"
      FAIL=$((FAIL + 1))
    fi
  elif [ -e "$path" ]; then
    echo "  ⚠️  WARN: $desc — 存在但非 symlink"
    PASS=$((PASS + 1))
  else
    echo "  ❌ FAIL: $desc — 文件不存在"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "========================================="
echo " dotfiles 烟雾测试"
echo "========================================="
echo ""

check ".zshenv" "$HOME/.zshenv" "git/dotfiles"
check ".gitconfig" "$HOME/.gitconfig" "git/dotfiles"
check ".tmux.conf" "$HOME/.tmux.conf" "git/dotfiles"
check ".zshrc (ZDOTDIR)" "$HOME/.config/zsh/.zshrc" "git/dotfiles"
check "starship.toml" "$HOME/.config/starship.toml" "git/dotfiles"

echo ""
echo "--- 基础设施 ---"
homedir-manager version >/dev/null 2>&1 && echo "  ✅ PASS: homedir-manager" && PASS=$((PASS + 1)) || { echo "  ❌ FAIL: homedir-manager" && FAIL=$((FAIL + 1)); }

if command -v mise &>/dev/null; then
  echo "  ✅ PASS: mise $(mise version)"
  PASS=$((PASS + 1))
else
  echo "  ❌ FAIL: mise"
  FAIL=$((FAIL + 1))
fi

echo ""
echo "--- 语言运行时 ---"
if command -v java &>/dev/null; then
  jver=$(java -version 2>&1 | head -1 | sed 's/.*"\(.*\)".*/\1/')
  echo "  ✅ PASS: JDK $jver"
  PASS=$((PASS + 1))
else
  echo "  ⚠️  SKIP: JDK 未安装（可选）"
  PASS=$((PASS + 1))
fi

if command -v mvn &>/dev/null; then
  mvnver=$(mvn --version 2>&1 | head -1 | sed 's/.*Apache Maven //' | awk '{print $1}')
  echo "  ✅ PASS: Maven $mvnver"
  PASS=$((PASS + 1))
else
  echo "  ⚠️  SKIP: Maven 未安装（可选）"
  PASS=$((PASS + 1))
fi

echo ""
echo "========================================="
echo " 结果: $PASS 通过 / $FAIL 失败"
echo "========================================="
echo ""
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
