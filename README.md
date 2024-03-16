# docker-opensmtpd

This is a Docker container image of [OpenSMTPd] constructed upon [distroless].

[OpenSMTPd]: https://www.opensmtpd.org
[distroless]: https://github.com/GoogleContainerTools/distroless?

## Setup

```sh
docker pull ghcr.io/uenob/opensmtpd
```

## Usage

Mount volumes to the following directores if necessary:
- `/usr/local/etc` contains the top-level configuration file named `smtpd.conf`.
- `/var/spool/smtpd` is the queue directory.
- `/var/spool/mail` is the mbox directory.
