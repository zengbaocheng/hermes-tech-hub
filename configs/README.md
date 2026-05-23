# configs/README.md — 配置管理

# ⚙️ 配置管理

Hermes Agent 的多场景配置方案。

## 目录结构

```
configs/
├── profiles/              # 多个场景 Profile
│   ├── development/       # 开发场景
│   ├── operations/        # 运维场景
│   └── research/          # 研究场景
├── examples/              # 配置示例
│   ├── config.yaml        # 基础配置模板
│   └── .env.example       # 环境变量模板
└── README.md
```

## 配置策略

### 多 Profile 管理
使用 Hermes Profile 实现场景隔离：
```bash
hermes profile create development --clone
hermes profile create operations --clone
hermes profile use development
```

### 配置模板化
- `config.yaml` — 基础配置模板
- `.env.example` — 环境变量模板（不含真实密钥）
- 按场景提供差异化配置