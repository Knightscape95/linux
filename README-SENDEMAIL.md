# Git Send-Email Setup for Linux Kernel Development

This directory contains resources to help you set up and use `git send-email` for submitting patches to the Linux kernel.

## 📚 Quick Start

### Option 1: Interactive Setup (Recommended)
```bash
./setup-git-sendemail.sh
```

### Option 2: Manual Configuration
```bash
# Read the comprehensive guide
less .git-send-email-setup.md

# Use the template
cat .gitconfig.sendemail-template >> ~/.gitconfig
# Then edit ~/.gitconfig with your details
```

### Option 3: Quick Reference
```bash
# View the cheat sheet
cat .git-send-email-cheatsheet.txt
```

## 📋 Files in This Setup

| File | Purpose |
|------|---------|
| `setup-git-sendemail.sh` | Interactive setup script - **Start here!** |
| `.git-send-email-setup.md` | Comprehensive guide with examples and troubleshooting |
| `.git-send-email-cheatsheet.txt` | Quick reference card for daily use |
| `.gitconfig.sendemail-template` | Git config template with useful aliases |
| `README-SENDEMAIL.md` | This file - overview and quick links |

## 🚀 Typical Workflow

1. **Make your changes**
   ```bash
   git add changed_file.c
   git commit -s
   ```

2. **Create patch**
   ```bash
   git format-patch -1
   ```

3. **Check style**
   ```bash
   ./scripts/checkpatch.pl 0001-*.patch
   ```

4. **Find maintainers**
   ```bash
   ./scripts/get_maintainer.pl 0001-*.patch
   ```

5. **Test send to yourself**
   ```bash
   git send-email --to your.email@example.com 0001-*.patch
   ```

6. **Send to maintainers**
   ```bash
   git send-email --to-cmd='./scripts/get_maintainer.pl --to' \
                  --cc-cmd='./scripts/get_maintainer.pl --cc' \
                  0001-*.patch
   ```

## ✅ Prerequisites

- [x] Git send-email installed (✓ already installed at `/usr/local/bin/git-send-email`)
- [ ] SMTP credentials configured (run `./setup-git-sendemail.sh`)
- [ ] User name and email set in git config

## 📖 Learning Resources

### Documentation in this Repository
- `Documentation/process/submitting-patches.rst` - Essential reading
- `Documentation/process/email-clients.rst` - Email setup guide
- `Documentation/process/5.Posting.rst` - Posting patches guide

### External Resources
- [Git send-email interactive tutorial](https://git-send-email.io)
- [Kernel Newbies](https://kernelnewbies.org/)
- [Linux Kernel Mailing List FAQ](https://vger.kernel.org/lkml/)

## 💡 Tips

- **Always test first**: Send to yourself before sending to maintainers
- **Use checkpatch.pl**: Run it on every patch before sending
- **Read existing patches**: Subscribe to relevant mailing lists to see examples
- **Start small**: Begin with simple documentation fixes to learn the process
- **Be patient**: Reviews can take time; be prepared to revise your patches

## 🔧 Troubleshooting

### Common Issues

**Q: Authentication fails with Gmail**
- Use an App Password, not your regular password
- Generate one at: https://myaccount.google.com/apppasswords

**Q: Patches not applying cleanly**
- Make sure you're based on the correct tree
- Check with maintainer which tree to use

**Q: No response to patch**
- Wait at least 1-2 weeks before following up
- Check if you CC'd the right people/lists
- Verify your patch arrived in the mailing list archives

**Q: Format-patch includes wrong commits**
- Use explicit commit ranges: `git format-patch <base>..<head>`
- Or use `-n` to specify number of commits

### Getting Help

- IRC: `#kernelnewbies` on OFTC (irc.oftc.net)
- Mailing list: kernelnewbies@kernelnewbies.org
- Read the docs: `Documentation/process/` in this repository

## 🎯 Next Steps After Setup

1. **Test your setup**
   - Create a test commit
   - Format and send to yourself
   - Verify the email looks correct

2. **Understand the process**
   - Read `Documentation/process/submitting-patches.rst`
   - Look at recent patches in the mailing list archives
   - Join #kernelnewbies IRC for questions

3. **Find a good first task**
   - Look for "TODO" comments in code
   - Fix obvious typos in documentation
   - Run sparse/checkpatch and fix warnings

4. **Submit your first patch**
   - Start with something simple
   - Follow the process exactly
   - Learn from the feedback

## 📧 Important Mailing Lists

- `linux-kernel@vger.kernel.org` - Main kernel list (always CC)
- Subsystem-specific lists (found via `get_maintainer.pl`)

Subscribe at: https://subspace.kernel.org/subscribing.html

## ⚖️ Developer's Certificate of Origin

By adding `Signed-off-by: Your Name <email>` to your commit, you certify that:
1. You wrote the contribution or have the right to submit it
2. It's submitted under the kernel's GPL-2.0 license
3. You understand and agree to the Developer's Certificate of Origin

Full text in `Documentation/process/submitting-patches.rst`

---

**Happy hacking!** 🐧

For questions or issues with this setup, check `.git-send-email-setup.md` for detailed troubleshooting.
