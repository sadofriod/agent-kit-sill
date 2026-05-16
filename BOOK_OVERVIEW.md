# AgentKit Documentation — 整体理解

> 本文档是基于 `docs/src/content/docs` 蒸馏出的阶段 0 产出，用作下游 skill 的全局上下文。

## 基本信息

- **书名**: AgentKit Documentation
- **作者**: Inngest
- **出版年**: 2026
- **版本来源**: `https://github.com/inngest/agent-kit/tree/main/docs`
- **处理时间**: 2026-05-16

---

## 1. 结构

### 类型
框架文档 / 实操手册 / API 参考的混合体

### 一句话主旨
AgentKit 试图把 agent 系统收敛为一套可编排的工程结构：用聚焦 agent 执行具体目标，用 tools 提供可调用能力，用 shared state 与 router 组织多 agent 循环，并借助 Inngest 让复杂执行具备耐久性与可重试性。

### 骨架

1. Agent 是围绕明确目标、模型和工具定义的无状态执行单元。
2. Tool 是给模型暴露结构化能力边界的函数契约，质量取决于名称、描述和参数建模。
3. Network 把多个 agent 放进共享 state 与 router 的循环中，以完成单 agent 难以稳定处理的任务。
4. Router 应优先基于状态做确定性选择，而不是把全部控制权继续交给自由推理。
5. 复杂 tool 应拆成多步、可重试、可恢复的工作流，并接入 Inngest 的 step 机制。

**论点关系**: 从单 agent 定义，递进到 tool 契约，再扩展到 network 编排与多步执行。

### 核心问题
如何把“会调用模型”升级成“可预测、可测试、可恢复的 agent 系统”。

---

## 2. 解释

### 关键术语

| 术语 | 文档中的定义 | 和常识用法的差异 |
|---|---|---|
| Agent | 围绕目标、system prompt、model 与 tools 定义的无状态实体 | 不是长期记忆容器，跨轮上下文主要由 network state 承担 |
| Tool | 暴露给模型调用的函数契约 | 重点不是“能做什么”，而是“模型什么时候会判断该调用它” |
| Network | 由 agents、shared state、router 组成的执行循环 | 不只是 agent 列表，而是带状态和路由策略的系统 |
| Router | 决定下一个运行哪个 agent，或结束循环的控制器 | 核心价值是收敛流程，而不是制造更多自治 |
| State | 存储历史与结构化数据的共享上下文 | 强调 workflow progress，而不是把一切塞进对话历史 |
| Multi-step tool | 借助 Inngest function 和 step 拆成多段执行的 tool | 重点是耐久、重试、并发和恢复，不是单次 handler 复杂化 |

### 核心命题

1. 好的 agent 设计先定义清晰职责，再决定是否需要 tools 和 network。
2. tool 的触发稳定性来自高质量描述和参数建模，而不是把 handler 写得更复杂。
3. 多 agent 系统的稳定性来自状态机式路由，而不是把所有判断继续交给模型自由发挥。
4. 一旦 tool 内部有多步副作用或长链依赖，就应升级为耐久工作流，而不是塞进单次调用。

### 论证链
文档先定义 agent、tool、network 的基本角色，再通过 deterministic routing 和 multi-step tools 展示如何把抽象概念落成可测试的工程结构，最后把可靠性问题收束到 state、router、retry 与 step 边界上。

---

## 3. 批判

### 时代局限
- 文档默认 Inngest 是核心运行基础，对非 Inngest 运行时的迁移成本讨论不足。
- 示例偏向 TypeScript 和服务端工作流，对前端嵌入式或极轻量场景覆盖较弱。

### 立场盲点
- 文档整体偏工程收敛，默认“确定性更重要”，对高探索性自治 agent 的价值着墨较少。
- 对提示词本身的设计深度较浅，更强调系统结构而非 prompt engineering 细节。

### 未被证明的假设
- 假设状态驱动 routing 总是比自治 routing 更合适，但某些开放式研究任务未必如此。
- 假设多步 tool 的成本值得承担，实际对简单同步任务可能过度设计。

### 最强反对意见
如果团队规模小、任务链短、失败代价低，那么引入 network、state、router 和多步工具可能让系统更难理解，而不是更高效。

---

## 4. 应用潜力

### 可 skill 化内容
- [x] Agent 职责边界设计
- [x] Tool 触发契约设计
- [x] Shared state 建模
- [x] Router handoff 与终止控制
- [x] 多步 durable tool 设计

### 不适合独立 skill 化的内容
- 安装与本地启动步骤
- 单个 provider 的模型参数差异
- 纯 API reference 枚举项

### 预估 skill 数量
**5 个**

### 优先级排序
1. Agent 职责边界设计
2. Tool 触发契约设计
3. Shared state 建模
4. Router handoff 与终止控制
5. 多步 durable tool 设计

---

## 质量门检查

- [x] 主旨能用一句话说清
- [x] 骨架列出 3–7 个一级论点
- [x] 关键术语词典 ≥5 条
- [x] 批判阶段列出 ≥3 条作者局限
- [x] 已根据核心文档完成内部确认

**用户确认时间**: 2026-05-16