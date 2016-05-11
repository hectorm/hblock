# Container used for testing purposes on a minimal environment
FROM alpine

RUN apk add --no-cache openssl

COPY hblock /usr/bin/hblock

CMD \
/usr/bin/hblock \
	-O "./hosts" \
	-R "127.0.0.1" \
	-H "127.0.0.1 localhost" \
	-S "https://raw.githubusercontent.com/zant95/hosts/master/hosts" \
	-W "^example\.com$ ^example\.org$" \
	-B "example.local example.localdomain" && \
head ./hosts

