## Writefreely Docker image
## Copyright (C) 2024 Nuvem LGBT
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Build image
FROM --platform=linux/amd64 golang:1.21-alpine3.18 as build

ARG WRITEFREELY_VERSION=v0.14.0
ARG WRITEFREELY_REF=62f9b2948ecaf6e8b4362570bf0e55111a24a183
ARG WRITEFREELY_FORK=writefreely/writefreely

RUN apk add --no-cache --update nodejs npm make g++ git \
    && npm install -g less@4.2.0 less-plugin-clean-css@1.5.1

RUN mkdir -p /go/src/github.com/${WRITEFREELY_FORK} && \
    git clone https://github.com/${WRITEFREELY_FORK}.git \
              /go/src/github.com/${WRITEFREELY_FORK} -b ${WRITEFREELY_VERSION}
WORKDIR /go/src/github.com/${WRITEFREELY_FORK}
RUN [ -n "${WRITEFREELY_REF}" ] && git checkout "${WRITEFREELY_REF}"

# hadolint ignore=DL3059
RUN cat ossl_legacy.cnf > /etc/ssl/openssl.cnf
ENV GO111MODULE=on
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN make build \
  && make ui \
  && mkdir /stage && \
     cp -R /go/bin \
           /go/src/github.com/${WRITEFREELY_FORK}/templates \
           /go/src/github.com/${WRITEFREELY_FORK}/static \
           /go/src/github.com/${WRITEFREELY_FORK}/pages \
           /go/src/github.com/${WRITEFREELY_FORK}/keys \
           /go/src/github.com/${WRITEFREELY_FORK}/cmd \
           /stage \
  && mv /stage/cmd/writefreely/writefreely /stage

# Final image
FROM --platform=linux/amd64 alpine:3.18.0
LABEL org.opencontainers.image.source=https://github.com/nuvemlgbt/writefreely
LABEL org.opencontainers.image.description="WriteFreely is a clean, minimalist publishing platform made for writers. Start a blog, share knowledge within your organization, or build a community around the shared act of writing."

ARG WRITEFREELY_UID=5000

RUN apk add --no-cache openssl ca-certificates \
    && adduser -D -H -h /writefreely -u "${WRITEFREELY_UID}" writefreely \
    && install -o writefreely -g writefreely -d /data
COPY --from=build --chown=writefreely:writefreely /stage /writefreely
COPY --chown=writefreely:writefreely bin/writefreely-docker.sh /writefreely/

VOLUME /data
WORKDIR /writefreely
EXPOSE 8080

USER writefreely:writefreely

ENTRYPOINT ["/writefreely/writefreely-docker.sh"]
