#!/bin/bash

# ============================================
# HANS HACKER THEME - UNINSTALL AUTOSCRIPT
# ============================================

clear

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m'

# Banner
echo -e "${RED}"
cat << "BANNER"
╔══════════════════════════════════════════════════════════════╗
║     ⚠️  HANS HACKER THEME - UNINSTALLER                     ║
║     THIS WILL DELETE ALL PERMANENT MEMORIES                 ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
sleep 2

# Show what will be deleted
echo -e "${YELLOW}📋 The following will be deleted:${NC}"
echo -e "  ${RED}•${NC} All AI memories and chat history"
echo -e "  ${RED}•${NC} Theme configuration files"
echo -e "  ${RED}•${NC} Permanent storage directories (~/.hans_hacker/)"
echo -e "  ${RED}•${NC} .bashrc modifications"
echo -e "  ${RED}•${NC} Welcome banner flags"
echo ""
echo -e "${RED}⚠️  THIS ACTION CANNOT BE UNDONE!${NC}"
echo ""

# Ask for backup
echo -e "${CYAN}Do you want to create a backup before uninstalling? (y/n): ${NC}"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Creating backup...${NC}"
    mkdir -p ~/storage/downloads/hans_backup 2>/dev/null
    if [ -d ~/.hans_hacker ]; then
        BACKUP_NAME="hans_hacker_backup_$(date +%Y%m%d_%H%M%S)"
        cp -r ~/.hans_hacker ~/storage/downloads/hans_backup/$BACKUP_NAME 2>/dev/null
        echo -e "${GREEN}✓ Backup saved to: ~/storage/downloads/hans_backup/$BACKUP_NAME${NC}"
    else
        echo -e "${YELLOW}No theme files found to backup${NC}"
    fi
fi

echo ""
echo -e "${RED}Are you sure you want to completely uninstall? (y/n): ${NC}"
read -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}🗑️  Removing HANS HACKER THEME...${NC}"
    echo ""
    
    # Remove main directory
    if [ -d ~/.hans_hacker ]; then
        rm -rf ~/.hans_hacker
        echo -e "${GREEN}✓ Removed ~/.hans_hacker/ directory${NC}"
    else
        echo -e "${YELLOW}⚠️  ~/.hans_hacker/ not found${NC}"
    fi
    
    # Remove old files
    OLD_FILES=(
        ~/.hans_ai_state
        ~/.hans_ai_memory.txt
        ~/.hans_ai_history.txt
        ~/.hans_ai.sh
        ~/.hans_theme.sh
        ~/.hans_hacker_welcome
    )
    
    for file in "${OLD_FILES[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo -e "${GREEN}✓ Removed $(basename "$file")${NC}"
        fi
    done
    
    # Remove from .bashrc
    if [ -f ~/.bashrc ]; then
        # Create backup of .bashrc before modifying
        cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)
        
        # Remove all HANS HACKER related lines
        sed -i '/hans_hacker/d' ~/.bashrc
        sed -i '/HANS HACKER/d' ~/.bashrc
        sed -i '/HANS-HACKER/d' ~/.bashrc
        sed -i '/command_not_found_handle/d' ~/.bashrc
        sed -i '/process_with_ai/d' ~/.bashrc
        sed -i '/generate_ps1/d' ~/.bashrc
        sed -i '/get_indicator/d' ~/.bashrc
        sed -i '/get_color/d' ~/.bashrc
        
        echo -e "${GREEN}✓ Removed entries from .bashrc${NC}"
        echo -e "${GREEN}✓ Backup saved: ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✅ HANS HACKER THEME UNINSTALLED!                  ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}📋 Next steps:${NC}"
    echo -e "  ${CYAN}1.${NC} Type ${GREEN}exit${NC} to close Termux"
    echo -e "  ${CYAN}2.${NC} Reopen Termux"
    echo -e "  ${CYAN}3.${NC} Your terminal is back to normal"
    echo ""
    
    # Ask to exit now
    echo -e "${CYAN}Do you want to exit Termux now? (y/n): ${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Exiting Termux...${NC}"
        sleep 2
        exit
    else
        echo -e "${YELLOW}Please manually run 'exit' and reopen Termux${NC}"
        echo -e "${YELLOW}Or run: ${GREEN}source ~/.bashrc${YELLOW} to reload without restarting${NC}"
    fi
else
    echo ""
    echo -e "${GREEN}✅ Uninstall cancelled. Your theme and memories are safe.${NC}"
fi
