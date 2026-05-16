---
name: deterministic-router-handoff
description: |
  当用户已经有多 agent 和基本 state 设计，但问题集中在下一跳怎么选、何时结束、如何避免重复调用与死循环时调用。
  不适用于: 单 agent 的职责边界、tool 契约、state 字段本身的梳理。
source_book: 《AgentKit Documentation》 Inngest
source_chapter: concepts/networks.mdx + advanced-patterns/routing.mdx
tags: [agentkit, router, handoff, termination]
related_skills: [shared-state-shaping, durable-multistep-tools]
---

# Deterministic Router Handoff

## R — 原文

> The Router decides the first Agent to run with your input.
>
> — Inngest, concepts/networks.mdx

> Implement iteration limits to prevent infinite loops.
>
> — Inngest, advanced-patterns/routing.mdx

---

## I — 方法论骨架

当多 agent 系统已经有了 state，下一步的关键问题就是 router 如何读取这些状态并做显式 handoff。

好的 router 不是再让一个模型泛泛判断“下一步大概是谁”，而是根据当前 state 分支：先谁、后谁、何时停、失败时回哪一层。

这套方法的核心约束有三个：显式分支、显式终止条件、显式迭代上限。没有这三者，多 agent 系统即使偶尔成功，也很难稳定复现。

---

## A1 — 书中的应用

### 案例 1: plan 存在前后走不同 agent
- **问题**: 系统需要在“还没规划”和“已经有计划”之间切换。
- **方法论的使用**: 示例 router 在 `plan === undefined` 时返回 planning agent，否则返回 editing agent。
- **结论**: handoff 规则应与 state 字段一一对应。
- **结果**: 运行路径稳定、可解释。

### 案例 2: 用 `done` 和 `callCount` 控制退出
- **问题**: 路由代理可能无法自然结束。
- **方法论的使用**: 文档明确建议使用 `done` 与迭代限制防止无限循环。
- **结论**: 终止控制必须由系统显式负责。
- **结果**: network 更容易测试，也更容易保护成本。

---

## A2 — 触发场景

### 用户会在什么情境下需要这个 skill?

1. router 经常重复调用同一个 agent，或在完成后仍继续循环。
2. 用户知道有哪些 agent，但不知道如何把阶段迁移写成清晰分支。
3. 团队希望 orchestration 行为可解释、可测试、可审计。

### 语言信号

- “下一轮到底该交给谁？”
- “为什么总在重复同一个 agent？”
- “done 条件和 maxIter 应该怎么配？”

### 与相邻 skill 的区分

- 与 `shared-state-shaping` 的区别: 本 skill 假设关键状态已存在，重点是如何依据它们 handoff。
- 与 `durable-multistep-tools` 的区别: 本 skill 处理 agent 层的循环控制，不处理单个 tool 内的 step 链。

---

## E — 可执行步骤

1. **为每个阶段写显式 handoff 条件**
   - 完成标准: router 每条主要分支都能对应一个明确状态条件。

2. **定义完成与退出条件**
   - 完成标准: 有明确 done 条件或返回 `undefined` 的时机，而不是只靠模型口头说明结束。

3. **加入迭代上限和兜底路径**
   - 完成标准: router 或 network 具备 `callCount`、`maxIter` 等成本保护与异常收敛逻辑。

---

## B — 边界

### 不要在以下情况使用此 skill

- state 还没设计清楚，router 没有可靠输入可读。
- 用户真正的问题在 tool 为什么不被调用。

### 作者在材料中警告的失败模式

- 让 router 依赖模糊自然语言去猜测下一步。
- 缺少迭代上限，导致网络无法识别终止条件时无限循环。

### 作者的盲点 / 时代局限

- 对高度开放式研究任务，确定性 handoff 可能限制探索路径。

### 容易混淆的邻近方法论

- “再加一个 supervisor”不等于“router 设计更好”；如果 handoff 规则没显式化，只是把不确定性交给另一个模型。

---

## 相关 skills

- depends-on: {shared-state-shaping}
- contrasts-with: {}
- composes-with: {durable-multistep-tools}

---

## 审计信息

- **验证通过**: V1 ✓ / V2 ✓ / V3 ✓
- **测试通过率**: 待执行 (详见 test-prompts.json)
- **蒸馏时间**: 2026-05-16