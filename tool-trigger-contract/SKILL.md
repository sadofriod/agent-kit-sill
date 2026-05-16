---
name: tool-trigger-contract
description: |
  当用户已经确定需要 tool，但模型不稳定调用、传参混乱，或 tool 定义本身模糊时调用。
  适用于“description 怎么写”“参数怎么收紧”“为什么模型只解释不调用”这类场景。
  不适用于: 单 agent 的职责切分、多 agent 路由、复杂 tool 的 durable execution。
source_book: 《AgentKit Documentation》 Inngest
source_chapter: concepts/tools.mdx + concepts/agents.mdx
tags: [agentkit, tools, function-calling]
related_skills: [agent-goal-boundary, durable-multistep-tools]
---

# Tool Trigger Contract

## R — 原文

> Each Tool's `name`, `description`, and `parameters` are part of the function definition that is used by model to learn about the tool's capabilities.
>
> — Inngest, concepts/tools.mdx

> Writing quality `name` and `description` parameters help the model determine when the particular Tool should be called.
>
> — Inngest, concepts/tools.mdx

---

## I — 方法论骨架

当模型拥有 tool 却不稳定调用时，问题往往不在 handler，而在模型看到的函数契约。

AgentKit 的重点不是“tool 能不能运行”，而是模型是否能从 `name`、`description`、`parameters` 判断何时该调用、传什么、何时不该调用。

因此改进 tool 触发稳定性时，不要先去写更长的 prompt，而应先让函数定义本身足够清楚、动作语义明确、参数边界收紧。

---

## A1 — 书中的应用

### 案例 1: list_charges 用 description 指出触发条件
- **问题**: 模型需要知道何时使用某个账户查询工具。
- **方法论的使用**: 示例 description 直接写明“当你需要在日期范围内查一个或多个收费记录时调用”。
- **结论**: 好的 description 是触发条件说明，不只是功能简介。
- **结果**: 模型更容易在正确上下文中发起调用。

### 案例 2: 用 schema 收紧输入边界
- **问题**: 参数过于松散会让模型传参不稳定。
- **方法论的使用**: 文档通过 zod schema 明确输入结构，并强调可空参数应用 `.nullable()` 而非任意放宽。
- **结论**: 参数 schema 同时承担验证和引导作用。
- **结果**: 调用成功率与可预期性提升。

---

## A2 — 触发场景

### 用户会在什么情境下需要这个 skill?

1. tool 已经存在，但模型经常用自然语言解释而不实际调用。
2. 模型会调用 tool，但参数常常传错或缺失。
3. 用户不知道 description 应该写功能介绍，还是写触发条件。

### 语言信号

- “模型老是不调这个 tool。”
- “参数总传不对。”
- “description 要写到什么程度？”

### 与相邻 skill 的区分

- 与 `agent-goal-boundary` 的区别: 本 skill 假设这个能力已经确定要做成 tool。
- 与 `durable-multistep-tools` 的区别: 本 skill 处理 tool 的调用契约，不处理其内部多步执行结构。

---

## E — 可执行步骤

1. **把 description 改写成触发规则**
   - 完成标准: description 明确说明什么时候该调用，而不是只说它能做什么。

2. **收紧参数 schema**
   - 完成标准: 参数有足够的结构约束，能减少含糊传参和错误形状。

3. **检查 name 的动作语义**
   - 完成标准: tool 名称能表达具体动作，避免过于抽象或泛化的命名。

---

## B — 边界

### 不要在以下情况使用此 skill

- 用户的问题是这个能力到底应不应该做成 tool。
- 用户已经进入多步 durable workflow 设计，问题不在触发而在恢复和重试。

### 作者在材料中警告的失败模式

- 把 description 写成功能名词解释，而不是触发条件。
- 参数 schema 太松，导致模型无法稳定构造正确输入。

### 作者的盲点 / 时代局限

- 文档没有覆盖大量 provider 之间的 tool-calling 差异，更多强调通用契约质量。

### 容易混淆的邻近方法论

- “handler 很强”不等于“tool 好用”；模型首先能看到的是契约，不是实现细节。

---

## 相关 skills

- depends-on: {agent-goal-boundary}
- contrasts-with: {}
- composes-with: {durable-multistep-tools}

---

## 审计信息

- **验证通过**: V1 ✓ / V2 ✓ / V3 ✓
- **测试通过率**: 待执行 (详见 test-prompts.json)
- **蒸馏时间**: 2026-05-16