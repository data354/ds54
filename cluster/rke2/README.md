# rke2-setup-ansible

### Description

This project is the setup of a production environment based on a kubernetes cluster for the deployment of a Big Data stack. It automates the setup of a highly available k8s cluster on the RKE2 distribution and the installation of all software stacks.

It takes into account the following features:

* Scaling (up and down)
* Load balancer et proxy
* Nodes Security
* Backup (Etcd and PV)
* Multiple OS family (Debian and Redhat)
* Idempotence

### Architecture

![Architecture img](https://raw.githubusercontent.com/data354/rke2-setup-ansible/main/archtitecture_setup_rke2.png)

### Prerequises

**Nodes**

* An odd number of control plane (minimum 3)
* One machine as load balancer and proxy
* Backup
* Ram: 16+ Gi
* CPU: 8+
* Disk: 100+ SSD
* OS: RHEL 8.5

**Software**

* Python 3.8
* Ansible 2.27

**Network**

* All node must be in the same private network except the backup node
* Nodes in the k8s cluster are not accessible via Internet
* Nodes in the k8s cluster are only accessible via the proxy machine (Master ansible)
* All node have access to Internet via port 443
* The master ansible host (proxy & load balancer) is accessible via Internet

**Machine Access**

* The proxy (Load balancer) machine is accessible via SSH port 22
* All host in the k8s cluster are accessible via the proxy machine on port SSH port 22
* All machine must have a same user with root privileges (proxy and backup machine include)
* Master ansible public key must be copied on each machine of the k8s cluster to avoid typing password during playbooks execution

### Process

**Test node connection**

`ansible -i inventory.ini -m ping all`

**Informations about playbooks**

There are four playbooks:

`prerequises.playbook.yml`  : All apps, modules required for the stack deployment

`cluster.playbook.yml` : Contains the roles for the creatin of the cluster (Server and agent)

`client.playbook.yml` : Contains locak software to manage cluster

`apps.playbook.yml` : Contains the differents applications of the stack to install

All these playbooks are executed in the previous order thanks to the playbook `main.playbook.yml` which integrates them all.

**Setup the cluster**

To display time taken for tasks when running ansible-playbook

`sudo nano -m /etc/ansible/ansible.cfg`

```
[defaults]
callbacks_enabled = profile_tasks
```

To launch the project, run the command : `ansible-playbook -i inventory.ini main.playbook.yml`
