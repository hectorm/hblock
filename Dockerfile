# Container used for testing purposes on a minimal environment
FROM alpine

RUN apk add --no-cache openssl

COPY hosts-update /usr/bin/hosts-update

CMD \
/usr/bin/hosts-update \
	-O "./hosts" \
	-R "127.0.0.1" \
	-H "127.0.0.1 localhost" \
	-S "https://adaway.org/hosts.txt https://raw.githubusercontent.com/zant95/hosts/master/hosts" \
	-W "^example\.com$ ^example\.org$" \
	-B "example.local example.localdomain" && \
head ./hosts

