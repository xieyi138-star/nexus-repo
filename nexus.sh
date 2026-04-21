#!/bin/sh
# Nexus 1.0 跨境黑盒 - 终极一键云端部署脚本

# 获取传入的节点参数
NODE_SERVER=$1
NODE_PORT=$2
NODE_USER=$3
NODE_PASS=$4

# 基础链接（指向你的军火库）
REPO_BASE="https://cdn.jsdelivr.net/gh/xieyi138-star/nexus-repo@main"

echo "------------------------------------------------"
echo "🚀 Nexus 1.0 云端部署启动..."
echo "------------------------------------------------"

# 1. 环境清理与依赖下载
cd /tmp
echo "Step 1: 正在拉取插件本体..."
wget -q -O oc.ipk "${REPO_BASE}/luci-app-openclash_0.47.088_all.ipk"
opkg install oc.ipk

# 2. 内核精准注入
echo "Step 2: 正在拉取 Meta 内核..."
mkdir -p /etc/openclash/core/
wget -q -O /etc/openclash/core/clash_meta "${REPO_BASE}/clash_meta"
chmod +x /etc/openclash/core/clash_meta
ln -sf /etc/openclash/core/clash_meta /etc/openclash/core/clash_meta_meta

# 3. 物理生成配置文件
echo "Step 3: 正在注入节点信息..."
cat <<EOF > /etc/openclash/config/config.yaml
mixed-port: 7890
allow-left-side: true
mode: rule
proxies:
  - name: "Nexus-Residential"
    type: socks5
    server: ${NODE_SERVER}
    port: ${NODE_PORT}
    username: ${NODE_USER}
    password: ${NODE_PASS}
    udp: true
proxy-groups:
  - name: 🚀 跨境专线
    type: select
    proxies:
      - "Nexus-Residential"
rules:
  - MATCH, 🚀 跨境专线
EOF

# 4. 固化参数并起飞
echo "Step 4: 固化配置并重启服务..."
uci set openclash.config.config_path='/etc/openclash/config/config.yaml'
uci set openclash.config.en_mode='fake_ip'
uci set openclash.config.dns_remote_parsing='1'
uci set openclash.config.enable='1'
uci commit openclash

/etc/init.d/openclash restart
echo "------------------------------------------------"
echo "[SUCCESS] Nexus 1.0 部署完成！"
echo "请开关飞行模式后访问 whoer.net 验收。"
echo "------------------------------------------------"
