# RKE2 SETUP CONFIG

1. Update config in `Pulumi.dev.yaml` following your
2. Run the pulumi script `pulumi up -y `for compute provisionning
3. Get compute public address with `gcloud compute instances list --format="value(NAME, EXTERNAL_IP)" | sed 's/-/_/g' | sed -r 's/\s/_public_ip=/'` . Copy and paste the result in `initialize-ansible-cluester.sh` in the section `PUBLIC_IP`
4. Run script `sh initialize-ansible-cluester.sh `to initialize ansible cluster
5. Connect to the ansible master machine `ssh k8s@master_ansible_ip`
6. Create ansible playbook for creating all cluster resources
   1. Create rke2 cluster
   2. Setup Load balancer on this machine to the others machines of the cluster
   3. Initialize Kube client (Kubectl and Helm)
   4. Deploy and expose rancher Admin UI
   5. Deploy Certif Manager
   6. Deploy and expose Monitoring stack (Prometheus grafana)
   7. Create role, user and group
   8. Security
