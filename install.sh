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
        echo -e "${CYAN}Continue anyway? (y/n): ${NC}"
        read -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${RED}Installation cancelled${NC}"
            exit 1
        fi
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
# All data saved in ~/.hans_hacker/

# File paths
AI_STATE_FILE="$HOME/.hans_hacker/ai_state"
AI_MEMORY_FILE="$HOME/.hans_hacker/memory/memory.txt"
AI_HISTORY_FILE="$HOME/.hans_hacker/memory/history.txt"
AI_BACKUP_FILE="$HOME/.hans_hacker/backup/memory_backup.txt"

# Initialize files
init_files() {
    [ ! -f "$AI_STATE_FILE" ] && echo "off" > "$AI_STATE_FILE"
    [ ! -f "$AI_MEMORY_FILE" ] && touch "$AI_MEMORY_FILE"
    [ ! -f "$AI_HISTORY_FILE" ] && touch "$AI_HISTORY_FILE"
    
    # Create backup of memory
    cp "$AI_MEMORY_FILE" "$AI_BACKUP_FILE" 2>/dev/null
}
init_files

# Save to permanent memory
save_to_memory() {
    local user_msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Save to history with timestamp
    echo "[$timestamp] User: $user_msg" >> "$AI_HISTORY_FILE"
    
    # Extract and save important info
    if echo "$user_msg" | grep -qi "my name is"; then
        local name=$(echo "$user_msg" | grep -oi "my name is [A-Za-z]*" | sed 's/my name is //i')
        echo "[NAME] $name" >> "$AI_MEMORY_FILE"
        echo -e "\033[92m✓ I'll remember your name is $name!${NC}"
    fi
    
    if echo "$user_msg" | grep -qi "i am.*from"; then
        local place=$(echo "$user_msg" | grep -oi "from [A-Za-z ]*" | sed 's/from //i')
        echo "[LOCATION] $place" >> "$AI_MEMORY_FILE"
    fi
    
    if echo "$user_msg" | grep -qi "i like"; then
        local pref=$(echo "$user_msg" | grep -oi "i like [A-Za-z ]*" | sed 's/i like //i')
        echo "[LIKES] $pref" >> "$AI_MEMORY_FILE"
    fi
    
    if echo "$user_msg" | grep -qi "i am [0-9]\+"; then
        local age=$(echo "$user_msg" | grep -oi "[0-9]\+" | head -1)
        echo "[AGE] $age" >> "$AI_MEMORY_FILE"
    fi
    
    # Remove duplicates and keep last 100 lines
    sort -u "$AI_MEMORY_FILE" | tail -n 100 > "$AI_MEMORY_FILE.tmp"
    mv "$AI_MEMORY_FILE.tmp" "$AI_MEMORY_FILE"
    
    # Backup to storage if available
    if [ -d "$HOME/storage/downloads" ]; then
        cp "$AI_MEMORY_FILE" "$HOME/storage/downloads/hans_backup/memory_$(date +%Y%m%d).txt" 2>/dev/null
    fi
}

# Save AI response
save_response() {
    local response="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] Hans: $response" >> "$AI_HISTORY_FILE"
    
    # Keep only last 500 lines
    tail -n 500 "$AI_HISTORY_FILE" > "$AI_HISTORY_FILE.tmp"
    mv "$AI_HISTORY_FILE.tmp" "$AI_HISTORY_FILE"
}

# Get memory context
get_memory_context() {
    local context=""
    local memory=$(cat "$AI_MEMORY_FILE" 2>/dev/null | tail -n 30)
    local history=$(tail -n 20 "$AI_HISTORY_FILE" 2>/dev/null)
    
    if [ -n "$memory" ]; then
        context="╔══════════════════════════════════════════════════════════╗\n"
        context="${context}║     🧠 WHAT I REMEMBER ABOUT YOU (PERMANENT)      ║\n"
        context="${context}╚══════════════════════════════════════════════════════════╝\n"
        context="${context}$memory\n\n"
    fi
    
    if [ -n "$history" ]; then
        context="${context}╔══════════════════════════════════════════════════════════╗\n"
        context="${context}║     💬 RECENT CONVERSATION                              ║\n"
        context="${context}╚══════════════════════════════════════════════════════════╝\n"
        context="${context}$history\n"
    fi
    
    echo "$context"
}

