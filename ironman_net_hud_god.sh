#!/data/data/com.termux/files/usr/bin/bash

# ====== COLOR ======
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
NC='\033[0m'

# ====== CONFIG ======
PING_LIMIT=120
DNS_LIST=("1.1.1.1" "8.8.8.8" "9.9.9.9")
DNS_INDEX=0
TARGET="1.1.1.1"

# ====== FUNCTIONS ======
progress_bar() {
  local value=$1
  local max=200
  local size=20
  local filled=$(( value * size / max ))
  local empty=$(( size - filled ))
  printf "${GREEN}["
  printf "█%.0s" $(seq 1 $filled)
  printf "${RED}░%.0s" $(seq 1 $empty)
  printf "${GREEN}]${NC}"
}

switch_dns() {
  DNS_INDEX=$(( (DNS_INDEX + 1) % ${#DNS_LIST[@]} ))
  TARGET=${DNS_LIST[$DNS_INDEX]}
}

# ====== LOOP ======
while true; do
clear

PING_RAW=$(ping -c 1 -W 1 $TARGET | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print int($1)}')
NET=$(ip route | grep default | awk '{print $5}')
IP=$(ip addr show | grep inet | grep -v 127 | awk '{print $2}' | head -n 1)

echo -e "${RED}╔═══════════════════════════════════════════╗${NC}"
echo -e "${RED}║   OPERATOR : TUIžFPV SanTiPap                 ║${NC}"
echo -e "${RED}║   MODE     : OBIXCONFIG NET HUD | GOD MODE    ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════╝${NC}"

echo -e "${CYAN}NETWORK   : ${YELLOW}$NET${NC}"
echo -e "${CYAN}LOCAL IP  : ${YELLOW}$IP${NC}"
echo -e "${CYAN}DNS NODE  : ${YELLOW}$TARGET${NC}"
echo ""

if [[ -z "$PING_RAW" ]]; then
  echo -e "${RED}PING      : NO RESPONSE ❌${NC}"
  switch_dns
else
  echo -e "${CYAN}PING      : ${GREEN}${PING_RAW} ms${NC}"
  echo -n "${CYAN}SIGNAL    : "
  progress_bar $PING_RAW
  echo ""

  if (( PING_RAW > PING_LIMIT )); then
    echo -e "${RED}🚨 ALERT : HIGH LATENCY DETECTED !${NC}"
    echo -e "${YELLOW}⚡ Switching DNS Node...${NC}"
    switch_dns
  else
    echo -e "${GREEN}STATUS    : STABLE ⚡${NC}"
  fi
fi

echo ""
echo -e "${MAGENTA}SYSTEM STATUS:${NC}"
echo -e "${GREEN}✔ DNS AUTO SWITCH${NC}"
echo -e "${GREEN}✔ REALTIME LATENCY MONITOR${NC}"
echo -e "${GREEN}✔ HUD FULL SCREEN ACTIVE${NC}"

sleep 1
done
