# PUBLIC IP
control_plane_1_public_ip="34.121.151.84"
control_plane_2_public_ip="35.222.113.8"
control_plane_3_public_ip="35.239.129.12"
data_plane_1_public_ip="35.192.164.4"
data_plane_2_public_ip="34.133.205.45"
master_ansible_public_ip="34.173.111.161"

# PRIVATE IP
control_plane_1_network_ip="10.240.0.4"
control_plane_2_network_ip="10.240.0.5"
control_plane_3_network_ip="10.240.0.6"

data_plane_1_network_ip="10.240.0.7"
data_plane_2_network_ip="10.240.0.8"

ssh-keygen -f "/home/dy/.ssh/known_hosts" -R $master_ansible_public_ip &
ssh-keygen -f "/home/dy/.ssh/known_hosts" -R $control_plane_1_public_ip &
ssh-keygen -f "/home/dy/.ssh/known_hosts" -R $control_plane_2_public_ip &
ssh-keygen -f "/home/dy/.ssh/known_hosts" -R $control_plane_3_public_ip &
ssh-keygen -f "/home/dy/.ssh/known_hosts" -R $data_plane_1_public_ip &
ssh-keygen -f "/home/dy/.ssh/known_hosts" -R $data_plane_2_public_ip &

wait

ssh-keyscan -H $master_ansible_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $control_plane_1_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $control_plane_2_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $control_plane_3_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $data_plane_1_public_ip >> ~/.ssh/known_hosts &
ssh-keyscan -H $data_plane_2_public_ip >> ~/.ssh/known_hosts &

wait

# Generer la paire de clé ssh du master ansible
ssh k8s@$master_ansible_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh k8s@$control_plane_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh k8s@$control_plane_1_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
# ssh k8s@$control_plane_2_public_ip "echo -e 'y\n' | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"

# Recuperer la clé publique du master ansible
master_ansible_pub_key=$(ssh k8s@$master_ansible_public_ip "cat ~/.ssh/id_rsa.pub")

# Ajouter la clé publique du master ansible aux clés autorisées des nodes ansible
ssh k8s@$control_plane_1_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$control_plane_2_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$control_plane_3_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$data_plane_1_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &
ssh k8s@$data_plane_2_public_ip "echo $master_ansible_pub_key > ~/.ssh/authorized_keys" &

wait

# Ajouter les adresses ip des nodes ansibles aux hotes connues du master pour faciliter la connexion sans interruption
ssh k8s@$master_ansible_public_ip "
ssh-keyscan -H control-plane-1 > ~/.ssh/known_hosts && \
ssh-keyscan -H control-plane-2 >> ~/.ssh/known_hosts && \
ssh-keyscan -H control-plane-3 >> ~/.ssh/known_hosts && \
ssh-keyscan -H data-plane-1 >> ~/.ssh/known_hosts && \
ssh-keyscan -H data-plane-2 >> ~/.ssh/known_hosts
"

# # Cloner le depot rke2-setup-ansible
ssh k8s@$master_ansible_public_ip "git clone https://github.com/data354/rke2-setup-ansible.git ansible"
