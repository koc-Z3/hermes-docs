# Hermes Docs Skill

<div align="right">

**English** | [简体中文](./README.zh-CN.md)

</div>

A documentation navigator for [Hermes Agent](https://hermes-agent.nousresearch.com/docs).

## What It Solves

1. Lets the `hermes-docs` skill help Hermes Agent answer any questions about documentation, installation, and configuration.
2. Reduces model hallucinations during configuration.

## How It Works

1. Search [`llms.txt`](https://hermes-agent.nousresearch.com/docs/llms.txt) for the relevant documentation path.
2. Fetch only the matching document.
3. Read only the relevant sections of that matched page, and provide a focused answer with clear guidance.

## Key Benefits

- Avoids loading the full documentation bundle, saving context.
- Enables efficient configuration with fewer hallucinations.

See [`hermes-docs.md`](./hermes-docs.md) for the complete skill instructions.
