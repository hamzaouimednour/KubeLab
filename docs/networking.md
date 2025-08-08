# KubeLab Networking Architecture


## Overview
This document walks through the network setup and design choices behind my home lab. It's not a step-by-step guide, just a way to share why everything's set up the way it is, what goals I had in mind, and how it all comes together into something that feels close to a production environement.

## Network Infrastructure

- **Fanless Mini PC (Router)**: For proper routing and monitoring, I use a **LIVA ZE** Mini PC powered by an Intel N3350 CPU, 8GB DDR3L, and 2x Gigabit Ethernet ports, running OPNsense as a router/firewall for the lab behind my ISP router (not the most powerful setup, but it gets the job done).
  - Why **OPNsense**? because it's super easy to manage ( VLANs, firewall rules, DHCP, plugins, ...), plus the web GUI is genuinely nice to work with (provides also SSH access).

- **TP-LINK TL-SG108E (Switch)**: 8-port Gigabit semi-managed switch for VLANs.

![Network Hardware](/screenshots/hardware/LIVA_ZE+TL-SG108E.png)


## OPNsense Configuration
OPNsense handles routing, firewall, VLANs, and DHCP for the lab, it's set up with two interfaces:
  - `re0` for WAN (connected to the ISP router)
  - `re1` for LAN (serving the lab).

VLANs separate traffic between services, management, and monitoring. Firewall rules are kept simple which allows only what's needed per VLAN. DHCP is enabled on each VLAN with static mappings for nodes (everything was managed through the web ui which makes configuration and monitoring easy).

![OPNsense Dashboard](/screenshots/OPNsense/gui-dashboard.png)

![OPNsense Assignments](/screenshots/OPNsense/gui-interfaces.png)

### Why VLANs ?
I wanted to simulate the kind of separation you'd find in an enterprise or cloud environment, so I set up all the VLANs and assigned them on the LAN interface, then gave each a static IP, enabled DHCP, and added the necessary firewall rules.
:

- **VLAN Configuration**:
  | VLAN                       | Gateway IP     | DHCP Range           |
  |----------------------------|----------------|----------------------|
  | VLAN 10 (Management)       | `192.168.10.1` | `192.168.10.100-200` |
  | VLAN 20 (Apps/Databases)   | `192.168.20.1` | `192.168.20.100-200` |
  | VLAN 30 (Monitoring)       | `192.168.30.1` | `192.168.30.100-200` |

- **VLAN 10**: Reserved for control plane traffic and cluster administration. This keeps SSH, API access, and node provisioning separated from apps traffic.

- **VLAN 20**: Where the actual business logic lives (Web services, databases, internal APIs, ...).

- **VLAN 30**: Reserved for Prometheus, Grafana, and any observability tools run here to keep noisy scraping or logging from interfering with app/data traffic.

- **Firewall Rules**:
  - MANAGEMENT: Allow TCP 6443 (k3s), 80/443 (Argo CD) from `192.168.10.0/24`
  - APPS: Allow TCP 80/443 (GitLab, Nginx/Traefik) from `192.168.20.0/24`
  - MONITORING: Allow TCP 8081 (Artifactory) from `192.168.30.0/24`
  - WAN: Allow outbound TCP 443

![OPNsense VLAN](/screenshots/OPNsense/gui-vlan.png)

## TL-SG108E Switch Configuration
- **VLAN Configuration**

  | VLAN | Tagged Port(s) | Untagged Port(s) | Purpose                              |
  |------|----------------|------------------|--------------------------------------|
  | 1    | -              | 1, 7, 8          | Switch Management                    |
  | 10   | 1              | 2                | Management VLAN (K3s control plane)  |
  | 20   | 1              | 3, 4             | Apps / Databases                     |
  | 30   | 1              | 5, 6             | Monitoring                           |

  ![TL-SG108E - VLAN Configuration](/screenshots/TL-SG108E/vlan-configuration.png)

- **VLAN PVID Setting**

  | Port | PVID | Purpose                       |
  | ---- | ---- | ----------------------------- |
  | 1    | 1    | Trunk (Tagged for all VLANs)  |
  | 2    | 10   | Node 1                        |
  | 3-4  | 20   | Node 2, 3                     |
  | 5-6  | 30   | Nodes 4, 5                    |
  | 7-8  | 1    | Switch Management             |


  ![TL-SG108E - VLAN PVID Setting](/screenshots/TL-SG108E/vlan-pvid-setting.png)
