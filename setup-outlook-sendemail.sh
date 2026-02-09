#!/bin/bash
# Quick Outlook/Microsoft 365 Setup for git send-email
# Run this script to configure git send-email for Outlook

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Git Send-Email Configuration for Outlook/MS 365     ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# Get user's Outlook email
read -p "Enter your Outlook/Microsoft 365 email address: " outlook_email

if [ -z "$outlook_email" ]; then
    echo "Error: Email address is required"
    exit 1
fi

# Configure git user if not set
current_name=$(git config --global user.name 2>/dev/null || echo "")
current_email=$(git config --global user.email 2>/dev/null || echo "")

if [ -z "$current_name" ] || [ -z "$current_email" ]; then
    echo ""
    echo -e "${YELLOW}Setting up git user identity...${NC}"
    read -p "Enter your full name: " user_name
    git config --global user.name "$user_name"
    git config --global user.email "$outlook_email"
    echo -e "${GREEN}✓ Git user identity configured${NC}"
fi

# Configure SMTP for Outlook
echo ""
echo -e "${BLUE}Configuring Outlook SMTP settings...${NC}"
git config --global sendemail.smtpserver smtp-mail.outlook.com
git config --global sendemail.smtpserverport 587
git config --global sendemail.smtpencryption tls
git config --global sendemail.smtpuser "$outlook_email"
echo -e "${GREEN}✓ SMTP server configured${NC}"

# Configure send-email behavior
echo ""
echo -e "${BLUE}Configuring email behavior...${NC}"
git config --global sendemail.confirm always
git config --global sendemail.chainreplyto false
git config --global sendemail.thread true
git config --global sendemail.cc "$outlook_email"
git config --global format.signoff true
echo -e "${GREEN}✓ Email behavior configured${NC}"

# Display configuration
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Configuration Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo "Current configuration:"
echo "─────────────────────────────────────────────────────"
git config --global --list | grep -E "(user\.|sendemail\.|format\.signoff)" || echo "No configuration found"

echo ""
echo -e "${YELLOW}IMPORTANT: Outlook Authentication${NC}"
echo "─────────────────────────────────────────────────────"
echo "When git send-email prompts for password, use your"
echo "regular Outlook/Microsoft 365 password."
echo ""
echo "If you have 2FA enabled, you may need to:"
echo "  1. Sign in to account.microsoft.com"
echo "  2. Go to Security > Advanced security options"
echo "  3. Create an app password for 'Mail'"
echo "  4. Use that app password instead"
echo ""

echo -e "${BLUE}Next Steps:${NC}"
echo "─────────────────────────────────────────────────────"
echo "1. Test your configuration:"
echo "   git format-patch -1"
echo "   git send-email --to $outlook_email 0001-*.patch"
echo ""
echo "2. Find maintainers for your patch:"
echo "   ./scripts/get_maintainer.pl 0001-*.patch"
echo ""
echo "3. Send to maintainers:"
echo "   git send-email --to-cmd='./scripts/get_maintainer.pl --to' \\"
echo "                  --cc-cmd='./scripts/get_maintainer.pl --cc' \\"
echo "                  0001-*.patch"
echo ""
echo "For more help, see: .git-send-email-setup.md"
echo ""
echo -e "${GREEN}Setup complete! You're ready to send patches.${NC}"
