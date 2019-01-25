#!/bin/bash

sudo mkdir -p /root/.chef
sudo mkdir -p /root/src

yum -y install curl wget net-tools lsof git epel-release policycoreutils-python
yum -y install lighttpd

sed -i 's/80/800/g' /etc/lighttpd/lighttpd.conf
sed -i 's/use-ipv6\ =\ "enable/use-ipv6\ =\ "disable/g' /etc/lighttpd/lighttpd.conf

semanage port -a -t http_port_t -p tcp 800
rm -f /var/www/lighttpd/*

systemctl start lighttpd

yum -y --nogpgcheck install https://packages.chef.io/files/stable/chef-server/12.15.8/el/7/chef-server-core-12.15.8-1.el7.x86_64.rpm
yum -y --nogpgcheck install https://packages.chef.io/files/stable/chefdk/2.5.3/el/7/chefdk-2.5.3-1.el7.x86_64.rpm

#Since chef is not verbose at all...
echo -n "Configuring Chef Server... "
chef-server-ctl reconfigure
echo "Done."
echo -n "Creating Admin User for Chef... "
chef-server-ctl user-create chef-admin Chef Admin chef-admin@example.com 'iamtheadmin1' --filename /root/.chef/chef-admin.pem
echo "Done."
echo -n "Creating Chef Organization... "
chef-server-ctl org-create darkstar 'darkstar' --association_user chef-admin --filename /root/.chef/darkstar-validator.pem
echo "Done."

### This is insecure but is necessary for automating the demo
echo -n "Deploying validation pem... "
cp /root/.chef/darkstar-validator.pem /var/www/lighttpd/
chmod 0644 /var/www/lighttpd/darkstar-validator.pem
echo "Done."

git clone https://github.com/kkenny/darkstar-chef.git /root/src/darkstar-chef

knife configure --admin-client-key /root/.chef/chef-admin.pem --admin-client-name chef-admin -d -s 'https://chef/organizations/darkstar/' --validation-client-name darkstar-validator --validation-key /root/.chef/darkstar-validator.pem -u chef-admin -r /root/src/darkstar-chef

knife ssl fetch

cookbook_path='/root/src/darkstar-chef/cookbooks'

for cb in `ls -1 ${cookbook_path}/`; do
  cd ${cookbook_path}/${cb}; berks install; berks upload
done
