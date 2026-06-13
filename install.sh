#!/bin/bash

# ============================================
# HANS HACKER THEME - COMPLETE AUTOSCRIPT
# ============================================

clear

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Banner
echo -e "${CYAN}"
cat << "BANNER"
╔══════════════════════════════════════════════════════════════╗
║     ██╗  ██╗ █████╗ ███╗   ██╗███████╗                     ║
║     ██║  ██║██╔══██╗████╗  ██║██╔════╝                     ║
║     ███████║███████║██╔██╗ ██║███████╗                     ║
║     ██╔══██║██╔══██║██║╚██╗██║╚════██║                     ║
║     ██║  ██║██║  ██║██║ ╚████║███████║                     ║
║     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝                     ║
║                                                              ║
║              H A N S   H A C K E R   A I                    ║
║                    COMPLETE AUTOSCRIPT                      ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
sleep 2

# Step 1: Auto Storage Permission
echo -e "${YELLOW}[1/5] Setting up storage permission...${NC}"
if [ ! -d ~/storage ]; then
    echo -e "${BLUE}Requesting storage permission...${NC}"
    termux-setup-storage
    sleep 3
    echo -e "${GREEN}✓ Storage permission granted${NC}"
else
    echo -e "${GREEN}✓ Storage already accessible${NC}"
fi
sleep 1

# Step 2: Auto Install Packages
echo -e "${YELLOW}[2/5] Installing packages...${NC}"
pkg update -y && pkg upgrade -y
pkg install -y curl jq git nano
echo -e "${GREEN}✓ Packages installed${NC}"
sleep 1

# Step 3: Auto Create Directories
echo -e "${YELLOW}[3/5] Creating directories...${NC}"
mkdir -p ~/.hans_hacker/memory
mkdir -p ~/.hans_hacker/backup
mkdir -p ~/storage/downloads/hans_backup 2>/dev/null
echo -e "${GREEN}✓ Directories created${NC}"
sleep 1

# Step 4: Auto Create AI System
echo -e "${YELLOW}[4/5] Creating AI system...${NC}"

cat > ~/.hans_hacker/ai_core.sh << 'EOF'
#!/bin/bash

# HANS HACKER AI - PERMANENT MEMORY
AI_STATE="$HOME/.hans_hacker/state"
AI_MEMORY="$HOME/.hans_hacker/memory/memory.txt"
AI_HISTORY="$HOME/.hans_hacker/memory/history.txt"

[ ! -f "$AI_STATE" ] && echo "off" > "$AI_STATE"
touch "$AI_MEMORY" "$AI_HISTORY"

hans() {
    case "$1" in
        on)
            echo "on" > "$AI_STATE"
            echo -e "\033[92m✅ HANS HACKER AI ACTIVATED - I WILL REMEMBER EVERYTHING!\033[0m"
            ;;
        off)
            echo "off" > "$AI_STATE"
            echo -e "\033[91m❌ HANS HACKER AI DEACTIVATED\033[0m"
            ;;
        status)
            [ "$(cat "$AI_STATE")" = "on" ] && echo -e "\033[92m🤖 AI: ACTIVE\033[0m" || echo -e "\033[91m💀 AI: INACTIVE\033[0m"
            ;;
        memory)
            echo -e "\033[96m📚 What I remember:\033[0m"
            [ -s "$AI_MEMORY" ] && cat "$AI_MEMORY" || echo -e "\033[33mNo memories yet\033[0m"
            ;;
        clear)
            echo -e "\033[93mClear all memory? (y/n): \033[0m"
            read -n 1 -r; echo
            [[ $REPLY =~ ^[Yy]$ ]] && > "$AI_MEMORY" && > "$AI_HISTORY" && echo -e "\033[92m✅ Memory cleared!\033[0m"
            ;;
        backup)
            if [ -d "$HOME/storage/downloads" ]; then
                cp "$AI_MEMORY" "$HOME/storage/downloads/hans_backup/memory_$(date +%Y%m%d_%H%M%S).txt"
                echo -e "\033[92m✅ Backed up to Downloads\033[0m"
            else
                echo -e "\033[33m⚠️ Run: termux-setup-storage\033[0m"
            fi
            ;;
        *)
            echo -e "\033[36m╔════════════════════════════════════════════╗\033[0m"
            echo -e "\033[36m║     \033[95m🤖 HANS HACKER AI\033[36m                      ║\033[0m"
            echo -e "\033[36m╠════════════════════════════════════════════╣\033[0m"
            echo -e "\033[36m║\033[0m \033[92mhans on\033[0m      - Activate AI              \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[91mhans off\033[0m     - Deactivate AI            \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[96mhans memory\033[0m  - Show memories            \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[93mhans clear\033[0m   - Clear all memory         \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[94mhans backup\033[0m  - Backup memory            \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[90mhans status\033[0m  - Check status             \033[36m║\033[0m"
            echo -e "\033[36m╚════════════════════════════════════════════╝\033[0m"
            ;;
    esac
}

