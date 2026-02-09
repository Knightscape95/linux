#!/bin/bash
# Git Send-Email Configuration Script for Linux Kernel Development
# This script helps configure git send-email for sending patches to maintainers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Git Send-Email Setup for Linux Kernel Development       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if git send-email is available
if ! command -v git-send-email &> /dev/null && ! git send-email --help &> /dev/null; then
    echo -e "${RED}✗ git send-email is not installed${NC}"
    echo "Please install it first. See .git-send-email-setup.md for instructions."
    exit 1
fi
echo -e "${GREEN}✓ git send-email is installed${NC}"

# Check current git user configuration
current_name=$(git config --global user.name 2>/dev/null || echo "")
current_email=$(git config --global user.email 2>/dev/null || echo "")

echo ""
echo -e "${YELLOW}Step 1: Configure User Identity${NC}"
echo "────────────────────────────────────"

if [ -n "$current_name" ] && [ -n "$current_email" ]; then
    echo -e "${GREEN}✓ Current configuration:${NC}"
    echo "  Name:  $current_name"
    echo "  Email: $current_email"
    read -p "Do you want to keep this configuration? (Y/n): " keep_user
    keep_user=${keep_user:-Y}
else
    keep_user="n"
fi

if [[ $keep_user =~ ^[Nn] ]]; then
    read -p "Enter your full name: " name
    read -p "Enter your email address: " email
    git config --global user.name "$name"
    git config --global user.email "$email"
    echo -e "${GREEN}✓ User identity configured${NC}"
fi

echo ""
echo -e "${YELLOW}Step 2: Configure SMTP Server${NC}"
echo "────────────────────────────────────"
echo "Select your email provider:"
echo "  1) Gmail"
echo "  2) Outlook/Microsoft 365"
echo "  3) Custom SMTP server"
echo "  4) Local sendmail"
echo "  5) Skip (already configured)"

read -p "Enter choice [1-5]: " smtp_choice

case $smtp_choice in
    1)
        echo -e "${BLUE}Configuring for Gmail...${NC}"
        git config --global sendemail.smtpserver smtp.gmail.com
        git config --global sendemail.smtpserverport 587
        git config --global sendemail.smtpencryption tls
        read -p "Enter your Gmail address: " gmail_user
        git config --global sendemail.smtpuser "$gmail_user"
        echo ""
        echo -e "${YELLOW}⚠ IMPORTANT: Gmail requires an App Password${NC}"
        echo "1. Go to: https://myaccount.google.com/apppasswords"
        echo "2. Generate an App Password for 'Mail'"
        echo "3. Use that password when git send-email prompts you"
        echo ""
        echo -e "${GREEN}✓ Gmail SMTP configured${NC}"
        ;;
    2)
        echo -e "${BLUE}Configuring for Outlook/Microsoft 365...${NC}"
        git config --global sendemail.smtpserver smtp-mail.outlook.com
        git config --global sendemail.smtpserverport 587
        git config --global sendemail.smtpencryption tls
        read -p "Enter your Outlook email: " outlook_user
        git config --global sendemail.smtpuser "$outlook_user"
        echo -e "${GREEN}✓ Outlook SMTP configured${NC}"
        ;;
    3)
        echo -e "${BLUE}Configuring custom SMTP server...${NC}"
        read -p "Enter SMTP server address: " smtp_server
        read -p "Enter SMTP port (usually 587 or 465): " smtp_port
        read -p "Enter encryption type (tls/ssl): " smtp_enc
        read -p "Enter SMTP username: " smtp_user
        git config --global sendemail.smtpserver "$smtp_server"
        git config --global sendemail.smtpserverport "$smtp_port"
        git config --global sendemail.smtpencryption "$smtp_enc"
        git config --global sendemail.smtpuser "$smtp_user"
        echo -e "${GREEN}✓ Custom SMTP configured${NC}"
        ;;
    4)
        echo -e "${BLUE}Configuring local sendmail...${NC}"
        git config --global sendemail.smtpserver /usr/sbin/sendmail
        echo -e "${GREEN}✓ Sendmail configured${NC}"
        ;;
    5)
        echo -e "${BLUE}Skipping SMTP configuration${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${YELLOW}Step 3: Configure Send-Email Behavior${NC}"
echo "────────────────────────────────────"

# Ask for confirmation preference
read -p "Confirm before sending each email? (Y/n): " confirm_pref
confirm_pref=${confirm_pref:-Y}
if [[ $confirm_pref =~ ^[Yy] ]]; then
    git config --global sendemail.confirm always
    echo -e "${GREEN}✓ Email confirmation enabled${NC}"
else
    git config --global sendemail.confirm auto
    echo -e "${GREEN}✓ Email confirmation set to auto${NC}"
fi

# Configure threading
git config --global sendemail.chainreplyto false
git config --global sendemail.thread true
echo -e "${GREEN}✓ Email threading configured${NC}"

# Configure signed-off-by
read -p "Automatically add Signed-off-by line? (Y/n): " signoff_pref
signoff_pref=${signoff_pref:-Y}
if [[ $signoff_pref =~ ^[Yy] ]]; then
    git config --global format.signoff true
    echo -e "${GREEN}✓ Automatic sign-off enabled${NC}"
fi

# Configure self CC
user_email=$(git config --global user.email)
read -p "CC yourself on all patches? (Y/n): " cc_self
cc_self=${cc_self:-Y}
if [[ $cc_self =~ ^[Yy] ]]; then
    git config --global sendemail.cc "$user_email"
    echo -e "${GREEN}✓ Self CC configured${NC}"
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Configuration Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""

echo "Current sendemail configuration:"
echo "────────────────────────────────────"
git config --global --list | grep -E "(user\.|sendemail\.|format\.signoff)" || echo "No configuration found"

echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Test your configuration:"
echo "   git format-patch -1"
echo "   git send-email --to $user_email 0001-*.patch"
echo ""
echo "2. Find maintainers for your patch:"
echo "   ./scripts/get_maintainer.pl 0001-*.patch"
echo ""
echo "3. Send your patch to maintainers:"
echo "   git send-email --to-cmd='./scripts/get_maintainer.pl --to' \\"
echo "                  --cc-cmd='./scripts/get_maintainer.pl --cc' \\"
echo "                  0001-*.patch"
echo ""
echo "For more information, see: .git-send-email-setup.md"
echo ""
echo -e "${BLUE}Happy hacking! 🚀${NC}"
