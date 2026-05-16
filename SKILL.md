---
name: agent-kit-docs-skill
description: |
  当用户要用 Inngest AgentKit 设计 agent、tool、network 或 router，并且问题集中在职责切分、触发条件、状态路由、耐久执行时调用。
  适用于“单 agent 何时该升级成 network”“tool 描述怎么写才会被正确调用”“如何用状态驱动多 agent 流转”“复杂 tool 怎么做成可重试工作流”这类场景。
  不适用于: 纯安装报错、单个 API 参数查询、与 AgentKit 无关的通用 AI 架构讨论。
source_book: 《AgentKit Documentation》 Inngest
source_chapter: docs/src/content/docs
tags: [agentkit, agents, tools, routing, inngest]
related_skills: [agent-goal-boundary, tool-trigger-contract, shared-state-shaping, deterministic-router-handoff, durable-multistep-tools]
---

# AgentKit Documentation Skill Pack

这个 skill 包把 AgentKit 文档中最稳定、最可复用的方法论蒸馏成 5 个原子 skill。

## 何时使用

当用户遇到以下问题时，优先激活本 skill 包，再路由到对应原子 skill：

1. 不知道 agent 应该只靠 prompt，还是需要补 tools、state、router。
2. tool 已经写了，但模型调用不稳定，或 handler 边界混乱。
3. 多个 agent 可以工作，但切换顺序不可预测、难测试、容易死循环。
4. 一个 tool 内部包含搜索、抓取、总结等多段流程，需要重试与并发控制。

## 路由规则

- 若用户核心问题是“单个 agent 到底该负责什么、不该负责什么”，调用 `agent-goal-boundary`。
- 若用户核心问题是“tool 为什么不被调用、description 和参数怎么写”，调用 `tool-trigger-contract`。
- 若用户核心问题是“state 里该放什么，才能支撑多 agent 协作”，调用 `shared-state-shaping`。
- 若用户核心问题是“router 如何 handoff、何时停止、如何避免死循环”，调用 `deterministic-router-handoff`。
- 若用户核心问题是“复杂 tool 如何拆成可重试、可恢复的多步流程”，调用 `durable-multistep-tools`。

## 使用边界

- 不要把整个 skill 包一次性灌给用户。先判断失败点在 agent、network，还是 tool 内部执行链。
- 如果用户只是在问某个函数签名或安装方式，本 skill 包只提供最低限度的结构建议。
- 如果用户要的是完全自治、不可预测的探索型 agent，本 skill 包会优先建议先做确定性收敛，而不是继续放大自由度。

## 相关文档

- 见 `BOOK_OVERVIEW.md` 获取文档骨架与术语。
- 见 `INDEX.md` 查看 3 个原子 skill 的关系图。