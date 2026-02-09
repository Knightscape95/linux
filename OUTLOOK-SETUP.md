# Git Send-Email Setup for Outlook/Microsoft 365

Quick guide for configuring git send-email with Outlook or Microsoft 365 email accounts.

## Quick Setup (Automated)

Run the automated setup script:

```bash
./setup-outlook-sendemail.sh
```

The script will:
- Prompt for your Outlook email address
- Configure SMTP settings for Outlook
- Set up email behavior (threading, confirmation, etc.)
- Display your configuration

## Manual Setup

If you prefer to configure manually:

### Step 1: Configure User Identity

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@outlook.com"
```

### Step 2: Configure Outlook SMTP

```bash
git config --global sendemail.smtpserver smtp-mail.outlook.com
git config --global sendemail.smtpserverport 587
git config --global sendemail.smtpencryption tls
git config --global sendemail.smtpuser your.email@outlook.com
```

**Note:** Replace `your.email@outlook.com` with your actual Outlook/Microsoft 365 email.

### Step 3: Configure Email Behavior

```bash
git config --global sendemail.confirm always
git config --global sendemail.chainreplyto false
git config --global sendemail.thread true
git config --global sendemail.cc your.email@outlook.com
git config --global format.signoff true
```

### Step 4: Verify Configuration

```bash
git config --global --list | grep sendemail
```

You should see:
```
sendemail.smtpserver=smtp-mail.outlook.com
sendemail.smtpserverport=587
sendemail.smtpencryption=tls
sendemail.smtpuser=your.email@outlook.com
sendemail.confirm=always
sendemail.chainreplyto=false
sendemail.thread=true
sendemail.cc=your.email@outlook.com
```

## Authentication

### Regular Account (No 2FA)

When git send-email prompts for password, enter your regular Outlook password.

### Account with Two-Factor Authentication (2FA)

If you have 2FA enabled, you'll need an app password:

1. Sign in to [account.microsoft.com](https://account.microsoft.com)
2. Go to **Security** > **Advanced security options**
3. Under **App passwords**, click **Create a new app password**
4. Select **Mail** as the app type
5. Copy the generated password
6. Use this app password when git send-email prompts for password

**Important:** Store the app password securely. You won't be able to view it again.

## Testing Your Setup

### Test 1: Send to Yourself

```bash
# Create a test patch
git format-patch -1

# Send to yourself
git send-email --to your.email@outlook.com 0001-*.patch
```

When prompted:
- **Password:** Enter your Outlook password (or app password if using 2FA)
- **Send this email?** Type `y` and press Enter

### Test 2: Verify Email Received

1. Check your Outlook inbox
2. Verify the email arrived
3. Check that formatting is preserved (no line wrapping, tabs intact)
4. Try replying to the email to test threading

## Common Issues

### Issue: Authentication Failed

**Solution:**
- Verify your email address is correct
- If you have 2FA, use an app password (not your regular password)
- Check if your account requires additional security settings

### Issue: Connection Timeout

**Solution:**
- Check your internet connection
- Verify firewall isn't blocking port 587
- Try using port 465 with SSL:
  ```bash
  git config --global sendemail.smtpserverport 465
  git config --global sendemail.smtpencryption ssl
  ```

### Issue: Password Prompt Every Time

**Solution:** Use git credential helper to cache passwords:

```bash
# Cache for 1 hour
git config --global credential.helper 'cache --timeout=3600'

# Or store permanently (less secure)
git config --global credential.helper store
```

### Issue: Email Not Arriving

**Solution:**
- Check your Outlook Sent folder
- Check recipient's spam/junk folder
- Verify SMTP settings are correct
- Test with a different email address

## Sending Patches to Maintainers

### Step 1: Create Patch

```bash
git format-patch -1
```

### Step 2: Check Style

```bash
./scripts/checkpatch.pl 0001-*.patch
```

### Step 3: Find Maintainers

```bash
./scripts/get_maintainer.pl 0001-*.patch
```

### Step 4: Send Patch

```bash
git send-email --to maintainer@example.com \
               --cc linux-kernel@vger.kernel.org \
               0001-*.patch
```

Or automatically find maintainers:

```bash
git send-email --to-cmd='./scripts/get_maintainer.pl --to' \
               --cc-cmd='./scripts/get_maintainer.pl --cc' \
               0001-*.patch
```

## Outlook-Specific Tips

### Corporate/Enterprise Accounts

If you're using a corporate Microsoft 365 account:

1. Check with your IT department if SMTP is enabled
2. You may need to use your corporate SMTP server instead
3. Some companies require VPN for external SMTP access
4. You might need to request SMTP access for your account

### Personal Accounts (outlook.com, hotmail.com, live.com)

- Use `smtp-mail.outlook.com` as the server
- Port 587 with TLS encryption
- Use your regular password or app password

### Microsoft 365 Domains

If your email is `user@company.com` hosted on Microsoft 365:

- Still use `smtp-mail.outlook.com` as the server
- Use your full email address as username
- Authentication may differ - check with IT

## Advanced Configuration

### Store SMTP Password (Not Recommended)

```bash
git config --global sendemail.smtppass "your-password"
```

**Warning:** This stores your password in plain text. Use app passwords if you must do this.

### Custom From Address

If your git email differs from your Outlook email:

```bash
git config --global sendemail.from "Different Name <different@email.com>"
```

### Multiple Email Accounts

Use local (repository-specific) config instead of global:

```bash
# In specific repository
git config sendemail.smtpuser work.email@company.com
```

## Troubleshooting Commands

Check current configuration:
```bash
git config --global --list | grep sendemail
```

Test SMTP connection:
```bash
# Install telnet if needed: sudo apt-get install telnet
telnet smtp-mail.outlook.com 587
```

View send-email help:
```bash
git send-email --help
```

Enable debug output:
```bash
git send-email --smtp-debug 1 --to test@example.com 0001-*.patch
```

## Additional Resources

- Main setup guide: `.git-send-email-setup.md`
- Quick reference: `.git-send-email-cheatsheet.txt`
- Interactive setup: `./setup-git-sendemail.sh`
- General README: `README-SENDEMAIL.md`

## Getting Help

If you encounter issues:

1. Check this guide's troubleshooting section
2. Review `.git-send-email-setup.md` for general help
3. Ask on #kernelnewbies IRC (irc.oftc.net)
4. Email kernelnewbies@kernelnewbies.org

## Quick Reference

```bash
# Configure (automated)
./setup-outlook-sendemail.sh

# Test send
git format-patch -1
git send-email --to your@outlook.com 0001-*.patch

# Send to maintainers
./scripts/checkpatch.pl 0001-*.patch
./scripts/get_maintainer.pl 0001-*.patch
git send-email --to-cmd='./scripts/get_maintainer.pl --to' \
               --cc-cmd='./scripts/get_maintainer.pl --cc' \
               0001-*.patch
```

---

**You're now ready to send patches from Outlook!** 📧

For questions specific to Outlook configuration, check Microsoft's documentation at:
https://support.microsoft.com/en-us/office/pop-imap-and-smtp-settings-8361e398-8af4-4e97-b147-6c6c4ac95353
