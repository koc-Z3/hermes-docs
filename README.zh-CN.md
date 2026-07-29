# Hermes Docs

<div align="right">

[English](./README.md) | **简体中文**

</div>

一个轻量级的 [Hermes Agent](https://hermes-agent.nousresearch.com/docs) 文档导航工具。

## 用途

此技能帮助 Hermes Agent 高效回答有关文档、安装和配置的问题。它会先搜索精简的文档索引，再仅获取相关页面，从而避免不必要的上下文占用。

## 工作原理

1. 在 [`llms.txt`](https://hermes-agent.nousresearch.com/docs/llms.txt) 中查找相关文档路径。
2. 仅获取匹配的页面。
3. 阅读相关章节并提供有针对性的答案。

## 主要优势

- 减少令牌和上下文占用
- 避免加载完整文档包
- 提供更快、更精准的答案

完整的技能说明请参阅 [`hermes-docs.md`](./hermes-docs.md)。