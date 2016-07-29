# tinc-lab
This repo contains some files to bootstrap a 3 nodes mesh VPN with tinc and make some performance tests with it with different ciphers. 
I try to keep it as simple and usuable everywhere as possible. It uses Vagrant and Virtualbox to create VMs and Saltstack to provision them with tinc.
For the sake of simplicity, I'm going straight to the minimal working configuration and I'm not using any optional features of tinc which should probably be used in production to enhance security and flexibility.

## Why would you need a VPN (in the cloud) ?
Because if you're using some cloud provider to build a service with multiple instances/droplets/VPS you'll probably want to make them communicate with each other.
But will they be communicating over the Internet ? All your database queries and logs sent in cleartext, all you're administration and monitoring web interfaces open on the Internet ?
That's probably not a good idea...
So you'll need a way to communicate securely and to isolate the services that don't need to be reachable to anyone on the Internet, but only by your other nodes.
You'll want somehing like a LAN between your nodes where you know you can bind services on it without them being accessible to anybody. 

Actually some cloud provider already have that, something usually called private networking, AWS, DigitalOcean, OVH...
But how do you know you can trust this feature and be sure that your private is not actually shared with other customers ?
That's the case for DigitalOcean for example, where the feature is actually a **Shared** private network https://www.digitalocean.com/company/blog/introducing-private-networking/
And anyway the feature will probably be limited to nodes in the same datacenter and not usable between different cloud provider in any case.

But that's still interesting because you'll probably be charged less for the bandwidth you use on the private network and can expect better performance than on the public network.
So it would be great to add a layer of encryption and authentication on top of those private network, and even better if we could extend our private-network-over-private-network to other cloud providers.
And we can achieve this with software VPNs!
 

## Why tinc ?
When looking for software VPNs you'll probably quickly run into those three:
- OpenVPN: looks safe and easy to use but usually not supported out of the box by OSes
- IPSEC: industry standard, supported on various hardware and OSes by default, probably safe but looks harder than the former to master
- PPTP: which is old and looks more vulnerable than the two others

So OK you could go for one of those three solution to set-up your VPN between your nodes.
The first kind of setup that comes to mind and the most documented one is to have a star topology: you'll have one central node where every other nodes connect to and all your traffic goes through this central node.
This is probably the simplest setup, **but**!
If you need to exchange large volume of data between your nodes, your central node will need to have a big network pipe to deliver it, and anyway as it's software VPN, you can expect some CPU load on your central node as it will have to process all this traffic.
But even worst that, what if your central node goes down?
Your all VPN goes down too, and probably your whole service too.
You could add redundancy to this central node, but them you'll have to monitor that, be sure that the failover works, that it's fast enough...
Great fun to come!

A different approach to avoid this SPOF would be to use a mesh topology, where every nodes can have a dedicated connection to each other, and no more central relay.
To accomplish that, I found two solutions so far to set-up mesh VPN:
- IPSEC in transport mode: looks fast, secure, but not so easy to get the configuration well
- tinc: secure, very easy to set-up

I was really surprised when I discovered tinc. 
It looked exactly like what I was looking for, and it felt awkward not ever having heard of what looks like such and interesting tool. 
And it's even more awkward that it's definitely not just a toy VPN but something that looks stable and OK to be run in production. 
Look:
- it was started in 1998 and it's still maitain as of july 2016
- it's C and it's portable, it works on linux, various BSD flavors, Solaris...
- developpers look really security-focused
- it uses LibreSSL or OpenSSL

One thing to know is that they are still using Blowfish as default cipher for encryption.
It can be changed for any supported cipher by Libre/OpenSSL for sure, AES for example, so it's not really an issu, just surprising that they didn't switched to something newer.
Maybe for compatibility reasons or because Blowfish has the reputation of being faster than AES, which is probably not true on platforms supporting AES hardware acceleration, which is quite common now. 
Anyway we'll test AES with this lab to see what the speed is like!

About the speed, that may be a drawback of tinc compared with IPSEC because tinc is a fully userland software whereas IPSEC has kernel support.
Although speed may not be as good as IPSEC with tinc, one can see the fact of being a userland software as a good point.
You don't need any particular kernel module (appart from tun/tap driver which is probably selected by everybody who build kernels), so you don't have to ask your cloud provider to update its kernel because you need some new functionnality. And you'll know that installing a new version of tinc will have no impact on the kernel stability. 

## Using the lab
TODO

## Resources
- https://www.tinc-vpn.org/documentation/tinc.pdf
- https://www.digitalocean.com/community/tutorials/how-to-install-tinc-and-set-up-a-basic-vpn-on-ubuntu-14-04
- http://stacksetup.com/VPN/UsingTinc
- https://2kswiki.wordpress.com/2016/02/05/simple-vpn-network-mesh-with-tinc/
- https://www.flockport.com/connect-lxc-hosts-with-an-ipsec-vpn/
- http://crypto.stackexchange.com/questions/8009/why-exactly-is-blowfish-faster-than-aes
