title: Projects
icon: fas fa-wrench

I am looking for opportunities to collaborate with musicians and film makers on set and in the studio as a drummer, recordist, sound designer, or photographer. I'm not looking for employment or contract opportunities at the moment.

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

<br />

## Art

### Audio

I am fascinated by noise, synthesizers, and digital signal processing. I record audio for films. I use [Bitwig](https://www.bitwig.com/) to produce original music. Here's one with vocals by Alexandra.

<center>
<iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/562265640&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"></iframe>
</center>
</br>

Sometimes I [Mixxx](https://www.mixxx.org/) techno.

<center>
<iframe width="100%" height="120" src="https://www.mixcloud.com/widget/iframe/?hide_cover=1&feed=%2Fqrkourier%2Fdance-directive%2F" frameborder="0" ></iframe>
</center>

[Spotify](https://open.spotify.com/user/128656604?si=Gihepa1zS9iOx3A2xvSYRg) ([alt](spotify:user:128656604))

<center><iframe src="https://open.spotify.com/embed/user/128656604/playlist/2DtKbdMMSBD5eEPrCbpLJx" width="80%" height="400" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe></center>
</br>
