# KubeLab: A Kubernetes cluster homelab

## Overview
**KubeLab** is a hands-on home lab built to master **Linux system administration**, **Kubernetes orchestration**, **networking**, and **DevOps practices**.

It's a place to try out new tools, experiment with GitOps, automate deployments and configs, and test things like backup strategies, security, and scaling. The idea overall is to build something close to a real production environment but with the flexibility to learn, break things and continuously improve.

## Index
- [Documentation for the lab](docs/) 
  - [Networking setup](docs/networking.md)
  - [Lab setup](docs/setup-guide.md)
- [Infrastructure configuration and automation](infrastructure/)
  - [Ansible playbooks for automating the lab setup](infrastructure/ansible/)
  - [Networking walkthroughs, configs, and backups](infrastructure/networking/)

## Hardware
The lab's built from a mix of refurbished HP mini PCs (pretty cheap but they perform surprisingly well), upgraded with DDR4 RAMs and NVMe SSDs for smoother performance, plus a custom router and a managed switch to tie it all together:
- **Node 1**: HP EliteDesk 800 G2 Mini i5-6500T / 16GB DDR4 / 512GB M.2 NVMe + 500GB HDD
- **Node 2**: HP ProDesk 600 G2 Mini i5-6500T / 16GB DDR4 / 512GB M.2 NVMe
- **Node 3**: HP ProDesk 400 G2 Mini i5-6500T / 16GB DDR4 / 512GB M.2 NVMe
- **Node 4**: HP ProDesk 400 G2 Mini i5-6500T / 32GB DDR4 / 256GB M.2 NVMe
- **Node 5**: HP ProDesk 400 G2 Mini i3-6100T / 16B DDR4 / 512GB M.2 NVMe
- **Router**: ECS LIVA ZE (Intel Celeron N3350 / 8GB DDR3L / 256GB SSD) running OPNsense
- **Switch**: TL-SG108E (8-port Gigabit semi-managed switch)
- **UPS**: Tecnoware ERA Plus 750 (750VA/525W) protects nodes/switch/router from blackouts which gives 10-15 minutes of backup

![Lab Hardware](/screenshots/hardware/lab_hardware.jpg)

## Technology Stack

The following table outlines the technology stack for **KubeLab**:

|      | Name | Description |
|------|------|-------------|
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/kubernetes/kubernetes-plain.svg" style="width: 32px; height: 32px;"> | k3s | Lightweight Kubernetes for running workloads on resource-constrained nodes.|
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/gitlab/gitlab-original.svg" style="width: 32px; height: 32px;"> | GitLab CE | Self-hosted CI/CD platform for building, testing, and deploying Java/Angular apps. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/java/java-original.svg" style="width: 32px; height: 32px;"> | Java | Backend runtime for application logic, integrated with CI/CD pipeline. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/angularjs/angularjs-original.svg" style="width: 32px; height: 32px;"> | Angular | My frontend framework choice. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/apachekafka/apachekafka-original.svg" style="width: 32px; height: 32px;"> | Kafka | Distributed streaming platform for event-driven data pipelines. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/mongodb/mongodb-original.svg" style="width: 32px; height: 32px;"> | MongoDB | NoSQL database for flexible, scalable data storage. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/postgresql/postgresql-original.svg" style="width: 32px; height: 32px;"> | PostgreSQL | Relational database for structured data and application persistence. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/elasticsearch/elasticsearch-original.svg" style="width: 32px; height: 32px;"> | Elasticsearch | Search and analytics engine for log and data indexing. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/nginx/nginx-original.svg" style="width: 32px; height: 32px;"> | Nginx | Web server and reverse proxy for serving apps and load balancing. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/traefikproxy/traefikproxy-original.svg" style="width: 32px; height: 32px;"> | Traefik | Cloud-native reverse proxy for dynamic routing in Kubernetes. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/argocd/argocd-original.svg" style="width: 32px; height: 32px;"> | Argo CD | GitOps tool for continuous deployment to k3s (switching to **FluxCD** soon). |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/prometheus/prometheus-original.svg" style="width: 32px; height: 32px;"> | Prometheus | Monitoring system for collecting and querying metrics. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/grafana/grafana-original.svg" style="width: 32px; height: 32px;"> | Grafana | Visualization platform for monitoring dashboards. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/kibana/kibana-original.svg" style="width: 32px; height: 32px;"> | Kibana | Log and data visualization tool, paired with Elasticsearch. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/vault/vault-original.svg" style="width: 32px; height: 32px;"> | Vault | Secrets management. |
| <img src="https://www.svgrepo.com/show/353933/jfrog.svg" style="width: 32px; height: 32px;"> | Artifactory | Artifact repository for storing CI/CD build outputs. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/ansible/ansible-original.svg" style="width: 32px; height: 32px;"> | Ansible | Automation tool for node configuration and provisioning. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/terraform/terraform-original.svg" style="width: 32px; height: 32px;"> | Terraform | Infrastructure-as-code tool for managing lab resources. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/helm/helm-original.svg" style="width: 32px; height: 32px;"> | Helm | Package manager for deploying applications to k3s. |
| <img src="https://camo.githubusercontent.com/4759101d66da36edea0998f8da3084921bd4f4eed32b999dde06685d7ac9f068/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f686f6d6172722d6c6162732f64617368626f6172642d69636f6e732f7376672f63696c69756d2e737667" style="width: 32px; height: 32px;"> | Cilium | Networking and security for Kubernetes with eBPF. |
| <img src="https://camo.githubusercontent.com/662c24a27156a7786f976a03eb81891d7cee8c289c19eb474e8f4112624e0138/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f77616c6b78636f64652f64617368626f6172642d69636f6e732f7376672f636572742d6d616e616765722e737667" style="width: 32px; height: 32px;"> | Cert-Manager | Automated certificate management for Kubernetes TLS. |
| <img src="https://forum.opnsense.org/Themes/Steyle-V4/images/OPNsense-logo.svg" style="width: 100px; height: 32px;"> | OPNsense | Open-source router/firewall for VLANs and network security. |
| <img src="https://cdn.jsdelivr.net/npm/devicon@2.16.0/icons/ubuntu/ubuntu-original.svg" style="width: 32px; height: 32px;"> | Linux | Ubuntu Server 24.04 LTS for all cluster nodes|


## Cluster Infrastructure
This diagram gives a clear view of my home lab's cluster setup, visually mapping how the components connected and how everything works together to build a production-like environment:
![Lab Diagram](docs/diagrams/lab-diagram.png)


## Contact
For feedback or collaboration, reach out via GitHub Issues or [hamzaouimohamednour@gmail.com].
