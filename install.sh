#!/bin/bash

# HANS HACKER THEME - COMPLETE INSTALLER WITH PERMANENT STORAGE
clear

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

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
║         PERMANENT INSTALLATION WITH STORAGE                 ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
sleep 2

# ============================================
# STEP 1: Request Storage Permission
# ============================================
echo -e "${YELLOW}[1/6] Checking Termux Storage Permission...${NC}"

if [ ! -d ~/storage ]; then
    echo -e "${BLUE}┌─────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│  📱 TERMUX STORAGE PERMISSION REQUIRED          │${NC}"
    echo -e "${BLUE}├─────────────────────────────────────────────────┤${NC}"
    echo -e "${BLUE}│  Hans Hacker Theme needs storage permission to:  │${NC}"
    echo -e "${BLUE}│  • Save AI memory permanently                    │${NC}"
    echo -e "${BLUE}│  • Backup your conversations                     │${NC}"
    echo -e "${BLUE}│  • Store theme files securely                    │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Termux needs storage access to save permanently!${NC}"
    echo -e "${CYAN}Do you want to grant storage permission? (y/n): ${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}✓ Requesting storage permission...${NC}"
        termux-setup-storage
        sleep 3
        echo -e "${GREEN}✓ Storage permission granted!${NC}"
    else
        echo -e "${RED}❌ Storage permission denied!${NC}"
        echo -e "${YELLOW}Theme will still work but memory may not persist after reboot${NC}"
    fi
else
    echo -e "${GREEN}✓ Storage already accessible${NC}"
fi
sleep 1

# ============================================
# STEP 2: Install Required Packages
# ============================================
echo -e "${YELLOW}[2/6] Installing required packages...${NC}"
pkg update -y && pkg upgrade -y
pkg install -y curl jq git nano 2>/dev/null
echo -e "${GREEN}✓ Packages installed${NC}"
sleep 1

# ============================================
# STEP 3: Create Permanent Directories
# ============================================
echo -e "${YELLOW}[3/6] Creating permanent directories...${NC}"

# Create main directory
mkdir -p ~/.hans_hacker
mkdir -p ~/.hans_hacker/memory
mkdir -p ~/.hans_hacker/backup
mkdir -p ~/storage/downloads/hans_backup 2>/dev/null

echo -e "${GREEN}✓ Directories created${NC}"
sleep 1

# ============================================
# STEP 4: Create AI System with Permanent Memory
# ============================================
echo -e "${YELLOW}[4/6] Creating AI system with permanent memory...${NC}"

cat > ~/.hans_hacker/ai_core.sh << 'EOF'
#!/bin/bash

# HANS HACKER AI - PERMANENT MEMORY SYSTEM
AI_STATE_FILE="$HOME/.hans_hacker/ai_state"
AI_MEMORY_FILE="$HOME/.hans_hacker/memory/memory.txt"
AI_HISTORY_FILE="$HOME/.hans_hacker/memory/history.txt"

# Initialize files
[ ! -f "$AI_STATE_FILE" ] && echo "off" > "$AI_STATE_FILE"
[ ! -f "$AI_MEMORY_FILE" ] && touch "$AI_MEMORY_FILE"
[ ! -f "$AI_HISTORY_FILE" ] && touch "$AI_HISTORY_FILE"

# Save to memory
save_to_memory() {
    local user_msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] User: $user_msg" >> "$AI_HISTORY_FILE"
    
    if echo "$user_msg" | grep -qi "my name is"; then
        local name=$(echo "$user_msg" | grep -oi "my name is [A-Za-z]*" | sed 's/my name is //i')
        echo "[NAME] Your name is $name" >> "$AI_MEMORY_FILE"
    fi
    
    if echo "$user_msg" | grep -qi "i like"; then
        local pref=$(echo "$user_msg" | grep -oi "i like [A-Za-z ]*" | sed 's/i like //i')
        echo "[LIKES] You like $pref" >> "$AI_MEMORY_FILE"
    fi
    
    sort -u "$AI_MEMORY_FILE" | tail -n 100 > "$AI_MEMORY_FILE.tmp"
    mv "$AI_MEMORY_FILE.tmp" "$AI_MEMORY_FILE"
}

# Save AI response
save_response() {
    local response="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] Hans: $response" >> "$AI_HISTORY_FILE"
    tail -n 500 "$AI_HISTORY_FILE" > "$AI_HISTORY_FILE.tmp"
    mv "$AI_HISTORY_FILE.tmp" "$AI_HISTORY_FILE"
}

# Get memory context
get_memory_context() {
    local memory=$(cat "$AI_MEMORY_FILE" 2>/dev/null | tail -n 30)
    local history=$(tail -n 20 "$AI_HISTORY_FILE" 2>/dev/null)
    
    if [ -n "$memory" ]; then
        echo "WHAT I REMEMBER ABOUT YOU:"
        echo "$memory"
        echo ""
    fi
    
    if [ -n "$history" ]; then
        echo "RECENT CONVERSATION:"
        echo "$history"
        echo ""
    fi
}

