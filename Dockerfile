# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:buster
RUN apt-get update && apt-get install -y --no-install-recommends netbase nfs-kernel-server && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /exports
RUN mkdir -p /e1
RUN mkdir -p /e2
RUN mkdir -p /e3
RUN mkdir -p /e4
RUN mkdir -p /e5
ADD run_nfs.sh /usr/local/bin/
ADD index.html /tmp/index.html
RUN chmod 644 /tmp/index.html

# expose mountd 20048/tcp and nfsd 2049/tcp and rpcbind 111/tcp
EXPOSE 2049/tcp 20048/tcp 111/tcp 111/udp

ENTRYPOINT ["/usr/local/bin/run_nfs.sh", "/exports", "/e1", "/e2", "/e3", "/e4", "/e5"]