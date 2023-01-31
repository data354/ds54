# VARIABLES
# git_username="dykoffi"
# git_usermail="dykoffi2000@gmail.com"

# PUBLIC IP
master_ansible_public_ip="35.232.1.133"
server_1_public_ip="34.70.59.170"
server_2_public_ip="35.238.82.216"
server_3_public_ip="34.27.218.213"
server_4_public_ip="104.154.175.47"
server_5_public_ip="34.121.200.85"

# 

ssh-keygen -f "~/.ssh/known_hosts" -R $master_ansible_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_1_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_2_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_3_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_4_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_5_public_ip &

wait

ssh-keyscan -H $master_ansible_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_1_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_2_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_3_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_4_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_5_public_ip >> ~/.ssh/known_hosts &

wait

# Generer la paire de clé ssh du master ansible
ssh k8s@$master_ansible_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh k8s@$server_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh k8s@$server_1_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh k8s@$server_2_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"

# Recuperer la clé publique du master ansible
master_ansible_pub_key=$(ssh k8s@$master_ansible_public_ip "cat ~/.ssh/id_rsa.pub")

# Ajouter la clé publique du master ansible aux clés autorisées des nodes ansible
ssh k8s@$server_1_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$server_2_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$server_3_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$server_4_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$server_5_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &

wait

# Ajouter les adresses ip des nodes ansibles aux hotes connues du master pour faciliter la connexion sans interruption
ssh k8s@$master_ansible_public_ip "
ssh-keyscan -H server-1 > ~/.ssh/known_hosts && \
ssh-keyscan -H server-2 >> ~/.ssh/known_hosts && \
ssh-keyscan -H server-3 >> ~/.ssh/known_hosts && \
ssh-keyscan -H server-4 >> ~/.ssh/known_hosts && \
ssh-keyscan -H server-5 >> ~/.ssh/known_hosts
"

# # Cloner le depot rke2-setup-ansible
# ssh k8s@$master_ansible_public_ip "
# git config --global user.name '$git_username' \
# git config --global user.email '$git_usermail' \
# git clone https://github.com/data354/ds54.git
# "
