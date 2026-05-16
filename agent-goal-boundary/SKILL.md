---
name: agent-goal-boundary
description: |
  当用户在用 AgentKit 设计单个 agent，并且问题集中在“这个 agent 到底该负责什么、不该负责什么”时调用。
  适用于职责不断膨胀、一个 agent 同时承担规划检索写作审查、system prompt 越写越长的场景。
  不适用于: tool 触发细节、network 中多个 agent 的 handoff、复杂 tool 的 durable execution。
source_book: 《AgentKit Documentation》 Inngest
source_chapter: concepts/agents.mdx + concepts/networks.mdx
tags: [agentkit, agent, role-design]
related_skills: [tool-trigger-contract, shared-state-shaping]
---

# Agent Goal Boundary

## R — 原文

> Agents are stateless entities with a defined goal.
>
> — Inngest, concepts/agents.mdx

> Networks use multiple Agents to work together with persisted State.
>
> — Inngest, concepts/agents.mdx

---

## I — 方法论骨架

先把单个 agent 看成一个目标非常窄的执行单元，而不是整个系统的万能代言人。

如果一个 agent 同时承担规划、检索、执行、总结、审查，那么 system prompt 很快会变成巨大的规则堆，模型也更难稳定判断当前应该做哪一种事。

AgentKit 的隐含边界是：单个 agent 只围绕一个明确 goal 工作；当任务天然需要多个阶段或多种角色时，应把复杂性外移到 tools、state 或 network，而不是继续往一个 agent 里堆职责。

---

## A1 — 书中的应用

### 案例 1: 简单 agent 从单一 goal 开始
- **问题**: 开发者容易先造一个什么都做的 agent。
- **方法论的使用**: 文档在最基础示例里只要求 `name`、`system`、`model`，先把 agent 定义成围绕一个目标的实体。
- **结论**: 设计顺序应先收紧角色，再决定是否扩展能力。
- **结果**: agent 本身保持轻量，复杂性可继续外移。

### 案例 2: 复杂协作交给 network
- **问题**: 更大的目标需要多个角色配合。
- **方法论的使用**: 文档把多角色协作交给 network、state、router，而不是继续扩大单 agent。
- **结论**: 当任务跨越多个阶段时，拆角色比扩 prompt 更稳。
- **结果**: 系统结构更可预测，也更容易测试。

---

## A2 — 触发场景

### 用户会在什么情境下需要这个 skill?

1. 一个 agent 同时负责规划、检索、生成、审查，表现忽好忽坏。
2. system prompt 越写越长，仍然经常跑偏或混淆当前任务。
3. 用户不确定现在的问题该靠单 agent 继续收敛，还是该升级到 network。

### 语言信号

- “我的 agent 什么都想做。”
- “prompt 已经很长了，还是不稳定。”
- “这个职责是不是应该拆给另一个 agent？”

### 与相邻 skill 的区分

- 与 `tool-trigger-contract` 的区别: 本 skill 先判断这个能力是否该留在 agent 内，而不是如何定义 tool。
- 与 `shared-state-shaping` 的区别: 本 skill 先做角色边界判断，不处理多 agent 共享上下文结构。

---

## E — 可执行步骤

1. **写出 agent 的唯一主目标**
   - 完成标准: 能用一句话描述该 agent 的主要职责和明显不负责的内容。

2. **标记超出边界的能力**
   - 完成标准: 区分哪些是外部能力调用、哪些是后续阶段、哪些是另一角色的工作。

3. **决定外移路径**
   - 完成标准: 超出边界的部分被明确归入 tool、state 或另一个 agent，而不是继续塞进 prompt。

---

## B — 边界

### 不要在以下情况使用此 skill

- 用户已经明确是在调 tool description 或参数 schema。
- 用户的系统已经是多 agent，主要问题在 router 停止条件。

### 作者在材料中警告的失败模式

- 把更大的系统目标硬塞给单个 agent。
- 用越来越长的 system prompt 掩盖职责没有切分的问题。

### 作者的盲点 / 时代局限

- 文档更偏工程收敛，对高度自治 agent 的探索空间讨论较少。

### 容易混淆的邻近方法论

- “一个 agent 更简单”不等于“系统更简单”；若职责混杂，只是把复杂度隐藏起来。

---

## 相关 skills

- depends-on: {}
- contrasts-with: {}
- composes-with: {tool-trigger-contract, shared-state-shaping}

---

## 审计信息

- **验证通过**: V1 ✓ / V2 ✓ / V3 ✓
- **测试通过率**: 待执行 (详见 test-prompts.json)
- **蒸馏时间**: 2026-05-16