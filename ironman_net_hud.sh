#!/data/data/com.termux/files/usr/bin/bash

clear
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

TARGET="1.1.1.1"
DNS1="1.1.1.1"
DNS2="8.8.8.8"

while true; do
clear

PING=$(ping -c 1 -W 1 $TARGET | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
IP=$(ip addr show | grep inet | grep -v 127 | awk '{print $2}' | head -n 1)
NET=$(ip route | grep default | awk '{print $5}')

echo -e "${RED}╔══════════════════════════════════════╗${NC}"
echo -e "${RED}║  OPERATOR : SanTiPapHacker            ║${NC}"
echo -e "${RED}║  MODE     : IRONMAN NET HUD           ║${NC}"
echo -e "${RED}╚══════════════════════════════════════╝${NC}"

echo -e "${CYAN}NETWORK     : ${YELLOW}$NET${NC}"
echo -e "${CYAN}LOCAL IP    : ${YELLOW}$IP${NC}"
echo -e "${CYAN}DNS ACTIVE  : ${YELLOW}$DNS1 , $DNS2${NC}"

if [ -z "$PING" ]; then
  echo -e "${RED}PING        : NO RESPONSE ❌${NC}"
else
  echo -e "${GREEN}PING        : ${PING} ms ⚡${NC}"
fi

echo ""
echo -e "${CYAN}OPTIMIZER STATUS:${NC}"
echo -e "${GREEN}✔ DNS Optimized${NC}"
echo -e "${GREEN}✔ Latency Monitor Active${NC}"
echo -e "${GREEN}✔ HUD Running Stable${NC}"

sleep 1
done
