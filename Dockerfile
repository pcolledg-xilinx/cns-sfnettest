# SPDX-License-Identifier: GPL-2.0-only
# SPDX-FileCopyrightText: (c) Copyright 2023 Advanced Micro Devices, Inc.

FROM redhat/ubi8-minimal:8.8 as builder
RUN microdnf install -y git make findutils gcc pciutils grep ethtool sed
COPY . /build/
WORKDIR /build/src
ARG SFNT_VERSION
RUN make

FROM redhat/ubi8-micro:8.8
COPY --from=builder /sbin/lspci /sbin/ethtool /sbin/
COPY --from=builder /bin/grep /bin/egrep /bin/sed /build/src/sfnt-stream /build/src/sfnt-pingpong /bin/
USER 1001
CMD [ "/bin/sfnt-pingpong" ]
