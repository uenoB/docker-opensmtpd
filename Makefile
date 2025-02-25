VERSION=7.6.0p1
SHA256=b27c806982a6653a2637f810ae7a45372b9a7ff99350ee1003746503ff0e4a97
NAME=ghcr.io/uenob/opensmtpd:$(VERSION)
DOCKER=docker

opensmtpd-$(VERSION).tar: Dockerfile opensmtpd-$(VERSION).tar.gz
	$(DOCKER) buildx build --build-arg VERSION=$(VERSION) --platform linux/amd64 -t $(NAME) .
	$(DOCKER) save -o $@ $(NAME)

opensmtpd-$(VERSION).tar.gz:
	curl -O https://www.opensmtpd.org/archives/opensmtpd-$(VERSION).tar.gz
	test "$$(shasum -a256 $@)" = '$(SHA256)  $@'
