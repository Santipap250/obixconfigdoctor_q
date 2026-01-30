#!/data/data/com.termux/files/usr/bin/bash

# ===== COLOR =====
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
NC='\033[0m'

# ===== CONFIG =====
DNS_LIST=("1.1.1.1" "8.8.8.8" "9.9.9.9")
DNS_INDEX=0
PING_LIMIT=120
MAX_GRAPH=20
PING_LOG=()

TARGET="${DNS_LIST[0]}"

# ===== FUNCTIONS =====
switch_dns() {
  DNS_INDEX=$(( (DNS_INDEX + 1) % ${#DNS_LIST[@]} ))
  TARGET="${DNS_LIST[$DNS_INDEX]}"
}

draw_graph() {
  echo -e "${CYAN}PING GRAPH (ล่าสุด → เก่า)${NC}"
  for p in "${PING_LOG[@]}"; do
    bars=$(( p / 10 ))
    (( bars > 25 )) && bars=25
    printf "%4sms |" "$p"
    printf "█%.0s" $(seq 1 $bars)
    echo ""
  done
}

benchmark() {
  echo -e "${YELLOW}🧪 RUNNING AUTO BENCHMARK...${NC}"
  SUM=0
  COUNT=10
  for i in $(seq 1 $COUNT); do
    P=$(ping -c 1 -W 1 "$TARGET" | awk -F'time=' '/time=/{print int($2)}')
    [[ -z "$P" ]] && P=200
    SUM=$((SUM + P))
    sleep 0.3
  done
  AVG=$((SUM / COUNT))
  echo -e "${GREEN}✔ AVG PING : ${AVG} ms${NC}"
  sleep 1
}

# ===== ESC KEY EXIT =====
check_key() {
  read -rsn1 -t 0.1 key
  if [[ $key == $'\e' ]]; then
    tput cnorm
    clear
    echo "ESC PRESSED - EXIT HUD"
    exit 0
  fi
}

# ===== BEFORE BENCH =====
benchmark

# ===== MAIN LOOP =====
clear
tput civis   # hide cursor

while true; do
  check_key
  tput cup 0 0

  PING=$(ping -c 1 -W 1 "$TARGET" | awk -F'time=' '/time=/{print int($2)}')
  [[ -z "$PING" ]] && PING=200

  PING_LOG=("$PING" "${PING_LOG[@]}")
  PING_LOG=("${PING_LOG[@]:0:$MAX_GRAPH}")

  NET=$(ip route | awk '/default/{print $5}')
  IP=$(ip addr show | awk '/inet / && !/127.0.0.1/{print $2}' | head -n1)

  echo -e "${RED}╔══════════════════════════════╗${NC}"
  echo -e "${RED}║ SanTiPapHacker | PROOF MODE  ║${NC}"
  echo -e "${RED}╚══════════════════════════════╝${NC}"

  echo -e "${CYAN}NET   : ${YELLOW}$NET${NC}"
  echo -e "${CYAN}IP    : ${YELLOW}$IP${NC}"
  echo -e "${CYAN}DNS   : ${YELLOW}$TARGET${NC}"
  echo -e "${CYAN}PING  : ${GREEN}${PING} ms${NC}"

  if (( PING > PING_LIMIT )); then
    echo -e "${RED}🚨 HIGH LATENCY! Switching DNS...${NC}"
    switch_dns
  fi

  echo ""
  draw_graph
  echo ""
  echo -e "${MAGENTA}HUD STATUS:${NC}"
  echo -e "${GREEN}✔ REALTIME GRAPH${NC}"
  echo -e "${GREEN}✔ DNS AUTO SWITCH${NC}"
  echo -e "${GREEN}✔ PROOF MODE ACTIVE${NC}"

  sleep 1
done
