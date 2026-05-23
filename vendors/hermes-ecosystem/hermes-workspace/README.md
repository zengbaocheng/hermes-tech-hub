# hermes-workspace

> **来源**: [outsourc-e/hermes-workspace](https://github.com/outsourc-e/hermes-workspace)
> ⭐ 4728 | 🍴 670 | 📝 Native web workspace for Hermes Agent — chat, terminal, memory, skills, inspecto
> 🏷️  agent-ui,ai-workspace,hackathon,hermes-agent,nous-research | 📅 最后更新: 2026-05-21T23:30:50Z
> 🛠️  Language: JavaScript

## 概览

从 GitHub 爬取的外部项目，与 Hermes Agent 生态相关。

## 核心技术

<div align="center">

<img src="./public/claude-avatar.webp" alt="Hermes Workspace" width="80" style="border-radius: 16px" />
<!-- avatar filename retained for cache stability — do not rename without coordinated cache-bust -->

# Hermes Workspace

**Your AI agent's command center — chat, files, memory, skills, and terminal in one place.**

[![Version](https://img.shields.io/badge/version-2.3.0-2557b7.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Node](https://img.shields.io/badge/node-%3E%3D22.0.0-brightgreen.svg)](https://nodejs.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-6366F1.svg)](CONTRIBUTING.md)

> Not a chat wrapper. A complete workspace — orchestrate agents, browse memory, manage skills, and control everything from one interface.

> **v2 — zero-fork.** Clone, don't fork. Runs on vanilla [`NousResearch/hermes-agent`](https://github.com/NousResearch/hermes-agent) installed via Nous's own installer. Chat, sessions, memory, skills, jobs, MCP, terminal, dashboard, Agent View, and Operations are all in vanilla parity. **Conductor** uses the dashboard mission API when available and falls back to Workspace-native Swarm dispatch (`mode: native-swarm`) when the dashboard endpoint is absent, preserving zero-fork behavior ([#262](https://github.com/outsourc-e/hermes-workspace/issues/262)).

![Hermes Workspace](./docs/screenshots/splash.png)

</div>

---

## Swarm Mode

Hermes Agent Swarm turns the workspace into a live control plane: unlimited Hermes Agents, 1 orchestrator, 0 humans manually dispatching.
Persistent tmux workers keep context across tasks, rotate safely, and report proof-bearing checkpoints.
Role-based dispatch routes builders, reviewers, docs, research, ops, triage, QA, and lab lanes without turning Eric into the task router.
A byte-verified review gate protects release branches before PRs ship.
Autonomous PR/issue lanes, lab experiments, and the repair playbook keep the machine moving

---

*自动爬取于 2026-05-23 | 完整仓库: [https://github.com/outsourc-e/hermes-workspace](https://github.com/outsourc-e/hermes-workspace)*
