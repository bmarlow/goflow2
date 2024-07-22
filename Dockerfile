FROM ubi9/go-toolset:latest as builder
ARG LDFLAGS=""

COPY . /build
WORKDIR /build
USER root

RUN go build -ldflags "${LDFLAGS}" -o goflow2 cmd/goflow2/main.go

FROM ubi9/ubi-minimal
RUN microdnf module enable nodejs:20 -y
ARG src_dir
ARG VERSION=""
ARG CREATED=""
ARG DESCRIPTION=""
ARG NAME=""
ARG MAINTAINER=""
ARG URL=""
ARG LICENSE=""
ARG REV=""

LABEL org.opencontainers.image.created="${CREATED}"
LABEL org.opencontainers.image.authors="${MAINTAINER}"
LABEL org.opencontainers.image.url="${URL}"
LABEL org.opencontainers.image.title="${NAME}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.description="${DESCRIPTION}"
LABEL org.opencontainers.image.licenses="${LICENSE}"
LABEL org.opencontainers.image.revision="${REV}"

RUN adduser -d /home/flow flow

COPY --from=builder /build/goflow2 /home/flow
USER flow


ENTRYPOINT ["/home/flow/goflow2"]