# Call Hans AI API
call_hans_api() {
    local user_input="$1"
    local memory_context=$(get_memory_context)
    
    local prompt="You are Hans AI, created by Hans from Dodoma Tanzania. You have PERMANENT MEMORY.

$memory_context

Current user message: $user_input

RULES:
- Reference what you remember about the user
- Use their name if you know it
- Be friendly and natural
- Never ask 'how can I assist you'

Your response:"
    
    local response=$(curl -s -G "https://Hansxmd-HansAi.hf.space/ai/logic" \
        --data-urlencode "q=$user_input" \
        --data-urlencode "logic=$prompt" \
        --max-time 15 2>/dev/null | jq -r '.result // .response // .answer // .' 2>/dev/null)
    
    if [ -z "$response" ] || [ "$response" = "null" ]; then
        response="Hans AI is ready! I remember everything you tell me. What's on your mind?"
    fi
    
    echo "$response"
}

# Process command with AI
process_with_ai() {
    local input="$1"
    local state=$(cat "$AI_STATE_FILE")
    
    if [ "$state" != "on" ]; then
        return 1
    fi
    
    # Skip AI commands
    if [[ "$input" =~ ^(hans|ai)$ ]] || [[ "$input" =~ ^(hans|ai)[[:space:]]+ ]]; then
        return 1
    fi
    
    if [ -z "$input" ] || [ ${#input} -lt 2 ]; then
        return 1
    fi
    
    # Show typing indicator
    echo -ne "\n\033[96m🤖 Hans AI: \033[0m"
    sleep 0.3
    
    # Get response
    local response=$(call_hans_api "$input")
    echo -e "\033[93m$response\033[0m\n"
    
    # Save to permanent memory
    save_to_memory "$input"
    save_response "$response"
    
    return 0
}

# Show all memories
show_memory() {
    echo -e "\033[96m╔══════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[96m║     \033[95m🧠 PERMANENT MEMORY - WHAT I REMEMBER\033[96m                ║\033[0m"
    echo -e "\033[96m╚══════════════════════════════════════════════════════════╝\033[0m\n"
    
    if [ -f "$AI_MEMORY_FILE" ] && [ -s "$AI_MEMORY_FILE" ]; then
        cat "$AI_MEMORY_FILE"
    else
        echo -e "\033[33m📭 No memories yet. Tell me about yourself!\033[0m"
        echo -e "\033[33m💡 Try: 'My name is John' or 'I like coding'\033[0m"
    fi
    
    echo -e "\n\033[96m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[96m📝 RECENT CONVERSATIONS:\033[0m"
    echo -e "\033[96m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    
    if [ -f "$AI_HISTORY_FILE" ] && [ -s "$AI_HISTORY_FILE" ]; then
        tail -n 30 "$AI_HISTORY_FILE"
    else
        echo -e "\033[33mNo conversations yet\033[0m"
    fi
}

# Clear all memory
clear_all_memory() {
    echo -e "\033[93m╔════════════════════════════════════════════╗\033[0m"
    echo -e "\033[93m║     ⚠️  DELETE ALL PERMANENT MEMORY?       ║\033[0m"
    echo -e "\033[93m║     THIS CANNOT BE UNDONE!                 ║\033[0m"
    echo -e "\033[93m╚════════════════════════════════════════════╝\033[0m"
    echo -e "\033[93mAre you sure? (y/n): \033[0m"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        > "$AI_MEMORY_FILE"
        > "$AI_HISTORY_FILE"
        echo -e "\033[92m✅ ALL MEMORY CLEARED! Starting fresh...\033[0m"
    else
        echo -e "\033[92m✅ Memory preserved\033[0m"
    fi
}

# Backup memory to storage
backup_memory() {
    if [ -d "$HOME/storage/downloads" ]; then
        local backup_name="hans_memory_$(date +%Y%m%d_%H%M%S).txt"
        cp "$AI_MEMORY_FILE" "$HOME/storage/downloads/hans_backup/$backup_name" 2>/dev/null
        echo -e "\033[92m✅ Memory backed up to Downloads/hans_backup/$backup_name\033[0m"
    else
        echo -e "\033[33m⚠️ Storage not accessible. Grant storage permission first.\033[0m"
    fi
}

# Hans command
hans() {
    case "$1" in
        on)
            echo "on" > "$AI_STATE_FILE"
            echo -e "\033[92m╔════════════════════════════════════════════╗\033[0m"
            echo -e "\033[92m║     🤖 HANS HACKER AI ACTIVATED          ║\033[0m"
            echo -e "\033[92m║     📚 PERMANENT MEMORY ENABLED          ║\033[0m"
            echo -e "\033[92m║     💾 ALL DATA SAVED PERMANENTLY        ║\033[0m"
            echo -e "\033[92m╚════════════════════════════════════════════╝\033[0m"
            ;;
        off)
            echo "off" > "$AI_STATE_FILE"
            echo -e "\033[91m╔════════════════════════════════════════════╗\033[0m"
            echo -e "\033[91m║     💀 HANS HACKER AI DEACTIVATED        ║\033[0m"
            echo -e "\033[91m╚════════════════════════════════════════════╝\033[0m"
            ;;
        status)
            local state=$(cat "$AI_STATE_FILE")
            if [ "$state" = "on" ]; then
                echo -e "\033[92m🤖 AI Status: ACTIVE\033[0m"
                echo -e "\033[96m📁 Memory file: ~/.hans_hacker/memory/memory.txt\033[0m"
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
            clear_all_memory
            ;;
        backup)
            backup_memory
            ;;
        path)
            echo -e "\033[96m📁 Permanent storage location:\033[0m"
            echo -e "\033[93m~/.hans_hacker/\033[0m"
            echo -e "\033[93m  ├── ai_state\033[0m"
            echo -e "\033[93m  ├── memory/\033[0m"
            echo -e "\033[93m  │   ├── memory.txt\033[0m"
            echo -e "\033[93m  │   └── history.txt\033[0m"
            echo -e "\033[93m  └── backup/\033[0m"
            ;;
        *)
            echo -e "\033[36m╔══════════════════════════════════════════════════════════╗\033[0m"
            echo -e "\033[36m║     \033[95m🤖 HANS HACKER AI - PERMANENT MEMORY\033[36m              ║\033[0m"
            echo -e "\033[36m╠══════════════════════════════════════════════════════════╣\033[0m"
            echo -e "\033[36m║\033[0m \033[92mhans on\033[0m        - Activate AI (permanent memory)    \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[91mhans off\033[0m       - Deactivate AI                      \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[96mhans memory\033[0m    - Show what I remember about you    \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[93mhans clear\033[0m     - DELETE ALL MEMORY                 \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[94mhans backup\033[0m    - Backup memory to storage          \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[90mhans path\033[0m     - Show permanent storage location   \033[36m║\033[0m"
            echo -e "\033[36m║\033[0m \033[90mhans status\033[0m    - Check AI status                   \033[36m║\033[0m"
            echo -e "\033[36m╚══════════════════════════════════════════════════════════╝\033[0m"
            ;;
    esac
}

