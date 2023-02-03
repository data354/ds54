# CLuster Ansible Setup

This folder contains the elements required to provision machines in order to create a dev environment for setting up and managing a kubernetes cluster.

## Prerequises

- [Node Js](https://nodejs.org/fr/download/)
- [yarn](https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable)
- [Pulumi](https://www.pulumi.com/docs/get-started/install/)
- [Gcloud](https://cloud.google.com/sdk/docs/install?hl=fr)
- Google cloud permissions
  - Compute Admin
  - Network Management Admin
  - Service Account Admin
  - Service Account Key Admin
  - Service Account User

## Resources

- 1 Service account
- 1 Network
- 1 Subnet
- 4 Firewalls:
  - allow all egress
  - allow all in subnet
  - allow ssh to k8s cluster
  - allow all tcp to master ansible
- 5 Computes engines:
  - 1 e2-standard-2: 2vCPU, 8Gi RAM (master-ansible)
  - 3 e2-standard-8: 8vCPU, 32Gi RAM (server-2, server-3, server-4)
  - 1 e2-standard-4: 4vCPU, 16Gi RAM (server-1)

## Steps

### On your local machine

#### Install dependencies

1. Use `yarn install` to install all dependencies the project need

#### Gcloud config

1. Connect to your gcloud account `gcloud auth login`
2. Get gcloud projects list `gcloud projects list`
3. Select gcloud project `gcloud config set project gps-oci`

#### Pulumi config and project running

1. Update config in `Pulumi.dev.yaml` (use your default pubic key `~/.ssh/id_rsa.pub`)
3. Run the pulumi script `pulumi up -y ` for compute provisioning
4. Select or create `dev` stack
6. Get compute public address with `gcloud compute instances list --format="value(NAME, EXTERNAL_IP)" | sed 's/-/_/g' | sed -r 's/\s/_public_ip=/'`
7. Replace the corresponding values in the `initialize-ansible-cluester.sh` in the `PUBLIC_IP` section
8. Run script `sh initialize-ansible-cluester.sh `to initialize ansible cluster
9. Connect to the ansible master machine `ssh k8s@master_ansible_ip`
10. When you have finished testing, don't forget to delete all resources by using `pulumi down -y`