# Call API
call_hans_api() {
    local user_input="$1"
    local context=$(get_memory_context)
    
    local prompt="You are Hans AI, created by Hans from Dodoma Tanzania. You have PERMANENT MEMORY.
    
$context

User: $user_input

Respond naturally, reference what you remember, be friendly:"
    
    local response=$(curl -s -G "https://Hansxmd-HansAi.hf.space/ai/logic" \
        --data-urlencode "q=$user_input" \
        --data-urlencode "logic=$prompt" \
        --max-time 15 2>/dev/null | jq -r '.result // .response // .answer // .' 2>/dev/null)
    
    if [ -z "$response" ] || [ "$response" = "null" ]; then
        response="Hans AI ready! What's on your mind?"
    fi
    
    echo "$response"
}

# Process command
process_with_ai() {
    local input="$1"
    local state=$(cat "$AI_STATE_FILE" 2>/dev/null)
    
    if [ "$state" != "on" ]; then
        return 1
    fi
    
    if [[ "$input" =~ ^(hans|ai)$ ]]; then
        return 1
    fi
    
    if [ -z "$input" ] || [ ${#input} -lt 2 ]; then
        return 1
    fi
    
    echo -ne "\n\033[96m🤖 Hans AI: \033[0m"
    local response=$(call_hans_api "$input")
    echo -e "\033[93m$response\033[0m\n"
    
    save_to_memory "$input"
    save_response "$response"
    
    return 0
}

# Show memory
show_memory() {
    echo -e "\033[96m╔════════════════════════════════════════════╗\033[0m"
    echo -e "\033[96m║     \033[95m🧠 WHAT I REMEMBER ABOUT YOU\033[96m          ║\033[0m"
    echo -e "\033[96m╚════════════════════════════════════════════╝\033[0m\n"
    
    if [ -s "$AI_MEMORY_FILE" ]; then
        cat "$AI_MEMORY_FILE"
    else
        echo -e "\033[33mNo memories yet. Tell me about yourself!\033[0m"
    fi
    
    echo -e "\n\033[96m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[96m📝 RECENT CONVERSATIONS:\033[0m"
    echo -e "\033[96m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    
    if [ -s "$AI_HISTORY_FILE" ]; then
        tail -n 30 "$AI_HISTORY_FILE"
    else
        echo -e "\033[33mNo conversations yet\033[0m"
    fi
}

# Clear memory
clear_memory() {
    echo -e "\033[93m⚠️ Delete all memory? (y/n): \033[0m"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        > "$AI_MEMORY_FILE"
        > "$AI_HISTORY_FILE"
        echo -e "\033[92m✅ All memory cleared!\033[0m"
    else
        echo -e "\033[92m✅ Memory preserved\033[0m"
    fi
}

# Backup memory
backup_memory() {
    if [ -d "$HOME/storage/downloads" ]; then
        local backup_name="hans_memory_$(date +%Y%m%d_%H%M%S).txt"
        cp "$AI_MEMORY_FILE" "$HOME/storage/downloads/hans_backup/$backup_name" 2>/dev/null
        echo -e "\033[92m✅ Memory backed up to Downloads/hans_backup/$backup_name\033[0m"
    else
        echo -e "\033[33m⚠️ Storage not accessible. Run: termux-setup-storage\033[0m"
    fi
}

# Hans command
hans() {
    case "$1" in
        on)
            echo "on" > "$AI_STATE_FILE"
            echo -e "\033[92m✅ HANS HACKER AI ACTIVATED - I WILL REMEMBER EVERYTHING!\033[0m"
            ;;
        off)
            echo "off" > "$AI_STATE_FILE"
            echo -e "\033[91m❌ HANS HACKER AI DEACTIVATED\033[0m"
            ;;
        status)
            local state=$(cat "$AI_STATE_FILE" 2>/dev/null)
            if [ "$state" = "on" ]; then
                echo -e "\033[92m🤖 AI Status: ACTIVE (Remembering everything)\033[0m"
                local memories=$(grep -c "^\[" "$AI_MEMORY_FILE" 2>/dev/null || echo 0)
                echo -e "\033[96m📚 I remember $memories things about you\033[0m"
            else
                echo -e "\033[91m💀 AI Status: INACTIVE\033[0m"
            fi
            ;;
        memory)
            show_memory
            ;;
        clear)
            clear_memory
            ;;
        backup)
            backup_memory
            ;;
        path)
            echo -e "\033[96m📁 Permanent storage: ~/.hans_hacker/\033[0m"
            ;;
        help|*)
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

# Command handler
command_not_found_handle() {
    process_with_ai "$*"
    return 0
}

export -f hans
export -f process_with_ai
EOF

echo -e "${GREEN}✓ AI system created${NC}"
sleep 1

# ============================================
# STEP 5: Create Theme
# ============================================
echo -e "${YELLOW}[5/6] Creating HANS HACKER Theme...${NC}"

cat > ~/.hans_hacker/theme.sh << 'EOF'
#!/bin/bash

