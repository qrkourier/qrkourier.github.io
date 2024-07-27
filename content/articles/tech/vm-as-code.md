---
title: Virtual Machines as Code
tags: packer, ansible, terraform, devops, iaas
icon: fas fa-code
category: Tech
date: 2022-03-13
---

Optimizing for determinism in virtual machines. This approach can be used to vend the same virtual machine image version in many formats e.g. VHD for Azure, Stack, and Hyper-V; OVA for VMware, VirtualBox; QCOW2 for KVM, and of course RAW.

[TOC]

An overview of the steps using Packer,Ansible, and AWS is given as an example.

## TL;DR

1. Choose a source control manager (SCM) that supports version tagging e.g. Git to house your code and perform the following actions inside the code repository.
1. Write a playbook declaring the desired OS configuration. To start, a single Ansible playbook file with several tasks may be sufficient. As your requirements become more complex you’ll employ Ansible roles which are reusable, parameterized configuration.
1. Write a Packer template.
1. Select the Packer “builder” for the desired VM image format e.g. amazon-ebs.
1. Select a trusted upstream image e.g. the Amazon Machine Image (AMI).
1. Select a Packer “provisioner” to invoke the configuration playbook e.g. “ansible”.
1. Commit the configuration playbook and Packer template to SCM.
1. Use a Git tag to “stamp” an immutable version string on the current SCM revision e.g. release-0.1.0.
1. Run Packer to “build” the new OS image in the specified format.

## Cloning vs Code

The crucial aim here is a deterministic configuration of a virtual machine from source code. Cloning a disk image reproduces the good, the bad, and the unknown. The starting point for your VM image production pipeline is an upstream, vanilla, verifiable OS image; and the goal is to transform it with code into something useful.

## Choosing the Upstream Image

The obvious choice is the checksum-verified install media from the OS maintainers, but it might make more sense to verify and trust a marketplace vendor, e.g. Rogue Wave Software on Azure, because they provide drivers and tunings for that platform.

If you require greater assurances or simply want more help with your image you may have more than one stage of upstream image transform that ultimately produces your functional image. One example of a multi-stage approach is to source the upstream image from a trusted vendor, and then to apply an OS hardening Ansible playbook. Alternatively, you could source a hardened OS image from the [Center for Internet Security](https://www.cisecurity.org/services/hardened-virtual-images/).

Either way, this is a time for diligence in risk management. You’ll want to be certain (enough) that you can verify the chain of custody of the upstream(s) with the rigor that is appropriate for your application.

## Configuring the Image

Now that you have a trusted upstream image you’ll set about customizing it for your application. You’ll be glad you used a declarative configuration management system instead of shell scripts, and the fortunate soul that inherits your code too will be grateful. This means that the code that describes the configuration of your OS declares the desired end state e.g. “bind-utils is installed”, and the configuration system takes whatever actions are necessary to effect that state, and reports back whether this was a success with or without any change. In general, this approach offers a more principled approach which brings improved maintainability, strict error handling, debugging tools, and the like. To boot, you’ll probably learn some Python or Ruby along the way. It’s worth it.

## Sealing the Image

It’s crucial to scrub and seal the OS before it becomes a reusable image. High-priority items include

* host SSH identities,
* hardware addresses in network configuration,
* deprovisioning any hypervisor agent e.g. waagent, and
* removing any artifacts of the Packer provisioner(s) e.g. ansible-local requires the playbooks to be uploaded to the prototype VM.

## Versioning the Image

Before you run Packer to produce a new OS image, you’ll want to stamp the SCM repo that’s housing all this configuration with an immutable release version string e.g. `git tag release-0.1.0`. Ideally, this same string is stamped somewhere in the OS of the resultant image e.g. `/etc/release` and is also in the metadata e.g. entity tags of public cloud images like an AMI. Tagging is a feature of Packer’s “amazon-ebs” builder.

## Releasing the Image

Most likely, this OS image you’re releasing will eventually become part of a release kit of many versioned components that together compose the full application stack. Importantly, releases are always immutable, and it is at this point that the OS image is “released” to and consumed by the stack. Any further features and fixes will be new release versions. Likewise, you’ll always be able to build an OS image with the current version by checking out the SCM tag on which it was originally built e.g. `git checkout release-0.1.0`.

## Launching from the Image

The new OS image should be referenced by its version string when launched by the application or a infrastructure-as-code provisioning tool like Terraform. This probably means some kind of lookup table that resolves the version string to the image ID. For example, if you used Packer’s “amazon-ebs” provisioner to assign an AMI tag “ImageVersion=release-0.1.0”, then you could find the AMI with that tag in a particular region with aws CLI.

```shell
aws ec2 describe-images \
   –filters Name=owner-id,Values=$AWS_ACCOUNT_ID \
   –filters Name=tag:ImageVersion,Values=release-0.1.0
```

## Upgrading Virtual Machines

You’ll have to judge whether your application is best served by an in-place upgrade or turn-and-burn. The advantages of latter are enabled by a stack architecture that abstracts away persistence from the purview of the VM. If you can see a path forward to that end, then “Go West”. If you are forced to manage in-place upgrades then an aggressive always-latest-stable kind of strategy works best, and tools like Salt Stack are your friends.
