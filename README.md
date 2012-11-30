VirtualHost-Framework
=====================

	Apache2 Virtual Host Framework


First we will start by forking my skeleton repo at ...

Next we will clone the repo

  mkdir /web
	cd /web
	git clone <git url> .

You should now have a folder structure similar to

	/web
	     /_conf
	     /_conf.d
	     /_certs
	     /_logs
	     /_scripts

You should also have the following files

	/web
	     /_conf
		      /conf.skel
	     /_conf.d
		      /confd.skel
	     /_scripts
		      /create_vblock.sh
		      /create_cert.sh
		      /install_uvhi.sh

Time to create our primary conf file

	echo "Include /web/_conf.d/*.conf" > /etc/httpd/conf.d/web.conf

We need to create the file that will add our webhead specific variables to the mix

	touch /web/_conf/web01.conf

A symlink will need to be created on each 

	ln -s /web/_conf/web01.conf /web/_conf/webhead.conf

Now we can add those variables to the Apache Pre-Fork Environment Variables Script

	echo ". /web/_conf/webhead.conf" >> /etc/sysconfig/httpd

Lets add the main httpd.conf file to the repo and set the environment variables

	cp /etc/httpd/conf/httpd.conf /web/_conf/httpd.conf
	echo "Include /web/_conf/httpd.conf" > /etc/httpd/conf/httpd.conf
	
	-> create array of variables starting with WEB_
	-> Add listen elements to the httpd.conf for each WEB_ var

Time to create our first virtual host block

	mkdir -p /web/<domain>/public
	cp /web/_conf.d/confd.skel /web/_conf.d/<domain>.conf
	-> sed/awk replace <domain> with \${$1}
	echo "WEB_<domain>_IP=192.168.100.143" >> /web/_conf/web01.conf
	echo "/web/<domain>/public" >> /web/.gitignore

		OR

	/web/_scripts/create_vblock.sh <domain> <ip>

Commit, Push Changes, Restart Apache

	git add .
	git commit -m 'Added <domain> on IP <ip>'
	git push -u origin master
	sudo /etc/init.d/httpd graceful
