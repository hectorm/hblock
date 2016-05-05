# Container used for testing purposes on a minimal environment
FROM alpine

RUN apk add --no-cache openssl

COPY hosts-update /usr/bin/hosts-update
CMD ["sh", "/usr/bin/hosts-update"]

