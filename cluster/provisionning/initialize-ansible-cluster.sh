# PUBLIC IP
control_plane_1_public_ip="35.239.38.89"
data_plane_1_public_ip="34.171.3.250"
data_plane_2_public_ip="35.222.187.74"
data_plane_3_public_ip="35.222.214.106"
master_ansible_public_ip="34.70.16.232"

ssh-keygen -f "~/.ssh/known_hosts" -R $master_ansible_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $control_plane_1_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $data_plane_1_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $data_plane_2_public_ip &
ssh-keygen -f "~/.ssh/known_hosts" -R $data_plane_3_public_ip &

wait

ssh-keyscan -H $master_ansible_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $control_plane_1_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $data_plane_1_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $data_plane_2_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $data_plane_3_public_ip >> ~/.ssh/known_hosts &

wait

# Generer la paire de clé ssh du master ansible
ssh data354@$master_ansible_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"

# ssh data354@$server_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh data354@$server_1_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh data354@$server_2_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"

# Recuperer la clé publique du master ansible
master_ansible_pub_key=$(ssh data354@$master_ansible_public_ip "cat ~/.ssh/id_rsa.pub")

echo
echo "Veuillez ajouter la clé du master ansible à votre compte github."
echo "Une fois la clé ajoutée cliquez sur ENTRER pour continuer."
echo
echo $master_ansible_pub_key
echo

read ENTRER

# Ajouter la clé publique du master ansible aux clés autorisées des nodes ansible
ssh data354@$control_plane_1_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh data354@$data_plane_1_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh data354@$data_plane_2_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh data354@$data_plane_3_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &

wait

# Ajouter les adresses ip des nodes ansibles aux hotes connues du master pour faciliter la connexion sans interruption
ssh data354@$master_ansible_public_ip "
ssh-keyscan -H control-plane-1 > ~/.ssh/known_hosts && \
ssh-keyscan -H data-plane-1 >> ~/.ssh/known_hosts && \
ssh-keyscan -H data-plane-2 >> ~/.ssh/known_hosts && \
ssh-keyscan -H data-plane-3 >> ~/.ssh/known_hosts
"

# Ajouter l'dresse de github.com pour faciliter la connexion sans interruption
ssh data354@$master_ansible_public_ip "ssh-keyscan -H github.com >> ~/.ssh/known_hosts"

# # Cloner le depot rke2
ssh data354@$master_ansible_public_ip "
git clone git@github.com:data354/ds54.git && \
cd ds54 && git checkout oci-env && cd - && \
cp -rd ds54/cluster/rke2 rke2 && \
rm -rdf ds54
# "

echo "Master Ansible Public Ip : $master_ansible_public_ip"