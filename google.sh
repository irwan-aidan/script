#!/usr/bin/bash
echo "Google Chrome run with user root Kali Linux"
sed -i '$d' /opt/google/chrome/google-chrome
echo -e 'exec -a "$0" "$HERE/chrome" "$@" --user-data-dir %U --test-type --no-sandbox --disable-rich-notifications' >> /opt/google/chrome/google-chrome
exit;
