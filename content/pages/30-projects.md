title: Projects
icon: fas fa-wrench

## Open Source Software

I've pinned a few repositories that I worked on [in GitHub](https://github.com/qrkourier).

### zrok

[zrok](https://zrok.io) is an open-source, self-hostable file and service sharing platform built on the firm foundation of OpenZiti. Here's [a post I wrote about running my own zrok in Docker](https://blog.openziti.io/limitless-zrok-with-docker).

### OpenZiti

[OpenZiti](https://openziti.io/) is a layer 4 overlay. As a transport-oriented abstraction over IP networking, the OpenZiti overlay makes it possible to stop managing IP addresses and focus on application identity and authorization.

This approach presents less surface area for attack than a VPN, and starts with a restrictive policy, i.e., no trust is implied by a network address.

The idea is to grow meaningful policies for labeled entities as application needs change, not convoluted ACLs based on IP addressing.

This way, there's no looming reckoning because every entity is known and every flow is authorized. Bonus: no proliferation of permissive VPNs to create new segments because you can just add a policy to the existing network.

Here's [a post I wrote about deploying OpenZiti in Kubernetes](https://blog.openziti.io/deploy-openziti-in-kubernetes-with-ease-using-k3d).

### Radial Calendar

Plot radiating dates for a fresh perspective that highlights similar time of year.

![png](/blob/radial-calendar.png)

[Link to GitHub](https://github.com/qrkourier/zrok_django_radial_calendar/)

This Djanjo app is also an example of using zrok's Python SDK instead of listening on a TCP port (`server.py`).

## Decks

### Patch v. Proxy

*Southeast Linuxfest 2024 in Charlotte, NC*

<iframe src="https://qrk.us/decks/patch-v-proxy/" width="100%" height="600px" frameborder="0" allowfullscreen></iframe>

- [view slide deck](https://qrk.us/decks/patch-v-proxy/)
- [slide sources in GitHub](https://github.com/qrkourier/decks/tree/main/source/patch-v-proxy)

<details>

<summary>Click for talk description</summary>

This one's for self-hosters navigating public ingress alternatives. We'll survey the gratis proxy providers and a libre entrant. We'll wrap up with some relevant examples for choosing between running a tunneling agent vs. going agent-less by patching the source to leverage a tunneling library.

Pairing a public reverse proxy with a reverse tunnel can be a better option for public ingress than port forwarding or a public VPS.

Until recently, the only way to achieve this was to run an agent to keep the tunnel to the public proxy open. That's still a fine choice and there are a few, interesting libraries that can make the tunneling functionality part of the application, eliminating the need for a separate agent, and allowing the app to have public ingress as long as it has public egress to create the reverse tunnel.

We'll touch on using systemd or Docker to run an agent, and Go and Python tunneling library examples.

</details>
