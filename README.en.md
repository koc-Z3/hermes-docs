---
name: hermes-docs
description: Use when the user asks for documentation, configuration files, setup guides, or details regarding Hermes Agent.
triggers:
  - "hermes agent config"
  - "hermes documentation"
  - "hermes setup"
  - "how to configure hermes agent"
---

# Hermes Agent Documentation Navigator

Don't drown the context window. NEVER download or ingest `llms-full.txt` (~1.8 MB) in a single request unless you actively enjoy hitting token limits. Follow this strict two-step retrieval procedure instead:

## Retrieval Workflow

### Step 1: Query the Lightweight Index
Fetch the tiny index file to find the relative URL path for the requested topic:
- **URL:** `https://hermes-agent.nousresearch.com/docs/llms.txt` (~17 KB)
- Scan the file for the specific page path matching the user's topic (e.g., `/docs/user-guide/configuration`, `/docs/getting-started/quickstart`).

### Step 2: Fetch Only the Targeted Sub-Page
Using the URL path identified in Step 1, issue a single targeted fetch request for that specific page only:
- **Target URL Pattern:** `https://hermes-agent.nousresearch.com<TARGET_PATH>`
- Parse only this retrieved body text to answer the user's question.

---

## Strict Constraints
- **Context Guard:** Do NOT fetch `llms-full.txt` unless the user explicitly begs for a complete documentation dump.
- **Chunking Rule:** If a single sub-page exceeds 20 KB, read only the relevant sections or header blocks matching the user's query.
