# 🛡️ IP-Sentinel Enhanced

<div align="center">

![License](https://img.shields.io/github/license/lgdglgc/IP-Sentinel-Enhanced)
![Version](https://img.shields.io/badge/version-4.3.5--Enhanced-blue)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)
![Shell](https://img.shields.io/badge/shell-bash%20%7C%20python3-green)

**基于 [hotyue/IP-Sentinel](https://github.com/hotyue/IP-Sentinel) 的高可用、强安全独立维护增强版本**

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
> 如您需要最原始官方版本，请直接访问 **[原项目](https://github.com/hotyue/IP-Sentinel)**。本项目为独立分支，长期同步上游最新特性并叠加高阶安全与运维增强。

---

## ✨ 相比原项目的对比与增强特性

本项目已全量融合上游原版 `v4.3.2` ~ `v4.3.5` 的所有新特性与核心安全加固，并深度叠加了增强版专属的供应链防护、监控探活与确定性调度能力：

| 维度 / 功能特性 | 原版 (hotyue) v4.3.1 | 原版最新 v4.3.5 | 增强版 (本仓库) v4.3.5-Enhanced |
| :--- | :--- | :--- | :--- |
| **第三方探针防劫持** | 仅检查 `grep "xykt"` | 仅检查 `grep "xykt"` | 🔒 **双重防线**：作者签名 + HTML 劫持阻断，主备 CDN 熔断保护 |
| **HMAC 鉴权机制** | 基础签名 (`path:t`) | 🛡️ **HMAC v2 全查询参数覆盖** | 🛡️ **HMAC v2 全量覆盖 + v1 自适应双重握手**（老节点不失联） |
| **全舰队切换 Bot 凭证** | 不支持 (需逐台重装) | 🚀 支持 (`/trigger_reconfig`) | 🚀 **全舰队一键切换** + 凭证预检 + 原子重写与平滑热重启 |
| **Telegram 控制台交互** | 历史指令无限堆叠 | 🎨 **UI 沉底重绘引擎** | 🎨 **UI 沉底重绘** + 历史面板自动清理 + 销毁二次确认防误触 |
| **重新发送注册指令** | 不支持 | 📡 支持 (选项 3) | 📡 **智能探测出口漂移** + 一键重新推送 `#REGISTER#` |
| **外部健康监控接口** | 无 | 无 | 🔍 **独家 `/health` 探活端点**（免 HMAC，输出 JSON 供外部探活） |
| **Region 拓扑文件寻址** | 非确定性 `find` 扫描 | 非确定性 `find` 扫描 | 🎯 **独家精确路径定位** (`REGION_JSON_PATH`)，杜绝多配置串线 |
| **养护模块调度权重** | 硬编码 70% / 30% | 硬编码 70% / 30% | ⚡ **独家配置化动态权重** (`GOOGLE_WEIGHT` / `TRUST_WEIGHT`) |
| **代码与日志规范** | `echo` 混用 `log()` | `echo` 混用 `log()` | 🔧 **统一日志库** (`core/log_lib.sh`)，支持 JSON 结构化日志 |
| **战区节点扩编** | 基础战区 | 扩编布法罗、尔湾、芝加哥 | 🗺️ **完整同步最新全球战区与拓扑图** |

---

## 📂 项目架构

```text
📦 IP-Sentinel-Enhanced
 ┣ 📂 .github/workflows/      # CI/CD 自动化流水线（词库同步与 UA 生成）
 ┣ 📂 install/                # 模块化安装引擎
 ┃  ┣ 📜 build_agent.sh       # Agent 编排入口
 ┃  ┣ 📜 build_master.sh      # Master 编排入口
 ┃  ┣ 📜 env_setup.sh         # 多发行版环境预检
 ┃  ┣ 📜 ui_menu.sh           # 交互式 LBS 状态机（含选项 3 重新注册）
 ┃  ┣ 📜 net_engine.sh        # 双栈探测、容灾装填与权重初始化
 ┃  ┣ 📜 sys_daemon.sh        # Systemd/Cron 守护注入
 ┃  ┗ 📜 master_setup.sh      # Master 专属安装逻辑
 ┣ 📂 core/                   # 边缘哨兵核心引擎
 ┃  ┣ 📜 agent_daemon.sh      # TLS Webhook 守护（含 HMAC v2、/health 与 /trigger_reconfig）
 ┃  ┣ 📜 runner.sh            # 主控调度器（支持自定义概率轮盘）
 ┃  ┣ 📜 mod_google.sh        # Google 区域行为模拟
 ┃  ┣ 📜 mod_trust.sh         # IP 信用净化（精确路径路由）
 ┃  ┣ 📜 mod_quality.sh       # 深海声呐探测（HTML 劫持防砖加固）
 ┃  ┣ 📜 log_lib.sh           # 统一日志接口库
 ┃  ┣ 📜 updater.sh           # 热数据 OTA（供应链安全加固）
 ┃  ┣ 📜 tg_report.sh         # 每日战报生成
 ┃  ┗ 📜 uninstall.sh         # 无痕卸载
 ┣ 📂 master/                 # 司令部（SQLite + TG Bot）
 ┃  ┣ 📜 tg_master.sh         # TG 长轮询调度器（UI 沉底重绘 + HMAC v2 握手 + 凭证轮换）
 ┃  ┣ 📜 install_master.sh    # Master 引导入口
 ┃  ┗ 📜 uninstall_master.sh  # Master 卸载
 ┣ 📂 data/                   # 全球数据规则库
 ┃  ┣ 📜 map.json             # 全球战区拓扑图谱（含 Buffalo / Irvine / Chicago）
 ┃  ┣ 📂 regions/             # LBS 冷数据（城市坐标与白名单）
 ┃  ┣ 📂 keywords/            # 热数据：各国搜索词库
 ┃  ┗ 📜 user_agents.txt      # 热数据：设备指纹库
 ┣ 📂 scripts/                # CI/CD Python 生成器
 ┣ 📜 install.sh              # Agent 引导入口
 ┣ 📜 version.txt             # 版本信标 (v4.3.5)
 ┣ 📜 CHANGELOG.md            # 版本演进履历
 ┗ 📂 telemetry/              # Cloudflare Workers 统计网关
```

---

## 🚀 快速部署

> ⚠️ **提示**：本增强版与原项目配置格式 100% 兼容，升级无需繁琐迁移。

### 1. 部署 Master 司令部（只需一台 VPS）

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lgdglgc/IP-Sentinel-Enhanced/master/master/install_master.sh)"
```

### 2. 部署 Agent 边缘哨兵（需要养护的各台 VPS）

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lgdglgc/IP-Sentinel-Enhanced/master/install.sh)"
```

---

## 💡 进阶功能指南

### 🔁 全舰队一键切换 Bot 凭证 (Fleet Reconfig)
更换 Telegram 机器人不再需要逐台登录服务器重装：
1. 打开旧司令部 TG 面板，点击主菜单的 **`[ 🔁 全舰队切换 Bot 凭证 ]`**；
2. 发送新凭证（支持第一行填 `Bot Token`，第二行填 `Chat ID`，或单行空格分隔）；
3. 司令部自动调用 TG API `getMe` 校验新凭证，通过后向所有开启 OTA 的节点下发切换指令；
4. 各节点自动完成新 Bot 握手、向新 Bot 发送注册回执，并使用 `fcntl` 文件锁原子更新本地配置与平滑热重启！

### 📡 重新发送注册指令 (选项 3)
若司令部重装导致节点档案丢失，或节点公网 IP 发生漂移变更：
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lgdglgc/IP-Sentinel-Enhanced/master/install.sh)"
```
在主菜单直接键入 `3`：系统将自动读取本地配置、复测当前网络出口及 WARP 状态，直接向您的 Telegram 推送注册报文，全程不破坏已有配置与服务。

### 🔍 外部健康探活端点 (`/health`)
增强版专属轻量探活接口，无需 HMAC 签名计算，专供监控系统（如 Uptime Kuma、Prometheus、黑盒监控）调用：
```bash
curl -k https://<YOUR_VPS_IP>:9527/health
```
返回示例：
```json
{
  "status": "ok",
  "version": "4.3.5",
  "node_alias": "东京-01",
  "region": "JP",
  "hmac_version": "v2",
  "ota_enabled": true,
  "uptime_seconds": 18240
}
```

### ⚙️ 自定义调度权重 (`/opt/ip_sentinel/config.conf`)
可随心调节任务触发偏好（默认：Google 纠偏 70%，信用净化 30%）：
```bash
# 修改模块调度权重（百分比或比例均可）
GOOGLE_WEIGHT="80"
TRUST_WEIGHT="20"

# 开启 JSON 结构化日志
ENABLE_JSON_LOG="false"
```

---

## 🆙 升级方式

- **方式一（远程静默升级）**：在 Telegram 控制台中依次点击 **`[ 🆙 升级控制中枢 ]`** 与 **`[ 🔄 全网节点 OTA 热重载 ]`**。
- **方式二（终端无损升级）**：直接在终端重新执行部署命令，脚本将自动识别历史档案，一路按回车即可 3 秒平滑继承。

---

## 🗑️ 卸载

```bash
bash /opt/ip_sentinel/core/uninstall.sh
```

---

## ⚙️ 支持平台

- Debian / Ubuntu ✅
- CentOS / RHEL / AlmaLinux / Rocky Linux ✅
- Alpine Linux ✅
- Arch Linux ✅

---

## ⚠️ 免责声明

本项目仅供网络协议研究、网络拓扑分析与个人 VPS 维护学习使用。请遵守目标服务商服务条款 (TOS) 及相关法律法规。

---

## 🤝 致敬与支持

感谢 **[hotyue/IP-Sentinel](https://github.com/hotyue/IP-Sentinel)** 原作者及所有社区贡献者的杰出开源贡献！
如果本项目对你有帮助，欢迎为本项目及原项目点亮 ⭐ Star！