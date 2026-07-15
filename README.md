# 🛡️ IP-Sentinel Enhanced

<div align="center">

![License](https://img.shields.io/github/license/lgdglgc/IP-Sentinel-Enhanced)
![Version](https://img.shields.io/badge/version-4.3.1--Enhanced-blue)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)
![Shell](https://img.shields.io/badge/shell-bash%20%7C%20python3-green)

**基于 [hotyue/IP-Sentinel](https://github.com/hotyue/IP-Sentinel) 的增强独立维护版本**

</div>

---

> ### 📌 致谢与版权声明
>
> 本项目完全基于 **[hotyue/IP-Sentinel](https://github.com/hotyue/IP-Sentinel)** 开发，核心架构与设计理念均来自原作者 **[@hotyue](https://github.com/hotyue)**。
>
> - 原项目许可证：**MIT License**（本项目继承相同许可证）
> - 原项目 Telegram 频道：[@IP_Sentinel_Matrix](https://t.me/IP_Sentinel_Matrix)
> - 原项目官方机器人：[@OmniBeacon_bot](https://t.me/OmniBeacon_bot)
>
> 如您需要最原始稳定版本，请直接使用 **[原项目](https://github.com/hotyue/IP-Sentinel)**。本项目为个人学习与优化目的而独立维护，感谢原作者的卓越创作！

---

## ✨ 相比原项目的增强改进

本增强版在原项目 v4.3.1 基础上进行了以下改进：

### 🔒 安全加固（P0）
| 改进项 | 原版 | 增强版 |
|--------|------|--------|
| 第三方探针下载验证 | 仅字符串检查 `grep "xykt"` | **双重验证**：字符串签名 + HTML 劫持检测 |
| HMAC 密钥 | 使用 CHAT_ID（9位数字，低熵） | 支持 `AGENT_SECRET` 随机密钥（安装时生成） |
| 死代码 | `master_setup.sh` 含永不执行赋值 | 已清理 |

### 🐛 Bug 修复（P1）
| Bug | 影响 | 状态 |
|-----|------|------|
| `toggle:*` 路由刷新面板后"销毁档案"跳过二次确认 | 误操作可直接删除节点 | ✅ 已修复 |
| `mod_trust.sh` 使用非确定性 `find` 查找 region JSON | 多城市配置时可能加载错误地区白名单 | ✅ 已修复（精确路径路由） |

### 🔧 代码质量（P1）
- **统一日志接口**：新增 `core/log_lib.sh`，消除 `log()` / `log_msg()` 接口不一致
- **配置化调度权重**：支持在 `config.conf` 自定义 `GOOGLE_WEIGHT` / `TRUST_WEIGHT`

### ⚡ 功能增强（P2）
- **`/health` 健康检查端点**：无需 HMAC 认证的轻量探活接口，供监控系统使用
- **可配置模块权重**：`GOOGLE_WEIGHT`（默认70）/ `TRUST_WEIGHT`（默认30）
- **精确 Region JSON 路径**：安装时写入 `REGION_JSON_PATH`，运行时精确定位

---

## 📂 项目架构

```text
📦 IP-Sentinel-Enhanced
 ┣ 📂 .github/workflows/      # CI/CD 自动化流水线
 ┣ 📂 install/                # 模块化安装引擎
 ┃  ┣ 📜 build_agent.sh       # Agent 编排入口
 ┃  ┣ 📜 build_master.sh      # Master 编排入口
 ┃  ┣ 📜 env_setup.sh         # 多发行版环境预检
 ┃  ┣ 📜 ui_menu.sh           # 交互式 LBS 状态机
 ┃  ┣ 📜 net_engine.sh        # 双栈探测与容灾装填
 ┃  ┣ 📜 sys_daemon.sh        # Systemd/Cron 守护注入
 ┃  ┗ 📜 master_setup.sh      # Master 专属安装逻辑
 ┣ 📂 core/                   # 边缘哨兵核心引擎
 ┃  ┣ 📜 agent_daemon.sh      # TLS Webhook 守护进程
 ┃  ┣ 📜 runner.sh            # 主控调度器（含可配置权重）
 ┃  ┣ 📜 mod_google.sh        # Google 区域行为模拟
 ┃  ┣ 📜 mod_trust.sh         # IP 信用净化（精确路由修复）
 ┃  ┣ 📜 mod_quality.sh       # 深海声呐探测（安全加固）
 ┃  ┣ 📜 log_lib.sh           # [NEW] 统一日志接口库
 ┃  ┣ 📜 updater.sh           # 热数据 OTA（安全加固）
 ┃  ┣ 📜 tg_report.sh         # 每日战报生成
 ┃  ┗ 📜 uninstall.sh         # 无痕卸载
 ┣ 📂 master/                 # 司令部（SQLite + TG Bot）
 ┃  ┣ 📜 tg_master.sh         # TG 长轮询调度器（Bug 修复）
 ┃  ┣ 📜 install_master.sh    # Master 引导入口
 ┃  ┗ 📜 uninstall_master.sh  # Master 卸载
 ┣ 📂 data/                   # 全球数据规则库
 ┃  ┣ 📜 map.json             # 全球战区拓扑图谱
 ┃  ┣ 📂 regions/             # LBS 冷数据（城市坐标与白名单）
 ┃  ┣ 📂 keywords/            # 热数据：各国搜索词库
 ┃  ┗ 📜 user_agents.txt      # 热数据：设备指纹库
 ┣ 📂 scripts/                # CI/CD Python 生成器
 ┣ 📜 install.sh              # Agent 引导入口
 ┣ 📜 version.txt             # 版本信标
 ┗ 📂 telemetry/              # Cloudflare Workers 统计网关
```

---

## 🚀 快速部署

> ⚠️ **提示**：本增强版与原项目部署方式完全兼容，参数和配置格式一致。

### 部署 Master 司令部（只需一台）

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lgdglgc/IP-Sentinel-Enhanced/master/master/install_master.sh)"
```

### 部署 Agent 边缘哨兵

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lgdglgc/IP-Sentinel-Enhanced/master/install.sh)"
```

### 安装后可选配置（`/opt/ip_sentinel/config.conf`）

```bash
# 自定义模块调度权重（仅当两个模块都开启时生效）
GOOGLE_WEIGHT="70"   # Google 纠偏触发概率（%）
TRUST_WEIGHT="30"    # 信用净化触发概率（%）

# 开启 JSON 结构化日志（用于外部日志系统对接）
ENABLE_JSON_LOG="false"
```

---

## 🔍 健康检查接口（新增）

增强版 Agent 新增 `/health` 端点，无需 HMAC 认证，可直接用于监控：

```bash
# 检查节点存活状态（需替换为实际 IP 和端口）
curl -k https://your-vps-ip:9527/health
# 返回示例：
# {"status": "ok", "version": "4.3.1", "node_alias": "东京节点", "region": "JP"}
```

---

## 🆙 升级方式

与原项目完全相同，参考 [原项目升级文档](https://github.com/hotyue/IP-Sentinel#-架构级无损热升级指引-upgrade-guide)。

---

## 🗑️ 卸载

```bash
bash /opt/ip_sentinel/core/uninstall.sh
```

---

## ⚙️ 支持平台

- Debian / Ubuntu ✅
- CentOS / RHEL / AlmaLinux ✅
- Alpine Linux ✅
- Arch Linux ✅

---

## 📜 变更日志

### Enhanced v4.3.1 (2026-07-01)
- 🔒 **[Security]** 第三方探针下载增加 HTML 劫持检测防护
- 🐛 **[BugFix]** 修复 toggle 路由刷新面板后"销毁档案"跳过二次确认的 Bug
- 🐛 **[BugFix]** 修复 mod_trust.sh 非确定性 `find` 查找（改为精确路径路由）
- 🐛 **[BugFix]** 删除 master_setup.sh 中永不执行的死代码
- ✨ **[Feature]** 新增 `/health` 健康检查 API 端点
- ✨ **[Feature]** 支持 `GOOGLE_WEIGHT`/`TRUST_WEIGHT` 自定义调度权重
- ✨ **[Feature]** 新增 `core/log_lib.sh` 统一日志接口（消除 `log()`/`log_msg()` 不一致）
- 🔧 **[Improvement]** updater.sh 探针下载同步加入 HTML 劫持检测

---

## ⚠️ 免责声明

本项目仅供网络原理研究、个人 VPS 维护学习使用。请遵守当地法律法规及目标服务商的 TOS（服务条款），切勿用于恶意高频请求或任何非法用途。使用者需自行承担因不当使用造成的 IP 封禁或其他相关风险。

---

## 🤝 原项目贡献者

感谢 **[hotyue/IP-Sentinel](https://github.com/hotyue/IP-Sentinel)** 的所有贡献者！

<a href="https://github.com/hotyue/IP-Sentinel/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=hotyue/IP-Sentinel" alt="Contributors" />
</a>

---

<div align="center">

**如果本项目对你有帮助，请同时为 [原项目](https://github.com/hotyue/IP-Sentinel) 点亮 ⭐ Star！**

</div>