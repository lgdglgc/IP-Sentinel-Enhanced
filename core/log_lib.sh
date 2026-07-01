#!/bin/bash
# ==========================================================
# 文件: core/log_lib.sh
# 版本: 1.0.0
# 职责: 全系统统一日志接口规范
# 改进: 统一 log() / log_msg() 不一致的接口，消除跨模块调用混乱
# ==========================================================

# ----------------------------------------------------------
# 核心接口: sentinel_log <MODULE> <LEVEL> <MESSAGE>
# LEVEL 枚举: INFO WARN ERROR DEBUG START END EXEC WAIT SCORE
# ----------------------------------------------------------
sentinel_log() {
    local module="${1:-SYSTEM}"
    local level="${2:-INFO}"
    local msg="$3"
    local local_ver="${AGENT_VERSION:-未知}"
    local region="${REGION_CODE:-UNKN}"
    local install_dir="${INSTALL_DIR:-/opt/ip_sentinel}"
    local log_file="${LOG_FILE:-${install_dir}/logs/sentinel.log}"

    mkdir -p "${install_dir}/logs"

    local core_msg
    core_msg=$(printf "[v%-5s] [%-5s] [%-7s] [%s] %s" \
        "$local_ver" "$level" "$module" "$region" "$msg")

    echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] $core_msg" >> "$log_file"

    if command -v logger >/dev/null 2>&1; then
        logger -t ip-sentinel "$core_msg"
    else
        echo "$core_msg"
    fi

    # [可选] JSON 结构化侧输出（通过 ENABLE_JSON_LOG=true 开启）
    if [ "${ENABLE_JSON_LOG:-false}" == "true" ]; then
        local json_log_file="${install_dir}/logs/sentinel.jsonl"
        local ts
        ts=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
        # 使用 printf 安全转义 msg 中的双引号
        local safe_msg
        safe_msg=$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g')
        printf '{"ts":"%s","v":"%s","mod":"%s","lvl":"%s","reg":"%s","msg":"%s"}\n' \
            "$ts" "$local_ver" "$module" "$level" "$region" "$safe_msg" \
            >> "$json_log_file"
    fi
}

# ----------------------------------------------------------
# 向后兼容别名
# 旧接口: log "MODULE" "LEVEL" "MSG" → 直接映射
# ----------------------------------------------------------
log() {
    sentinel_log "$1" "$2" "$3"
}

# ----------------------------------------------------------
# 向后兼容别名
# 旧接口: log_msg "LEVEL" "MSG"（mod_trust.sh 使用）
# 自动注入模块名 Trust
# ----------------------------------------------------------
log_msg() {
    sentinel_log "Trust" "$1" "$2"
}

export -f sentinel_log log log_msg
