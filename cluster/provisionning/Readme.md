### CLuster Ansible Setup

This folder contains the elements required to provision machines in order to create a dev environment for setting up and managing a kubernetes cluster.

### Prerequises

- [Node Js](https://nodejs.org/fr/download/)
- [yarn](https://classic.yarnpkg.com/lang/en/docs/install/#debian-stable)
- [Pulumi](https://www.pulumi.com/docs/get-started/install/)
- [Gcloud](https://cloud.google.com/sdk/docs/install?hl=fr)
- Google cloud permissions

### Steps

###### On your local machine

1. Update config in `Pulumi.dev.yaml` (use your pubic key)
2. Use `yarn install` to install all dependencies the project need
3. Run the pulumi script `pulumi up -y ` for compute provisioning
4. Select or create `dev` stack
5. Set gcloud project by using `gcloud config set project $MY_PROJECT_ID`
6. Get compute public address with `gcloud compute instances list --format="value(NAME, EXTERNAL_IP)" | sed 's/-/_/g' | sed -r 's/\s/_public_ip=/'` . Copy and paste the result in `initialize-ansible-cluester.sh` in the section `PUBLIC_IP`
7. Run script `sh initialize-ansible-cluester.sh `to initialize ansible cluster
8. Connect to the ansible master machine `ssh k8s@master_ansible_ip`
