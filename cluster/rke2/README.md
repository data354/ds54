# **rke2-setup-ansible**

## **Description**

This project is the setup of a production environment based on a kubernetes cluster for the deployment of a Big Data stack. It automates the setup of a highly available k8s cluster on the RKE2 distribution and the installation of all software stacks.

It takes into account the following features:

* Scaling (up and down)
* Load balancer et proxy
* Nodes Security
* Backup (Etcd and PV)
* Multiple OS family (Debian and Redhat)
* Idempotence

## **Prerequises**

**Nodes**

* An odd number of control plane (minimum 3)
* One machine as load balancer and proxy
* Backup
* Ram: 16+ Gi
* CPU: 8+
* Disk: 100Gi+ SSD
* OS: Ubuntu 20.04

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

## **Playbooks**

There are four playbooks:

`prerequises.playbook.yml`  : All apps, modules required for the stack deployment

`cluster.playbook.yml` : Contains the roles for the creatin of the cluster (Server and agent)

`client.playbook.yml` : Contains locak software to manage cluster

`apps.playbook.yml` : Contains the differents applications of the stack to install

`main.playbook.yml` : Contains all previous playbooks and runs them in order.


## **Configuration**

To display time taken for tasks when running ansible-playbook, copy and paste the following content in the file `/etc/ansible/ansible.cfg`

```bash
[defaults]
callbacks_enabled = profile_tasks
```

## **Process**

1. Copy the master ansible ip address in the common variable `loadbalancer_public_address`
2. Test node connection : `ansible -i inventory.ini -m ping all`
3. Launch project : `ansible-playbook -i inventory.ini main.playbook.yml`

## **Test cluster**

```bash
# Get all nodes
kubectl get nodes -o wide

# Get nodes resource utilization
kubectl top nodes 

# Get all pods
kubectl get pods -A -o wide

# Get pods resource utilization
kubectl top pods 

# Get all failed pods
kubectl get pods -A --field-selector=status.phase=Failed

# Get all failed pods
kubectl get pods -A --field-selector=status.phase=Unknown
```