import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

// CONFIG
const config = new pulumi.Config("gce");
const project = config.require("project")

const imageOs = "projects/rhel-sap-cloud/global/images/rhel-7-9-sap-v20230203"
const gcpRegion = "us-central1"
const gcpZone = "us-central1-a"

/* SERVICE ACCOUNT CONFIG */

const service_account = new gcp.serviceaccount.Account("k8s", {
	accountId: "k8s-account",
	project: project,
	description: "THis service allow permission on resources creating",
	displayName: "k8s-account",
});

/* NETWORK CONFIG */

const network = new gcp.compute.Network("kube-network", {
	autoCreateSubnetworks: false,
	name: "kube-network",
	project,
});

const subnet = new gcp.compute.Subnetwork("cluster-a", {
	network: network.id,
	ipCidrRange: "10.240.0.0/24",
	region: gcpRegion,
	project
});

/* FIREWALL CONFIG */

const cfAllowAllEgress = new gcp.compute.Firewall("allow-all-egress", {
	network: network.id,
	destinationRanges: ["0.0.0.0/0"],
	direction: "EGRESS",
	allows: [{ protocol: "all" }],
	project
});

const cfAllowAllInSubnet = new gcp.compute.Firewall("allow-all-in-subnet", {
	network: network.id,
	sourceRanges: ["10.240.0.0/24"],
	allows: [{ protocol: "all" }],
	project
});

const cfAllowSSHToK8sCluster = new gcp.compute.Firewall("allow-ssh-to-ansible-cluster", {
	network: network.id,
	sourceRanges: ["0.0.0.0/0"],
	targetTags: ["k8s", "proxy", "master-ansible"],
	allows: [{ protocol: "tcp", ports: ["22"] }],
	project
});

const cfAllowAllTCPToMasterAnsible = new gcp.compute.Firewall("allow-all-tcp-to-proxy-machine", {
	network: network.id,
	sourceRanges: ["0.0.0.0/0"],
	targetTags: ["proxy", "master-ansible"],
	allows: [{ protocol: "tcp" }],
	project
});

function createGCEInstance(
	name: string,
	ip: string,
	sshKeys: string,
	tags?: string[],
	startupScript?: string,
	diskSize: number = 100,
	machineType: string = "e2-standard-8",
) {
	return new gcp.compute.Instance(name, {
		name,
		bootDisk: {
			initializeParams: {
				image: imageOs,
				type: `projects/${project}/zones/us-west4-b/diskTypes/pd-balanced`,
				size: diskSize,
			},
			autoDelete: true,
			deviceName: name,
		},
		serviceAccount: {
			email: service_account.email,
			scopes: [
				"https://www.googleapis.com/auth/devstorage.read_only",
				"https://www.googleapis.com/auth/logging.write",
				"https://www.googleapis.com/auth/monitoring.write",
				"https://www.googleapis.com/auth/servicecontrol",
				"https://www.googleapis.com/auth/service.management.readonly",
				"https://www.googleapis.com/auth/trace.append",
			],
		},
		metadataStartupScript: startupScript,

		machineType: machineType,
		project: project,
		tags: tags,
		zone: gcpZone,
		shieldedInstanceConfig: {
			enableVtpm: true,
			enableIntegrityMonitoring: true,
			enableSecureBoot: true,
		},
		metadata: {
			"ssh-keys": sshKeys,
		},
		networkInterfaces: [
			{
				accessConfigs: [{}],
				subnetwork: subnet.id,
				network: network.id,
				networkIp: ip,
			},
		],
	});
}

/* MACHINES PROVISION */

const master_ansible = createGCEInstance(
	"master-ansible",
	"10.240.0.2",
	`k8s:${config.require("myPublicKey")}`,
	["master-ansible"],
	`
	sudo yum update
	sudo yum install -y git
	sudo yum install -y wget
	sudo yum install -y nano
  `,
	60,
	"e2-standard-2"
);

const control_plane_1 = createGCEInstance(
	"control-plane-1",
	"10.240.0.4",
	`k8s:${config.require("myPublicKey")}`,
	["k8s"],
	undefined,
	undefined,
	"e2-standard-4"
);

const data_plane_2 = createGCEInstance(
	"data-plane-1",
	"10.240.0.5",
	`k8s:${config.require("myPublicKey")}`,
	["k8s"],
);

const data_plane_3 = createGCEInstance(
	"data-plane-2",
	"10.240.0.6",
	`k8s:${config.require("myPublicKey")}`,
	["k8s"],
);

const data_plane_4 = createGCEInstance(
	"data-plane-3",
	"10.240.0.7",
	`k8s:${config.require("myPublicKey")}`,
	["k8s"],
);

// const server_5 = createGCEInstance(
// 	"server-5",
// 	"10.240.0.8",
// 	`k8s:${config.require("myPublicKey")}`,
// 	["proxy"],
// 	undefined,
// 	80,
// 	"e2-standard-2"
// );


// Get the public IP of the instance
export const master_ansible_ip = master_ansible.networkInterfaces;