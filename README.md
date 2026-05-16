# AgentKit Docs Skill Pack

这个仓库整理了 1 个总入口 skill 和 5 个原子 skills，用于在 GitHub Copilot Chat / VS Code 自定义 skill 目录中安装和使用一组面向 Inngest AgentKit 的方法论文档。

## 包含内容

- `agent-kit-docs-skill`：总入口 skill，用来判断用户问题应路由到哪个原子 skill。
- `agent-goal-boundary`：收紧单个 agent 的职责边界。
- `tool-trigger-contract`：提高 tool 触发稳定性与参数契约质量。
- `shared-state-shaping`：为多 agent 协作设计共享 state。
- `deterministic-router-handoff`：约束 router handoff、终止条件与迭代上限。
- `durable-multistep-tools`：把复杂 tool 拆成可重试、可恢复的 durable workflow。

## 目录结构

```text
.
├── SKILL.md
├── BOOK_OVERVIEW.md
├── INDEX.md
├── verified.md
├── agent-goal-boundary/
├── tool-trigger-contract/
├── shared-state-shaping/
├── deterministic-router-handoff/
└── durable-multistep-tools/
```

## 安装

### 默认安装

脚本会默认安装到当前用户的 Copilot skill 目录：`~/.copilot/skills/agent-kit-docs-skill`

```bash
chmod +x ./install-skills.sh
./install-skills.sh
```

### 安装到自定义目录

```bash
./install-skills.sh /path/to/skills/agent-kit-docs-skill
```

### 符号链接安装

如果你会持续修改这个仓库，推荐使用符号链接模式，目标目录会直接链接到当前仓库中的文件与子目录，后续迭代文档不需要重复复制安装。

```bash
./install-skills.sh --link
```

也可以和自定义目录一起使用：

```bash
./install-skills.sh --link /path/to/skills/agent-kit-docs-skill
```

### 安装行为

脚本会执行以下动作：

1. 校验当前仓库包含根 `SKILL.md` 与 5 个原子 skill。
2. 创建目标目录。
3. 根据模式复制或链接根文档和每个 skill 子目录。
4. 输出安装完成摘要。

## 更新安装

- 复制模式：重复运行脚本会覆盖目标目录中的同名文件。
- 符号链接模式：仓库内容变更后会直接反映到安装目录；如果你调整了目录结构，重新运行一次安装脚本即可。

## 卸载

可以使用卸载脚本删除安装目录：

```bash
chmod +x ./uninstall-skills.sh
./uninstall-skills.sh
```

卸载自定义目录：

```bash
./uninstall-skills.sh /path/to/skills/agent-kit-docs-skill
```

卸载脚本只会删除目标安装目录，不会删除当前仓库源文件。

## 使用建议

- 当问题还不明确时，优先让 Copilot 读取根 skill：`agent-kit-docs-skill`。
- 当问题已收敛到职责切分、tool 调用、状态设计、router handoff 或 durable workflow 之一时，直接激活对应原子 skill。
- 如果你的 Copilot skill 目录不在默认位置，请使用自定义安装路径。

## 参考文档

- `BOOK_OVERVIEW.md`：整体理解与方法论骨架。
- `INDEX.md`：skill 索引与推荐学习顺序。
- `verified.md`：已验证条目。