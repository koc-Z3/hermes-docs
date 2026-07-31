---
topic: backends
tier: 1
audience: agent-self-config
last_verified: 2026-07-31
---

# Backends (where the agent's terminal runs)

The agent's `terminal` tool runs commands in a backend. The default is `local`; others give you isolation.

## Backends

| Backend | What it does | When to use |
|---|---|---|
| `local` | Runs on your machine | Default. Trust yourself. |
| `docker` | Runs inside a Docker container | Isolation, reproducibility, throwaway envs |
| `ssh` | Runs on a remote host over SSH | Run on a beefy box, access remote systems |
| `daytona` | Managed dev environment | Cloud dev sandboxes |
| `modal` | Serverless compute | Ephemeral, GPU access |
| `singularity` | HPC / cluster | Shared clusters |

## Find current backend

```bash
hermes config get terminal.backend
hermes status --all | grep backend
```

## Switch backend

```bash
hermes config set terminal.backend docker
hermes config set terminal.docker.image "python:3.12-slim"
hermes config set terminal.ssh.host "user@host"
```

## Per-session override

```bash
hermes --backend docker -q "run tests"
```

## Sandbox inside local

Even with `local` backend, you can sandbox the terminal:

```bash
hermes config set security.sandbox enabled
hermes config set security.sandbox.type firejail   # or bubblewrap, docker
```

## Self-check

```bash
hermes config get terminal.backend
hermes status --all | grep -i backend
hermes -q "echo $HOSTNAME"           # verify which host is actually running
```

## Escalate to T2 when:

- Setting up Docker backend from scratch → T3 `/user-guide/docker`
- SSH backend config (jump hosts, keys, port forwarding) → `hermes-agent/references/configuration.md`
- Daytona / Modal / Singularity setup → T3 `/getting-started/installation` (per-backend notes)
- Sandbox not isolating as expected → T3 `/user-guide/security`
- A backend command fails → `hermes-agent/references/troubleshooting.md`
