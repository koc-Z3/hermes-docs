# Hermes Docs

<div align="right">

**English** | [简体中文](./README.zh-CN.md)

</div>

A lightweight documentation navigator for [Hermes Agent](https://hermes-agent.nousresearch.com/docs).

## Purpose

This skill helps Hermes Agent answer documentation, setup, and configuration questions efficiently. It first searches the compact documentation index, then retrieves only the relevant page—avoiding unnecessary context usage.

## How It Works

1. Search [`llms.txt`](https://hermes-agent.nousresearch.com/docs/llms.txt) for the relevant documentation path.
2. Fetch only the matching page.
3. Read the relevant sections and provide a focused answer.

## Key Benefits

- Minimizes token and context usage
- Avoids loading the full documentation bundle
- Produces faster, more targeted answers

See [`hermes-docs.md`](./hermes-docs.md) for the complete skill instructions.