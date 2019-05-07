# 1. hamachi-vpn

Containerized Hamachi VPN

<!-- TOC -->

- [1. hamachi-vpn](#1-hamachi-vpn)
    - [1.1. Purpose](#11-purpose)
    - [1.2. Pinned Hamachi Release Version](#12-pinned-hamachi-release-version)
    - [1.3. Setting up a Host](#13-setting-up-a-host)
    - [1.4. Bug Reports](#14-bug-reports)
    - [1.5. Will it Work On...](#15-will-it-work-on)
    - [1.6. Examples](#16-examples)
        - [1.6.1. A note on using 'privileged'](#161-a-note-on-using-privileged)

<!-- /TOC -->

## 1.1. Purpose

To create a means of launching a Hamachi VPN client for hub / spoke configurations in a NAS or other environment that does not meet first-class support requirements for Hamachi on Linux but does have:

* Support for tunnels
* Support for Docker

## 1.2. Pinned Hamachi Release Version

As of 05/07/2019 this is pinned to 2.1.0.198.

## 1.3. Setting up a Host

A script *run_on_host.sh* has been provided as a convenience. It has been tested on a Synology NAS and when run with sudo successfully created the necessary host architecture to support operation of this container.

*That being said please don't run BASH scripts on your system without looking at them first.*

Like the LICENSE says, there is no warranty. Your mileage may vary. Subtle differences may be noticable. Birds may suddenly appear. It can be said a million different ways but it ultimately distills down to: If you run the BASH script without knowing what it does it isn't my fault. If you run the BASH script knowing what it does and it doesn't do what it was supposed to do it isn't my problem.

Hamachi requires a functioning /dev/net/tun node to work. It requires privileged access to it. Once it has that prerequisite resolved, however you want to resolve it, the container can and will run.

That being said, that brings us to a point about...

## 1.4. Bug Reports

If you are submitting a bug report submit logs with it. The logs for the container may contain sensitive information like IP addresses so feel free to redact those. If you feel confident that there's megabytes of information that have absolutely no relevance to a giant glaring stderr critical failure, feel free to omit those. But please at least submit some kind of logs pertaining to the failure so there's something to go on.

Also, keep in mind I am in no way affiliated with vpn.net or LogMeIn so if it's a failure in Hamachi itself all I can do is relay the information and update the container when a new version resolving the issue is released.

Which brings us to...

## 1.5. Will it Work On...

* Synology? Yes, provided you are running the latest. It may run on earlier than the latest 6.2 but Synology has a bad habit of lagging behind on Docker installations so I wouldn't go too far back.

* Other NAS solutions? Potentially. I don't own anything other than my Synology swarm so I really couldn't tell you but the criteria are very straightforward. See above under Purpose.

* Non-NAS Linux deployments? Sure, really no reason why not, provided you aren't running a deployment so stripped down it doesn't support the things you need to run a VPN client. See above under Purpose.

* Mac / Windows? No idea. Mac? Maybe, if it works with /dev/net/tun, which off the top of my head I don't think it does, or it does in a weird way. Windows does networking in its own creative way so theoretically what you may end up with if you try it on Windows is a Hamachi client into hyper-v... If anything. It would be fun to try though when WSL2 comes out and that whole thing happens.

## 1.6. Examples

*docker-compose.yml* is provided as an example of how to run the container. It's really straightforward intentionally:

```yaml
version: "3"
services:
  hamachi:
    build: hamachi
    container_name: hamachi
    restart: unless-stopped
    volumes:
      - config:/var/lib/logmein-hamachi:rw
      - /etc/localtime:/etc/localtime
    privileged: true
    network_mode: "host"
    environment:
      - ACCOUNT=<ACCOUNT EMAIL>
```

When the container comes up it will send an attach request to the account specified in <ACCOUNT_EMAIL>.

Once you approve the request and add the now logged-in client to a network that's it, the client is active and its IP address can be used to bring up services.

### 1.6.1. A note on using 'privileged'

It's a VPN client. It needs privileged.
