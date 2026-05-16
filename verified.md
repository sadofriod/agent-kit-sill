- id: ak01
  title: agent-goal-boundary
  type: framework
  V1_cross_domain:
    passed: true
    evidence:
      - concepts/agents.mdx 将 agent 定义为围绕 goal、model、system、tools 的无状态实体
      - concepts/networks.mdx 强调 network 负责更大的目标，反向限定单 agent 不应无限膨胀
  V2_predictive_power:
    passed: true
    novel_question: 如果一个 agent 经常在该用 tool 时只输出文字解释，应该先改哪里？
    derived_answer: 先检查这个 agent 是否承担了多个不相容职责；若是，应先收紧边界，而不是继续堆更多 prompt 说明。
  V3_exclusivity:
    passed: true
    why_not_common: 它不是泛泛地说“写好提示词”，而是把稳定性首先归结为职责边界是否收敛。

- id: ak02
  title: tool-trigger-contract
  type: framework
  V1_cross_domain:
    passed: true
    evidence:
      - concepts/tools.mdx 反复强调 tool name、description、parameters 是模型判断是否调用的函数定义
      - concepts/agents.mdx 在添加 tools 一节再次把 tool 与 inference loop 的调用决策绑定起来
  V2_predictive_power:
    passed: true
    novel_question: 如果模型拥有 tool 但经常只文字说明自己会做什么而不实际调用，应该先查什么？
    derived_answer: 先看 tool description 是否明确触发条件、参数 schema 是否收敛、name 是否表达动作语义，而不是只继续加 prompt 约束。
  V3_exclusivity:
    passed: true
    why_not_common: 它把 tool 使用稳定性具体化为契约设计问题，而不是抽象的“模型有时不听话”。

- id: ak03
  title: shared-state-shaping
  type: framework
  V1_cross_domain:
    passed: true
    evidence:
      - concepts/networks.mdx 把 state 定义为 agents 与 router 的共享上下文
      - advanced-patterns/routing.mdx 用 `plan`、`done`、`files` 等结构化字段展示 workflow progress 建模
  V2_predictive_power:
    passed: true
    novel_question: 如果多个 agent 都依赖上一步产物，但这些产物只存在对话历史里，最容易出什么问题？
    derived_answer: 最容易出现 handoff 模糊和路由失真，因此应把关键进度、分类结果和产物显式写进 state。
  V3_exclusivity:
    passed: true
    why_not_common: 它不是泛泛提“要有状态”，而是强调 state 必须表达 workflow progress 而不是只做杂项存储。

- id: ak04
  title: deterministic-router-handoff
  type: framework
  V1_cross_domain:
    passed: true
    evidence:
      - concepts/networks.mdx 说明 router 决定下一位 agent 或结束循环
      - advanced-patterns/routing.mdx 明确主张用确定性状态机和 callCount 限制控制 handoff
  V2_predictive_power:
    passed: true
    novel_question: 如果多 agent 系统偶尔能成功，但经常重复调用同一 agent 或停不下来，应该先查什么？
    derived_answer: 先看 router 是否有显式分支、done 条件和迭代上限，而不是先调模型温度。
  V3_exclusivity:
    passed: true
    why_not_common: 它把 orchestrator 稳定性具体化为 router handoff 与终止控制，而不是“加个 supervisor 试试”。

- id: ak05
  title: durable-multistep-tools
  type: framework
  V1_cross_domain:
    passed: true
    evidence:
      - advanced-patterns/multi-steps-tools.mdx 用 step.ai.infer 和 step.run 展示多段 tool 执行
      - concepts/networks.mdx 与 concepts/agents.mdx 都说明 tool 会嵌入 agent 和 network 的运行循环
  V2_predictive_power:
    passed: true
    novel_question: 一个 research tool 需要生成查询、抓取网页、总结结果，如果中间抓取失败该怎么设计才能不整段重来？
    derived_answer: 把它升级为 Inngest function，用独立 steps 表达推理、抓取、总结，让失败从中断处重试并保留前序结果。
  V3_exclusivity:
    passed: true
    why_not_common: 它不是普通的“拆函数”，而是把 durable execution、重试和并发当作 tool 设计的一等约束。