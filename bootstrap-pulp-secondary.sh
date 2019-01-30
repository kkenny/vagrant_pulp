#!/bin/bash

[[ ! -d /etc/chef ]] && mkdir /etc/chef

echo '10.0.0.3 chef chef' >> /etc/hosts

wget http://10.0.0.3:800/darkstar-validator.pem -O /etc/chef/darkstar-validator.pem

# Install chef
curl -L https://omnitruck.chef.io/install.sh | bash || error_exit 'could not install chef'

# Create first-boot.json
cat > "/etc/chef/first-boot.json" << EOF
{
   "run_list" :[
   "recipe[base]",
   "recipe[pulp-server::main-secondary]"
   ]
}
EOF

cat > "/etc/chef/client.rb" << EOF
log_location STDOUT
chef_server_url 'https://chef/organizations/darkstar'
validation_client_name 'darkstar-validator'
validation_key '/etc/chef/darkstar-validator.pem'
EOF

knife ssl fetch -c /etc/chef/client.rb

chef-client -j /etc/chef/first-boot.json
