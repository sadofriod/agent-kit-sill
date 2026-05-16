---
name: shared-state-shaping
description: |
  当用户在 AgentKit 中做多 agent 协作，并且问题集中在 state 里该放什么、如何表达 workflow progress、何时把信息从 history 提升为结构化字段时调用。
  不适用于: 单 agent 职责切分、tool 触发契约、router 的具体 handoff 条件。
source_book: 《AgentKit Documentation》 Inngest
source_chapter: concepts/networks.mdx + advanced-patterns/routing.mdx
tags: [agentkit, state, network, workflow]
related_skills: [agent-goal-boundary, deterministic-router-handoff]
---

# Shared State Shaping

## R — 原文

> A network contains ... a State including past messages and a key value store, shared between Agents and the Router.
>
> — Inngest, concepts/networks.mdx

> Design state to clearly represent workflow progress.
>
> — Inngest, advanced-patterns/routing.mdx

---

## I — 方法论骨架

多 agent 系统是否稳定，首先取决于关键进度是否存在结构化 state 中，而不是只存在对话历史里。

如果 plan、classification、done、files 这类关键事实只留在自然语言输出中，后续 agent 和 router 就只能反复猜测上下文，导致 handoff 不稳定、重复执行、难以测试。

因此 state 的设计目标不是“多存一点信息”，而是准确表达 workflow progress、关键产物和下一跳决策所需的最小结构。

---

## A1 — 书中的应用

### 案例 1: 用 `plan` 表示是否完成规划阶段
- **问题**: router 需要判断是继续调查还是开始编辑。
- **方法论的使用**: 示例 state 用 `plan` 字段显式表示规划结果是否已经产生。
- **结论**: 状态字段应直接映射流程节点。
- **结果**: router 可以无需猜测地切换 agent。

### 案例 2: 用 `done` 表示工作流终止
- **问题**: network 需要清楚知道何时退出。
- **方法论的使用**: 示例 state 使用 `done` 字段作为终止标记。
- **结论**: 终止条件不应只靠自然语言“我已经做完了”。
- **结果**: 退出逻辑更稳定、更可测试。

---

## A2 — 触发场景

### 用户会在什么情境下需要这个 skill?

1. 多个 agent 都依赖上一步结果，但结果只存在聊天文本里。
2. router 经常看不懂当前进度，需要反复解析自然语言。
3. 用户不知道哪些信息值得提升为 state 字段，哪些只留在 history 即可。

### 语言信号

- “这些结果要不要存到 state 里？”
- “router 总得读一大段文本才知道下一步。”
- “workflow progress 应该怎么建模？”

### 与相邻 skill 的区分

- 与 `deterministic-router-handoff` 的区别: 本 skill 处理状态结构本身，不处理基于该状态写什么 router 分支。
- 与 `agent-goal-boundary` 的区别: 本 skill 假设已经进入多 agent 协作阶段。

---

## E — 可执行步骤

1. **列出下一跳真正依赖的事实**
   - 完成标准: 明确哪些结果会决定接下来运行哪个 agent 或是否结束。

2. **把这些事实提升为结构化字段**
   - 完成标准: 关键进度、分类结果、产物引用和完成标记都存在 state 中。

3. **压缩 history 的职责**
   - 完成标准: history 主要保留推理与上下文，关键控制信号不再只依赖自然语言解析。

---

## B — 边界

### 不要在以下情况使用此 skill

- 用户还处在单 agent 设计阶段。
- 用户的问题已经明确是 router 停止条件或 handoff 分支本身。

### 作者在材料中警告的失败模式

- 把 workflow progress 藏在自然语言 history 中。
- state 存很多杂项数据，却没有直接支撑路由和完成判断的字段。

### 作者的盲点 / 时代局限

- 文档对大规模复杂 state 的治理、版本演进讨论不多，更关注最小可用结构。

### 容易混淆的邻近方法论

- “有状态”不等于“状态设计正确”；关键是 state 是否直接服务 handoff 与终止判断。

---

## 相关 skills

- depends-on: {agent-goal-boundary}
- contrasts-with: {}
- composes-with: {deterministic-router-handoff}

---

## 审计信息

- **验证通过**: V1 ✓ / V2 ✓ / V3 ✓
- **测试通过率**: 待执行 (详见 test-prompts.json)
- **蒸馏时间**: 2026-05-16