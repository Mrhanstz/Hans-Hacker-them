#!/bin/bash

# HANS HACKER THEME - COMPLETE UNINSTALLER
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
echo "  • All AI memories and history"
echo "  • Theme configuration"
echo "  • Permanent storage files"
echo ""
echo -e "${RED}Are you sure you want to uninstall? (y/n): ${NC}"
read -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Removing all files...${NC}"
    
    # Delete main directory
    rm -rf ~/.hans_hacker
    
    # Remove from .bashrc
    sed -i '/hans_hacker/d' ~/.bashrc
    
    # Remove welcome flag
    rm -f ~/.hans_hacker_welcome
    
    echo -e "${GREEN}✓ All files removed${NC}"
    echo -e "${GREEN}✅ HANS HACKER THEME UNINSTALLED!${NC}"
    echo -e "${YELLOW}Restart Termux to complete: exit then reopen${NC}"
else
    echo -e "${GREEN}Uninstall cancelled. Your memories are safe.${NC}"
fi
