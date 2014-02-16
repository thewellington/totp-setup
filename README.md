#Easy OATH based TOTP authentication for CentOS 6

This is a pair of scripts that essentially performs the steps at http://spod.cx/blog/two-factor-ssh-auth-with-pam_oath-google-authenticator.shtml to make deploying OATH based TOTP authentication work for SSH connections _only._

##Setting up OATH in CentOS 6

Run `oath-setup` one time on your system to set up OATH authentication.

1. The EPEL repository will be added to your system.
2. `pam_oath` and `oathtool` will be added to your system.
3. `/etc/ssh/sshd_config` will be modified to include `ChallengeResponseAuthentication yes` and sshd will be restarted (Assumes that `/etc/ssh/sshd.config` has not been modified in another way)
4. Creates `/etc/users.oath` - this file is where each user's TOTP key is stored
5. Creates `/etc/security/access-local.conf` - this file defines who is asked for a TOTP token upon login.  By default no console users are asked for a token, only SSH users.
6. Creates the PAM rules for oath in file `/etc/pam.d/oath` and creates a symlink at`/etc/pam.d/oath-sshd`
7. Edits `/etc/pam.d/sshd` to include `/etc/pam.d/oath-sshd` in the rulset processed for sshd logins.
8. 
