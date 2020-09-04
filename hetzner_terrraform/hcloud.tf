terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.20.0"
    }
  }
}

provider "hcloud" {
  token = "${var.hcloud_token}"
}

resource "hcloud_network" "privNet" {
  name = "${var.net_name}"
  ip_range = "${var.net_ip_range}"
}


resource "hcloud_network_subnet" "foonet" {
  network_id = "${hcloud_network.privNet.id}"
  type = "${var.subnet_type}"
  network_zone = "${var.network_zone}"
  ip_range   = "${var.subnet_ip_range}"
}

resource "hcloud_ssh_key" "SSH_Public_Key" {
  name = "${var.SSH_Public_Key_name}"
  public_key = "${file(var.SSH_Public_Key_Path)}"
}


resource "hcloud_server" "first_master" {
  name        = "${var.masters_name}-1"
  image       = "${var.image}"
  server_type = "${var.server_type_for_masters}"
  ssh_keys = ["${var.SSH_Public_Key_name}"]
}

resource "hcloud_server_network" "srvnetwork" {
  server_id = "${hcloud_server.first_master.id}"
  network_id = "${hcloud_network.privNet.id}"
}




 resource "hcloud_server" "workers" {
  count = "${var.worker_nodes_count}"
  name        = "${var.server_workers_name}-${count.index+1}"
  image       = "${var.image}"
  server_type = "${var.server_type_for_workers}"
  ssh_keys = ["${var.SSH_Public_Key_name}"]
}
resource "hcloud_server_network" "srvnetwork2" {
  count = "${var.worker_nodes_count}"
  server_id = "${hcloud_server.workers[count.index].id}" 
  network_id = "${hcloud_network.privNet.id}"
}


resource "local_file" "inventory" {
    filename = "../kubernetes_cluster_ansible/hosts"
    content     = <<EOF

[all:vars]
ansible_user=root
ansible_connection=ssh
ansible_ssh_private_key_file = ${var.privet_key}


[master]
${hcloud_server.first_master.name} ansible_host=${hcloud_server.first_master.ipv4_address} 


[workers]
%{ for item, i in local.ip_of_instences_workers ~}
k8s-workers-${item+1} ansible_host=${i}
%{ endfor ~}

  EOF
}
