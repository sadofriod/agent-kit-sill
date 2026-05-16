---
name: durable-multistep-tools
description: |
  当用户的 AgentKit tool 不再是一次性同步调用，而是包含多步推理、抓取、并发任务、重试或恢复需求时调用。
  适用于 research、crawl、batch processing、外部副作用链等复杂工具设计场景。
  不适用于: 简单同步 tool、单 agent 职责设计、纯 network 路由选择问题。
source_book: 《AgentKit Documentation》 Inngest
source_chapter: advanced-patterns/multi-steps-tools.mdx
tags: [agentkit, tool, inngest, durable-execution]
related_skills: [tool-trigger-contract, deterministic-router-handoff]
---

# Durable Multistep Tools

## R — 原文

> By combining your AgentKit network with Inngest, each step of your tool will be retried automatically.
>
> — Inngest, advanced-patterns/multi-steps-tools.mdx

> The `step.run()` call will run the `crawl-web` step in parallel.
>
> — Inngest, advanced-patterns/multi-steps-tools.mdx

---

## I — 方法论骨架

当一个 tool 内部已经包含多段推理、抓取、聚合或副作用操作时，继续把它写成单个 handler，问题会集中爆发在三处：失败后整段重来、并发难控、过程不可恢复。

AgentKit 文档给出的解法是，把这种 tool 升级为 Inngest function，再把内部执行显式拆成多个 step。

这样每一步都能独立重试、记录、恢复，必要时还能并发执行某些步骤，例如批量抓取网页。

本质上，这不是“把一个函数拆成几个函数”，而是把 tool 从一次性调用提升为 durable workflow，让 agent 仍以 tool 的方式使用它，但底层执行具备工程级可靠性。

---

## A1 — 书中的应用

### 案例 1: research-web tool 的三段结构
- **问题**: 一个 research tool 既要生成查询，又要抓取网页，再总结结果。
- **方法论的使用**: 文档把它实现成 Inngest function，依次执行 `generate-search-queries`、`crawl-web`、`summarize-search-results`。
- **结论**: 多步工具应把阶段切开，而不是藏在单个 handler 中。
- **结果**: 每一步都有独立失败恢复点。

### 案例 2: 并发抓取 + 自动重试
- **问题**: 抓取阶段容易失败，且批量任务本身适合并发。
- **方法论的使用**: 文档使用 `step.run()` 并配合 `Promise.all` 并发执行抓取步骤。
- **结论**: 并发与重试应作为 tool 设计的一部分，而不是事后补丁。
- **结果**: 工具执行既更快，也更稳。

---

## A2 — 触发场景

### 用户会在什么情境下需要这个 skill?

1. 一个 tool 里面已经包含多个顺序步骤，任何一步失败都让整体体验很差。
2. tool 需要调用外部系统、抓取多个资源，或存在明显的并发价值。
3. 用户需要长任务在失败后恢复，而不是从头再跑一次。

### 语言信号

- “这个 tool 一失败就得整段重来。”
- “我想让抓取步骤并发跑。”
- “这个 research workflow 能不能从中断处恢复？”

### 与相邻 skill 的区分

- 与 `tool-trigger-contract` 的区别: 本 skill 假设用户已经确定需要 tool，重点在内部执行链的耐久化。
- 与 `deterministic-router-handoff` 的区别: 本 skill 处理单个 tool 内部的 step 结构，不处理多个 agent 的下一跳选择。

---

## E — 可执行步骤

1. **识别 tool 内部的天然阶段**
   - 完成标准: 能把 tool 清晰拆成若干推理、I/O、聚合或副作用步骤。

2. **把步骤映射为 Inngest step**
   - 完成标准: 每一步都有独立名字、输入输出边界，以及可单独重试的语义。

3. **区分串行与并发部分**
   - 完成标准: 明确哪些步骤必须顺序执行，哪些可以并发，并保证最终结果仍可恢复与追踪。

---

## B — 边界

### 不要在以下情况使用此 skill

- tool 本质只是一个短小、纯同步、低失败成本的函数。
- 用户的核心痛点是 agent 职责划分或 network 路由，而不是 tool 执行链。

### 作者在材料中警告的失败模式

- 把长链工作流塞进单个 tool handler，导致失败恢复点消失。
- 只做并发，不做阶段边界和恢复设计，最后难以追踪与调试。

### 作者的盲点 / 时代局限

- 文档默认接入 Inngest；若团队不能引入该运行时，耐久能力需要自行替代。

### 容易混淆的邻近方法论

- “多步 tool”不等于“多 agent network”；前者是在一个 tool 内做 durable workflow，后者是在 agent 层做协作编排。

---

## 相关 skills

- depends-on: {tool-trigger-contract}
- contrasts-with: {}
- composes-with: {deterministic-router-handoff}

---

## 审计信息

- **验证通过**: V1 ✓ / V2 ✓ / V3 ✓
- **测试通过率**: 待执行 (详见 test-prompts.json)
- **蒸馏时间**: 2026-05-16