# hash:sha256:b8c41fddd17c1402d866b11d11806e1756dd6c1ccc785c94411d2a4767dc5c14
FROM registry.codeocean.com/codeocean/matlab:2016b-cuda8.0.61-cudnn6.0.21-ubuntu16.04

ARG DEBIAN_FRONTEND=noninteractive
ARG MLM_LICENSE_FILE

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc=4:5.3.1-1ubuntu1 \
    && rm -rf /var/lib/apt/lists/*

COPY postInstall /
RUN /postInstall
