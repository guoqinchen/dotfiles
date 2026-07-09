# CLAUDE.md — Claude Code Agent 规则

## 行为准则

1. **先说结论，后说理由** — 回答要直接，避免冗长铺垫
2. **主动质疑，不附和** — 发现不合理的要求、风险或更好的方案时，必须提出
3. **不编造细节** — 不知道的 API、参数、路径，直接说不知道或去查文档
4. **最小改动** — 只做需要的事，不做过度工程化

## 工程规范

- 优先用 YAGNI 原则：不写用不到的代码
- Git 提交：频繁提交，每条消息有主题行+详细说明
- 遇到复杂问题，先找根因而非修复症状
- 执行前确认操作是可逆的
- 不使用 emoji 除非用户要求

## 开发环境

- Shell: zsh (ZDOTDIR=~/.config/zsh)
- 包管理: Homebrew (Apple Silicon arm64)
- Node 管理: mise（项目级 `.mise.toml` / 全局 `mise config`）
- 工具版本: mise 管理（Go/Node/Python/fnox）；Rust 由 rustup 管理
- 密钥管理: fnox
- macOS

## 工作目录结构

- ~/git/dotfiles — 配置仓库
- ~/git/dotfiles-private — 私有配置/密钥引用
- ~/git/homedir-manager — 部署引擎

## 维护

- 定期运行 `homedir-manager audit` 检查部署完整性
- 向公开仓库推送前运行 `homedir-manager audit --secrets`
- 新机器部署：clone → homedir-manager install → 补密钥
