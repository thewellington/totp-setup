#!/bin/bash
#
# TOTP User Setup - 'totp-user-setup.sh' - used to set up a new user for TOTP
# based authentication.
#
# Pre-requisites: pam_oath and oathtool.
# Setup per http://spod.cx/blog/two-factor-ssh-auth-with-pam_oath-google-authenticator.shtml
# Works well on CentOS 6.x
#
# by bill@wellingtonnet.net for Fulcrum Technologies Inc.
# v0.6 2013-09-20
#

# Install EPEL Repo
wget http://fedora-epel.mirror.lstn.net/6/i386/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm


# Install packages required for OATH
yum -y install pam_oath oathtool
ln -s /usr/lib64/security/pam_oath.so /lib64/security/pam_oath.so

# Update /etc/ssh/sshd_config
sed -i.bak 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart

# Create /etc/users.oath
touch /etc/users.oath
chmod 600 /etc/users.oath
chown root /etc/users.oath

# Create /etc/security/access-local.conf
OUTFILE='/etc/security/access-local.conf'
touch $OUTFILE
echo -e '+ : ALL : LOCAL
- : ALL : ALL' > $OUTFILE

# Create /etc/pam.d/oath
OUTFILE='/etc/pam.d/oath'
touch $OUTFILE
echo -e '#%PAM-1.0
# This file requires the use of TOTP following password authentication
auth        required      pam_env.so
auth        required      pam_unix.so nullok try_first_pass
auth        [success=1 default=ignore] pam_access.so accessfile=/etc/security/access-local.conf
auth        sufficient    pam_oath.so usersfile=/etc/users.oath window=30
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so' > $OUTFILE

ln -s /etc/pam.d/oath /etc/pam.d/oath-sshd

# Update /etc/pam.d/sshd
sed -i.bak 's/auth       include      password-auth/#auth       include      password-auth\
auth       include      oath-sshd/g' /etc/pam.d/sshd

echo -e 'This system is now set up for 2-Factor Authentication.  It is important that you generate a totp key for this user.  If you do not, you may not be able to log in again.'

