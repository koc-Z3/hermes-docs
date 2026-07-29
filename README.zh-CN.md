# Hermes Docs Skill

<div align="right">

[English](./README.md) | **简体中文**

</div>

[Hermes Agent](https://hermes-agent.nousresearch.com/docs) 文档导航工具

## 解决的问题

1. hermes-docs skill 帮助 Hermes Agent 回答有关文档、安装和配置所遇到的问题
2. 降低配置时模型的幻觉


## 工作原理

1. 在 [`llms.txt`](https://hermes-agent.nousresearch.com/docs/llms.txt) 中查找相关文档路径
2. 仅获取匹配的页面
3. 只阅读相关匹配的页面里的章节, 并提供有针对性的答案和指事

## 主要优势

- 避免加载完整文档包, 省下下文
- 提供更精准的答案, 减少幻觉

完整的技能说明请参阅 [`hermes-docs.md`](./hermes-docs.md)
