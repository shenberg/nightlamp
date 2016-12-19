# installation
* Ubuntu 16.04 and install LAMP
# before shared folder works:
* `mount guest additions cdrom`
* `sudo apt-get install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r)`
* `sudo mount /dev/cdrom /media/cdrom`
* `sudo /media/cdrom/VBoxLinuxAdditions.run`
* restart the system (mount shared folder - hopefully automounted to /media/sf_nightlamp)
* go to shared folder/wifi-captive-portal

# set up redirects
* `sudo cp apache-redirect.conf /etc/apache2/sites-available`
* `sudo rm /etc/apache2/sites-enabled/000-default.conf`
* `sudo ln -s /etc/apache2/sites-available/apache-redirect.conf /etc/apache2/sites-enabled/apache-redirect.conf`
* `sudo service apache2 restart`

# set up dhcp server
* `sudo apt-get install isc-dhcp-server`
* `cat dhcpd.conf | sudo tee -a /etc/dhcp/dhcpd.conf` <- append dhcp config
* remove dhcp line from  `/etc/network/interfaces` - it should be (`iface <interface> inet dhcp`)
* modify `addif` -> replace `enp0s3` with the correct interface from /etc/network/interfaces
* `cat addif | sudo tee -a /etc/network/interfaces`

# set up dns (http://serverfault.com/questions/396958/configure-dns-server-to-return-same-ip-for-all-domains)
* `sudo apt-get install bind9`
* `sudo cp db.fakeroot named.conf.local /etc/bind/`
* `sudo service bind9 restart`
