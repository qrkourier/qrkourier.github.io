---
title: Harvester Homelab
tags: Rancher, Harvester, LongHorn, OpenSUSE
icon: fas fa-flask-vial
status: hidden
category: Tech
date: 2023-04-02
---

## I Bit the Bullet

A homelab is a great way to experiment with new ideas. I had enjoyed running a handful of self-hosted apps and was using Docker Compose to manage their configurations. That worked just fine for experiments but I've been wanting to become more familiar with running workloads in Kubernetes so that I can leverage the tools that are built for that platform for things like management and security.

So, I decided to install Harvester on my home server. I was hesitant at first because I had recently installed ProxMox and was very happy with it. I was impressed when I read a little bit about Harvester. It seemed like a firm foundation for self-hosting Kubernetes on my own equipment. There were some challenges but I am very happy with the results so far.

Harvester is a Kubernetes distribution that is designed to run on bare metal servers. It uses Kubevirt and LongHorn to provide a virtualization layer and storage layer. Harvester is designed to be used with Rancher, which is a Kubernetes management platform. Rancher provides a web UI for managing Kubernetes clusters and applications. It also provides a Kubernetes API for managing clusters and applications programmatically.

A Harvester cluster is treated as a special type of Kubernetes cluster when it's imported in Rancher Manager. The Harvester cluster appears as a virtualization provider next to the other Kubernetes clusters. This allows you to create virtual machines in the same way that you would create pods in a regular Kubernetes cluster. Once imported into Rancher, you can use the Rancher UI to create individual virtual machines or an entire Kubernetes cluster with nodes running as Harvester virtual machines with pod storage classes provided by LongHorn. This is made possible by the Harvester Node Driver a.k.a. Harvester Cloud Provider.

LongHorn is a distributed block storage system that is designed to run on Kubernetes and it comes with Harvester. It provides a Kubernetes StorageClass that can be used to provision persistent volumes for pods, including the Harvester virtual machines. I considered using OpenEBS or CEPH, but I decided to go with LongHorn because it's designed to run on Kubernetes and it's comparatively simple and works with a single physical node.

## The Hardware

I have a single desktop-class system that was built by System76.