# 使用buildx作为构建器
FROM --platform=$BUILDPLATFORM docker.io/docker/docker:20.10 AS buildx

RUN docker buildx create --use --name multiarch

# 构建amd64镜像
FROM buildx AS amd64
ARG BUILDPLATFORM
RUN echo "Building for $BUILDPLATFORM"
COPY Dockerfile.amd64 /
RUN $BUILDPLATFORM=linux/amd64 docker buildx build --platform linux/amd64 -t myimage:amd64 --load .

# 构建arm64镜像 
FROM buildx AS arm64
ARG BUILDPLATFORM 
RUN echo "Building for $BUILDPLATFORM"
COPY Dockerfile.arm64 /
RUN $BUILDPLATFORM=linux/arm64 docker buildx build --platform linux/arm64 -t myimage:arm64 --load .

# 共享层
FROM scratch
COPY --from=myimage:amd64 / /
COPY --from=myimage:arm64 / /
