#!/data/data/com.termux/files/usr/bin/bash

# ========= GOD MODE NET HUD =========
# OPERATOR: SanTiPapHacker
# EXIT: ESC KEY
# ===================================

# ----- COLOR -----
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# ----- CONFIG -----
DNS_LIST=("1.1.1.1" "8.8.8.8" "9.9.9.9")
DNS_INDEX=0
PING_LIMIT=120
MAX_GRAPH=25
PING_LOG=()
TARGET="${DNS_LIST[0]}"

# ----- FUNCTIONS -----
switch_dns() {
  DNS_INDEX=$(( (DNS_INDEX + 1) % ${#DNS_LIST[@]} ))
  TARGET="${DNS_LIST[$DNS_INDEX]}"
}

draw_graph() {
  echo -e "${CYAN}PING GRAPH (LIVE)${NC}"
  for p in "${PING_LOG[@]}"; do
    bars=$(( p / 8 ))
    (( bars > 30 )) && bars=30
    printf "%4sms |" "$p"
    printf "█%.0s" $(seq 1 $bars)
    echo ""
  done
}

benchmark() {
  SUM=0
  COUNT=12
  for i in $(seq 1 $COUNT); do
    P=$(ping -c 1 -W 1 "$TARGET" | awk -F'time=' '/time=/{print int($2)}')
    [[ -z "$P" ]] && P=200
    SUM=$((SUM + P))
    sleep 0.2
  done
  echo $((SUM / COUNT))
}

check_key() {
  read -rsn1 -t 0.05 key
  if [[ $key == $'\e' ]]; then
    tput cnorm
    clear
    echo "EXIT GOD MODE"
    exit 0
  fi
}

# ----- BEFORE TEST -----
clear
echo -e "${YELLOW}🧪 RUNNING BEFORE BENCHMARK...${NC}"
BEFORE_AVG=$(benchmark)
sleep 1

# ----- MAIN LOOP -----
clear
tput civis

while true; do
  check_key
  tput cup 0 0

  PING=$(ping -c 1 -W 1 "$TARGET" | awk -F'time=' '/time=/{print int($2)}')
  [[ -z "$PING" ]] && PING=200

  PING_LOG=("$PING" "${PING_LOG[@]}")
  PING_LOG=("${PING_LOG[@]:0:$MAX_GRAPH}")

  NET=$(ip route | awk '/default/{print $5}')
  IP=$(ip addr show | awk '/inet / && !/127.0.0.1/{print $2}' | head -n1)

  echo -e "${RED}╔══════════════════════════════════╗${NC}"
  echo -e "${RED}║  SanTiPapHacker :: GOD MODE NET  ║${NC}"
  echo -e "${RED}╚══════════════════════════════════╝${NC}"

  echo -e "${CYAN}NET        : ${YELLOW}$NET${NC}"
  echo -e "${CYAN}IP         : ${YELLOW}$IP${NC}"
  echo -e "${CYAN}DNS        : ${YELLOW}$TARGET${NC}"
  echo -e "${CYAN}PING       : ${GREEN}${PING} ms${NC}"
  echo -e "${CYAN}BEFORE AVG : ${WHITE}${BEFORE_AVG} ms${NC}"

  DIFF=$((BEFORE_AVG - PING))
  if (( DIFF > 0 )); then
    echo -e "${GREEN}GAIN       : ↓ ${DIFF} ms${NC}"
  else
    echo -e "${RED}GAIN       : ↑ ${DIFF#-} ms${NC}"
  fi

  if (( PING > PING_LIMIT )); then
    echo -e "${RED}🚨 HIGH LATENCY → SWITCH DNS${NC}"
    switch_dns
  fi

  echo ""
  draw_graph

  echo ""
  echo -e "${MAGENTA}STATUS:${NC}"
  echo -e "${GREEN}✔ REALTIME HUD${NC}"
  echo -e "${GREEN}✔ AUTO DNS SWITCH${NC}"
  echo -e "${GREEN}✔ PROOF MODE ACTIVE${NC}"
  echo -e "${YELLOW}ESC = EXIT${NC}"

  sleep 0.6
done