# Auto memory save
save_memory() {
    local msg="$1"
    if echo "$msg" | grep -qi "my name is"; then
        local name=$(echo "$msg" | sed 's/.*my name is //i' | awk '{print $1}')
        echo "📝 Your name is $name" >> "$AI_MEMORY"
    fi
    if echo "$msg" | grep -qi "i like"; then
        local like=$(echo "$msg" | sed 's/.*i like //i')
        echo "❤️ You like $like" >> "$AI_MEMORY"
    fi
}

# AI Response
call_api() {
    local msg="$1"
    local history=$(tail -n 10 "$AI_HISTORY" 2>/dev/null)
    local memory=$(cat "$AI_MEMORY" 2>/dev/null)
    
    local prompt="You are Hans AI. Memory: $memory. History: $history. User: $msg. Respond naturally:"
    
    curl -s -G "https://Hansxmd-HansAi.hf.space/ai/logic" \
        --data-urlencode "q=$msg" \
        --data-urlencode "logic=$prompt" \
        --max-time 15 2>/dev/null | jq -r '.result // .response // .answer // "Hans AI ready!"' 2>/dev/null
}

# Process command
process() {
    local cmd="$1"
    [ "$(cat "$AI_STATE")" != "on" ] && return 1
    [[ "$cmd" =~ ^(hans|ai)$ ]] && return 1
    
    echo -ne "\n\033[96m🤖 Hans AI: \033[0m"
    local resp=$(call_api "$cmd")
    echo -e "\033[93m$resp\033[0m\n"
    
    echo "[$(date '+%H:%M:%S')] User: $cmd" >> "$AI_HISTORY"
    echo "[$(date '+%H:%M:%S')] Hans: $resp" >> "$AI_HISTORY"
    save_memory "$cmd"
    tail -n 100 "$AI_HISTORY" > "$AI_HISTORY.tmp" && mv "$AI_HISTORY.tmp" "$AI_HISTORY"
}

# Command handler
command_not_found_handle() { process "$*"; return 0; }

export -f hans process
EOF

# Step 5: Create Theme
cat > ~/.hans_hacker/theme.sh << 'EOF'
#!/bin/bash

get_indicator() {
    [ "$(cat "$HOME/.hans_hacker/state" 2>/dev/null)" = "on" ] && echo "🧠🤖" || echo "💀"
}

