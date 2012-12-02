#!/bin/bash

. /web/_scripts/header

if [ ! -f /web/_conf/webhead.conf ]
then
   echo ""
   echo "Please Create Your Web Head Symlink."
   echo "  ex: ln -s /web/_conf/web01.conf /web/_conf/webhead.conf"
   echo ""
   echo "For more information, visit"
   echo "  https://github.com/jroberts0001/VirtualHost-Framework"
   echo ""
   exit 1
fi

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   echo ""
   echo ""
   exit 1
fi

if [ ! -f /etc/httpd/conf.d/web.conf ]
then
	echo "Include /web/_conf.d/*.conf" > /etc/httpd/conf.d/web.conf
else
	echo "File /etc/httpd/conf.d/web.conf Exists! Skipping..."
fi

gexists=`grep "/web/_conf/web.conf" /etc/sysconfig/httpd`

if [ "$gexists" == "" ]
then
	echo ". /web/_conf/web.conf" >> /etc/sysconfig/httpd
else
	echo "web.conf Already Included, Skipping..."
fi

echo ""
echo "Framework Successfully Installed"
echo "  Create your first VirtualHost using /web/_scripts/create_vblock.sh"
echo ""
