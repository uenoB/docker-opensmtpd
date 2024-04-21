VERSION=7.5.0p0
SHA256=84f5c1393c0c1becc72ceea971e0abd7075b2ca7e4e1f8909b83edfd8de0c39c
NAME=ghcr.io/uenob/opensmtpd:$(VERSION)

opensmtpd-$(VERSION).tar: Dockerfile opensmtpd-$(VERSION).tar.gz
	docker buildx build --build-arg VERSION=$(VERSION) --platform linux/amd64 -t $(NAME) .
	docker save -o $@ $(NAME)

opensmtpd-$(VERSION).tar.gz:
	curl -O https://www.opensmtpd.org/archives/opensmtpd-$(VERSION).tar.gz
	test "$$(shasum -a256 $@)" = '$(SHA256)  $@'