get_color() {
    echo ${COLORS[$RANDOM % ${#COLORS[@]}]}
}

COLORS=(31 32 33 34 35 36 91 92 93 94 95 96)
generate_ps1() {
    PS1="\[\e[$(get_color)m\]┌──(HANS-HACKER@HANS-TECH)-[$(get_indicator)]-[\W]\n└─$ \[\e[0m\]"
}
PROMPT_COMMAND="generate_ps1"
EOF

echo -e "${GREEN}✓ AI system created${NC}"
sleep 1

# Step 5: Auto Configure .bashrc
echo -e "${YELLOW}[5/5] Configuring .bashrc...${NC}"

# Backup existing
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.backup

# Create new .bashrc
cat > ~/.bashrc << 'BASHRC'
# HANS HACKER THEME
source ~/.hans_hacker/ai_core.sh
source ~/.hans_hacker/theme.sh

alias c='clear'
alias cls='clear'
command_not_found_handle() { process "$*"; return 0; }

# Welcome banner
if [ ! -f ~/.hans_hacker/welcome ]; then
    clear
    echo -e "\033[96m"
    cat << "BAN"
╔══════════════════════════════════════════════════════════════╗
║     ██╗  ██╗ █████╗ ███╗   ██╗███████╗                     ║
║     ██║  ██║██╔══██╗████╗  ██║██╔════╝                     ║
║     ███████║███████║██╔██╗ ██║███████╗                     ║
║     ██╔══██║██╔══██║██║╚██╗██║╚════██║                     ║
║     ██║  ██║██║  ██║██║ ╚████║███████║                     ║
║     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝                     ║
║              H A N S   H A C K E R   A I                    ║
╚══════════════════════════════════════════════════════════════╝
BAN
    echo -e "\033[0m"
    echo ""
    echo -e "\033[92m┌─────────────────────────────────────────────────┐\033[0m"
    echo -e "\033[92m│  \033[96m🤖 COMMANDS\033[92m                                          │\033[0m"
    echo -e "\033[92m├─────────────────────────────────────────────────┤\033[0m"
    echo -e "\033[92m│  \033[92mhans on\033[92m      - Activate AI                         │\033[0m"
    echo -e "\033[92m│  \033[91mhans off\033[92m     - Deactivate AI                       │\033[0m"
    echo -e "\033[92m│  \033[96mhans memory\033[92m  - Show memories                       │\033[0m"
    echo -e "\033[92m│  \033[93mhans clear\033[92m   - Clear all memory                    │\033[0m"
    echo -e "\033[92m│  \033[94mhans backup\033[92m  - Backup to storage                   │\033[0m"
    echo -e "\033[92m└─────────────────────────────────────────────────┘\033[0m"
    echo ""
    echo -e "\033[93m💡 Type '\033[92mhans on\033[93m' to activate AI!\033[0m"
    echo -e "\033[93m💡 Your memories are saved PERMANENTLY!\033[0m"
    echo ""
    touch ~/.hans_hacker/welcome
fi
BASHRC

echo -e "${GREEN}✓ .bashrc configured${NC}"
sleep 1

# Step 6: Auto Finalize
echo -e "${YELLOW}Finalizing...${NC}"
chmod +x ~/.hans_hacker/ai_core.sh ~/.hans_hacker/theme.sh
echo "off" > ~/.hans_hacker/state

echo ""
echo -e "${CYAN}══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}⏳ Auto-reloading in 4 seconds...${NC}"

for i in 4 3 2 1; do
    echo -ne "\r${CYAN}🔄 $i...${NC}   "
    sleep 1
done

echo ""
echo -e "${GREEN}🔄 Loading HANS HACKER THEME...${NC}"
sleep 1

# Auto reload
source ~/.bashrc

# Final message
clear
echo -e "${GREEN}"
cat << "DONE"
╔══════════════════════════════════════════════════════════════════╗
║     ✅ HANS HACKER THEME INSTALLED SUCCESSFULLY!               ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  💾 PERMANENT MEMORY:                                           ║
║     ✓ All memories saved forever                               ║
║     ✓ Survives restarts and reboots                           ║
║                                                                  ║
║  📋 QUICK START:                                                ║
║     hans on      - Activate AI                                 ║
║     hello        - Start chatting                              ║
║     hans memory  - See what I remember                         ║
║                                                                  ║
║  🗑️  UNINSTALL:                                                ║
║     bash <(curl -fsSL https://raw.githubusercontent.com/Mrhanstz/Hans-Hacker-them/main/uninstall.sh)
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
DONE
echo -e "${NC}"

echo ""
echo -e "\033[96m🚀 Type '\033[92mhans on\033[96m' to start using AI!\033[0m"
echo -e "\033[93m💡 Example: 'my name is John' then 'what is my name'\033[0m"
echo -e "\033[93m💡 Theme auto-reloaded successfully!\033[0m\n"
