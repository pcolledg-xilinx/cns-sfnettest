# SPDX-License-Identifier: GPL-2.0-only
# SPDX-FileCopyrightText: (c) Copyright 2023 Advanced Micro Devices, Inc.

ARG UBI9_VERSION=9.2
FROM registry.access.redhat.com/ubi9/ubi-minimal:$UBI9_VERSION as builder
RUN microdnf install -y git make findutils gcc glibc-static
COPY . /build/
WORKDIR /build/src
ARG SFNT_VERSION
ARG CCLINKFLAGS="-static"
RUN make

FROM scratch
COPY --from=builder /build/src/sfnt-stream /build/src/sfnt-pingpong /
USER 1001
ENTRYPOINT [ "/sfnt-pingpong" ]
