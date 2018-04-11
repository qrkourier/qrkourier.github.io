Title: CloudFlare DNS for Network Manager
Tags: linux, dns, privacy

CloudFlare provides [a performant recursive nameserver](https://developers.cloudflare.com/1.1.1.1/what-is-1.1.1.1/) along with a promise to never surveil their users.

Their Linux quickstart involves modifying the standard C library's resolver (i.e. /etc/resolv.conf) which is a terrible idea if you are using most of the popular flavors of Linux as a daily driver desktop OS because they're likely using `dnsmasq` or `resolvconf` or both to declare the contents of that file.

For what it's worth, here's shellcode to quickly reconfigure an existing Network Manager saved connection with `nmcli`.

```shell

# make a note of the name of the connection you wish to configure e.g. "WiFi Secure"
nmcli connection show

# save the name of the connection in a variable
export CONN="WiFi Secure"

# paste the following in your terminal to reconfigure DNS
nmcli connection modify "$CONN" \
    ipv4.ignore-auto-dns yes \
    ipv4.never-default no \
    ipv4.dns "1.1.1.1"

# reactivate the saved connection
nmcli connection up "$CONN"

# optionally restore default DNS (DHCP)
nmcli connection modify "$CONN" \
    ipv4.ignore-auto-dns no

```

---

##Comments
<blockquote class="reddit-card" data-card-created="1523472389"><a href="https://www.reddit.com/user/bingnet/comments/8bjhvg/cloudflare_dns_for_network_manager/?ref=share&ref_source=embed">CloudFlare DNS for Network Manager</a> from <a href="http://www.reddit.com/u/bingnet">u/bingnet</a></blockquote>
<script async src="//embed.redditmedia.com/widgets/platform.js" charset="UTF-8"></script>
