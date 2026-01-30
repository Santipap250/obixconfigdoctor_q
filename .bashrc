# === AUTO START IRONMAN HUD ===
if [ -z "$HUD_STARTED" ]; then
  export HUD_STARTED=1
  clear
  bash $HOME/ironman_net_hud_proof.sh
fi
alias ais="bash ~/ironman_net_hud_proof.sh"
export PATH="$HOME/bin:$PATH"
clear
echo "WELCOME AGENT TUI"
clear
echo "INITIALIZING OBIXCONFIG LAB..."
sleep 1
echo "ACCESSING DRONE DATABASE..."
sleep 1
echo "AUTHORIZED USER: TUI"
sleep 1
cmatrix -b
