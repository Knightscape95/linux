#!/bin/bash
# Example patch submission workflow
# This script demonstrates a complete patch submission process

set -e

cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║         Example: Complete Patch Submission Workflow             ║
╚══════════════════════════════════════════════════════════════════╝

This script demonstrates the complete workflow for submitting a patch
to the Linux kernel. Follow along or run sections individually.

EOF

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

step=1

show_step() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Step $step: $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    ((step++))
}

show_command() {
    echo -e "${GREEN}$ $1${NC}"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

show_step "Check your git configuration"
show_command "git config user.name"
git config user.name || echo "Not set - run: git config --global user.name 'Your Name'"
show_command "git config user.email"
git config user.email || echo "Not set - run: git config --global user.email 'your@email.com'"

show_step "View your recent changes"
show_command "git log --oneline -5"
git log --oneline -5 2>/dev/null || echo "No commits yet"

show_step "Create a patch from the last commit"
show_command "git format-patch -1"
echo "This will create a file like: 0001-your-commit-subject.patch"
echo ""
echo "If you want to actually create it, run:"
echo "  git format-patch -1"
echo "  git format-patch -1 --stdout > /tmp/my-patch.patch  # Preview to file"

show_step "Check patch with checkpatch.pl"
show_command "./scripts/checkpatch.pl 0001-*.patch"
echo ""
echo "This checks for:"
echo "  - Coding style violations"
echo "  - Line length issues"
echo "  - Whitespace problems"
echo "  - Common mistakes"
echo ""
echo "Example output:"
echo "  total: 0 errors, 0 warnings, 24 lines checked"
echo "  0001-your-patch.patch has no obvious style problems and is ready for submission."

show_step "Find maintainers for your patch"
show_command "./scripts/get_maintainer.pl 0001-*.patch"
echo ""
echo "This will show:"
echo "  - Maintainers to send to (--to)"
echo "  - People to CC (--cc)"
echo "  - Relevant mailing lists"
echo ""
echo "Example output:"
echo '  John Maintainer <jmaintainer@example.com> (maintainer:SUBSYSTEM)'
echo '  linux-kernel@vger.kernel.org (open list:SUBSYSTEM)'
echo '  linux-subsystem@vger.kernel.org (open list)'

show_step "Test by sending to yourself FIRST"
show_command "git send-email --to your.email@example.com 0001-*.patch"
echo ""
echo "IMPORTANT: Always test first!"
echo "  1. Send to yourself"
echo "  2. Check the received email"
echo "  3. Verify formatting is correct"
echo "  4. Try applying it with 'git am'"

show_step "Review the patch before sending"
echo "Open the .patch file and verify:"
echo "  ✓ Subject line is descriptive and < 70 characters"
echo "  ✓ Commit message explains WHY (not just what)"
echo "  ✓ Signed-off-by line is present"
echo "  ✓ No trailing whitespace"
echo "  ✓ Follows kernel coding style"
echo ""
show_command "cat 0001-*.patch"

show_step "Send to maintainers (after testing!)"
show_command "git send-email --to-cmd='./scripts/get_maintainer.pl --to' \\"
echo "                  --cc-cmd='./scripts/get_maintainer.pl --cc' \\"
echo "                  0001-*.patch"
echo ""
echo "Or manually specify recipients:"
show_command "git send-email --to maintainer@example.com \\"
echo "                  --cc linux-kernel@vger.kernel.org \\"
echo "                  --cc linux-subsystem@vger.kernel.org \\"
echo "                  0001-*.patch"

show_step "What happens next?"
cat << 'EOF'
After sending:
  1. Your patch arrives on the mailing list
  2. Maintainers and reviewers will read it
  3. You may receive feedback via email
  4. Be prepared to send a v2 with fixes

Timeline:
  - Initial review: 1-2 weeks (be patient!)
  - May need several revisions
  - If accepted, will be merged in next merge window

Responding to feedback:
  - Reply to review emails
  - Make requested changes
  - Send v2 with changelog:
    git format-patch -1 -v2
    # Edit patch to add: "v2: Fixed xyz based on feedback"
    git send-email --subject-prefix="PATCH v2" \
                   --in-reply-to="<original-message-id>" \
                   v2-*.patch

Good practices:
  ✓ Be polite and professional
  ✓ Thank reviewers for their time
  ✓ Explain your design choices
  ✓ Be open to feedback and changes
  ✓ Keep revisions focused on review feedback
EOF

echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}End of Example Workflow${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "For more information:"
echo "  - Read: .git-send-email-setup.md"
echo "  - View: .git-send-email-cheatsheet.txt"
echo "  - Run: ./setup-git-sendemail.sh"
echo ""
echo "Documentation:"
echo "  - Documentation/process/submitting-patches.rst"
echo "  - Documentation/process/submit-checklist.rst"
echo ""
echo "Happy patching! 🚀"
