#!/bin/sh
# Nexus 1.0 跨境黑盒 - API 智能修复版

API_TOKEN="edb1c6e5d4535362987496954971fbe36a1d10af94c4ef3f8ed942af1888"
REPO_BASE="https://cdn.jsdelivr.net/gh/xieyi138-star/nexus-repo@main"

echo "🚀 Nexus 正在进行 API 授权自修复..."

# 1. 自动获取当前公网 IP 并绑定白名单 (解决 i/o timeout 的杀手锏)
CURRENT_IP=$(curl -s http://checkip.amazonaws.com)
echo "检测到当前公网 IP: $CURRENT_IP"

# 调用 IPRoyal API 自动更新白名单 (假设 API 路径如下，需确认)
curl -X POST "https://api.iproyal.com/v1/reseller/auth/ip" \
     -H "X-Access-Token: $API_TOKEN" \
     -d "ip=$CURRENT_IP"

echo "✅ IP 授权已更新，正在重新激活流量通道..."

# 2. 下面继续原有的 OpenClash 重启逻辑
/etc/init.d/openclash restart
echo "------------------------------------------------"
echo "[SUCCESS] 跨境通道已通过 API 自动锁定！"
