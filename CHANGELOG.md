# 📜 Changelog (IP-Sentinel-Enhanced 演进历史)

All notable changes to the **IP-Sentinel-Enhanced** project will be documented in this file.
This project is an enhanced independent branch based on [hotyue/IP-Sentinel](https://github.com/hotyue/IP-Sentinel).

---

## [v4.3.5-Enhanced] - 2026-09-20

### 🛡️ 安全加固 (Security Upgrades)
- **HMAC v2 全参数动态签名覆盖** (Issue #108)：全面升级 Agent 与 Master 之间的通信鉴权。签名不仅覆盖 URL 路径与时间戳，还完整覆盖所有查询参数（如 `mod`、`state`、`b64` 等），彻底免疫中间人参数篡改攻击。
- **HMAC v2/v1 双重握手自适应降级**：Master 默认使用 V2 强签名下发，检测到历史未升级节点（返回 401）时自动无缝降级为 V1 签名，保障历史部署节点 100% 不失联。
- **SQL 注入参数白名单拦截** (Issue #105)：Master 指令分发核心重构，对节点名称、控制指令执行严格白名单正则过滤，杜绝 SQL 拼接隐患。
- **特权操作回调鉴权** (Issue #106)：重构 Master 状态机，强制要求 OTA 热更新、档案销毁等特权动作必须由经过身份核验的内联按钮触发，屏蔽纯文本越权伪造。
- **SSRF 内网地址隔离墙** (Issue #107)：Agent 注册与通讯下发全面阻断私有地址（RFC1918）、链路本地、云元数据 IP（`169.254.169.254`）及内网域名解析（`.local` / `.internal` / `.nip.io`）。
- **保留 Enhanced 独家供应链防护**：第三方质量探针（`mod_quality.sh`）与热更新程序（`updater.sh`）严格维持“作者签名 + HTML 劫持阻断”双重防护，防止 GitHub Raw 故障下发错误 HTML 导致脚本被投毒或毁损。

### ✨ 核心功能与交互革命 (Features & UX)
- **全舰队一键切换 Bot 凭证 (Fleet Reconfig)** (Issue #102, v4.3.4/v4.3.5)：
  - Master 主菜单挂载「🔁 全舰队切换 Bot 凭证」按钮；
  - 支持第一行 Token / 第二行 Chat ID 或空格分隔凭证输入；
  - 司令部前置 `getMe` 校验拦截无效凭证，通过安全 Base64 载荷批量下发至开启 OTA 的所有节点；
  - Agent 端新增 `/trigger_reconfig` 路由，先向新 Bot 推送注册回执，验证成功后通过 `fcntl` 独占锁原子重写本地配置，并延迟平滑重启完成 HMAC 密钥轮换。
  - 包含 upstream v4.3.5 的 case 通配符裸写修复 (`do_reconfig:*`) 与两行式格式提示。
- **UI 沉底重绘引擎 (Sink & Redraw)** (Issue #104, v4.3.3)：
  - 引入 `render_ui()` 与 `render_msg()`，交互动作发生时自动抹杀历史旧面板，控制台始终悬浮在聊天窗口最底部，彻底解决控制台堆叠与翻屏视线跳跃。
- **新增选项 3 重新发送注册指令 (Re-Register)** (v4.3.2)：
  - 安装引导菜单（`install/ui_menu.sh`）新增「3) 📡 重新发送注册指令」；
  - 支持在不重装 Agent 的情况下重新提取节点配置，探测公网出口与通讯弹匣（支持智能识别 IP 漂移并交互更新），直接向 Telegram 补发 `#REGISTER#` 注册指令。
- **全球战区扩编**：
  - 新增美国纽约州布法罗（Buffalo）节点坐标与本地白名单数据；
  - 扩编尔湾 (Irvine)、芝加哥 (Chicago) 节点数据。

### 🌟 增强版独家特性传承 (Enhanced Exclusive Features Kept)
- **`/health` 轻量探活端点**：Agent 保留无需 HMAC 的轻量 GET `/health` 端点，升级返回 JSON，支持接入 Prometheus、Uptime Kuma 等外部监控平台，新增 `hmac_version: "v2"` 信标。
- **精确 Region 路径路由**：`mod_trust.sh` 坚持 `REGION_JSON_PATH` 优先精确寻址，彻底告别原版非确定性 `find`。
- **任务调度权重可配置**：`runner.sh` 支持 `GOOGLE_WEIGHT`（默认70）与 `TRUST_WEIGHT`（默认30）自定义，满足个性化养护侧重。
- **统一日志库**：`core/log_lib.sh` 统一规范标准日志与可选 JSON 结构化日志。

---

## [v4.3.1-Enhanced] - 2026-07-01

### 🔒 安全加固
- 第三方探针下载增加 HTML 劫持检测防护（`mod_quality.sh`, `updater.sh`）。
- Master 安装死代码清理（`master_setup.sh` 剔除冗余变量覆盖）。

### 🐛 Bug 修复
- 修复 toggle 路由刷新面板后“销毁档案”跳过二次确认的重大安全漏洞（强制使用 `del_confirm`）。
- 修复 `mod_trust.sh` 非确定性 `find` 查找，改为优先使用安装时落地的 `REGION_JSON_PATH` 精确路由。

### ✨ 功能增强
- 新增 `core/log_lib.sh` 统一日志输出。
- `core/agent_daemon.sh` 新增 `/health` 健康检查端点。
- `core/runner.sh` 引入配置化概率调度权重（`GOOGLE_WEIGHT` / `TRUST_WEIGHT`）。