# Command handler
command_not_found_handle() {
    process_with_ai "$*"
    return 0
}

# Export functions
export -f hans
export -f process_with_ai
export -f show_memory
export -f backup_memory
EOF

echo -e "${GREEN}✓ AI system created with permanent memory${NC}"
sleep 1

# ============================================
# STEP 5: Create Theme
# ============================================
echo -e "${YELLOW}[5/6] Creating HANS HACKER Theme...${NC}"

cat > ~/.hans_hacker/theme.sh << 'EOF'
#!/bin/bash

# HANS HACKER THEME
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

get_storage_status() {
    if [ -d "$HOME/storage/downloads" ]; then
        echo "💾"
    else
        echo "⚠️"
    fi
}

generate_ps1() {
    local indicator=$(get_ai_indicator)
    local storage=$(get_storage_status)
    local color=$(get_random_color)
    PS1="\[\e[${color}m\]┌──(HANS-HACKER@HANS-TECH)-[${indicator}${storage}]-[\W]\n└─$ \[\e[0m\]"
}

PROMPT_COMMAND="generate_ps1"
EOF

echo -e "${GREEN}✓ Theme created${NC}"
sleep 1

# ============================================
# STEP 6: Configure .bashrc Permanently
# ============================================
echo -e "${YELLOW}[6/6] Configuring .bashrc permanently...${NC}"

# Backup existing .bashrc
if [ -f ~/.bashrc ]; then
    cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)
    echo -e "${GREEN}✓ Old .bashrc backed up${NC}"
fi

# Remove old entries
sed -i '/hans_hacker/d' ~/.bashrc

# Add new permanent configuration
cat >> ~/.bashrc << 'BASHRC'

# ============================================
# HANS HACKER THEME - PERMANENT CONFIGURATION
# ============================================

# Load AI System
source ~/.hans_hacker/ai_core.sh
source ~/.hans_hacker/theme.sh

# Clean prompt
unset PROMPT_COMMAND
PROMPT_COMMAND="generate_ps1"

# Aliases
alias c='clear'
alias cls='clear'
alias ll='ls -lah'
alias hanshelp='hans'

# Command handler for AI
command_not_found_handle() {
    process_with_ai "$*"
    return 0
}

