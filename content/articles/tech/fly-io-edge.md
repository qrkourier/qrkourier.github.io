---
title: Fly.io Programmable Front-end
tags: cdn, devops
icon: fab fa-fly
category: Tech
date: 2018-05-10
---

In short, a programmable cloud delivery network (CDN) aka front-end like Fly.io is an API by which to configure the logical edge of an application stack. Fly.io also provides an intuitive web UI which simplifies common administrative operations.

[TOC]

For example:

* high availability for a service endpoint (this is automatic);
* requesting, issuing, binding, and renewing a free TLS server certificate (just verify a domain name);
* injecting business logic and automation at the application edge e.g. analytics, policies, authentication, caching, redirects, lambda functions, etc... (just click to enable middleware); and
* allocating workloads to multiple upstreams (backend capacity pools e.g. GCE, ECS, EC2).

### Example of a multi-cloud backend fronted by Fly.io

For one project I created a Fly.io "site" to front an application served up by Kubernetes in Google Compute Engine (GCE) and Elastic Container Service (ECS) simultaneously. Such a multi-cloud architecture is typically possible with any CDN, but here's an overview of the steps to do this with Fly.io.

1. `docker push` to upload my custom Docker image to the Elastic Container Registry (ECR)
2. configure the Kubernetes cluster to source that container image by registry address, name:tag, and publish the service port on a load balancer
3. configure AWS's ECS Fargate to source the image by name:tag (requires hosting the container image in ECR), and publish the service port on an Elastic Load Balancer (ELB)
4. create the Fly.io site with a backend of the Kubernetes load balancer address:port and ELB address:port

A note about TLS (SSL): It's a great idea to require TLS everywhere. This gives greater assurance of data integrity even when confidentiality is a non-issue. Both GCE Kubernetes LBs and ELBs can issue and bind a free TLS server certificate. There's no need to request a certificate common name (CN) or subject alternative name (SAN) matching the domain name your clients/customers will "see". This is because the frontend provided by Fly.io will bind that familiar domain name when you verify the DNS hostname. The CN+SAN in the backend load balancers' server certificates are arbitrary and simply need to match the domain name generated by that platform for the particular service address e.g. example-service-2045107736.us-east-1.elb.amazonaws.com.

## Example of a personal web site without hosting expenses

I came across Fly.io by way of an email invitation for a free trial and have combined this with [the Keybase Filesystem]({filename}keybase.md) and the Pelican static HTML generator (described in [About page]({filename}/pages/60-about.md)) to create this blog site which is highly secure, performant, highly available, and (for now) completely free of operational expenses!

---
