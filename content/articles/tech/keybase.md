---
title: Keybase
tags: identity, encryption
icon: fab fa-keybase
category: Tech
date: 2018-03-21
---

I first started using [@KeybaseIO](https://www.keybase.io) a few years ago to link together my social accounts. This creates a web of accounts which is dramatically more difficult to impersonate than any single account. So, it's an exercise in impeding identity theft.

A web of accounts could, for example, enable me to trust your email signature when I only know you through Twitter.

The Keybase filesystem is one of the newer tools and has a lot of promise. It is a global
namespace with public and private trees. The private tree allows any two parties have a
truly confidential exchange of data just by reading and writing in the special folders on
their computer. You can look over here for [more info about
it](https://keybase.io/docs/kbfs).

This web page is actually hosted in the kbfs at `/keybase/public/kourier`. The content is
signed during upload and so is verifiable by running the Keybase app on your computer,
though it is not obvious in your web browser.

If you install Keybase you'll be able to passively track changes in the web of identity
with commands like

```bash
keybase follow kourier
```

---
