# KubeLab: A Kubernetes cluster home lab

## Overview
KubeLab is a hands-on home lab built to master **Linux system administration**, **Kubernetes orchestration**, **networking**, and **DevOps practices**. It runs on two compact HP mini PCs, leveraging **k3s** (lightweight Kubernetes), **Grafana** for visualization, **Prometheus** for monitoring, **Argo CD** for GitOps, and a **small Java application** to simulate real-world workloads. This project demonstrates skills in containerization, CI/CD, monitoring, and infrastructure automation, with a focus on scalability and learning.

## Project Goals
- **Linux**: Deepen expertise in Ubuntu Server administration, scripting, and system configuration.
- **Kubernetes**: Deploy and manage a k3s cluster for container orchestration.
- **Networking**: Experiment with static IPs, routing, and service exposure.
- **DevOps**: Implement GitOps with Argo CD, monitor with Prometheus/Grafana, and deploy a Java app.

## Hardware
- **Node 1**: HP EliteDesk 800 G2 Mini
  - CPU: Intel Core i5-6500T (4 cores, 4 threads, 2.5-3.1 GHz)
  - RAM: 16GB DDR4
  - Storage: 256GB M.2 NVMe SSD + 2TB 2.5" SATA HDD
  - Networking: 1x Gigabit Ethernet (Intel I219-LM)
- **Node 2**: HP ProDesk 400 G2 Mini
  - CPU: Intel Core i3-6100T (2 cores, 4 threads, 3.2 GHz)
  - RAM: 16GB DDR4
  - Storage: 256GB M.2 SATA SSD + 2TB 2.5" SATA HDD
  - Networking: 1x Gigabit Ethernet
- **Networking**: Direct mini-to-mini connection (0.3m Cat6 U/UTP LINDY cable) or both minis to home router (2m Cat6 U/UTP cables), no switch.

## Software Stack
- **OS**: Ubuntu Server 24.04 LTS
- **Kubernetes**: k3s (control plane on 800 G2, worker on 400 G2)
- **Containerization**: Docker
- **Monitoring**: Prometheus + Grafana
- **GitOps**: Argo CD
- **Application**: Small Java Spring Boot REST API
- **Networking**: Static IPs or DHCP via router, optional WireGuard VPN

## Architecture
The lab consists of two nodes connected via a home router or direct Ethernet cable, running a k3s cluster. The HP 800 G2 hosts the k3s control plane, Grafana, Prometheus, and Argo CD, while the 400 G2 acts as a worker node hosting the Java app. Prometheus scrapes metrics from k3s and the Java app, visualized in Grafana dashboards. Argo CD manages the Java app deployment via GitOps. SSDs store OS and container images, with HDDs for logs and backups.

; ![Architecture Diagram](docs/diagrams/lab-diagram.png)

## Resource Assessment
- **CPU**: i5-6500T (4 cores) and i3-6100T (2 cores) handle k3s, Grafana, Prometheus, Argo CD, and Java app (~2-3 vCPUs total).
- **RAM**: 16GB per node supports services (~4-7GB used) with room for growth.
- **Storage**: 256GB SSDs store OS and containers (~30-50GB used); 2TB HDDs handle logs/backups.
- **Networking**: Gigabit Ethernet via router or direct connection meets low-bandwidth needs.

## Future Enhancements
- Add a managed switch for VLAN experiments.
- Deploy additional services (e.g., Pi-hole, Nginx Ingress).
- Integrate a NAS for shared storage.
- Expand to multi-cluster Kubernetes setups.

## Contact
For feedback or collaboration, reach out via GitHub Issues or [hamzaouimohamednour@gmail.com].
