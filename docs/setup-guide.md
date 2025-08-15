# **Lab Setup**

A walkthrough on how I set up my Kubernetes (K3s) home lab from scratch.
I kept it minimal, reproducible, and automated as much as possible so I can rebuild it easily if needed.

---

## **1. Install Ubuntu Server**

* Installed Ubuntu Server 24.04 (minimal version) on each machine in the cluster .
* Set static IPs for each node (check `/docs/networking.md` for VLANs and addresses)
* Configured partitions (swaps, /data, ...)

---

## **2. SSH Access Setup**

I do all automation from my **Debian VM** (host machine):

1. generated an SSH key on my host:

   ```bash
   ssh-keygen -t rsa -b 4096
   ```
2. created a script `/infrastructure/scripts/copy-ssh-key.sh` to send my public key to each node (i updated my hosts file to call nodes by their hostnames, and also i use same username `kube` in all nodes) :

   ```bash
   #!/bin/sh
   ssh-copy-id kube@k3s-master
   ssh-copy-id kube@node1
   ...
   ```
3. now i'm able to login to each node without entering a password:

   ```bash
   ssh kube@node1
   ```

---

## **3. Why Ansible Instead of Manual SSH**

Here comes the boring part which is normally I'd ssh into each node and run updates, install packages (bunch of copy-paste commands and typos, bla bla ...), so instead I chose to use **Ansible** to automate it all (that's our job to automate stuff, right ?) so even if I ever wipe/reinstall a node, I can bring it back with one command.

---

### **3.1. Ansible Playbooks Structure**
All of my Ansible automation lives in the `/infrastructure/ansible/` folder:

#### **(1) Inventory + Global Variables**
- `inventory.yml`: list of nodes IPs/hostnames, common username, and permission to run as root
- `group_vars/all.yml`: stores global variables that apply to all nodes.

```bash
ansible all -i inventory.yml -m ping
```
![Ansible ping nodes](/screenshots/setup/ansible-ping-nodes.png)

#### **(2) Ansible Vault**
- `host_vars/`: contains an Ansible Vault file for each node's root password (e.g. `ansible-vault create host_vars/k3s-master/vault.yml`).

#### **(3) Baseline Playbook**

* updates and upgrades all nodes then installs system packages (tools like `curl`, `vim`, `net-tools`, ...)
* disables swap (required for Kubernetes) and configures sysctl for K3s networking
```bash
ansible-playbook -i inventory.yml playbooks/00-baseline.yml --ask-vault-pass
```

#### **(4) K3s Playbook**

* installs K3s on the master node and retrieves the join token
* installs K3s agents on worker nodes and automatically joins them to the cluster
```bash
ansible-playbook -i inventory.yml playbooks/10-k3s.yml --ask-vault-pass
```

---

## **5. Cluster Readyyy ! :>**

At this step the cluster should be ready, i can ssh into the master node and run `kubectl get nodes` or `ansible k3s-master -i inventory.yml -m shell -a "kubectl get nodes" --ask-vault-pass`

![Cluster](/screenshots/setup/ansible-cluster.png)
