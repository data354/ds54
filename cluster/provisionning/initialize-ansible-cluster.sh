# PUBLIC IP
master_ansible_public_ip=34.29.157.43
server_1_public_ip=35.223.160.236
server_2_public_ip=35.232.151.104
server_3_public_ip=34.70.77.133
server_4_public_ip=34.133.118.225

ssh-keygen -f "~/.ssh/known_hosts" -R $master_ansible_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_1_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_2_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_3_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $server_4_public_ip &
# ssh-keygen -f "~/.ssh/known_hosts" -R $server_5_public_ip &

wait

ssh-keyscan -H $master_ansible_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_1_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_2_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_3_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $server_4_public_ip >> ~/.ssh/known_hosts &
# ssh-keyscan -H $server_5_public_ip >> ~/.ssh/known_hosts &

wait

# Generer la paire de clé ssh du master ansible
ssh k8s@$master_ansible_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"

# ssh k8s@$server_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh k8s@$server_1_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh k8s@$server_2_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"

# Recuperer la clé publique du master ansible
master_ansible_pub_key=$(ssh k8s@$master_ansible_public_ip "cat ~/.ssh/id_rsa.pub")

echo
echo "Veuillez ajouter la clé du master ansible à votre compte github."
echo "Une fois la clé ajoutée cliquez sur ENTRER pour continuer."
echo
echo $master_ansible_pub_key
echo

read ENTRER

# Ajouter la clé publique du master ansible aux clés autorisées des nodes ansible
ssh k8s@$server_1_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$server_2_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$server_3_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$server_4_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
# ssh k8s@$server_5_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &

wait

# Ajouter les adresses ip des nodes ansibles aux hotes connues du master pour faciliter la connexion sans interruption
ssh k8s@$master_ansible_public_ip "
ssh-keyscan -H server-1 > ~/.ssh/known_hosts && \
ssh-keyscan -H server-2 >> ~/.ssh/known_hosts && \
ssh-keyscan -H server-3 >> ~/.ssh/known_hosts && \
ssh-keyscan -H server-4 >> ~/.ssh/known_hosts
"

# Ajouter l'dresse de github.com pour faciliter la connexion sans interruption
ssh k8s@$master_ansible_public_ip "ssh-keyscan -H github.com >> ~/.ssh/known_hosts"

# # Cloner le depot rke2
ssh k8s@$master_ansible_public_ip "
git clone git@github.com:data354/ds54.git && \
cp -rd ds54/cluster/rke2 rke2 && \
rm -rdf ds54
"

echo "Master Ansible Public Ip : $master_ansible_public_ip"