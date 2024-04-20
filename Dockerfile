FROM --platform=linux/amd64 debian:12 AS build
RUN apt-get update
RUN apt-get install -y libc6-dev gcc make
RUN apt-get install -y wget libssl-dev libevent-dev libz-dev
WORKDIR /root
ARG VERSION
COPY opensmtpd-$VERSION.tar.gz /root
RUN tar -zxf opensmtpd-$VERSION.tar.gz
RUN cd opensmtpd-$VERSION && \
    ./configure \
      --without-auth-pam \
      --with-path-CAfile=/etc/ssl/certs/ca-certificates.crt \
      --with-user-smtpd=nonroot \
      --with-user-queue=nobody \
      --with-group-queue=nobody
RUN cd opensmtpd-$VERSION && make
RUN cd opensmtpd-$VERSION && make install
RUN chgrp 65534 /usr/local/sbin/smtpctl
RUN sed -i -e 's,/etc/mail/,/usr/local/etc/,' /usr/local/etc/smtpd.conf
RUN sed -i -e 's,localhost,127.0.0.1,' /usr/local/etc/smtpd.conf
RUN touch /usr/local/etc/aliases

FROM --platform=linux/amd64 gcr.io/distroless/cc-debian12
COPY --from=build \
  /lib/x86_64-linux-gnu/libcrypt.so.1 \
  /lib/x86_64-linux-gnu/libz.so.1 \
  /usr/lib/x86_64-linux-gnu/libevent-2.1.so.7 \
  /usr/lib/x86_64-linux-gnu/
COPY --from=build /usr/local/sbin /usr/local/sbin
COPY --from=build /usr/local/etc /usr/local/etc
COPY --from=build /usr/local/libexec/opensmtpd /usr/local/libexec/opensmtpd
WORKDIR /var/empty
CMD ["smtpd", "-d"]
