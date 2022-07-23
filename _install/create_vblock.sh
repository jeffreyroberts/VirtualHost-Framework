#!/bin/bash

echo ""

WEBHEADS=()
while :
do
    case "$1" in
      -wh | --webhead)
                  WEBHEADS+=("$2;$3")
          shift 3
          ;;
          -d  | --domain)
          DOMAIN=$2
          shift 2
          ;;
           *)
                  break
                  ;;
    esac
done

if [ ${#WEBHEADS[@]} -lt 1 ] || [ "$DOMAIN" == "" ]
then
        echo "Usage: ./create_vblock.sh -d <domain name> -wh <webhead name> <ip address> (-wh <webhead name> <ip address>) (...)"
        echo "   Ex: ./create_vblock.sh -d demo.example.com -wh web01 192.168.100.1 -wh web02 192.168.100.2 (...)"
        echo ""
        exit 1
fi

if [ -d /var/web/$DOMAIN ]
then
        echo "Directory Already Exists, Exiting"
        echo ""
        exit 1
fi

mkdir -p /var/web/$DOMAIN/public
sed -e s/DOMAIN/"$DOMAIN"/g /var/web/_conf.d/confd.skel > /var/web/_conf.d/$DOMAIN.tmp.conf
WEBIPSKELETON=`echo $DOMAIN | sed 's/\.//g'`
WEBIPSKELETON=`echo WEBIP$WEBIPSKELETON | tr "[a-z]" "[A-Z]"`
sed -e s/WEBIPSKELETON/"$WEBIPSKELETON"/g /var/web/_conf.d/$DOMAIN.tmp.conf > /var/web/_conf.d/$DOMAIN.conf
rm -rf /var/web/_conf.d/$DOMAIN.tmp.conf

for webhead in "${WEBHEADS[@]}"
do
        IFS=';' read -ra ADDR <<< "$webhead"

                web="${ADDR[0]}"
                ip="${ADDR[1]}"

				if [ -f /var/web/_conf/$web.conf ]
				then
					gexists=`grep $ip /var/web/_conf/$web.conf`
				else
					gexists=""
				fi

				if [ "$gexists" == "" ] || [ ! -f /var/web/_conf/$web.conf ]
				then
					sed -e s/192.168.100.1/"$ip"/g /var/web/_conf/conf.skel >> /var/web/_conf/$web.tmp.conf
					sed -e s/WEBIP/"$WEBIPSKELETON"/g /var/web/_conf/$web.tmp.conf >> /var/web/_conf/$web.conf
					rm -rf /var/web/_conf/$web.tmp.conf
				fi
done