get_ai_indicator() {
    local state=$(cat "$HOME/.hans_hacker/ai_state" 2>/dev/null || echo "off")
    if [ "$state" = "on" ]; then
        echo "🧠🤖"
    else
        echo "💀"
    fi
}

get_random_color() {
    COLORS=(31 32 33 34 35 36 91 92 93 94 95 96)
    echo ${COLORS[$RANDOM % ${#COLORS[@]}]}
}

generate_ps1() {
    local indicator=$(get_ai_indicator)
    local color=$(get_random_color)
    PS1="\[\e[${color}m\]┌──(HANS-HACKER@HANS-TECH)-[${indicator}]-[\W]\n└─$ \[\e[0m\]"
}

PROMPT_COMMAND="generate_ps1"
EOF

echo -e "${GREEN}✓ Theme created${NC}"
sleep 1

# ============================================
# STEP 6: Configure .bashrc (FIXED)
# ============================================
echo -e "${YELLOW}[6/6] Configuring .bashrc permanently...${NC}"

# Backup existing .bashrc
if [ -f ~/.bashrc ]; then
    cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)
fi

# Remove old entries
sed -i '/hans_hacker/d' ~/.bashrc

# Create fresh .bashrc
cat > ~/.bashrc << 'BASHRC'
# HANS HACKER THEME
source ~/.hans_hacker/ai_core.sh
source ~/.hans_hacker/theme.sh

# Aliases
alias c='clear'
alias cls='clear'
alias ll='ls -lah'

# Command handler
command_not_found_handle() {
    process_with_ai "$*"
    return 0
}

# Welcome banner
if [ ! -f ~/.hans_hacker/welcome_shown ]; then
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
║                                                              ║
║              H A N S   H A C K E R   A I                    ║
║                 PERMANENT MEMORY ACTIVE                      ║
╚══════════════════════════════════════════════════════════════╝
BAN
    echo -e "\033[0m"
    echo ""
    echo -e "\033[92m┌─────────────────────────────────────────────────┐\033[0m"
    echo -e "\033[92m│  \033[96m🤖 PERMANENT AI COMMANDS\033[92m                      │\033[0m"
    echo -e "\033[92m├─────────────────────────────────────────────────┤\033[0m"
    echo -e "\033[92m│  \033[92mhans on\033[92m      - Activate AI                 │\033[0m"
    echo -e "\033[92m│  \033[91mhans off\033[92m     - Deactivate AI               │\033[0m"
    echo -e "\033[92m│  \033[96mhans memory\033[92m  - Show memories               │\033[0m"
    echo -e "\033[92m│  \033[93mhans clear\033[92m   - Delete all memory           │\033[0m"
    echo -e "\033[92m│  \033[94mhans backup\033[92m  - Backup memory               │\033[0m"
    echo -e "\033[92m└─────────────────────────────────────────────────┘\033[0m"
    echo ""
    echo -e "\033[93m💡 Type '\033[92mhans on\033[93m' to activate AI!\033[0m"
    echo -e "\033[93m💡 Your memories are saved PERMANENTLY!\033[0m"
    echo ""
    touch ~/.hans_hacker/welcome_shown
fi
BASHRC

echo -e "${GREEN}✓ .bashrc configured${NC}"
sleep 1

# ============================================
# FINALIZE
# ============================================
echo -e "${YELLOW}Finalizing installation...${NC}"

chmod +x ~/.hans_hacker/ai_core.sh
chmod +x ~/.hans_hacker/theme.sh
echo "off" > ~/.hans_hacker/ai_state

if [ -d ~/storage/downloads ]; then
    mkdir -p ~/storage/downloads/hans_backup
fi

# Auto-reload
echo ""
echo -e "${CYAN}══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}⏳ Reloading in 4 seconds...${NC}"

for i in 4 3 2 1; do
    echo -ne "\r${CYAN}🔄 $i...${NC}   "
    sleep 1
done

echo ""
echo -e "${GREEN}🔄 Loading HANS HACKER THEME...${NC}"
sleep 1

source ~/.bashrc

clear
echo -e "${GREEN}"
cat << "SUCCESS"
╔══════════════════════════════════════════════════════════════════╗
║     ✅ HANS HACKER THEME INSTALLED SUCCESSFULLY!               ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  💾 PERMANENT MEMORY:                                           ║
║     ✓ All memories saved forever                               ║
║     ✓ Survives restarts and reboots                           ║
║                                                                  ║
║  📋 COMMANDS:                                                   ║
║     hans on      - Activate AI                                 ║
║     hans off     - Deactivate AI                               ║
║     hans memory  - Show memories                               ║
║     hans clear   - Delete all memory                           ║
║     hans backup  - Backup to storage                           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
SUCCESS
echo -e "${NC}"

echo ""
echo -e "\033[96m🚀 Type '\033[92mhans on\033[96m' to start using AI!\033[0m"
echo -e "\033[93m💡 Example: 'my name is John' then 'what is my name'\033[0m\n"
