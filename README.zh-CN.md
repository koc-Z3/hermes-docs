# Hermes Docs (自适应技能)

<div align="right">

[English](./README.md) | **简体中文**

</div>

一个用于 [Hermes Agent](https://hermes-agent.nousresearch.com/docs) 的**文档导航器**，采用三层自适应路由器，自动选择最便宜的信息来源来回答配置问题。

## 解决的问题

1. 让 `hermes-docs` 技能帮助 Hermes Agent 回答有关**自身配置、命令、环境变量、文件路径或安装步骤**的任何问题。
2. 通过路由到权威来源（而不是猜测），降低配置时的模型幻觉。
3. 在可能的情况下优先使用本地打包文件而非网络请求，从而减少 token 消耗。

## 工作原理 — 三个层级

当代理遇到一个 Hermes 相关问题时，编排器（`skill/hermes-docs.md`）会将其路由到三个层级之一：

| 层级 | 内容 | 适用场景 | 成本 |
|------|------|----------|------|
| **T1 — 自身配置** | `skill/references/*.md` — 21 个短文件（总计约 50 KB），专供代理配置自身使用 | 单点查询：环境变量、标志、路径、当前设置 | 瞬时，无网络请求 |
| **T2 — 深度参考** | `skill/hermes-agent/` — 完整复制的 `hermes-agent` 技能（18 个参考文件，约 100 KB） | 同一系统内的多步操作、边界情况 | 瞬时，无网络请求 |
| **T3 — 实时获取** | `https://hermes-agent.nousresearch.com/docs/<path>` | 跨系统、教程、未打包的内容 | 网络请求（约 17 KB 索引 + 页面） |

**自身配置问题的默认值：T1。** 只有当 T1 明确要求升级，或没有 T1 文件能匹配时，编排器才会升级到更高层级。

## 主要优势

- **自适应路由** — 针对每个问题选择最便宜的能回答它的层级。简单问题保持快速，复杂问题获取完整文档。
- **不重复来源** — T1 和 T2 覆盖不同的范围（T1 = 代理自身配置，T2 = 面向用户的一般参考）。T3 是始终保持最新的回退方案。
- **支持离线** — T1 和 T2 不需要网络。T3 是唯一需要连接的层级。
- **自我提升目标** — 旨在让代理更擅长配置自身设置，而不仅仅是帮助用户。

## 仓库结构

```
hermes-docs/
├── README.md                  ← 英文版
├── README.zh-CN.md            ← 本文件
└── skill/
    ├── hermes-docs.md         ← 编排器（路由逻辑）
    ├── INDEX.md               ← 主题 → 层级 路由表
    ├── references/            ← T1：代理自身配置（21 个文件，约 50 KB）
    │   ├── paths.md
    │   ├── env-vars.md
    │   ├── providers.md
    │   ├── ... (还有 17 个)
    ├── hermes-agent/          ← T2：深度层级（打包的 hermes-agent 技能）
    │   ├── SKILL.md
    │   ├── references/        (18 个文件)
    │   └── templates/         (3 个文件)
    └── examples/              ← 配置示例演练
        ├── example-cli-flags.md
        ├── example-messaging-setup.md
        └── example-self-config.md
```

## 代理如何使用本技能

1. **阅读 `skill/hermes-docs.md`** — 这是编排器，定义了路由规则。
2. **阅读 `skill/INDEX.md`** — 找到主题，获取层级分配。
3. **加载文件** — T1 文件在 `references/`，T2 文件在 `hermes-agent/references/`，T3 URL 在文档目录中。
4. **回答** — 在回复中注明来源文件或 URL。

## 维护说明

打包的 `hermes-agent/` 层级是 [NousResearch/hermes-agent 的 `skills/autonomous-ai-agents/hermes-agent/`](https://github.com/NousResearch/hermes-agent/tree/main/skills/autonomous-ai-agents/hermes-agent) 的逐字复制版本。当上游变更时，应当**重新同步**。

T1 的 `references/` 层级在此处维护，刻意聚焦于**代理自身配置**——并非通用的 Hermes 参考。通用参考位于 T2（以及 T3 的实时文档）。

## 另请参阅

- 实时文档：https://hermes-agent.nousresearch.com/docs
- 打包的 `hermes-agent` 技能：https://github.com/NousResearch/hermes-agent/tree/main/skills/autonomous-ai-agents/hermes-agent
- 配置示例：`skill/examples/`
