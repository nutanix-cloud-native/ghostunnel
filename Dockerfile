# Dockerfile for ghostunnel/ghostunnel, useful as a basis for other images.
#
# To build this image:
#     docker build -t ghostunnel/ghostunnel .
#
# To run ghostunnel from the image (for example):
#     docker run --rm ghostunnel/ghostunnel --version

FROM golang:1.27-alpine as build

# Dependencies
RUN apk add --no-cache --update gcc musl-dev libtool make git

# Copy source
COPY . /go/src/github.com/mesosphere/ghostunnel

# Build
RUN cd /go/src/github.com/mesosphere/ghostunnel && \
    GO111MODULE=on make clean ghostunnel && \
    cp ghostunnel /usr/bin/ghostunnel

# Create a multi-stage build with the binary
FROM alpine:3.18.5

RUN apk add --no-cache --update libtool curl
COPY --from=build /usr/bin/ghostunnel /usr/bin/ghostunnel

ENTRYPOINT ["/usr/bin/ghostunnel"]
