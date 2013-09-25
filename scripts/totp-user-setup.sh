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
# v0.8 2013-09-20
#

OUTFILE='/etc/users.oath'

USERNAME=$1
EMAIL=$2

#Generate secret
SECRET=`head -10 /dev/urandom | md5sum | cut -b 1-30`
SECRET32=`oathtool --totp -v $SECRET | grep Base32 | awk '{print $3}'`

OUTPUT='HOTP/T30/6\t'$USERNAME'\t-\t'$SECRET

#append to file
echo -e '# '$EMAIL'\t-\t'$SECRET >> $OUTFILE
echo -e $OUTPUT >> $OUTFILE

# Output to User
clear
echo -e '\r\r\r
\033[1;31m----- BEGIN SECRET INFORMATION -----\e[0m
Authentication Token has been generated for $EMAIL
This information needs to be kept secret, do not share this with anybody.
You should save this information in a secure place - do not leave this lying around!
\r
Your new secret key is: $SECRET32
\r
1. Download Google Authenticator to your mobile device, or use an alternate app capable of generating TOTP tokens.
2. Copy the following URL and paste it into a web browser to generate a QR code.
3. Scan the QR code with your mobile device.
\r
QR Code URL:
https://www.google.com/chart?chs=400x400&chld=M|08&cht=qr&chl=otpauth://totp/$USERNAME@$HOSTNAME%3Fsecret%3D$SECRET32
\r
\033[1;31m----- END SECRET INFORMATION -----\e[0m
\r\r\r'