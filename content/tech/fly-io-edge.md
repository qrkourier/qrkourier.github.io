Title: Fly.io Programmable Edge
Tags: middleware, distributed system, load balancer, edge, reverse proxy, cdn
#Status: draft

In short, a programmable cloud delivery network (CDN) like Fly.io is an API for your application's logical edge. Fly.io is particularly awesome because they provide an API and web UI (WUI) making it super easy to do things like
* high availability for a public network service endpoint;
* requesting, issuing, binding, and renewing a TLS server certificate;
* injecting business logic and automation at the application edge e.g. analytics, policies, authentication, caching, redirects, lambda functions, etc...; and
* fully controlling multiple upstreams (backend application capacity).

I came across Fly.io by way of an email invitation for a free trial and have combined this with [the Keybase Filesystem]({filename}keybase.md) and the Pelican static HTML generator (described in [About page]({filename}/pages/about.md)) to create this blog site which is highly secure, performant, highly available, and (for now) completely free of operational expenses!

For another project I created a Fly.io "site" to front a Google Compute Engine (GCE) Kubernetes cluster because I'd customized a particular docker container image to serve an application so I did
# `docker push` to upload my container image to the Docker Hub registry
# configured the GCE Kubernetes cluster to source that image from Docker Hub
# created the Fly.io site with a backend of the Kubernetes load balancer address



---

##Comments