# Welcome banner (only once per session)
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
    echo -e "\033[92m┌─────────────────────────────────────────────────────────────┐\033[0m"
    echo -e "\033[92m│  \033[96m🤖 PERMANENT AI COMMANDS\033[92m                                        │\033[0m"
    echo -e "\033[92m├─────────────────────────────────────────────────────────────┤\033[0m"
    echo -e "\033[92m│  \033[92mhans on\033[92m      - Activate AI (remembers everything)            │\033[0m"
    echo -e "\033[92m│  \033[91mhans off\033[92m     - Deactivate AI                                   │\033[0m"
    echo -e "\033[92m│  \033[96mhans memory\033[92m  - See what I remember about you                  │\033[0m"
    echo -e "\033[92m│  \033[93mhans clear\033[92m   - DELETE ALL MEMORY                              │\033[0m"
    echo -e "\033[92m│  \033[94mhans backup\033[92m  - Backup memory to storage                       │\033[0m"
    echo -e "\033[92m│  \033[90mhans path\033[92m   - Show permanent storage location                 │\033[0m"
    echo -e "\033[92m└─────────────────────────────────────────────────────────────┘\033[0m"
    echo ""
    echo -e "\033[93m💡 \033[92mType 'hans on' to activate AI!\033[0m"
    echo -e "\033[93m💡 \033[96mYour memories are saved PERMANENTLY in ~/.hans_hacker/\033[0m"
    echo -e "\033[93m💡 \033[94mStorage permission: $([ -d ~/storage/downloads ] && echo 'GRANTED ✓' || echo 'NOT GRANTED')\033[0m"
    echo ""
    touch ~/.hans_hacker/welcome_shown
fi
BASHRC

echo -e "${GREEN}✓ .bashrc configured permanently${NC}"
sleep 1

# ============================================
# FINALIZE INSTALLATION
# ============================================
echo -e "${YELLOW}Finalizing permanent installation...${NC}"

# Set permissions
chmod +x ~/.hans_hacker/ai_core.sh
chmod +x ~/.hans_hacker/theme.sh

# Initialize state
echo "off" > ~/.hans_hacker/ai_state

# Create backup directory in storage
if [ -d ~/storage/downloads ]; then
    mkdir -p ~/storage/downloads/hans_backup
    echo -e "${GREEN}✓ Backup directory created in Downloads/hans_backup${NC}"
fi

# ============================================
# AUTO-RELOAD AFTER 4 SECONDS
# ============================================
echo ""
echo -e "${CYAN}══════════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}⏳ Waiting 4 seconds before auto-reloading theme...${NC}"

# Countdown
for i in 4 3 2 1; do
    echo -ne "\r${CYAN}🔄 Reloading in $i seconds...${NC}   "
    sleep 1
done

echo ""
echo -e "${GREEN}🔄 Auto-reloading HANS HACKER THEME...${NC}"
sleep 1

# Auto-reload source
source ~/.bashrc

# Final success message
clear
echo -e "${GREEN}"
cat << "SUCCESS"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║     ✅ HANS HACKER THEME PERMANENTLY INSTALLED!                 ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  💾 PERMANENT STORAGE:                                          ║
║     ✓ All memories saved in ~/.hans_hacker/                    ║
║     ✓ Survives Termux restarts                                  ║
║     ✓ Survives device reboot                                    ║
║     ✓ Auto-backup to storage if granted                        ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  📋 COMMANDS:                                                   ║
║     hans on      - Activate AI (remembers everything)          ║
║     hans off     - Deactivate AI                                ║
║     hans memory  - See what I remember about you               ║
║     hans clear   - DELETE ALL MEMORY                            ║
║     hans backup  - Backup memory to storage                     ║
║     hans path    - Show storage location                        ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  📁 PERMANENT FILES LOCATION:                                   ║
║     ~/.hans_hacker/                                             ║
║                                                                  ║
║  🗑️  UNINSTALL:                                                ║
║     rm -rf ~/.hans_hacker                                       ║
║     (then remove from .bashrc)                                  ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
SUCCESS
echo -e "${NC}"

echo ""
echo -e "\033[96m🚀 Type '\033[92mhans on\033[96m' to activate HANS HACKER AI!\033[0m"
echo -e "\033[93m💡 Your memories will be saved PERMANENTLY!\033[0m"
echo -e "\033[93m💡 Theme auto-reloaded successfully!\033[0m\n"

# Ask about storage again
if [ ! -d ~/storage/downloads ]; then
    echo -e "\033[93m⚠️  Storage permission not granted. Memory will still work but backups disabled.\033[0m"
    echo -e "\033[96mTo enable backups later, run: termux-setup-storage\033[0m\n"
fi
