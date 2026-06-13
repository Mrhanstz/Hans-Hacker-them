#!/bin/bash

# HANS HACKER THEME - UNINSTALLER
clear

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}"
cat << "BANNER"
╔══════════════════════════════════════════════════════════════╗
║     ⚠️  HANS HACKER THEME UNINSTALLER                      ║
║     THIS WILL DELETE ALL PERMANENT MEMORIES                 ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

echo -e "${YELLOW}This will delete:${NC}"
echo "  • All AI memories and chat history"
echo "  • Theme configuration files"
echo "  • Permanent storage directories"
echo ""

echo -e "${RED}Are you sure you want to uninstall? (y/n): ${NC}"
read -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Removing HANS HACKER THEME...${NC}"
    
    # Remove main directory
    rm -rf ~/.hans_hacker
    echo -e "${GREEN}✓ Removed ~/.hans_hacker/${NC}"
    
    # Remove old files
    rm -f ~/.hans_ai_state 2>/dev/null
    rm -f ~/.hans_ai_memory.txt 2>/dev/null
    rm -f ~/.hans_ai_history.txt 2>/dev/null
    rm -f ~/.hans_ai.sh 2>/dev/null
    rm -f ~/.hans_theme.sh 2>/dev/null
    
    # Remove from .bashrc
    sed -i '/hans_hacker/d' ~/.bashrc
    sed -i '/HANS HACKER/d' ~/.bashrc
    sed -i '/command_not_found_handle/d' ~/.bashrc
    echo -e "${GREEN}✓ Removed from .bashrc${NC}"
    
    # Remove welcome flag
    rm -f ~/.hans_hacker_welcome 2>/dev/null
    
    echo ""
    echo -e "${GREEN}✅ HANS HACKER THEME UNINSTALLED!${NC}"
    echo ""
    echo -e "${YELLOW}Please run: ${NC}exit${YELLOW} and reopen Termux${NC}"
else
    echo -e "${GREEN}Uninstall cancelled${NC}"
fi
