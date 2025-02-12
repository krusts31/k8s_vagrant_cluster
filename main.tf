variable "containerd_version" {
  description = "containerd version"
  type        = string
  default     = "2.0.2"
}

variable "runc_version" {
  description = "runc version"
  type        = string
  default     = "1.2.4"
}

variable "cni" {
  description = "CNI version"
  type        = string
  default     = "1.6.2"
}

variable "version_for_file" {
  description = "version"
  type        = string
  default     = "0.0.2"
}

provider "null" {}

# Apply to both master and workers
resource "null_resource" "update_upgrade_all" {
  count = 3  # Master + 2 Workers

  triggers = {
    containerd_version = var.containerd_version
    runc_version       = var.runc_version
    cni_version        = var.cni
    version            = var.version_for_file
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "wget https://github.com/containerd/containerd/releases/download/v${var.containerd_version}/containerd-${var.containerd_version}-linux-amd64.tar.gz",
      "sudo tar Cxzvf /usr/local containerd-${var.containerd_version}-linux-amd64.tar.gz",
      "wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service",
      "sudo mkdir -p /usr/local/lib/systemd/system/",
      "sudo mv containerd.service /usr/local/lib/systemd/system/containerd.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable --now containerd",
      "wget https://github.com/opencontainers/runc/releases/download/v${var.runc_version}/runc.amd64",
      "sudo install -m 755 runc.amd64 /usr/local/sbin/runc",
      "sudo mkdir -p /opt/cni/bin",
      "sudo wget https://github.com/containernetworking/plugins/releases/download/v${var.cni}/cni-plugins-linux-amd64-v${var.cni}.tgz",
      "sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v${var.cni}.tgz",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/k8s.conf",
      "sudo sysctl --system",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gpg",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y kubelet kubeadm",
      "sudo apt-mark hold kubelet kubeadm",
      "sudo systemctl enable --now kubelet",
      "rm -rf containerd-${var.containerd_version}-linux-amd64.tar.gz runc.amd64 cni-plugins-linux-amd64-v${var.cni}.tgz containerd.service",
    ]

    connection {
      type        = "ssh"
      host        = element(["127.0.0.1", "127.0.0.1", "127.0.0.1"], count.index)
      port        = element(["2222", "2200", "2201"], count.index)
      user        = "vagrant"
      private_key = file(element([
        "/Users/admin/k8s_vagrant_cluster/.vagrant/machines/master/virtualbox/private_key",
        "/Users/admin/k8s_vagrant_cluster/.vagrant/machines/worker/virtualbox/private_key",
        "/Users/admin/k8s_vagrant_cluster/.vagrant/machines/worker2/virtualbox/private_key"
      ], count.index))
    }
  }
}

# Apply only to the master node
resource "null_resource" "update_upgrade_master" {
  triggers = {
    containerd_version = var.containerd_version
    runc_version       = var.runc_version
    cni_version        = var.cni
    version            = var.version_for_file
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt upgrade -y"
    ]

    connection {
      type        = "ssh"
      host        = "127.0.0.1"
      port        = "2222"
      user        = "vagrant"
      private_key = file("/Users/admin/k8s_vagrant_cluster/.vagrant/machines/master/virtualbox/private_key")
    }
  }
}

# Apply only to the worker nodes
resource "null_resource" "update_upgrade_workers" {
  count = 2  # Worker 1 and Worker 2

  triggers = {
    containerd_version = var.containerd_version
    runc_version       = var.runc_version
    cni_version        = var.cni
    version            = var.version_for_file
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt upgrade -y"
    ]

    connection {
      type        = "ssh"
      host        = element(["127.0.0.1", "127.0.0.1"], count.index)
      port        = element(["2200", "2201"], count.index)
      user        = "vagrant"
      private_key = file(element([
        "/Users/admin/k8s_vagrant_cluster/.vagrant/machines/worker/virtualbox/private_key",
        "/Users/admin/k8s_vagrant_cluster/.vagrant/machines/worker2/virtualbox/private_key"
      ], count.index))
    }
  }
}

