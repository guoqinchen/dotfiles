# Pi Agent 用户手册

> **版本**: 0.80.3 | **最后更新**: 2026-07-08 | **项目主页**: [pi.dev](https://pi.dev)
> **仓库**: [github.com/earendil-works/pi-coding-agent](https://github.com/earendil-works/pi-coding-agent)
> **安装方式**: `npm install -g @earendil-works/pi-coding-agent`

---

## 目录

1. [产品概述](#1-产品概述)
2. [安装部署](#2-安装部署)
3. [快速上手](#3-快速上手)
4. [核心功能介绍](#4-核心功能介绍)
5. [配置参数说明](#5-配置参数说明)
6. [LLM 提供商配置](#6-llm-提供商配置)
7. [会话管理](#7-会话管理)
8. [扩展开发](#8-扩展开发)
9. [技能系统](#9-技能系统)
10. [安全机制](#10-安全机制)
11. [日常维护](#11-日常维护)
12. [故障排查](#12-故障排查)
13. [附录](#13-附录)

---

## 1. 产品概述

### 1.1 什么是 Pi Agent

Pi Agent 是一款**终端 AI 编码助手框架**，以 npm 包形式分发，采用 TypeScript 编写。它通过 CLI 提供交互式 AI 编码辅助，核心设计哲学是**保持精简核心、通过扩展机制增强功能**。

### 1.2 核心特性

| 特性 | 说明 |
|------|------|
| **AI 编码助手** | 内置 read/write/edit/bash 工具，支持全流程编码协作 |
| **多 LLM 提供商** | 支持 Anthropic、OpenAI、Google Gemini、DeepSeek 等 20+ 提供商 |
| **交互式/非交互双模式** | 既可交互式会话，也可 `-p` 参数一次性执行 |
| **会话管理** | 自动保存、分支/分叉/克隆、历史回溯 |
| **扩展系统** | TypeScript 模块，可注册工具/命令/事件 |
| **技能系统** | SKILL.md 渐进式加载，按需注入系统提示 |
| **多模型切换** | 运行时 Ctrl+P 切换模型，支持思考级别设置 |
| **RPC 模式** | JSONL 标准 I/O，适合嵌入其他工具链 |

---

## 2. 安装部署

### 2.1 系统要求

| 项目 | 要求 |
|------|------|
| **运行时** | Node.js >= 18.x |
| **操作系统** | macOS / Linux / Windows |
| **终端** | 支持 256 色和 Unicode |

### 2.2 安装方式

#### 方式一：npm 全局安装（推荐）

```bash
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

`--ignore-scripts` 可禁用依赖的生命周期脚本（非必需，建议添加以提高安全性）。

#### 方式二：一键安装脚本（macOS/Linux）

```bash
curl -fsSL https://pi.dev/install.sh | sh
```

### 2.3 验证安装

```bash
pi --version
# 输出: 0.80.3
```

### 2.4 更新

```bash
# 更新 Pi 自身
pi update self

# 更新 Pi 及所有扩展
pi update --all
```

### 2.5 卸载

```bash
npm uninstall -g @earendil-works/pi-coding-agent
```

---

## 3. 快速上手

### 3.1 首次启动

```bash
cd your-project-directory
pi
```

首次启动时，Pi 会检查 LLM 提供商认证：

- **订阅制提供商**（如 Anthropic）：运行后输入 `/login` 进行 OAuth 认证
- **API Key 提供商**：提前设置环境变量

### 3.2 设置 API Key

```bash
# Anthropic Claude
export ANTHROPIC_API_KEY=sk-ant-xxxxxxxxxxxx

# OpenAI
export OPENAI_API_KEY=sk-xxxxxxxxxxxx

# Google Gemini
export GEMINI_API_KEY=xxxxxxxxxxxx
```

### 3.3 基础使用

```bash
# 交互模式（启动后输入自然语言指令）
pi

# 带初始提示启动
pi "列出 src/ 目录下所有 TypeScript 文件"

# 包含文件上下文
pi @package.json @README.md "解释这个项目的结构"

# 非交互模式（执行后立即退出）
pi -p "统计 src/ 中的代码行数"

# 管道输入
cat README.md | pi -p "用中文总结这段内容"

# 图片输入
pi @screenshot.png "这个界面有什么问题？"
```

### 3.4 内置命令

在交互模式下，输入斜杠命令：

| 命令 | 功能 |
|------|------|
| `/session` | 显示当前会话信息 |
| `/tree` | 查看会话分支树 |
| `/fork` | 从当前消息分叉新会话 |
| `/clone` | 复制当前分支到新会话文件 |
| `/compact` | 压缩旧消息释放上下文 |
| `/reload` | 热重载扩展 |
| `/settings` | 打开设置管理 |
| `/login` | 进行 OAuth 认证 |
| `/help` | 显示帮助信息 |
| `Ctrl+P` | 快速切换 AI 模型 |
| `Ctrl+C` | 中断当前操作 |
| `Ctrl+D` | 退出会话 |

---

## 4. 核心功能介绍

### 4.1 内置工具

Pi 提供以下内置工具供 LLM 调用：

| 工具名 | 功能 | 默认启用 | 说明 |
|--------|------|---------|------|
| `read` | 读取文件内容 | ✅ 是 | 支持文本和二进制文件 |
| `bash` | 执行 Shell 命令 | ✅ 是 | 以启动用户权限运行 |
| `edit` | 编辑文件（查找替换） | ✅ 是 | 精确替换模式编辑 |
| `write` | 写入文件（创建/覆盖） | ✅ 是 | 新建或完全覆盖 |
| `grep` | 搜索文件内容 | ❌ 否 | 类似 ripgrep |
| `find` | 按 glob 查找文件 | ❌ 否 | 类似 fd/find |
| `ls` | 列出目录内容 | ❌ 否 | 类似 ls |

**工具控制选项**：

```bash
# 只启用只读工具
pi --tools read,grep,find,ls -p "审查 src/ 中的代码"

# 禁用特定工具
pi --exclude-tools bash

# 禁用所有工具
pi --no-tools

# 禁用内置工具（保留扩展工具）
pi --no-builtin-tools
```

### 4.2 文件传递

通过 `@` 前缀传递文件内容到 AI 上下文：

```bash
# 传递单个文件
pi @src/index.ts "检查这个文件的类型安全"

# 传递多个文件 + 图片
pi @prompt.md @screenshot.png "分析这张截图"

# 传递目录（会显示目录结构）
pi @src/components
```

### 4.3 思考级别

对于支持推理的模型（如 Claude Sonnet），可设置思考级别：

```bash
# 设置思考级别
pi --thinking high "解决这个复杂算法问题"

# 在模型选择中固定思考级别
pi --models sonnet:high,haiku:low
```

思考级别选项：`off`、`minimal`、`low`、`medium`、`high`、`xhigh`

### 4.4 模型热切换

运行时按 `Ctrl+P` 可在预设模型列表中循环切换：

```bash
# 预设可切换的模型列表
pi --models claude-sonnet,claude-haiku,gpt-4o

# 按提供商模式匹配
pi --models "github-copilot/*"

# 固定思考级别的模型列表
pi --models sonnet:high,haiku:low
```

---

## 5. 配置参数说明

### 5.1 配置文件层级

Pi 的配置分为两层，项目级覆盖全局级：

| 层级 | 路径 |
|------|------|
| **全局设置** | `~/.pi/agent/settings.json` |
| **项目设置** | `.pi/settings.json` |

### 5.2 配置项说明

```json
{
  "theme": "my-theme",
  "skills": ["~/.claude/skills", "~/.codex/skills"],
  "compaction": {
    "enabled": true,
    "reserveTokens": 2000,
    "keepRecentTokens": 500
  },
  "shellPath": "/bin/zsh",
  "shellCommandPrefix": "shopt -s expand_aliases\neval \"$(grep '^alias ' ~/.zshrc)\"",
  "defaultProjectTrust": "ask"
}
```

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `theme` | string | auto | 主题名称（基于终端背景自动选 dark/light） |
| `skills` | string[] | [] | 外部技能目录路径 |
| `compaction.enabled` | boolean | true | 启用上下文压缩 |
| `compaction.reserveTokens` | number | 2000 | 压缩预留的 token 数 |
| `compaction.keepRecentTokens` | number | 500 | 保留的最近 token 数 |
| `shellPath` | string | 系统默认 | 自定义 Shell 路径 |
| `shellCommandPrefix` | string | "" | Shell 命令前缀（如别名扩展） |
| `defaultProjectTrust` | string | "ask" | 项目信任默认行为（ask/allow/deny） |

### 5.3 CLI 选项速查

| 选项 | 简写 | 说明 |
|------|------|------|
| `--print` | `-p` | 非交互模式，执行后退出 |
| `--continue` | `-c` | 继续最近会话 |
| `--resume` | `-r` | 选择要恢复的会话 |
| `--name` | `-n` | 设置会话显示名称 |
| `--model` | | 指定模型（支持 `provider/id` 格式） |
| `--provider` | | 指定提供商 |
| `--thinking` | | 设置思考级别 |
| `--tools` | `-t` | 工具允许列表（逗号分隔） |
| `--exclude-tools` | `-xt` | 工具拒绝列表 |
| `--no-tools` | `-nt` | 禁用所有工具 |
| `--verbose` | | 详细启动日志 |
| `--approve` | `-a` | 信任项目本地文件 |
| `--offline` | | 禁用启动时网络操作 |
| `--session` | | 使用指定会话 ID |
| `--fork` | | 分叉现有会话 |
| `--mode` | | 输出模式（text/json/rpc） |

---

## 6. LLM 提供商配置

### 6.1 支持的内置提供商

Pi 内置支持 20+ LLM 提供商。设置对应环境变量即可使用：

| 提供商 | 环境变量 | 默认模型 |
|--------|---------|---------|
| Anthropic | `ANTHROPIC_API_KEY` | claude-sonnet |
| OpenAI | `OPENAI_API_KEY` | gpt-4o |
| Google Gemini | `GEMINI_API_KEY` | gemini-2.0-flash |
| DeepSeek | `DEEPSEEK_API_KEY` | deepseek-chat |
| Groq | `GROQ_API_KEY` | llama-3.3 |
| OpenRouter | `OPENROUTER_API_KEY` | 按路由选择 |
| Amazon Bedrock | `AWS_PROFILE` + `AWS_REGION` | 按配置选择 |
| GitHub Copilot | 自动 OAuth | gpt-4o |

完整列表见 [pi.dev/docs/latest/providers](https://pi.dev/docs/latest/providers)。

### 6.2 OAuth 订阅提供商

```bash
pi
# 在交互式终端中输入:
/login
# 按提示完成浏览器认证
```

### 6.3 自定义模型

创建 `~/.pi/agent/models.json`：

```json
[
  {
    "id": "ollama/llama3",
    "name": "Llama 3 (Local)",
    "provider": {
      "baseUrl": "http://localhost:11434/v1",
      "apiKey": "$OLLAMA_API_KEY",
      "api": "openai-completions"
    },
    "contextWindow": 8192,
    "maxTokens": 4096
  }
]
```

### 6.4 自定义提供商

通过扩展注册自定义提供商：

```typescript
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerProvider("my-provider", {
    name: "My Provider",
    baseUrl: "https://api.example.com/v1",
    apiKey: "$MY_API_KEY",
    api: "openai-completions",
    models: [
      { id: "my-model", name: "My Model", contextWindow: 32768 }
    ]
  });
}
```

---

## 7. 会话管理

### 7.1 会话存储

Pi 自动将会话保存到 `~/.pi/agent/sessions/` 目录，文件格式为 JSONL。

### 7.2 基本操作

```bash
# 继续最近会话
pi -c

# 浏览历史会话并选择恢复
pi -r

# 以指定名称启动会话
pi --name "重构认证模块"

# 临时模式（不保存会话）
pi --no-session
```

### 7.3 分支管理

Pi 支持在同一个会话中创建分支，探索不同解决方案路径：

```
会话文件
├── 主分支（初始方案）
│   ├── 消息 1: 分析需求
│   ├── 消息 2: 实现方案 A
│   └── 消息 3: 优化
├── 分支 1（方案 B）
│   ├── 消息 2: 实现方案 B
│   └── 消息 3: 测试
└── 分支 2（方案 A 的另一种优化方向）
    └── 消息 3: 不同优化策略
```

**交互式命令**：

| 命令 | 功能 |
|------|------|
| `/tree` | 查看并导航分支树，可包含分支摘要 |
| `/fork` | 从当前消息创建新会话文件 |
| `/clone` | 将当前分支复制到新会话文件 |
| `/compact` | 总结旧消息释放上下文 |

### 7.4 上下文压缩

长会话中，`/compact` 可总结旧消息以释放 token 空间。配置：

```json
{
  "compaction": {
    "enabled": true,
    "reserveTokens": 2000,
    "keepRecentTokens": 500
  }
}
```

### 7.5 导出会话

```bash
# 导出为 HTML
pi --export session.jsonl output.html
pi --export ~/.pi/agent/sessions/--path--/session.jsonl
```

---

## 8. 扩展开发

### 8.1 扩展目录结构

```
~/.pi/agent/extensions/          # 全局扩展
.my-project/.pi/extensions/      # 项目级扩展
```

### 8.2 基础扩展模板

```typescript
// ~/.pi/agent/extensions/my-extension.ts
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  // 注册工具
  pi.registerTool({
    name: "my_tool",
    label: "My Tool",
    description: "一个自定义工具",
    parameters: {
      type: "object",
      properties: {
        input: { type: "string" }
      }
    },
    async execute({ input }, ctx) {
      return `处理结果: ${input}`;
    }
  });

  // 注册命令
  pi.registerCommand("hello", {
    description: "打招呼",
    handler: async (_args, ctx) => {
      ctx.ui.notify("你好！");
    }
  });

  // 监听事件
  pi.on("session_start", async (_event, ctx) => {
    console.log("会话已启动");
  });

  pi.on("tool_call", async (event, ctx) => {
    console.log(`工具调用: ${event.tool}`);
  });
}
```

### 8.3 热重载

修改扩展后，在 Pi 交互终端中运行 `/reload` 即可加载最新代码，无需重启。

### 8.4 扩展 API

| API | 说明 |
|-----|------|
| `pi.registerTool(definition)` | 注册 LLM 可调用的工具 |
| `pi.registerCommand(name, def)` | 注册斜杠命令 |
| `pi.on(event, handler)` | 监听生命周期事件 |
| `pi.appendEntry(entry)` | 持久化状态（跨重启） |
| `pi.setActiveTools(tools)` | 运行时启用/禁用工具 |
| `pi.registerProvider(name, config)` | 注册 LLM 提供商 |
| `ctx.ui.notify()` | 发送通知 |
| `ctx.ui.confirm()` | 请求确认 |
| `ctx.ui.prompt()` | 请求输入 |
| `ctx.navigateTree(path)` | 导航到会话树节点 |

---

## 9. 技能系统

### 9.1 什么是技能

技能（Skill）是包含 `SKILL.md` 文件和辅助目录的目录结构。Pi 采用**渐进式加载策略**：启动时只将技能名称和描述放入系统提示，当 LLM 判断任务匹配时才加载完整的 `SKILL.md` 指令。

### 9.2 技能目录结构

```
my-skill/
├── SKILL.md        # 必需：frontmatter + 指令
├── scripts/        # 辅助脚本
├── references/     # 按需加载的详细文档
└── assets/         # 资源文件
```

### 9.3 SKILL.md 格式

```markdown
---
name: my-skill
description: 这个技能用于处理...
settings:
  model: claude-sonnet
  thinking: high
---

# My Skill 指令

当此技能被激活时，请遵循以下步骤：

1. 第一步：...
2. 第二步：...
3. 第三步：...

## 注意事项

- 重要提醒 1
- 重要提醒 2
```

### 9.4 技能加载位置

| 层级 | 路径 |
|------|------|
| 全局 | `~/.pi/agent/skills/` |
| 兼容 | `~/.agents/skills/`（Claude Code 兼容） |
| 项目 | `.pi/skills/` |
| 设置 | 通过 `skills` 数组配置 |
| CLI | `pi --skill <path>` 直接指定 |

---

## 10. 安全机制

### 10.1 权限模型

Pi 以启动用户的账户权限运行命令，本身不提供沙箱隔离。它不会限制模型在受信任目录中要求工具执行的操作。

### 10.2 项目信任

Pi 对项目目录有信任检查机制。当项目包含本地设置或扩展时，Pi 会询问是否信任：

```
检测到项目包含本地设置文件：
  .pi/settings.json
  是否信任此项目？[y/N]
```

信任决策保存在 `~/.pi/agent/trust.json`。

**触发信任检查的条件**：项目目录中存在以下任一文件：`.pi/settings.json`、`.pi/extensions`、`.pi/skills`、`.pi/prompts`、`.pi/themes`、`.pi/SYSTEM.md`、`.pi/APPEND_SYSTEM.md`。

**配置默认行为**：

```json
{
  "defaultProjectTrust": "ask"   // ask | allow | deny
}
```

### 10.3 安全建议

- **认证文件权限**：`~/.pi/agent/auth.json` 应设为 `0600` 权限
- **容器运行建议**：
  - 仅挂载必要的工作区路径
  - 避免挂载敏感主机目录（如 `~/.pi/agent`）
  - 使用短期凭证
  - 限制网络访问
- **Prompt 注入**：属于已知风险，Pi 无法可靠防止

### 10.4 沙箱集成

Pi 支持通过 Gondolin、Docker 或 OpenShell 进行容器化运行：

```bash
# Docker 沙箱运行
docker run -v $(pwd):/workspace pi-agent

# 参见官方容器化文档
pi.dev/docs/latest/containerization
```

---

## 11. 日常维护

### 11.1 建议维护计划

| 频率 | 任务 | 命令 |
|------|------|------|
| **每次使用前** | 检查版本 | `pi --version` |
| **每周** | 更新 Pi | `pi update self` |
| **每月** | 清理旧会话 | `rm -rf ~/.pi/agent/sessions/` |
| **每月** | 审核已安装扩展 | `pi list` |
| **按需** | 更新扩展 | `pi update --all` |

### 11.2 配置文件位置

```
~/.pi/
└── agent/
    ├── auth.json          # API 密钥（权限 0600）
    ├── settings.json      # 全局设置
    ├── trust.json         # 项目信任记录
    ├── models.json        # 自定义模型（可选）
    ├── sessions/          # 会话存储
    ├── extensions/        # 全局扩展
    ├── skills/            # 全局技能
    └── themes/            # 自定义主题
```

### 11.3 与 dotfiles 集成

Pi 的配置文件可以纳入 dotfiles 管理。建议策略：

| 文件 | 是否纳入 dotfiles | 说明 |
|------|-------------------|------|
| `settings.json` | ✅ 可纳入 | 非敏感通用配置 |
| `auth.json` | ❌ 绝不纳入 | 包含 API 密钥 |
| `trust.json` | ❌ 不推荐 | 机器专属 |
| `models.json` | ✅ 可纳入 | 自定义模型配置 |
| 扩展/技能 | ✅ 可纳入 | 可复用的开发资产 |

---

## 12. 故障排查

### 12.1 常见问题

#### Q: 安装后 `pi` 命令找不到

```bash
# 确认 npm 全局 bin 在 PATH 中
npm bin -g
# 输出示例: /Users/xxx/.local/share/mise/installs/node/lts/bin
# 确保此路径在 $PATH 中
```

#### Q: API 认证失败

```bash
# 检查环境变量是否设置
echo $ANTHROPIC_API_KEY

# 或者运行 /login 进行 OAuth 认证
pi
/login
```

#### Q: 会话丢失

所有会话自动保存在 `~/.pi/agent/sessions/`：

```bash
ls ~/.pi/agent/sessions/
pi -r  # 浏览历史会话
```

#### Q: 扩展不生效

```bash
# 运行热重载
/reload

# 检查扩展是否已加载
pi list

# 检查语法错误
node -c ~/.pi/agent/extensions/my-extension.ts
```

#### Q: 输出模式问题

```bash
# 切换到文本模式（默认）
pi --mode text

# 导出会话并检查
pi --export session.jsonl output.html
```

### 12.2 诊断命令

```bash
# 版本和构建信息
pi --version

# 列出可用模型
pi --list-models

# 详细启动日志
pi --verbose

# 离线模式（跳过网络操作）
pi --offline

# 列出已安装扩展
pi list
```

---

## 13. 附录

### 13.1 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|---------|
| 0.80.3 | 2026-07 | 当前版本 |

### 13.2 环境变量速查

```bash
# 核心 API Key
export ANTHROPIC_API_KEY=sk-ant-...      # Claude
export OPENAI_API_KEY=sk-...             # OpenAI
export GEMINI_API_KEY=...                # Gemini

# 配置目录
export PI_CODING_AGENT_DIR=~/.pi/agent   # 配置根目录
export PI_CODING_AGENT_SESSION_DIR=...   # 会话存储目录
export PI_PACKAGE_DIR=...                # 包目录（Nix/Guix 覆盖）

# 运行模式
export PI_OFFLINE=1                      # 离线模式
export PI_TELEMETRY=0                    # 禁用遥测
```

### 13.3 参考链接

| 资源 | 链接 |
|------|------|
| 官方文档 | [pi.dev/docs/latest](https://pi.dev/docs/latest) |
| GitHub | [github.com/earendil-works/pi-coding-agent](https://github.com/earendil-works/pi-coding-agent) |
| 快速开始 | [pi.dev/docs/latest/quickstart](https://pi.dev/docs/latest/quickstart) |
| 提供商配置 | [pi.dev/docs/latest/providers](https://pi.dev/docs/latest/providers) |
| 扩展开发 | [pi.dev/docs/latest/extensions](https://pi.dev/docs/latest/extensions) |
| 技能系统 | [pi.dev/docs/latest/skills](https://pi.dev/docs/latest/skills) |
| 会话管理 | [pi.dev/docs/latest/sessions](https://pi.dev/docs/latest/sessions) |
| 安全指南 | [pi.dev/docs/latest/security](https://pi.dev/docs/latest/security) |

### 13.4 文档存档

| 项目 | 内容 |
|------|------|
| 文档路径 | `~/git/dotfiles/docs/pi-agent-manual.md` |
| 对应版本 | pi v0.80.3 |
| 存档格式 | Markdown (GFM) |
| 更新机制 | 随 Pi 版本升级同步更新 |

---

> **版权声明**: 本文档基于 [Pi Agent 官方文档](https://pi.dev/docs/latest) 编写，遵循项目开源许可协议。
> 文档版本 v0.80.3，与安装的 Pi Agent 版本保持一致。
