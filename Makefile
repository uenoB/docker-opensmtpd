VERSION=7.4.0p1
NAME=ghcr.io/uenob/opensmtpd:$(VERSION)

opensmtpd:$(VERSION).tar: Dockerfile
	docker buildx build --build-arg VERSION=$(VERSION) -t $(NAME) .
	docker save -o $@ $(NAME)
	docker rmi $(NAME)
